@isTest(SeeAllData=false)
public class NSSales_OppLaneClosedLostBatchTest {
   
    public static testmethod void testMethod1() {
        
        test.StartTest();
        opportunity opty = NSSales_OpportunityFactory.createOpportunityForHelper();
        Account testAccount = AccountTestFactory.createAccountRecord('Test');
        BU__C testPAC = new BU__c();
        testPAC.RecordTypeId = Schema.SObjectType.BU__c.getRecordTypeInfosByName().get('Automotive').getRecordTypeId();
        testPAC.Account__c = testAccount.id;
        insert testPAC;
        Opportunity op = NSSales_OpportunityFactory.createOpportunityForHelper(); 
        opty.NSSales_Parent_Opportunity__c =op.id;
       	update opty;
        
        NSSales_Opportunity_Lanes__c OLS = new NSSales_Opportunity_Lanes__c();
        OLS.NSSales_LaneId__c='a12364a';
        OLS.NSSales_Round_1_Rate__c = 'sddv';
        OLS.NSSales_Opportunity__c = opty.id;
        Datetime dates = DateTime.parse('05/30/2019 05:00 AM');
        OLS.CreatedDate =dates;
        OLS.NSSales_Round_1_Rate_Update__c = System.today() - 120;
        insert OLS;
        
        database.executeBatch(new NSSales_OppLaneClosedLostBatch());
        
        test.StopTest();
        
    }

}