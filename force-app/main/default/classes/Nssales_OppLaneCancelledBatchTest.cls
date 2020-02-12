@isTest(seeAllData=false)
public class Nssales_OppLaneCancelledBatchTest {
    public static testmethod void OppCanceled()
    {
         Test.startTest();
        Opportunity op = NSSales_OpportunityFactory.createOpportunityForHelper();  
        Opportunity op1 = NSSales_OpportunityFactory.createOpportunityForHelper(); 
        op1.NSSales_Parent_Opportunity__c =op.id;
        update op1;
        NSSales_Opportunity_Lanes__c opl = new NSSales_Opportunity_Lanes__c();
        opl.NSSales_LaneId__c = '1000000004';
        opl.NSSales_Opportunity__c = op1.id;
        Datetime dt = DateTime.parse('09/25/2019 11:46 AM');
        opl.CreatedDate =dt;
        insert opl;
         Database.executeBatch(new Nssales_OppLaneCancelledBatch());
        System.assert(opl.Id!=null);
        Test.stopTest();

    }
}