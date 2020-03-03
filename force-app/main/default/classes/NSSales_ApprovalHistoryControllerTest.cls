@istest
public class NSSales_ApprovalHistoryControllerTest {
    @istest
    public static void fetchOpportunityIdfromProcessInstanceStepTest(){
    	//Creating Admin User  
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        User atest;
        User btest;
        
         //Creating Sales manager test User  
        System.runAs( admin ){ 
            Profile agent = UserTestFactory.createProfile(NS_StaticVariablesUtility.SalesManager);
            atest = UserTestFactory.createUserSales(22,agent.Id);
            
        }
        System.runAs(admin){
            Profile agent = UserTestFactory.createProfile(NS_StaticVariablesUtility.SalesManager);
            btest = UserTestFactory.createUserSales(24,agent.Id);
        }
        system.debug('atest'+atest.id);
        system.debug('debug'+btest.id);
        
        system.test.StartTest();
        
        //Opportunity Creation
        Opportunity Opty = NSSales_OpportunityFactory.createOpportunityForHelper();
        
        opty.NSSales_609_1_SwitchRemovalRequest__c=true;
        update opty;
        opty.NSSales_609_1_IDManagerApprovalOwner__c=atest.id;
        opty.NSSales_609_1_FSManagerApprovalOwner__c=btest.id;
        opty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NSSales_609_1').getRecordTypeId();
        update opty;
        system.assertNotEquals(null, atest.id);
        system.assertNotEquals(null, btest.id);
        NSSales_609_1_ApprovalProcessController.initiate_609_1_ApprovalProcess(opty.Id);
        List<ProcessInstanceWorkitem> p = [select id, ProcessInstanceId from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :opty.Id];
        List<ProcessInstanceStep> q = [select ProcessInstanceId from ProcessInstanceStep where ProcessInstance.TargetObjectId = :opty.Id];

        
        NSSales_ApprovalHistoryController.fetchHistory(opty.Id);
        NSSales_ApprovalHistoryController.fetchOpportunityIdfromProcessInstanceStep(q[0].id);
        system.assertNotEquals(null, p[0].id);
        system.assertNotEquals(null, q[0].id);
        NSSales_ApprovalHistoryController.getObjectRecordType(p[0].id);
        NSSales_ApprovalHistoryController.getObjectRecordType(q[0].id);
        NSSales_ApprovalHistoryController.getObjectRecordType(opty.Id);
        NSSales_ApprovalHistoryController.getObjectRecordType('');
        opty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NS_General_Opportunity').getRecordTypeId();
        update opty;
        NSSales_ApprovalHistoryController.getObjectRecordType(opty.Id);
        
    }

}