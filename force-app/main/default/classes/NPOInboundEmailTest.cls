@isTest
public class NPOInboundEmailTest {
    
             
        Public static String approvedStatus = 'Approved';
        Public static String StageNameInternalReview = 'Internal Review';  
    
        public static testmethod void testNPOInboundEmail(){    
        
        //Creating Admin User  
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        User atest;   
          
    //Creating Sales manager test User  
     System.runAs( admin ){ 
            Profile agent = UserTestFactory.createProfile(NS_StaticVariablesUtility.SalesManager);
            atest = UserTestFactory.createUserSales(22,agent.Id);
        
     
     } 
            
        //Creating Opportunity    
        // Creating an account for Opportunity
            Account acc = new Account(
                RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerBusiness' AND 
                                SobjectType ='Account' Limit 1].id,
                Name='AccountForOppotunity');
            insert acc;
           //Account classification Creation            
            BU__c accclassi= new BU__c();
            accclassi.RecordTypeId=Schema.SObjectType.BU__c.getRecordTypeInfosByName().get('Automotive').getRecordTypeId();
            accclassi.Account__c=acc.id;
            insert accclassi;
            // Creating a New Opportunity
            Opportunity Opty = new Opportunity();
            Opty.Name = 'Test';
            Opty.AccountId = acc.Id;
            Opty.NS_Originating_Department__c = 'Automotive';
            Opty.NS_Origin_Station__c='Test';	
            Opty.StageName = 'Qualification/Analysis';                
            Opty.CloseDate = System.Today();
            Opty.NS_Estimated_Volume__c=50;
            Opty.NS_Destination_Station__c='Test123';
            Opty.NSSales_Commodity_Group__c='Test123';
            Opty.Projected_Start_Date__c=System.Today();
            Opty.NS_Contract_Start_Date__c=System.Today();
            Opty.NS_Destination_State__c='Test';
            Opty.Frequency__c='Weekly';
            Opty.NSSales_Spot_Contract__c='Spot';
            Opty.NSSales_Need_by_Date__c=System.Today();
            Opty.NS_Origin_City__c='Kolkata';
            Opty.NSSales_Route__c='Test';
            Opty.NS_Destination_City__c='Kolkata';
            Opty.Consignee__c=acc.id;                
            Opty.NSSales_Shipper__c=acc.id;
            Opty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('General Opportunity').getRecordTypeId();
            //Opty.NSSales_Account_Classification__c =  accclassi.id;      
            insert Opty;
            

       //Update Opportunity   
        Opty.NS_SalesNPO_Approvers__c = atest.id;
            
        Opty.StageName=StageNameInternalReview;
        Opty.NSSales_OPS_Planning_Central__c = TRUE;
        Opty.NSSales_Account_Classification__c =  accclassi.id; 
        
        update Opty;
        Opportunity sNew = [select Id, NSSales_Opportunity_Number__c from Opportunity where id = : Opty.id];
    
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'Sandbox: '+sNew.NSSales_Opportunity_Number__c;//string.valueof(Opty.id);
        email.plainTextBody = 'Hello, this a test email body. For testing purposes only';
        email.HtmlBody = 'Hello, this a test email body. For testing purposes only.';
        email.toAddresses = new List<String>{System.Label.emailServiceAddress};   
        email.ccAddresses = new List<String>{'nsTest@testmail.com'};
            
        Messaging.InboundEmail.Header hditem= new Messaging.InboundEmail.Header();   
        hditem.name='Date'; 
        hditem.value='< image Tue, 28 Apr 2009 14:08:37 -0700 >';
        email.headers=new Messaging.inboundEmail.Header[]{hditem}; 
       
   
        envelope.fromAddress = 'test.testing@sometest.com'; 
         
        

        NPOInboundEmail emailServiceHandler = new NPOInboundEmail();
        system.debug(email.headers);
        Messaging.InboundEmailResult result =  emailServiceHandler.handleInboundEmail(email, envelope);
        
  
      
         
         }
    

}