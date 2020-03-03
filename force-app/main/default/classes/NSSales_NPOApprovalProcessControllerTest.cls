@istest
public class NSSales_NPOApprovalProcessControllerTest {
    @istest
    public static void NSSales_NPOApprovalProcessControllerTestPositive()
    {
        Opportunity op =  simpleOpty();
        Profile testIDProf = UserTestFactory.createProfile(NS_StaticVariablesUtility.NSSalesIDProfile);
        User testIDUser= UserTestFactory.createUser(13, testIDProf.Id);
        User testIDUser2= UserTestFactory.createUser(121, testIDProf.Id);
        
        op.NS_SalesNPO_Approvers__c=testIDUser.Id;
        op.NSSales_OPS_Planning_North__c = True;
        update op;
        op.NSSales_OPS_Planning_North__c = False;
        op.NSSales_OPS_Planning_East__c = True;
        update op;
        List<NSSales_NPO_Approval__c> childNPO2Opty= [select id,NSSales_Approval_Type__c,NSSales_Status__c from NSSales_NPO_Approval__c where NSSales_Related_Opportunity__c =: op.Id];
        List<ProcessInstanceWorkitem> pI = [select id, ProcessInstanceId from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :childNPO2Opty[0].Id];
        List<ProcessInstanceWorkitem> piDetails = NSSales_NPOApprovalProcessController.fetchProcessItemDetails(pI[0].ProcessInstanceId);
        String piDetailsString = NSSales_NPOApprovalProcessController.fetchProcessInstanceStepId(pI[0].ProcessInstanceId);
        String npoObjReq = NSSales_NPOApprovalProcessController.findObjectNameFromRecordId(childNPO2Opty[0].Id);
        String ObjVisibility = NSSales_NPOApprovalProcessController.getVisibility(pI[0].id);//npoObjReq
        String piObjId = NSSales_NPOApprovalProcessController.fetchObjectId(pI[0].id);
        
        NSSales_NPOApprovalProcessController.callReassignProcess(pI[0].id, testIDUser2.id,'Reassigned','Reassigned');
        NSSales_NPOApprovalProcessController.callApprovalProcess(pI[0].id, 'ApprovedTest', 'Approve');
        NSSales_NPOApprovalProcessController.callApprovalProcess(pI[0].id,'Rejecting request for Opportunity', 'Reject');
    }
    
    public static Opportunity simpleOpty()
    {
        Account acc = new Account(
            RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerBusiness' AND 
                            SobjectType ='Account' Limit 1].id,
            Name='AccountForOppotunity');
        insert acc;
        system.assertNotEquals(null,acc.id); 
        Opportunity opty = new Opportunity();
        opty.Name = 'Test';
        opty.AccountId = acc.Id;
        opty.NS_Originating_Department__c = 'Automotive';
        opty.StageName = 'Qualification/Analysis';                
        opty.CloseDate = System.Today();
        opty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NS_General_Opportunity').getRecordTypeId();
        insert opty;
        return opty;
    }
    
}