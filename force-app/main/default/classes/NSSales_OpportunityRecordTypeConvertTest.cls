@isTest
public class NSSales_OpportunityRecordTypeConvertTest {
    
    Static Final String Stage = 'Suspect';
    Static Final String OriginatingDepartment = 'Industrial Development';
    
    static testMethod void opportunityConvertTest() 
    {
                  
          Profile agent = UserTestFactory.createProfile(NS_StaticVariablesUtility.SalesManager);
            User atest = UserTestFactory.createUserSales(22,agent.Id);
        Account acc = new Account(
            RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerBusiness' AND 
                            SobjectType ='Account' Limit 1].id,Name='AccountForOppotunity');
         insert acc;
         
        Opportunity oppNew = new Opportunity();
        oppNew.Name = 'Test';
        
                oppNew.AccountId = acc.Id;
                oppNew.NS_Originating_Department__c = OriginatingDepartment;
                oppNew.StageName = Stage;                
                oppNew.CloseDate = System.Today();
                oppNew.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ID').getRecordTypeId();
        insert oppNew;
        oppNew.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('General Opportunity').getRecordTypeId();
        update oppNew;
        NSSales_OpportunityRecordTypeConvertion.opportunityConvert(oppNew.id);
        NSSales_OpportunityRecordTypeConvertion.showIDOptyInfo(oppNew.id);
    }

}