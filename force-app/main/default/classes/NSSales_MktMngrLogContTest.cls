/**@author  Accenture
* @Created Date 21stOct,2019
* @version  1.0
* @description This is the test class of NSSales_MrktMngrAssgnmntLogsController
*/ 
@isTest(SeeAllData=false)
private class NSSales_MktMngrLogContTest {
    static testmethod void testTerminalInsert(){
        Test.startTest();
        // Create a account
        Account acc = AccountTestFactory.createAccountRecord('NFS');
        system.assertNotEquals(null,acc.id); 
        //Create a profile
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User testUser = UserTestFactory.createUser(14,sysprof.Id);
        system.assertNotEquals(null,testUser.id); 
        // Create a marketing manager assignment
        NSSales_Marketing_Manager_Assignment__c createAsgn=new NSSales_Marketing_Manager_Assignment__c();
        createAsgn.NSSales_BusinessUnit__c='Automotive';
        createAsgn.NSSales_MarketingManager__c=testUser.id;
        createAsgn.NSSales_Role__c='Service Manager';
        createAsgn.NSSales_Account__c=acc.Id;
        insert createAsgn;
        system.assertNotEquals(null,createAsgn.id); 
        //Check to see whetermarketing manager assignment is associated with the log 
        NSSales_MarketingManagerAssignmentLog__c logDetails=[SELECT Id,NSSales_BusinessUnit__c,NSSales_MarketingManager__c,NSSales_Role__c,NSSales_Account__c FROM NSSales_MarketingManagerAssignmentLog__c WHERE NSSales_Account__c = :acc.Id];
        system.assertNotEquals(null,logDetails.Id); 
        NSSales_MrktMngrAssgnmntLogsController.getMarketingManagerAssignmentLog(acc.Id);
        Test.stopTest();
    }
}