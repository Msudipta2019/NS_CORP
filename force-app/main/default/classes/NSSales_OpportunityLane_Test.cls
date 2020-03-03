@isTest
public class NSSales_OpportunityLane_Test {
	 @isTest
    static void testOppurtunityLane()
    {
        Account acc=new Account(Name='TEST');
        insert acc;
        
  
         Opportunity opp=new Opportunity(
             Name='CHECK',
        		CloseDate=System.today().addMonths(1),
        		StageName='Qualification/Analysis',
        		AccountId=acc.Id,
        		NS_Originating_Department__c='Automotive');
    
        insert opp;
               
        Test.startTest();
        NSSales_OpportunityLane.fetchOpportunityLane(opp.Id);
        Test.stopTest();
        
      
        System.assertNotEquals(null,opp.Id);     
        
    }

}