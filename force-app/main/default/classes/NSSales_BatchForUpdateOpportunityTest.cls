@isTest 
public class NSSales_BatchForUpdateOpportunityTest {
    
static testMethod void testMethod1()
    {
        List<Opportunity> lstOpps= new List<Opportunity>();
        Account masterAccount= AccountTestFactory.createAccountRecord('BacthTest');
        
        
        
        for(Integer i=0 ;i < 5;i++)
        {
            Opportunity opp = new Opportunity();
            opp.Name ='Name'+i;
            opp.CloseDate=(system.today()+3);
            opp.AccountId=masterAccount.id;
            opp.NS_Originating_Department__c='Automotive';
            opp.NSSales_Implementation_Date__c=system.today();
            opp.StageName='Closed: Implementation Pending';
            opp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NPO Operations Opportunity').getRecordTypeId();
            lstOpps.add(opp);
        }
        
        insert lstOpps;
        
        Test.startTest();

            NSSales_BatchForUpdateOpportunity obj = new NSSales_BatchForUpdateOpportunity();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    


	public static testMethod void testschedule() {
		Test.StartTest();
		NSSales_BatchForupdateOppScheduler testsche = new NSSales_BatchForupdateOppScheduler();
		String sch = '0 0 01 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}

 
}