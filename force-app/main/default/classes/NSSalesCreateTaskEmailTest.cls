@isTest
private class NSSalesCreateTaskEmailTest {


    private static testmethod void testExistingOpp_Positive(){ 
        Account newAcc = new Account(Name='Test',RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerBusiness' AND 
                            SobjectType ='Account' Limit 1].id);
    insert newAcc;
    
        Opportunity newOpp = new Opportunity (Name='Testing',AccountId=newAcc.id,
         StageName='Qualification/Analysis',CloseDate=System.Today(),NS_Originating_Department__c ='Coal');
        insert newOpp;
        
        newOpp = [Select id,NSSales_Opportunity_Number__c from Opportunity where Id = :newOpp.Id LIMIT 1];
        
       

        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'This is the Email Subject';
        email.plainTextBody = 'Hello, this a test email body. For testing purposes only. Opportunity Number : '+newOpp.NSSales_Opportunity_Number__c;
        email.HtmlBody = 'Hello, this a test email body. For testing purposes only.';
       // email.toAddresses = new List<String>{'nssalescreatetaskemail@w-3147o6qbj1dmw49sfik87m1qix7oc8mkrw7o8ktc28uthw1j8x.0v-93ekeaq.'+
           // 'cs66.apex.sandbox.salesforce.com'};
        /*email.toAddresses = new List<String>{'nssalescreateemail@cne2u7mm26kbn5nv39y5ww8hrhw3co25dn02zxixm108w43yf.17-15mneay.'+
           'cs22.apex.sandbox.salesforce.com'};   */
        email.toAddresses = new List<String>{System.Label.emailServiceAddress}; 
        email.ccAddresses = new List<String>{'nsTest@testmail.com'};
            
        Messaging.InboundEmail.Header hditem= new Messaging.InboundEmail.Header();   
        hditem.name='Date'; 
        hditem.value='< image Tue, 28 Apr 2009 14:08:37 -0700 >';
        email.headers=new Messaging.inboundEmail.Header[]{hditem}; 
        system.debug('headers'+ email.headers.size());
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.headers = email.headers;
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            system.debug('binaryAttachmentsize'+ email.binaryAttachments.size());
      /*
        // add an Text atatchment
        Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo3.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
      */
        envelope.fromAddress = 'test.testing@sometest.com'; 
         
        
        NSSales_Email__c newEmail = new NSSales_Email__c(NSSales_Subject__c= email.subject,NSSales_TextBody__c = email.plainTextBody ,
        HTML_Body__c =email.htmlBody, NSSales_Opportunity__c=newOpp.id);
        insert newEmail;          

        NSSalesCreateTaskEmail emailServiceHandler = new NSSalesCreateTaskEmail();
        system.debug(email.headers);
        Messaging.InboundEmailResult result =  emailServiceHandler.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);
    }
    
    private static testmethod void testExistingOpp_Negative(){ 
        Account newAcc = new Account(Name='Test',RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerBusiness' AND 
                            SobjectType ='Account' Limit 1].id);
    insert newAcc;
    
        Opportunity newOpp = new Opportunity (Name='Testing',AccountId=newAcc.id,
         StageName='Qualification/Analysis',CloseDate=System.Today(),NS_Originating_Department__c ='Coal');
        insert newOpp;
        
        
        
        NSSalesCreateTaskEmail emailServiceHandler = new NSSalesCreateTaskEmail();

        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'This is the Email Subject';
        email.plainTextBody = 'Hello, this a test email body. For testing purposes only. Opportunity Number : '+newOpp.NSSales_Opportunity_Number__c;
        email.HtmlBody = 'Hello, this a test email body. For testing purposes only.';
       // email.toAddresses = new List<String>{'nssalescreatetaskemail@w-3147o6qbj1dmw49sfik87m1qix7oc8mkrw7o8ktc28uthw1j8x.0v-93ekeaq.'+
       //     'cs66.apex.sandbox.salesforce.com'};
        email.toAddresses = new List<String>{'nssalescreateemail@cne2u7mm26kbn5nv39y5ww8hrhw3co25dn02zxixm108w43yf.17-15mneay.'+
           'cs22.apex.sandbox.salesforce.com'};    
        email.ccAddresses = new List<String>{'nsTest@testmail.com'};
      
       //Creating Header For Inbound Email     
        Messaging.InboundEmail.Header hditem= new Messaging.InboundEmail.Header();   
        hditem.name='Date'; 
        hditem.value='< image Tue, 28 Apr 2009 14:08:37 -0700 >';
        email.headers=new Messaging.inboundEmail.Header[]{hditem}; 
       
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        attachment.headers = email.headers;
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            system.debug('binaryAttachmentsize'+ email.binaryAttachments.size());
       /* 
        // add an Text atatchment
        Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo3.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
      */
        envelope.fromAddress = 'test.testing@sometest.com'; 
        
        NSSales_Email__c newEmail = new NSSales_Email__c(NSSales_Subject__c= email.subject,NSSales_TextBody__c = email.plainTextBody ,
        HTML_Body__c = email.htmlBody, NSSales_Opportunity__c=newOpp.id);
        insert newEmail;
        
        Messaging.InboundEmailResult result = emailServiceHandler.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);
    }
     }