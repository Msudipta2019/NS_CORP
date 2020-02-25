public class NSSalesNPORejectionTriggerHelperTest {
/*********************not in use***********/

/*    Public static String approvedStatus = 'Approved';
    Public static String StageNameInternalReview = 'Internal Review';
    static testMethod void updateOpportunityForNPORejection() {
        
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        
        
        
        
        //Creating Sales manager test User 
        User atest; 
        System.runAs( admin ){ 
            Profile agent = UserTestFactory.createProfile(NS_StaticVariablesUtility.SalesManager);
            atest = UserTestFactory.createUserSales(22,agent.Id);
            
            
        }
        
        system.test.StartTest();
        System.runAs(admin){
            //Creating Opportunity   
            Opportunity Opty = NSSales_OpportunityFactory.createOpportunityForHelper();
            //Account classification Creation            
            BU__c accclassi= new BU__c();
            accclassi.RecordTypeId=Schema.SObjectType.BU__c.getRecordTypeInfosByName().get('Automotive').getRecordTypeId();
            //accclassi.Account__c=Opty.AccountId;
            insert accclassi;   
            
            // Associate Account Classification with Opportunity         
            Opty.NSSales_Account_Classification__c =  accclassi.id;
            update Opty;  
            //Update Opportunity   
            Opty.StageName=StageNameInternalReview;
            update opty;
            Opty.NS_SalesNPO_Approvers__c = admin.id;
            Opty.NSSales_OPS_Planning_East__c = TRUE;
            Opty.NSSales_OPS_Planning_North__c = TRUE;
            update Opty;
            
            NSSales_NPO_Approval__c nssapproval = [Select id,NSSales_Status__c from NSSales_NPO_Approval__c where NSSales_Related_Opportunity__c =:Opty.id LIMIT 1];
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Reject request for NPO');
            req.setAction('Reject');
           ProcessInstanceWorkitem workItem = [Select Id from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId =: nssapproval.id];
            req.setWorkitemId(workItem.Id);
            Approval.ProcessResult result = Approval.process(req);
            
    }
}
****/
}