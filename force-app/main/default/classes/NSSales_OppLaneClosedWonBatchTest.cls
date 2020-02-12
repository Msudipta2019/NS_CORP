@isTest(seeAllData=false)
public class NSSales_OppLaneClosedWonBatchTest {
    
    public static testmethod void OppClosedWon()
    {
         Test.startTest();
         String testVariable='Test';
         Account testAccount = AccountTestFactory.createAccountRecord(testVariable);
        BU__C testPAC = new BU__c();
        testPAC.RecordTypeId = Schema.SObjectType.BU__c.getRecordTypeInfosByName().get('Automotive').getRecordTypeId();
        testPAC.Account__c = testAccount.id;
        insert testPAC;
        Opportunity op = NSSales_OpportunityFactory.createOpportunityForHelper();  
        Opportunity op1 = NSSales_OpportunityFactory.createOpportunityForHelper(); 
        op1.NSSales_Parent_Opportunity__c =op.id;
        op1.NSSales_Account_Classification__c = testPAC.Id;
        update op1;
        NSSales_Opportunity_Lanes__c opl = new NSSales_Opportunity_Lanes__c();
        opl.NSSales_LaneId__c = '1000000004';
        opl.NSSales_Opportunity__c = op1.id;
        Datetime dt = DateTime.parse('09/25/2019 11:46 AM');
        opl.CreatedDate =dt;
        insert opl;
        opl.NSSales_Final_Rate__c ='Test';
        update opl;
        opl.NSSales_Final_Rate_Update__c = System.today()-14;
        update opl;
         Database.executeBatch(new NSSales_OppLaneClosedWonBatch());
        System.assert(opl.Id!=null);
        Test.stopTest();
    }
}