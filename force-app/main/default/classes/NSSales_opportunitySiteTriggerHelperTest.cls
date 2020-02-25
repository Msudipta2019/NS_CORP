/**************************************************************************
Description  : Test Class for NSSales_opportunitySiteTriggerHelper class
Developer    : Accenture Solutions
Date         : 05-07-2019
****************************************************************************/
@isTest
public class NSSales_opportunitySiteTriggerHelperTest {
    
    static testMethod void updateOpportunityTestMethod(){
        
        Profile agent = UserTestFactory.createProfile(NS_StaticVariablesUtility.SalesManager);
        User atest = UserTestFactory.createUserSales(22,agent.Id);
        
        system.test.StartTest();
        System.runAs(atest){
            
            Account acc = new Account(
                RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerBusiness' AND 
                                SobjectType ='Account' Limit 1].id,Name='AccountForOppotunity');
            insert acc;
            
            Opportunity Opty = new Opportunity();
            Opty.Name = 'test Opty';
            Opty.AccountId = acc.id;
            Opty.StageName = 'Suspect';
            Opty.CloseDate = System.Today();
            Opty.NS_Originating_Department__c = 'Industrial Development';
            Opty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ID').getRecordTypeId();
            insert Opty;
            
            Site__c siteWon1 = new Site__c();
            Site__c siteWon2 = new Site__c();
            Opportunity_Site__c opSite1 = new Opportunity_Site__c();
            Opportunity_Site__c opSite2 = new Opportunity_Site__c();
            
            
            siteWon1.Name = 'Test Site 1';
            insert siteWon1;
            siteWon1.Name = 'Test Site 2';
            insert siteWon2;
            
            opSite1.Opportunity__c = Opty.Id;
            opSite1.Site__c = siteWon1.id;
            opSite1.NSSales_Stage__c = 'Working';
            insert opSite1;
            opSite1.NSSales_Stage__c = 'Won';
            update opSite1;
            
            opSite2.Opportunity__c = Opty.Id;
            opSite2.Site__c = siteWon1.id;
            opSite2.NSSales_Stage__c = 'Working';
            insert opSite2;
            opSite2.NSSales_Stage__c = 'Won';
            update opSite2;
            
            opSite1.NSSales_Stage__c = 'Lost';
            update opSite1;
            opSite2.NSSales_Stage__c = 'Lost';
            update opSite2;
        }
        System.test.StopTest();
        
    }
    
    
}