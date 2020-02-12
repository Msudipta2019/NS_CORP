/**@author  Accenture
* @Created Date 2018-03-11
* @version  1.0
* @description This class handles all inbound email send to email service email address for case creation.
*
*Modification History
*************************************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
*************************************************************************************************
06/26/2019          Gidon Payenson      IM02506283 – EmailToCase functionality for similar queue
													 metadata email strings
07/09/2019          Daniel Glaser       IM02509476 - Email function within ConnectNS not working properly
07/09/2019          Daniel Glaser       IM02319098 - Undeliverable emails	
07/15/2019			Gidon Payenson		Increase test class coverage [COVERAGE]
07/27/2019			Daniel Glaser       IM02533777, IM02535878, IM02544832 - Email contains &nbsp
													Use textbody in emailmessage.
08/06/2019			Daniel Glaser		IM02577761	Missing Attachment Not Exporting over
10/09/2019			Gidon Payenson		IM02659096  Email Reply address clenaup. Skip this handler if email to customer service
11/01/2019			Sudipto Ghosh		D-1843     - Preventing the case creation loop during Out Of Office Auto Reply with dynamic URL  	
12/13/2019          Sudipta Mukherjee	IM02737086   To add a check for the Subject length before creating Cases.
12/13/2019          Sudipta Mukherjee   IM02737077  Email id length check upto 80 charecters
Still not deployed(1/8/2020) 12/30/2019          Daniel Glaser		IM02756476  Email hash code fix for exception: Ending position out of bounds
-------------------------------------------------------------------------------------------------

*/
global without sharing class NS_EmailtoCaseHandler implements Messaging.InboundEmailHandler {
    List<OrgWideEmailAddress> owdEmails;
    /*
    * handleInboundEmail method of InboundEmailHandler interface is being overriden to create case based on email services.
    */
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope)
    {
        final String className = 'NS_EmailtoCaseHandler';
        String METHOD_NAME='handleInboundEmail';
        Case cse = new Case();
        String caseNum='';
        String toAddress='';
        String toAddresses='';
        String ccAddresses='';
        String forwardingEmails='';
        String emailHtmlBody = email.HtmlBody;
        String emailBody = email.plainTextBody;
        String searchStr = email.subject+email.plainTextBody;
        String owd = System.Label.NS_NoReplyOrgWideAddress;
        String noReplyMsg = 'This is a no reply mail and this inbox is not being monitored';
        String message='Please ensure that the Norfolk Southern email address you are attempting to contact is populated in the email "To" line.';
        Boolean createNewCase = true;
        Set<String> emailToExclude = new Set<String>();
        String queueName = '';
        string libAddress = '';
        Integer hashcode = 0;
        //Added By Sudipta for Email Subject max length check
        Integer maxSize = 255;
        //Added By Sudipta to store the emails those are only having length upto 80 charecter 
        Integer maxemailidlength=81;
        ID queueId;
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        system.debug('NS_EmailtoCaseHandler handleInboundEmail entered');
        //IM02506283 - Gidon -- 06/26/19  -- map to keep EmailToQueue metadata. Key = Forwarding_Address__c
        Map<string,NS_EmailToQueue__mdt>  emailToQueueMdtMap = new Map<string,NS_EmailToQueue__mdt>();
        /*Comment out below line for deployment on 11/26/2019 to be syncwith production by Sudipto G                      */
		//system.debug('NS_EmailtoCaseHandler handleInboundEmail skip= ' + NS_EmailUtils.skipEamilToCaseHandler(email));
		If (!NS_EmailUtils.skipEamilToCaseHandler(email)) { //IM02659096 gp
            try{
                
                List<Attachment> allAttachment = new List<Attachment>();
                Set <String> emailaddr = new Set<String> ();
    
               // for(NS_EmailToQueue__mdt allEmail :[SELECT Label, Routing_Email_1__c ,Forwarding_Address__c FROM NS_EmailToQueue__mdt LIMIT 50000]){
               for(NS_EmailToQueue__mdt allEmail :[SELECT Queue_Id__c, Label, Routing_Email_1__c ,Forwarding_Address__c
                                                    FROM NS_EmailToQueue__mdt LIMIT 50000]){ //IM02506283
    
                if(allEmail.Forwarding_Address__c != null){
                        emailaddr.add(allEmail.Forwarding_Address__c);
                        emailToQueueMdtMap.put(allEmail.Forwarding_Address__c,allEmail); //IM02506283
                    }
                    if(allEmail.Label.equalsIgnoreCase(NS_StaticVariablesUtility.NS_EMAILTOLIBRARY)){
                        libAddress = allEmail.Forwarding_Address__c;
                    }
                }
    
                //If to address  or  cc address is available.
                if(email.toAddresses != null) {
                    for(String addr : email.toAddresses){
                        for(String frwdAdd : emailaddr){
                            //IM02506283 - Gidon -- 06/26/19  -- replaced with split.
                            //frwdAdd contains semicolon separated email addresses
                            //if(frwdAdd.toLowerCase().contains(addr.toLowerCase())){
                            For (string splitAddr: frwdAdd.split(';')) {  //IM02506283 - Gidon -- 06/26/19  -- split to find exact match
                                if(splitAddr.toLowerCase() == addr.toLowerCase()){
                                    //if(toAddress == ''){  //IM02506283 - Gidon -- 06/26/19 no need any more
                                        toAddress = addr;
                                    //}
                                    emailToExclude.add(addr);
                                    //IM02506283 - Gidon -- 06/26/19 added 2 lines to get values from map
                                    queueId = (ID)emailToQueueMdtMap.Get(frwdAdd).Queue_Id__c;
                                    queueName = emailToQueueMdtMap.Get(frwdAdd).Label; //gp
                               }
                            if (toAddress != '') break; //IM02506283 - Gidon -- 06/26/19 -- break when match found
                            }
                        if (toAddress != '') break; //IM02506283 - Gidon -- 06/26/19 -- break when match found
                        }
                    if (toAddress != '') break; //IM02506283 - Gidon -- 06/26/19 -- break when match found
                    }
                }
    
                //If to address is not a part of metadata, search for cc address instead.
                //if(toAddress == '' && email.ccAddresses != null){
                //if(email.ccAddresses != null) //IM02506283 - Gidon -- 06/26/19  -- replaced with split.
                                                                //frwdAdd contains semicolon separated email addresses
                if(email.ccAddresses != null && toAddress == ''){ //IM02506283 - Gidon -- 06/26/19  -- only ifno match in To Address
                    for(String ccAddr : email.ccAddresses){
                        for(String frwdAdd : emailaddr){
                            //system.debug('NS_EmailToCaseHandler:frwdAdd.toLowerCase= ' + frwdAdd.toLowerCase());
                            //system.debug('NS_EmailToCaseHandler:ccAddr.toLowerCase()= ' + ccAddr.toLowerCase());
                            For (string splitAddr: frwdAdd.split(';')) { //IM02506283 - Gidon -- 06/26/19  -- use split for exact match
                                if(splitAddr.toLowerCase() == ccAddr.toLowerCase()){
                                    //if(toAddress == ''){ //IM02506283 - Gidon -- 06/26/19  -- redundant, since breaking
                                    toAddress = ccAddr;
                                    //}
                                    emailToExclude.add(ccAddr);
                                    //IM02506283 - Gidon -- 06/26/19 added 2 lines to get values from map
                                    queueId = (ID)emailToQueueMdtMap.Get(frwdAdd).Queue_Id__c;
                                    queueName = emailToQueueMdtMap.Get(frwdAdd).Label;
    
                                }
                            if(toAddress != '') break; //IM02506283 - Gidon -- 06/26/19 -- break when match found
                            }
                        if(toAddress != '') break; //IM02506283 - Gidon -- 06/26/19 -- break when match found
                        }
                    if(toAddress != '') break; //IM02506283 - Gidon -- 06/26/19 -- break when match found
                    }
                }
                if(toAddress != ''){
                    /*Comment out below line for deployment on 11/26/2019 to be syncwith production by Sudipto G
                     */
                    //system.debug('ANAA toAddress*********' + toAddress);
                    if(owd.equalsIgnoreCase(toAddress) || ''.equalsIgnoreCase(toAddress)){
                        sendBounceBack(email, noReplyMsg);
                    }
    
                    /*The attachment needs to be stored in Salesforce Library if email is sent to Custom Label>NS_LibraryEmail
                    *Request# 1464
                    *Developer: Jyoti
                    *Date: 01/21/2019
                    */
                    //Code modification done for D-1152 by Ananya on 6/7/2019
                    /*else if(Label.NS_LibraryEmail.equalsIgnoreCase(toAddress)){
                        createLibraryFile(email);
                    }
    
                    else if(toAddress.contains(Label.NS_LibraryEmail)){
                        createLibraryFile(email);
                    }*/
                    
                    /*Comment out below line for deployment on 11/26/2019 to be syncwith production by Sudipto G
                     */
                    else if(libAddress != null && (libAddress.toLowerCase().contains(toAddress.toLowerCase()))){
                    //system.debug('ANAA libAddress **********' + libAddress);
                        
                  //  else if(libAddress.toLowerCase().contains(toAddress.toLowerCase())){
                        createLibraryFile(email);
                    }
    
                    //
                    //End of change for Request# 1464
                    else{
                        if(email.toAddresses != null){
                            for(String emailId : email.toAddresses){
                                toAddresses += emailId+NS_StaticVariablesUtility.NS_SemiColon;
                            }
                        }
                        if(email.ccAddresses != null){
                            for(String emailId : email.ccAddresses){
                                ccAddresses += emailId+NS_StaticVariablesUtility.NS_SemiColon;
                            }
                        }
                        /* IM02506283 --------------------------
                        for(NS_EmailToQueue__mdt casePriorityMappings : [SELECT Label, DeveloperName, Queue_Id__c,Forwarding_Address__c,Routing_Email_1__c
                                                                         FROM NS_EmailToQueue__mdt LIMIT 50000]){
    
    
                                                                             if(casePriorityMappings.Forwarding_Address__c != null && String.valueOf(casePriorityMappings.Forwarding_Address__c).contains(toAddress)){
                                                                                 queueId = (ID)casePriorityMappings.Queue_Id__c;
                                                                                 queueName = casePriorityMappings.Label;
                                                                                 break;
                                                                             }
    
                                                                         }
    
                        */ //IM02506283  ---------------------------------
                        pattern myPattern = pattern.compile(NS_StaticVariablesUtility.NS_Regex);
                        matcher myMatcher = myPattern.matcher(searchStr);
                        Integer count =limits.getLimitQueryRows();
                        if (!test.isRunningTest()){ //COVERAGE gp 07/16/19
    
                            String queueEmail = [SELECT Id, Name, Email FROM Group where Type = 'Queue' and Id = :queueId].Email;
                            owdEmails = [SELECT Id, Address FROM OrgWideEmailAddress where Address = :queueEmail];
                            //Get First match
                            //
                            while (myMatcher.find()) {
                                List<String> parts = (myMatcher.group(0)).split(NS_StaticVariablesUtility.NS_Colon);
                                if(!parts.isEmpty()){
                                    caseNum = parts[1];
                                }
                                break;
                            }
                        }
                        // 1.23.2019, update to use matches()
                        /*if (myMatcher.matches()) {
                            List<String> parts = (myMatcher.group(0)).split(NS_StaticVariablesUtility.NS_Colon);
                            caseNum = parts[1];
                        }*/
    
                        try {
                            List<Contact> vCon = [SELECT Id,AccountId, Name, Email FROM Contact WHERE Email = :email.fromAddress LIMIT:count];
                            if(!String.isEmpty(caseNum)){
                                List<Case> caseList = [Select id,casenumber,IsClosed from Case where casenumber = :caseNum.trim() LIMIT 1];
                                if(!caseList.isEmpty()){
                                    cse = caseList[0];
                                    createNewCase = false;
                                }
                            }
                            system.debug('NS_EmailtoCaseHandler handleInboundEmail text body length '+email.plainTextBody.length());
                            // IM02319098 can only copy 32000 characters to description
                            if(email.plainTextBody != null && email.plainTextBody.length() > NS_StaticVariablesUtility.NS_CaseDescriptionLimit){
                                emailBody = 'Email message has been truncated due to size limit. Please refer to attachment/email for full message '+emailBody.substring(0, NS_StaticVariablesUtility.NS_CaseDescriptionLimit);
                            }
                            // system.debug('NS_EmailtoCaseHandler emailHtmlBody '+emailHtmlBody.length());
                            if(email.HtmlBody != null && email.HtmlBody.length() > NS_StaticVariablesUtility.NS_emailBodyLimit){
                                emailHtmlBody = emailHtmlBody.substring(0, NS_StaticVariablesUtility.NS_emailBodyLimit);
                            }
                            // system.debug('NS_EmailtoCaseHandler emailHtmlBody check '+emailHtmlBody.length());
                            List<String> allEmails = new List<String>();
                            String lastEmailToCc = NS_StaticVariablesUtility.CONST_BLANK;
                            for(String lstEmail : toAddresses.split(';')){
                               //IM02737077: Email id length upto 80 charecters by sudipta
                                if(!emailToExclude.contains(lstEmail) && lstEmail.length()<maxemailidlength){
                                    allEmails.add(lstEmail);
                                
                                }else{
                                    forwardingEmails += lstEmail+' ';
                                }
    
                            }
                            for(String lstccEmail : ccAddresses.split(';')){
                                //IM02737077: Email id length upto 80 charecters by sudipta
                                if(!emailToExclude.contains(lstccEmail) && lstccEmail.length()<maxemailidlength){
                                    allEmails.add(lstccEmail);
                                }else{
                                    forwardingEmails += lstccEmail+' ';
                                }
                            }
                            forwardingEmails = forwardingEmails.trim();
                            if(forwardingEmails.length() > 255){
                                forwardingEmails = forwardingEmails.substring(0, 256);
                            }
                            if(!allEmails.isEmpty()){
                                for(String emailId : allEmails){
                                    lastEmailToCc += emailId+NS_StaticVariablesUtility.NS_SemiColon;
                                }
                            }
                            if(createNewCase){
                                //String body=emailBody.replace('\u2028','\n');
                                system.debug('NS_EmailtoCaseHandler handleInboundEmail: description length '+emailBody.length());
                                Case cseSobj = new Case();
                                cseSobj.put('Queue_Type__c',queueName);
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
                                cseSobj.put('ownerID',queueId);
                                // Added by Sudipto G for D-1843 preventing the case creation loop during Out Of Office Auto Reply with dynamic URL 
                                
                                String urlStart = '$$$$$$';
                                String finalemailbody = '';
                                Integer emailUrlCount = 0;
                                String emailbodyReplace = emailBody;
                                emailbodyReplace = emailbodyReplace.replace('http://', '$$$$$$');
                                emailbodyReplace = emailbodyReplace.replace('https://', '$$$$$$');
                                emailbodyReplace = emailbodyReplace.replace('ftp://', '$$$$$$');
                                emailUrlCount = emailbodyReplace.indexOf(urlStart);
                                System.debug('emailUrlCount' +emailUrlCount);
                                System.debug('emailbodyReplace' +emailbodyReplace);
                                if(emailUrlCount == -1)
                                {
                                    hashcode = (Date.today()+''+NS_StaticVariablesUtility.NS+''+emailBody+''+email.subject).hashcode();
                                }
                                else
                                {
                                    finalemailbody = emailbodyReplace;
                                    //finalemailbody = emailbodyReplace+ ' ';  // Daniel Glaser for Ending position out of bounds
                                    finalemailbody = finalemailbody.replace('\r\n', ' ');
                                    finalemailbody = finalemailbody.replace('\n', ' ');
                                    finalemailbody = finalemailbody.replace('\r', ' ');
                                    Boolean urlFound = true;
                                    while(urlFound)
                                    {
                                        emailUrlCount = finalemailbody.indexOf(urlStart);
                                        String startUrl = finalemailbody.substring(emailUrlCount);
                                        System.debug('startUrl' +startUrl);
                                        String endUrlidentifier = ' ';
                                        Integer emailUrlendIndex = startUrl.indexOf(endUrlidentifier);
                                        System.debug('emailUrlendIndex' +emailUrlendIndex);
                                        String emailUrl = finalemailbody.substring(emailUrlCount,emailUrlCount+emailUrlendIndex);
                                        System.debug('emailUrl' +emailUrl);
                                        finalemailbody = finalemailbody.replace(emailUrl, '');
                                        Integer emailUrlCheck = finalemailbody.indexOf(urlStart);
                                        System.debug('emailUrlCheck' +emailUrlCheck);
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
                                if(!vCon.isEmpty() && vCon.size() == 1){
                                    cseSobj.put('ContactId',vCon[0].Id);
                                }
    
                                if(lastEmailToCc!=NS_StaticVariablesUtility.CONST_BLANK){
                                    cseSobj.put('NS_LastEmailAddresses__c',lastEmailToCc);
                                }
                                cseSobj.put('NS_Email_1__c',email.fromAddress);
                                cseSobj.put('Forwarding_Emails__c',forwardingEmails);
    
    
                                List<String> emailFieldApiNames = new List<String>();
                                //add all 25 email field api name starting from 2.
                                for(Integer apiNameIndex = 2; apiNameIndex <= 25 ; apiNameIndex ++){
                                    emailFieldApiNames.add('NS_Email_'+apiNameIndex+'__c');
                                }
    
    
                                for(Integer i=0; i<allEmails.size(); i++){
                                    if(i == emailFieldApiNames.size()){
                                        break;
                                    }
                                  /*  //this is added by Sudipta
                                    if(allEmails.get(i).length()<80)
                                    {*/
                                    cseSobj.put(emailFieldApiNames.get(i),allEmails.get(i));
                                   // }
                                    //to avoid going beyond 25 emails and throw exception.
                                }
                                 //COVERAGE gp 07/16/19 group is created in test class. Need to set ownerid to newly created case
                                 //-------------
                                if(Test.isRunningTest()){
                                    Group testGr = [Select ID from Group where type='Queue' limit 1];
                                    If (testGr != null) {
                                        cseSObj.OwnerId = testGr.id;
                                    }
                                } //COVERAGE gp 07/16/19-----------
    
                                Database.insert(cseSobj);
                                hashcode = 0;
                                cse = [Select id,casenumber,NS_LastEmailAddresses__c,Subject,IsClosed from Case where Id = :cseSobj.Id LIMIT 1];
                            }
                            system.debug('NS_EmailtoCaseHandler cse check for null');
                            if(cse != null){                                
                                //Attach email to the email related list
                                EmailMessage emailMsg = new EmailMessage(); // Created a EmailMessage and copy all details from above.
                                emailMsg.ToAddress=toAddresses;
                                emailMsg.CcAddress=ccAddresses;
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
                                // IM02533777, IM02535878, IM02544832
                                // By using emailbody no &nbsp will show up.
                                if(email.plainTextBody != null && email.plainTextBody.length() > NS_StaticVariablesUtility.NS_EmailBodyLimit){
                                    emailBody = email.plainTextBody.substring(0, NS_StaticVariablesUtility.NS_CaseDescriptionLimit) + ' \r\n' +' ------------ Email message has been truncated due to size limit. Please refer to attachment for full message ';
                                } else {
                                    emailBody = email.plainTextBody;
                                }
                                    
                                emailMsg.TextBody=emailBody;
                                if(emailHtmlBody!=null){
                                  emailMsg.HtmlBody=emailHtmlBody;
                                  system.debug('NS_EmailtoCaseHandler Create emailmsg with html body length '+emailHtmlBody.length());
                                  // system.debug('html body: '+emailHtmlBody);
                                }
                                system.debug('NS_EmailtoCaseHandler Create emailmsg toaddress '+toAddresses);
                                system.debug('NS_EmailtoCaseHandler Create emailmsg CCaddress '+ccAddresses);                            
                                emailMsg.ParentId = cse.Id; //Attach with the case
                                emailMsg.MessageDate = system.now();
                                emailMsg.Status='0';
                                emailMsg.Incoming=true;
                                emailMsg.FromAddress=email.fromAddress;
                                Database.insert(emailMsg);
    
                                if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
    
                                    for (integer i = 0; i < email.binaryAttachments.size(); i++) {
                                        allAttachment.add(new Attachment(
                                            ParentId = emailMsg.Id,
                                            Name = email.binaryAttachments[i].filename,
                                            Body = email.binaryAttachments[i].body));
    
                                    }
                                }
    
                                // if(email.plainTextBody.length() > NS_StaticVariablesUtility.NS_CaseDescriptionLimit){
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
                                        system.debug('NS_EmailtoCaseHandler Process clips of html data '+strbody.length());
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
                                            system.debug('NS_EmailtoCaseHandler htmlbody rebuilt');
                                        } else {
                                            strhtmlbody = email.htmlBody;
                                            //system.debug('htmlbody Contains no src html length '+strhtmlbody.length());
                                        }
                                    }
                                    //********************************************
                                    // END Dan IM02319098 - Undeliverable emails
                                    //system.debug('blob size '+strhtmlbody.length());
                                    // system.debug('blob text '+strhtmlbody);
                                    // Dan IM02319098 - Undeliverable emails
                                    blob pdfcontents = convertToPdf(strhtmlbody, email.plainTextBody);
                                    // system.debug('NS_EmailtoCaseHandler pdfcontents size '+pdfcontents.size());
                                    //Gets attached to Attachment related List
                                    Attachment att = new Attachment(
                                        ParentId = emailMsg.Id,
                                        IsPrivate = false,
                                        ContentType = 'application/pdf',
                                        Name = email.subject+NS_StaticVariablesUtility.Space+NS_StaticVariablesUtility.Hyphen+
                                        NS_StaticVariablesUtility.Space+cse.casenumber+NS_StaticVariablesUtility.Dot+NS_StaticVariablesUtility.PDF,
                                        // Body = blob.toPDF(email.htmlBody.replaceall('src','')));
                                        Body = pdfcontents);
                                    //system.debug('body size '+email.htmlBody.length());
                                    //system.debug('PDF body size '+att.Body.size());
                                    allAttachment.add(att);
                                }
                            }
                            if (allAttachment.size() > 0) {
                                system.debug('NS_EmailtoCaseHandler contains attachments');
                                Database.insert(allAttachment);
                            }
                            result.success = true;
                            // system.debug('NS_EmailtoCaseHandler Final body size '+email.htmlBody.length());
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
                                        system.debug('NS_EmailtoCaseHandler handleInboundEmail Case already created '+hcaseck[0].id);
                                        return result;
                                    }					
                                }
                                
                            }                    	
                            NS_StaticVariablesUtility.createExceptionRecord(e, className, className);
                        }
                    }
                }
                else{
                    sendBounceBack(email, message);
                }
              
              }catch(Exception ex){
    
                NS_StaticVariablesUtility.createExceptionRecord(ex, className, METHOD_NAME );
            }
        } 
        return result;
    
    }

   /*
    * This method sends the bounce back message to customer if they are trying to reply back on noreply address
    */
    public void sendBounceBack(Messaging.InboundEmail email, String Message){

        String className='NS_EmailtoCaseHandler';
        String subjectMsg='No Reply Mail';
        String METHOD_NAME='sendBounceBack';
        try{
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            semail.toAddresses = new List <String> {email.fromAddress};
            semail.setSubject(subjectMsg);
            semail.setplainTextBody(Message);
            system.debug('semail.toAddresses = ' + semail.toAddresses);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { semail });
        }
        catch (Exception e) {
            NS_StaticVariablesUtility.createExceptionRecord(e, className, METHOD_NAME );
        }
    }

    /*The attachment needs to be stored in Salesforce Library if email is sent to Custom Label>NS_LibraryEmail
    *Request# 1464
    *Developer: Jyoti
    *Date: 01/21/2019
    */
    public void createLibraryFile(Messaging.InboundEmail email){
        List<ContentFolder> rampFolder = new List<ContentFolder>();
        List<ContentFolder> monthFolder = new List<ContentFolder>();
        String eSubject;
        Id parentFolder;
        try{
            //ContentWorkspace is Library, e.g. Automotive Library

            ContentWorkspace cw = [SELECT Id, Name FROM ContentWorkspace WHERE Name =: Label.NS_LibraryName LIMIT 100];

            //ContentFolder is File
            ContentFolder cf = [SELECT Id,Name FROM ContentFolder WHERE Name =: cw.Id LIMIT 100];
            List < ContentFolderLink > cfl = [SELECT Id, ContentFolderId, ParentEntityId
                                             FROM ContentFolderLink
                                             WHERE ParentEntityId = : cw.Id LIMIT 100];
            if (cfl.size() > 0) {
                //All punctuation characters except ' and \
                String regExp = '[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]';

                //Prepare a string from email subject in uppercase and without punctuation
                // eSubject = ((email.subject).replaceAll(regExp, NS_StaticVariablesUtility.CONST_BLANK)).toUpperCase()+ '%';

                  eSubject = email.subject.trim() +'%';

                //Library Folder name is ramp name which is expected in email subject
                  rampFolder = [SELECT Id, Name, ParentContentFolderId FROM ContentFolder where Name LIKE: eSubject and ParentContentFolderId =: cf.Id];

                //If ramp folder is not present, file will be created inside 'Automotive Library'
                if(rampFolder.isEmpty()){
                    parentFolder = cf.Id;
                }
                //If Ramp folder is present then look for current month folder with name as 'yyyy-mm'
                else{
                    String yearMonth = String.valueOf((System.today()).year())+ '-'+ String.valueOf((System.today()).month());
                    monthFolder = [SELECT Id, Name, ParentContentFolderId FROM ContentFolder where ParentContentFolderId =: rampFolder[0].Id AND Name=:yearMonth LIMIT 100];
                    if(monthFolder.isEmpty()){
                        monthFolder.add(new ContentFolder(Name = yearMonth, ParentContentFolderId = rampFolder[0].Id));
                        Insert monthFolder;
                    }
                    //File will be created inside the month folder
                    parentFolder = monthFolder[0].Id;
                }

            }
            List<ContentVersion>cvList = new List<ContentVersion>();
            List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
            //Create the files with title as 'email subject yyyy-MM-dd HH-mm'
            for (Messaging.InboundEmail.BinaryAttachment binAttach : email.binaryAttachments) {
                ContentVersion conInsert = new ContentVersion();
                if(eSubject == null){
                    conInsert.Title = '';
                }
                else{
                    conInsert.Title = eSubject.removeEnd('%') +' '+ (system.now()).format('yyyy-MM-dd HH-mm','America/New_York');
                }
                conInsert.VersionData = binAttach.body;
                conInsert.PathOnClient = '/' + binAttach.fileName ;
                cvList.add(conInsert);
            }
            insert cvList; //File insert
            //create the junction object ContentDocumentLink, file access is defined here
            cvList = [select id, ContentDocumentId from ContentVersion WHERE Id in :cvList];
            for (ContentVersion cv : cvList) {
                ContentDocumentLink cl = new ContentDocumentLink();
                cl.ContentDocumentId = cv.ContentDocumentId;
                cl.LinkedEntityId = cw.Id;
                cl.ShareType = 'I';
                cl.Visibility = 'AllUsers';
                cdlList.add(cl);
            }
            insert cdlList;

            //Update the parent Folder
            //
            //ContentVersion cv =[SELECT ContentDocumentId FROM ContentVersion WHERE Id = : cvList[0].Id];
            SET<ID> cvIdList = new SET<ID>();
            List<ContentFolderMember> conFol= new List<ContentFolderMember>();
            for(ContentVersion cv1: cvList)
            {
                cvIdList.add(cv1.ContentDocumentId);
            }

            conFol = [SELECT ChildRecordId,Id,ParentContentFolderId,SystemModstamp FROM ContentFolderMember WHERE ChildRecordId IN : cvIdList LIMIT 100]; //cv.ContentDocumentId]cvList[0].ContentDocumentId;
            for(ContentFolderMember cfol : conFol)
            {
               cfol.ParentContentFolderId = parentFolder;
            }
            //upsert fol;
            update conFol;

        }
        catch(Exception ex){
            NS_StaticVariablesUtility.createExceptionRecord(ex, 'NS_EmailtoCaseHandler', 'createLibraryFile' );
        }
    }
    // iF Blob to pdf fails, use the email text instead of the htmltext
    // Dan IM02319098 - Undeliverable emails
    public blob convertToPdf(string strhtmlbody, string emailtext) {
			String tmp = strhtmlbody;
			String htmltext = '';
			blob pdfcontents = null;
			Pattern p = Pattern.compile('(<table[^>]*) width="[^"]*"');
			Matcher m = p.matcher(tmp);
			while (m.find()) {
		 		tmp = tmp.replaceFirst(m.group(), m.group().replaceAll(' width="[^"]*"',''));
			}
			try {
				system.debug(' converttoPdf call toBPF');
				pdfcontents = blob.toPDF(tmp);
			} catch (exception ex) {
				NS_StaticVariablesUtility.createExceptionRecord(ex, 'NS_EmailtoCaseHandler', 'convertToPdf' );
				system.debug(' converttoPdf pass emailtext toBPF');
				// pdfcontents = blob.toPDF(emailtext);
			}
    
			return(pdfcontents);  	
    }
}