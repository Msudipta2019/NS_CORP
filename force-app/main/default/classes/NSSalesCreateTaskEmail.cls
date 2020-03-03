global class NSSalesCreateTaskEmail implements Messaging.InboundEmailHandler
{
    public boolean SentMail =false;
    String customLabelValue = System.Label.NS_NoReplyOrgWideAddress;
  global Messaging.InboundEmailResult  handleInboundEmail(Messaging.inboundEmail email, 
                                                       Messaging.InboundEnvelope env)
{
 
    // Create an InboundEmailResult object for returning the result of the 
    // Apex Email Service
    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
     String myhtmlText= '';
    String myPlainText= '';
    String myccAddresses= '';
    String mytoAddresses= '';
    
    String oppNum='';
    String searchStr = email.subject+email.plainTextBody;
    
   
    
    // Store the email plain text into the local variable 
   // myPlainText = email.plainTextBody;
    if(email.ccAddresses != null){
                        for(String emailId : email.ccAddresses){
                            myccAddresses+= emailId+NS_StaticVariablesUtility.NS_SemiColon;
                        }
                    }
    if(email.toAddresses!= null){
                        for(String emailId : email.toAddresses){
                            mytoAddresses+= emailId+NS_StaticVariablesUtility.NS_SemiColon;
                        }
                    }
    
    
    
   if (email.plainTextBody.length() > NS_StaticVariablesUtility.NS_EmailBodyLimit){
        myPlainText = email.plainTextBody.substring(0, NS_StaticVariablesUtility.NS_EmailBodyLimit);
    } else {
        myPlainText = email.plainTextBody;
    } 
    
   // if(''.equals(email.htmlBody)){
    if(email.htmlBody == null){
        myhtmlText = myPlainText;
    }
    else if (email.htmlBody.length() > NS_StaticVariablesUtility.NS_EmailBodyLimit){
        myhtmlText = email.htmlBody.substring(0, NS_StaticVariablesUtility.NS_EmailBodyLimit);
    } else {
        myhtmlText = email.htmlBody;
    } 

    // Create a new Email record 
    
    NSSales_Email__c[] newEmail = new NSSales_Email__c[0];
     
    List<Attachment> attachmentList = new List<Attachment>();
    Map< String, Attachment > mapAttachments = new Map< String, Attachment >();
    // If there are more than one contacts with the same email address,
    // an exception will be thrown and the catch statement block will be executed.
    pattern myPattern = pattern.compile(NS_StaticVariablesUtility.NS_Opp); 
    matcher myMatcher = myPattern.matcher(searchStr);

     while (myMatcher.find()) {
                        List<String> parts = (myMatcher.group(0)).split(NS_StaticVariablesUtility.NS_Colon);
                        if(!parts.isEmpty()){
                            oppNum = parts[0];
                            system.debug('SOS OPP X1 '+oppNum);
                        }


                        system.debug(oppNum);
                         
                        break;                
                    }
      /*  if(!myMatcher.find()) {
             sendBounceBack(email);
         }
*/
try 
{
    system.debug('SOS OPP TRM '+oppNum.trim());
    list<Opportunity> oppList = [SELECT Id FROM Opportunity WHERE NSSales_Opportunity_Number__c= :oppNum.trim()]; 
    system.debug('SOS OPP LST '+oppList);
    if(oppList.size()==0){
        sendBounceBack(email);
    }
    
    Opportunity vOpp = [SELECT Id, Name, NSSales_Email__c,NSSales_Opportunity_Number__c FROM Opportunity WHERE NSSales_Opportunity_Number__c= :oppNum.trim()   LIMIT 1];
      //Opportunity vOpp = [SELECT Id, Name FROM Opportunity WHERE Name Like :email.subject LIMIT 1];
              
      
      
      newEmail.add(new NSSales_Email__c(NSSales_CcAddress__c = myccAddresses,
          NSSales_FromAddress__c = email.fromAddress,
          NSSales_FromName__c =email.fromName,
          
          HTML_Body__c = myhtmlText,//email.htmlBody,
          NSSales_Subject__c = email.subject,
          NSSales_TextBody__c = myPlainText,//email.plainTextBody,
          NSSales_ToAddress__c = mytoAddresses,
          NSSales_Opportunity__c =  vOpp.Id));
     
     // Insert the new Email 
     insert newEmail; 
   system.debug('HTML' +newEmail[0].HTML_Body__c);  
       
     
     
     if(email.binaryAttachments!=null){
                for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = bAttachment.fileName;
                    attachment.Body = bAttachment.body;
                    attachment.ParentId = newEmail[0].Id;
                    attachmentList.add(attachment);
                }
            }
 
            if(!attachmentList.isEmpty()){
                insert attachmentList;
            }  
    
    //Attachments
     if(email.binaryAttachments!=null){
        for(Messaging.InboundEmail.BinaryAttachment bA : email.binaryAttachments) {
            System.debug(bA);
            for(integer i = 0; i < bA.headers.size(); i++) {
                
                //Header Value
                String headerValue = bA.headers[i].value;
                if(headerValue.startsWith('ii') || headerValue.startsWith('< image')) {
                    headerValue = headerValue.replaceAll('<', '').replaceAll('>', '');
                    mapAttachments.put(headerValue, new Attachment(Name = bA.fileName, body = bA.body, 
                                                    ParentId = newEmail[0].Id, ContentType = bA.mimeTypeSubType));
                }
            }
        }
        
        //Insert
        insert mapAttachments.values();
    
    //Process inline images and update the HTML Body
        for(String headerValue : mapAttachments.keySet()) {
    
            //Reference Link
            String refLink = '/servlet/servlet.FileDownload?file=' + mapAttachments.get(headerValue).Id;
            newEmail[0].HTML_Body__c = newEmail[0].HTML_Body__c.replaceAll('cid:' + headerValue, refLink);
        }
        }
        update newEmail;
     
     
     
    }
   
    
    // The exception is written to the Apex debug log.
   catch (QueryException e) {
       System.debug('Query Issue: ' + e);
   }
   
   // Set the result to true. No need to send an email back to the user 
   // with an error message
   result.success = true;
   
   // Return the result for the Apex Email Service
   return result;
  }
    
public void sendBounceBack(Messaging.InboundEmail email){
      String message=NS_StaticVariablesUtility.bounceMessage;
        String className='NSSalesCreateTaskEmail';
        String subjectMsg='No Reply Mail';
        String METHOD_NAME='sendBounceBack';
    OrgWideEmailAddress OWA = [select Id from OrgWideEmailAddress where Address =: customLabelValue];
        try{
            system.debug('SOS BB');
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();        
            semail.toAddresses = new List <String> {email.fromAddress};
            semail.setSubject(email.subject);
            semail.setHtmlBody(message);
            semail.setOrgWideEmailAddressId(OWA.Id);
            if(!SentMail){
                system.debug('SOS BB SENT');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { semail });
                SentMail=true;
     
            }
   }
        catch (Exception e) {
            NS_StaticVariablesUtility.createExceptionRecord(e, className, METHOD_NAME ); 
        }
    }

   
}