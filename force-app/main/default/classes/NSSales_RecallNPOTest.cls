@isTest
public class NSSales_RecallNPOTest {
    
    Public static String approvedStatus = 'Approved';
    Public static String StageNameInternalReview = 'Internal Review';
    static testMethod void updateOpportunityForNPORecall() {
        
        //Creating Admin User  
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        User atest;   
        User apprvOpp;        
        
        
        //Creating Sales manager test User  
        System.runAs( admin ){ 
            Profile agent = UserTestFactory.createProfile(NS_StaticVariablesUtility.SalesManager);
            atest = UserTestFactory.createUserSales(22,agent.Id);
            apprvOpp=UserTestFactory.createUserSales(23,agent.Id);
            
            //Group g=[select Id from Group Where DeveloperName='NPO_Approvers'];
            Group g=[select Id from Group Where DeveloperName='NPO_Approvers_Automotive'];
            
            GroupMember gm= new GroupMember(); 
            gm.GroupId=g.id;
            gm.UserOrGroupId = apprvOpp.id;
            insert gm;
        }
        
        system.test.StartTest();
        System.runAs(admin){
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
            Opty.NS_SalesNPO_Approvers__c = admin.id;
            Opty.StageName=StageNameInternalReview;
            Opty.NSSales_OPS_Planning_Central__c = TRUE;            
            Opty.NSSales_OPS_Planning_Central_Status__c = approvedStatus;
            Opty.NSSales_Account_Classification__c =  accclassi.id;   
            
            
            update opty;
           
          //  List<NSSales_NPO_Approval__c> nssapproval =New List<NSSales_NPO_Approval__c> ([select id,NSSales_Status__c from NSSales_NPO_Approval__c where NSSales_Related_Opportunity__c =:opty.id]);
           
            NSSales_RecallNPO.CheckAccess(opty.id); 
            NSSales_RecallNPO.RecallAction(opty.id,'Recalled due to Rejection'); 
     
        }
    }   
    
}