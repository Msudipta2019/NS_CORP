/*
Description  : This class covers the unit testing for NS_EmailToCaseHandler class
Developer    : Accenture Solutions
Date         : 20-06-2018

-----------------------------------------------------------------------
Developer name        Date          Description        
-----------------------------------------------------------------------
@Bharadwaj Urma    20-06-2018     Unit testing methods
@Gidon Payenson    07/16/2019     Modified testNewCase_CreateLibrary()[LIBRARY] 
@Gidon Payenson	   07/16/2019	  Added  methods to increase coverage [COVERAGE] 
Daniel Glaser	   07/18/2019     Added Large email test 
*/
@isTest(SeeAllData=false)
private without sharing class NS_EmailToCaseHandlerTest{ 
    
  //Class Variables for test data - COVERAGE  
  static  List<string> toAddressLst = new list<string>(); //to retain email ToAddresss
 /*
   * Test data setup  - COVERAGE
   * Created 07/15/19 gp
   */ 
    @testSetup 
    static void createAccountAndContat() {
      Account acc = AccountTestFactory.createAccountRecord('test Account');//Create account
      Contact con = ContactTestFactory.createContactRecord(acc.id, 'customerAccount') ;  //create contact     
      con.email = 'test.testing@sometest.com';  //set contact email
      update con;
      //toAddressLst=getToAddressFromMetadata(); //set To Address list
      Group g1 = new Group(Name='OSSEast', type='Queue'); //insert queue
      insert g1; 
        
    }
    
  /* COVERAGE
   * Get To Email Address from emailtoqueue forwarding address
   * Return value - email address (string) list
   * Created 07/15/19 
  */ 
    private static List<string> getToAddressFromMetadata (){
        if (toAddressLst.size() == 0){
        //get email to queue metadata 
            List<NS_EmailToQueue__mdt> allEmail =[SELECT Queue_Id__c, Label, Routing_Email_1__c ,Forwarding_Address__c 
                                                        FROM NS_EmailToQueue__mdt];
             //List<string> toAddrLst = new List<string>();
             //find a non null forwardng address  
              for (integer i=0; i< allEmail.size(); i++) { 
                        If (allEmail[i].Forwarding_Address__c != null) { //found
                            toAddressLst.add(allEmail[i].Forwarding_Address__c.split(';')[0]); 
                            break;
                        }    
                }
            //system.debug('toAddrLst= ' + toAddrLst);
        }
        return toAddressLst;
      }


    
/*
 * Test method to check if a case is getting created with below subject ,bodyline and the case owner
 */    
    private static testmethod void testNewCase_Positive(){ 
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(25,sysprof.Id);
        System.runAs( admin ){
        NS_EmailToCaseHandler emailServiceHandler = new NS_EmailToCaseHandler();
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'This is the Email Subject';
        email.plainTextBody = 'Hello, this a test email body. For testing purposes only.testNewCase_Positive';
        email.HtmlBody = 'Hello, this a test email body. For testing purposes only.testNewCase_Positive';//email.toAddresses = new List<String>{'1tncsoautomotiveboml@nscorp.com'};
        email.toAddresses = getToAddressFromMetadata(); //COVERAGE
        envelope.fromAddress = 'test.testing@sometest.com';
        email.fromAddress = 'test.testing@sometest.com';
		email.ccAddresses = new List<String>{'nsTest@testmail.com'};
        Messaging.InboundEmailResult result = emailServiceHandler.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);  
        //system.debug([select Id from Case where subject =: 'This is the Email Subject']);
        }
        
        
    }
    
    private static testmethod void testNewCase_Positive2(){ 
        /*List<String> queueEmail = new List<String>();
        for(Group emailAddr : [SELECT Email FROM Group WHERE DeveloperName = 'NS_UTSEnergy']){
            queueEmail.add(emailAddr.Email);
        }*/
        
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(25,sysprof.Id);
        System.runAs( admin ){
        NS_EmailToCaseHandler emailServiceHandler = new NS_EmailToCaseHandler();
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'This is the Email Subject';
        email.plainTextBody = 'Hello, this a test email body. For testing purposes only.testNewCase_Positive2';
        email.HtmlBody = 'Hello, this a test email body. For testing purposes only.testNewCase_Positive2';
        email.toAddresses = new List<String>{'1tncsoautomotiveboml@nscorp.com'};
        //email.toAddresses = getToAddressFromMetadata(); //COVERAGE gp 07/15/2019
        envelope.fromAddress = 'test.testing@sometest.com';
		//email.ccAddresses = new List<String>{'nsTest1@testmail.com'};
        email.ccAddresses = getToAddressFromMetadata();
        Messaging.InboundEmailResult result = emailServiceHandler.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);  
        }       
              
        
    }
    
    @istest      
    private static  void testExistingCase_Positive(){ 
      
        String emailToCaseRT = 'Email-to-Case';
      
        NS_EmailToCaseHandler emailServiceHandler1 = new NS_EmailToCaseHandler();
        Messaging.InboundEmail email1 = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope1 = new Messaging.InboundEnvelope();
        email1.subject = 'This is the Email Subject';
        email1.plainTextBody = 'Hello, this a test email body. For testing purposes only.testNewCase_Positive';
        email1.HtmlBody = 'Hello, this a test email body. For testing purposes only.testNewCase_Positive';
        //email1.toAddresses = new List<String>{'tncsoautomotiveboml@nscorp.com'};
            //connectns.nsuat+automotivebadorder-uat02@gmail.com
        
        email1.toAddresses = getToAddressFromMetadata(); //COVERAGE gp 07/15/2019
        envelope1.fromAddress = 'test.testing@sometest.com';
        email1.fromAddress = 'test.testing@sometest.com';
        email1.ccAddresses = new List<String>{'nsTest@testmail.com'};
        Messaging.InboundEmailResult result1 = emailServiceHandler1.handleInboundEmail(email1, envelope1);
 
        Case cse = [select Id, casenumber from Case where subject =: 'This is the Email Subject' LIMIT 1];
        NS_EmailToCaseHandler emailServiceHandler = new NS_EmailToCaseHandler();

        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'This is the Email Subject';
        email.plainTextBody = 'Hello, this a test email body. For testing purposes only. Case Number : '+cse.CaseNumber;
        email.HtmlBody = 'Hello, this a test email body. For testing purposes only.testExistingCase_Positive';
        //email.toAddresses = new List<String>{'tncsoautomotiveboml@nscorp.com'};
        email.toAddresses = getToAddressFromMetadata(); //COVERAGE gp 07/15/2019
        //email.toAddresses = toEmail;
        email.ccAddresses = new List<String>{'tncsoautomotiveboml@nscorp.com'};
        //email.ccAddresses = ccEmail;
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
      
        // add an Text atatchment
        Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo3.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
        email.fromAddress = 'test.testing@sometest.com';
        envelope.fromAddress = 'test.testing@sometest.com';
        Messaging.InboundEmailResult result = emailServiceHandler.handleInboundEmail(email, envelope);
        
        System.assertEquals( result.success  ,true);
    }
   
    
      
    private static testmethod void testNewCase_CreateLibrary(){ 
        /*List<String> queueEmail = new List<String>();
        for(Group emailAddr : [SELECT Email FROM Group WHERE DeveloperName = 'NS_AutomotiveEmpties']){
            queueEmail.add(emailAddr.Email);
        }*/
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User autoUser = UserTestFactory.createAutoLeadUser(25,sysprof.Id);
        System.runAs( autoUser ){
        NS_EmailToCaseHandler emailServiceHandler = new NS_EmailToCaseHandler();
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'This is the Email Subject';
        email.plainTextBody = 'Hello, this a test email body. For testing purposes only.testNewCase_CreateLibrary';
        email.HtmlBody = 'Hello, this a test email body. For testing purposes only.testNewCase_CreateLibrary';
        //email.toAddresses = new List<String>{'tncsoautomotiveboml@nscorp.com'};
        email.toAddresses = getToAddressFromMetadata(); //COVERAGE gp 07/15/2019
        envelope.fromAddress = 'test.testing@sometest.com';
		email.ccAddresses = new List<String>{'tncsoautomotiveboml@nscorp.com'};
		//email.ccAddresses = queueEmail;
        
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
      
        // add an Text atatchment
        Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo3.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
        //Modified 07/15/2019 LIBRARY gp -----------------------
        //Messaging.InboundEmailResult result = emailServiceHandler.handleInboundEmail(email, envelope);
        //System.assertEquals( result.success  ,true); 
        test.startTest(); 
        List<ContentVersion> cvList = [select id, ContentDocumentId from ContentVersion]; //get content version count  
        integer cvListSize = cvList.size();
        system.debug('cvListSize' +cvListSize);
        emailServiceHandler.createLibraryFile(email); //call method directly
        emailServiceHandler.sendBounceBack(email,'test message'); //COVERAGE
        test.stopTest();
        cvList = [select id, ContentDocumentId from ContentVersion]; //content version should be increased
        system.debug('cvListSize 2' +cvList.size());
        system.assertEquals(cvList.size()>cvListSize, true);
        // System.assertEquals( result.success  ,true); 
        //LIBRARY 07/15/2019 ------------------------- 
        }       
        
    }
    
    private static testmethod void testNewCase_Positive4(){ 
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(25,sysprof.Id);
        System.runAs( admin ){
        NS_EmailToCaseHandler emailServiceHandler = new NS_EmailToCaseHandler();
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'This is the Email Subject';
        email.plainTextBody = 'Hello, this a test email body. For testing purposes only.testNewCase_Positive4';
        email.HtmlBody = 'Hello, this a test email body. For testing purposes only.testNewCase_Positive4';
        //email.toAddresses = new List<String>{'tncsoautomotiveboml@nscorp.com'};
        email.toAddresses = getToAddressFromMetadata(); //COVERAGE gp 07/15/2019
        envelope.fromAddress = 'test.testing@sometest.com';
		email.ccAddresses = new List<String>{'tncsoautomotiveboml@nscorp.com; tncsoautomotiveboml@nscorp.com; tncsoautomotiveboml@nscorp.com'};
        Messaging.InboundEmailResult result = emailServiceHandler.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);  
        }
        
        
    }
    
    private static testmethod void testNewCase_Positive5(){ 
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(25,sysprof.Id);
        System.runAs( admin ){
        NS_EmailToCaseHandler emailServiceHandler = new NS_EmailToCaseHandler();
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'This is the Email Subject';
        email.plainTextBody = 'Hello, this a test email body. For testing purposes only.';
        email.HtmlBody = 'Hello, this a test email body. For testing purposes only.';
        //email.toAddresses = new List<String>{'tncsoautomotiveboml@nscorp.com; tncsoautomotiveboml@nscorp.com; tncsoautomotiveboml@nscorp.com'};
        email.toAddresses = getToAddressFromMetadata(); //COVERAGE gp 07/15/2019
        envelope.fromAddress = 'test.testing@sometest.com';
		email.ccAddresses = new List<String>{'tncsoautomotiveboml@nscorp.com; tncsoautomotiveboml@nscorp.com; tncsoautomotiveboml@nscorp.com; tncsoautomotiveboml@nscorp.com'};
        Messaging.InboundEmailResult result = emailServiceHandler.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);  
        }
        
        
    }
    
    private static testmethod void testNewCase_Positive6(){ 
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(25,sysprof.Id);
        System.runAs( admin ){
        NS_EmailToCaseHandler emailServiceHandler = new NS_EmailToCaseHandler();
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'This is the Email Subject';
        email.plainTextBody = 'Hello, this a test email body. For testing purposes only.testNewCase_Positive';
        email.HtmlBody = 'Hello, this a test email body. For testing purposes only.testNewCase_Positive';
        //email.toAddresses = new List<String>{'tncsoautomotiveboml@nscorp.com'};
        email.toAddresses = getToAddressFromMetadata(); //COVERAGE gp 07/15/2019
        envelope.fromAddress = 'test.testing@sometest.com';
		email.ccAddresses = new List<String>{'nsTest@testmail.com'};
        //Messaging.InboundEmailResult result = emailServiceHandler.handleInboundEmail(email, envelope);
        //System.assertEquals( result.success  ,true);
            
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
      
        // add an Text atatchment
        Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo3.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
            
        Messaging.InboundEmailResult result = emailServiceHandler.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);  
        }
        
        
    }

    // large text email test  @DG
    private static testmethod void testNewCase_PositiveLarge(){ 
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(25,sysprof.Id);
        System.runAs( admin ){
        NS_EmailToCaseHandler emailServiceHandler = new NS_EmailToCaseHandler();
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'This is the Large Email Subject';
        email.plainTextBody = createLargeString();
        email.HtmlBody = createLargehtml();
        // email.toAddresses = new List<String>{'tncsoautomotiveboml@nscorp.com'};
        email.toAddresses = getToAddressFromMetadata(); //COVERAGE gp 07/15/2019
        envelope.fromAddress = 'test.testing@sometest.com';
		email.ccAddresses = new List<String>{'nsTest@testmail.com'};
        Messaging.InboundEmailResult result = emailServiceHandler.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);  
        //system.debug([select Id from Case where subject =: 'This is the Large Email Subject']);
        }
        
    }      
    
    private static string createLargeString() {
    	string basestring = 'The quick brown fox Ran up the railroad track. The fast the fox ran the train kept getting closer. This is a test of large str.';
    	string largestring = basestring.repeat(256);
    	return largestring;
    }

    private static string createLargehtml() {
    	string basestring = '<br/>The quick brown fox Ran up the railroad track.<br/> The fast the fox ran the train kept getting closer.<p/> This is a test of large str.<br/>';
    	string largestring = basestring.repeat(256);
    	largestring += 'src   123';
    	largestring = largestring.repeat(4);
    	return largestring;
    }
        
    
    
}