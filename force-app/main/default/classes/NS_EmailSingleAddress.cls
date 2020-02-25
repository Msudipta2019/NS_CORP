/**@author  ConnectNS
* @Created Date 2019-08-12
* @version  1.0
* @description This class handles all inbound email send to email service : SingleEmailtoQueue
*
*Modification History 
*************************************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
*************************************************************************************************
09/12/2019           Gidon Payenson     Use API names to identify metadata       Single Email To Case (SE-V2)
10/08/2019           Gidon Payenson     Modify call to Email utils class to exclude metadata addresss (E-Utils)
10/14/2019           Daniel Glaser      Added code for Domain Routing
11/01/2019          Sudipto Ghosh       D-1843     - Preventing the case creation loop during Out Of Office Auto Reply with dynamic URL 
12/13/2019          Sudipta Mukherjee   IM02737086   To add a check for the Subject length before creating Cases.
12/30/2019          Daniel Glaser     IM02756476   Email hash code fix for exception: Ending position out of bounds
-------------------------------------------------------------------------------------------------

*/
global without sharing class NS_EmailSingleAddress implements Messaging.InboundEmailHandler {
    
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope) 
    {
        final String className = 'NS_EmailSingleAddress';
        final String unidentifiedTierCommodity = 'CS_Unidentified'; //gp holds unidentified e2c metadata API name
        
        NS_EmailUtils.accountIdTierCom acctTier = new NS_EmailUtils.accountIdTierCom(); 
        
        String METHOD_NAME='handleInboundEmail';
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        Map<string,NS_EmailToQueue__mdt>  emailToQueueMdtMap = new Map<string,NS_EmailToQueue__mdt>();

        List<Attachment> allAttachment = new List<Attachment>();
        Set <String> emailaddr = new Set<String> ();
        EmailMessage emailMsg = new EmailMessage(); // Created a EmailMessage and copy all details from above.
        Case cseSobj = new Case();
        Case cse = new Case();
        String caseNum='';
        Boolean createCommodityCase = false;
        // List<String> AccountRecordTypes = new List<String> {'Business','Corporate','Service','Slim Golden'};
        Set<String> forwardingAdd = new Set<String>();
        String emailHtmlBody = email.HtmlBody;
        String emailBody = email.plainTextBody;
        String searchStr = email.subject+email.plainTextBody;
        String emailFromAddress = email.fromAddress;
        String MajorCommodityQueueName;
        String noReplyMsg = 'This is a no reply mail and this inbox is not being monitored';
        String message='Please ensure that the Norfolk Southern email address you are attempting to contact is populated in the email "To" line.';
        Boolean createNewCase = true;        
        Id MajorCommodityQueueId;
        String AccountId;
        String TierCommodity;
        String tierval = '';
        String toAddress='';
        String lastEmailToCc = NS_StaticVariablesUtility.CONST_BLANK;
        Integer hashcode = 0;
        //Added By Sudipta for Email Subject max length check
        Integer maxSize = 255;
        
        system.debug('NS_EmailSingleAddress email from addresss --'+emailFromAddress); 
        try { 

            //TierCommodity = NS_EmailUtils.getTeirCommodity(emailFromAddress); // @Daniel Glaser   Added code for Domain Routing 
            acctTier = NS_EmailUtils.getTeirCommodity(emailFromAddress);
            TierCommodity = acctTier.TierCommodity;
            AccountId = acctTier.id;
            //system.debug('gp  Tier Commodity = ' + TierCommodity );
            system.debug('NS_EmailSingleAddress TierCommodity---'+TierCommodity);

           //Get appropriate email to queue record based on DeveloperName (Name). 
           //Note - if none found, will raise an exception
            NS_EmailToQueue__mdt Etq = [SELECT Label,Queue_Id__c,Forwarding_Address__c FROM NS_EmailToQueue__mdt WHERE DeveloperName =:TierCommodity Limit 1];
            //system.debug('NS_EmailSingleAddress Etq--'+Etq);
            MajorCommodityQueueId = Etq.Queue_Id__c; //Owner Queue ID
            // SE_V2 Get group name by group ID
            Group gr = [Select Name from Group where Type='Queue' AND id=:MajorCommodityQueueId limit 1];
            //system.debug('gp gr=' + gr);
            //MajorCommodityQueueName = Etq.Label; 
            MajorCommodityQueueName = gr.Name; // SE_V2Group Name field corresponds to Label in user interface
        
            toAddress = Etq.Forwarding_Address__c;
            // system.debug('NS_EmailSingleAddress search Str '+searchStr);
            // system.debug('NS_EmailSingleAddress Pattern '+NS_StaticVariablesUtility.NS_Regex);
            pattern myPattern = pattern.compile(NS_StaticVariablesUtility.NS_Regex);
            matcher myMatcher = myPattern.matcher(searchStr);
            Integer count =limits.getLimitQueryRows();
            // if (!test.isRunningTest()){ //COVERAGE gp 07/16/19
            
                //Get First match
                //
                while (myMatcher.find()) {
                    List<String> parts = (myMatcher.group(0)).split(NS_StaticVariablesUtility.NS_Colon);
                    if(!parts.isEmpty()){
                        
                        caseNum = parts[1];
                    }
                    system.debug('NS_EmailSingleAddress search Str found ');
                    break;
                }
            // }

            try {
                if(!String.isEmpty(caseNum)){
                    List<Case> caseList = [Select id,casenumber,IsClosed from Case where casenumber = :caseNum.trim() LIMIT 1];
                    if(!caseList.isEmpty()){
                        cse = caseList[0];
                        createNewCase = false;
                    }
                }

                // system.debug('NS_EmailSingleAddress handleInboundEmail text body length '+email.plainTextBody.length());
                // IM02319098 can only copy 32000 characters to description
                if(email.plainTextBody != null && email.plainTextBody.length() > NS_StaticVariablesUtility.NS_CaseDescriptionLimit){
                    emailBody = 'NS_EmailSingleAddress Email message has been truncated due to size limit. Please refer to attachment/email for full message '+emailBody.substring(0, NS_StaticVariablesUtility.NS_CaseDescriptionLimit);
                }
                //system.debug('NS_EmailtoCaseHandler emailHtmlBody '+emailHtmlBody.length());
                if(email.HtmlBody != null && email.HtmlBody.length() > NS_StaticVariablesUtility.NS_emailBodyLimit){
                    emailHtmlBody = emailHtmlBody.substring(0, NS_StaticVariablesUtility.NS_emailBodyLimit);
                }
                // system.debug('NS_EmailSingleAddress emailHtmlBody check '+emailHtmlBody.length());
            
                if(createNewCase) {
                    
                    //system.debug('NS_EmailSingleAddress handleInboundEmail: description length '+emailBody.length());
                    
                    cseSobj.put('Queue_Type__c',MajorCommodityQueueName);
                    cseSobj.put('NS_Created_By_Queue__c',MajorCommodityQueueName);
                    cseSobj.put('Description',emailBody);
                    //***Modified by sudipta to check the Subject length  :IM02737086
                    //cseSobj.put('subject',email.subject);
                    if(email.subject.length()>maxSize)
                       {
                        string subjectString = email.subject.substring(0, maxSize);
                        cseSobj.put('subject',subjectString);
                      }
                    else
                       {
                        cseSobj.put('subject',email.subject);
                       }
                    //End of IM02737086 change
                    cseSobj.put('Origin',NS_StaticVariablesUtility.NS_Email);
                    cseSobj.put('Priority',NS_StaticVariablesUtility.NS_LOW);
                    cseSobj.put('Status',NS_StaticVariablesUtility.NS_NEW);
                    cseSobj.put('ownerID',MajorCommodityQueueId);
                    // Added by Sudipto G for D-1843 preventing the case creation loop during Out Of Office Auto Reply with dynamic URL 
                                
                    String urlStart = '$$$$$$';
                    String finalemailbody = '';
                    Integer emailUrlCount = 0;
                    String emailbodyReplace = emailBody;
                    emailbodyReplace = emailbodyReplace.replace('http://', '$$$$$$');
                    emailbodyReplace = emailbodyReplace.replace('https://', '$$$$$$');
                    emailbodyReplace = emailbodyReplace.replace('ftp://', '$$$$$$');
                    emailUrlCount = emailbodyReplace.indexOf(urlStart);
                    //System.debug('emailUrlCount' +emailUrlCount);
                    //System.debug('emailbodyReplace' +emailbodyReplace);
                    if(emailUrlCount == -1)
                    {
                        hashcode = (Date.today()+''+NS_StaticVariablesUtility.NS+''+emailBody+''+email.subject).hashcode();
                    }
                    else
                    {
                        // finalemailbody = emailbodyReplace;
                        finalemailbody = emailbodyReplace + ' ';    // Daniel Glaser for Ending position out of bounds
                        finalemailbody = finalemailbody.replace('\r\n', ' ');
                        finalemailbody = finalemailbody.replace('\n', ' ');
                        finalemailbody = finalemailbody.replace('\r', ' ');
                        Boolean urlFound = true;
                        while(urlFound)
                        {
                            emailUrlCount = finalemailbody.indexOf(urlStart);
                            String startUrl = finalemailbody.substring(emailUrlCount);
                            //System.debug('startUrl' +startUrl);
                            String endUrlidentifier = ' ';
                            Integer emailUrlendIndex = startUrl.indexOf(endUrlidentifier);
                            //System.debug('emailUrlendIndex' +emailUrlendIndex);
                            String emailUrl = finalemailbody.substring(emailUrlCount,emailUrlCount+emailUrlendIndex);
                            //System.debug('emailUrl' +emailUrl);
                            finalemailbody = finalemailbody.replace(emailUrl, '');
                            Integer emailUrlCheck = finalemailbody.indexOf(urlStart);
                            //System.debug('emailUrlCheck' +emailUrlCheck);
                            if(emailUrlCheck == -1)
                            {
                                urlFound = false;
                            }
                        }
                        hashcode = (Date.today()+''+NS_StaticVariablesUtility.NS+''+finalemailbody+''+email.subject).hashcode();
                    }
                    
                    System.debug('hashcode' +hashcode);
                    //End of Code 
                    //hashcode = (Date.today()+''+NS_StaticVariablesUtility.NS+''+emailBody+''+email.subject).hashcode();
                    cseSobj.put('NS_Email_Service_Message_ID__c',String.valueOf(hashcode));
                    cseSobj.put('RecordTypeId',Schema.SObjectType.case.getRecordTypeInfosByName()
                        .get(NS_StaticVariablesUtility.NS_EmailToCaseRT).getRecordTypeId());
                    if (AccountId != null && AccountId != '') {
                        cseSobj.put('AccountId',AccountId);
                    }   
                    // E-Utils modified call to exclude metadadata forwarding emails from To and CC addresses   
                    cseSobj =  NS_EmailUtils.FillCaseForwardLastEmails(cseSobj, email);
                    //COVERAGE gp 07/16/19 group is created in test class. Need to set ownerid to newly created case
                     //-------------
                    if(Test.isRunningTest()){
                        Group testGr = [Select ID from Group where type='Queue' limit 1];
                        If (testGr != null) {
                            cseSObj.OwnerId = testGr.id;
                        }
                    } //COVERAGE gp 07/16/19-----------
                    system.debug('NS_EmailSingleAddress emailHtmlBody cseSobj---'+cseSobj);
                    //system.debug('NS_EmailSingleAddress hashcode '+hashcode);
                
                    Database.insert(cseSobj);
                    hashcode = 0;
                    // system.debug('NS_EmailSingleAddress emailHtmlBody cseSobj2---'+cseSobj);
                    //system.debug('NS_EmailSingleAddress cseSobj---'+cseSobj.Id);
                    cse = [Select id,casenumber,NS_LastEmailAddresses__c,Subject,IsClosed,ownerID from Case where Id = :cseSobj.Id LIMIT 1];
                   
                }
                    
                // system.debug('cse check for null');
                if(cse != null) {
                    // system.debug('cse != null');
                    //Attach email to the email related list
                   
                    emailMsg =  NS_EmailUtils.FillEmailToCC(emailMsg, email);
                    if(createNewCase){
                        emailMsg.Subject=email.subject+NS_StaticVariablesUtility.Space+NS_StaticVariablesUtility.Hyphen+
                            NS_StaticVariablesUtility.Space+NS_StaticVariablesUtility.NS_CASENUMBER+NS_StaticVariablesUtility.Space+
                            NS_StaticVariablesUtility.NS_Colon+NS_StaticVariablesUtility.Space+cse.casenumber;
                    }
                    else{
                        emailMsg.Subject=email.subject;
                        if(lastEmailToCc!=NS_StaticVariablesUtility.CONST_BLANK && cse.IsClosed==false){
                            cse.NS_LastEmailAddresses__c = lastEmailToCc;
                            cse.NS_WFAutoRelease__c = true;
                            update cse;
                        }
                    }
                    // system.debug ('NS_EmailSingleAddress emailHtmlBody cse.NS_LastEmailAddresses__c = ' + cse.NS_LastEmailAddresses__c);
                    // IM02533777, IM02535878, IM02544832
                    // By using emailbody no &nbsp will show up.
                    if(email.plainTextBody != null && email.plainTextBody.length() > NS_StaticVariablesUtility.NS_EmailBodyLimit) {
                        emailBody = email.plainTextBody.substring(0, NS_StaticVariablesUtility.NS_CaseDescriptionLimit) + ' \r\n' +' ------------ Email message has been truncated due to size limit. Please refer to attachment for full message ';
                    } else {
                        emailBody = email.plainTextBody;
                    }
                        
                    emailMsg.TextBody=emailBody;
                    if(emailHtmlBody!=null){
                      emailMsg.HtmlBody=emailHtmlBody;
                      system.debug('NS_EmailSingleAddress Create emailmsg with html body length '+emailHtmlBody.length());
                      // system.debug('html body: '+emailHtmlBody);
                    }
                        
                    emailMsg.ParentId = cse.Id; //Attach with the case
                    emailMsg.MessageDate = system.now();
                    emailMsg.Status='0';
                    emailMsg.Incoming=true;
                    emailMsg.FromAddress=email.fromAddress;
                    Database.insert(emailMsg);

                    if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                        system.debug('NS_EmailSingleAddress Total Binary Attachments '+email.binaryAttachments.size());
                        for (integer i = 0; i < email.binaryAttachments.size(); i++) {
                            allAttachment.add(new Attachment(
                                ParentId = emailMsg.Id,
                                Name = email.binaryAttachments[i].filename,
                                Body = email.binaryAttachments[i].body));

                        }
                    }

                    
                    // Daniel Missing Attachment fix IM02577761
                    if((email.plainTextBody != null && email.plainTextBody.length() > NS_StaticVariablesUtility.NS_EmailBodyLimit) ||
                      (email.htmlBody !=null && email.htmlBody.length() > NS_StaticVariablesUtility.NS_EmailBodyLimit)) {

                        // Dan IM02319098 - Undeliverable emails
                        // Additional check for htmlbody != null for large text emails
                        //********************************************
                        string strhtmlbody = email.plainTextBody;
                        if (email.htmlBody !=null) {
                            string strbody = email.htmlBody;
                           
                            integer striplen = 0; //  NS_StaticVariablesUtility.NS_CaseDescriptionLimit;
                            system.debug('NS_EmailSingleAddress Process clips of html data '+strbody.length());
                            if (strbody.length() > 0 && strbody.contains('src')) {
                                integer p = 0;
                                do {
                                    striplen += NS_StaticVariablesUtility.NS_emailBodyLimit;
                                    if (striplen >= email.htmlBody.length() ) {
                                        striplen = email.htmlBody.length();
                                        // system.debug('Reached max length ');
                                    }
    
                                    string replacedstr = email.htmlBody.substring(p, striplen);
                                    // system.debug('replace html data to '+striplen+ ' from P= '+p);
                                    strhtmlbody += replacedstr.replaceall('src','');
                                    
                                    // system.debug('Strip len '+striplen);
                                    // index++;
                                    p+=NS_StaticVariablesUtility.NS_emailBodyLimit;
                                    
                                } while (p < email.htmlBody.length());
                                system.debug('htmlbody rebuilt');
                            } else {
                                strhtmlbody = email.htmlBody;
                                system.debug('NS_EmailSingleAddress htmlbody Contains no src html length '+strhtmlbody.length());
                            }
                        }
                        //********************************************
                        //system.debug('blob size '+strhtmlbody.length());
                        // system.debug('blob text '+strhtmlbody);
                        blob pdfcontents =  NS_EmailUtils.convertToPdf(strhtmlbody, email.plainTextBody);
                        // system.debug('NS_EmailSingleAddress pdfcontents size '+pdfcontents.size());
                        //Gets attached to Attachment related List
                        Attachment att = new Attachment(
                            ParentId = emailMsg.Id,
                            IsPrivate = false,
                            ContentType = 'application/pdf',
                            Name = email.subject+NS_StaticVariablesUtility.Space+NS_StaticVariablesUtility.Hyphen+
                            NS_StaticVariablesUtility.Space+cse.casenumber+NS_StaticVariablesUtility.Dot+NS_StaticVariablesUtility.PDF,
                            
                            Body = pdfcontents);
                        //system.debug('body size '+email.htmlBody.length());
                        //system.debug('PDF body size '+att.Body.size());
                        allAttachment.add(att);
                    }
                }   
                if (allAttachment.size() > 0) {
                    system.debug('contains attachments');
                    Database.insert(allAttachment);
                }
                result.success = true;
                // system.debug('NS_EmailSingleAddress Final body size '+email.htmlBody.length());
                // system.debug('HTMLbody '+email.htmlBody);
            }
            catch(Exception e){
                if (hashcode != 0) {
                    string expdesc = e.getMessage();
                    boolean duplicatehash = expdesc.contains('NS_Email_Service_Message_ID__c duplicates');
                    if (duplicatehash) {
                        string strhashcode = String.valueOf(hashcode);
                        // NS_Email_Service_Message_ID__c duplicates
                        list<case> hcaseck = [select id from case where NS_Email_Service_Message_ID__c =:strhashcode LIMIT 1];  
                        if(hcaseck.size() > 0) {
                            system.debug('NS_EmailSingleAddress handleInboundEmail Case already created '+hcaseck[0].id);
                            return result;
                        }                   
                    }                   
                }
                NS_StaticVariablesUtility.createExceptionRecord(e, className, className);
            }
            

        }catch(Exception ex){

            NS_StaticVariablesUtility.createExceptionRecord(ex, className, METHOD_NAME );
        }
        return result;
    }
        

}