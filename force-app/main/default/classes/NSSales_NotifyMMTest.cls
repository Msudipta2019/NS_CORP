@isTest(SeeAllData=false)
public class NSSales_NotifyMMTest {
    public static testmethod void NSSales_NotifyMMTestPositiveTest()
    {
       
        Test.startTest();
        Account testAccount= AccountTestFactory.createAccountRecord('TestAcc');
        Profile user1Profile=UserTestFactory.createProfile('NS Marketing Manager'); 
        Profile user2Profile=UserTestFactory.createProfile('NS Marketing Manager');
        Profile user3Profile=UserTestFactory.createProfile('NS Marketing Manager');
        User user1= UserTestFactory.createUser(132, user1Profile.Id);
        user1.Email='crazymokey@gmail.com';
        User user2= UserTestFactory.createUser(393, user2Profile.Id);
        user2.Email='blackfox@gmail.com';
        User user3= UserTestFactory.createUser(582, user3Profile.Id);
        user3.Email='blackfox1@gmail.com';
        Opportunity opTest = new Opportunity();
        opTest.Name ='testOpty';
        opTest.CloseDate=(system.today()+3);
        opTest.AccountId=testAccount.id;
        opTest.NS_Originating_Department__c='Automotive';
        opTest.NSSales_Implementation_Date__c=(system.today());
        opTest.StageName='Qualification/Analysis';
        opTest.NSSales_Rate_Renewal_Expiration_Date__c = (system.today()+1);
        opTest.NS_Expiration_Notification_Timeframe__c = 1;
        opTest.Type='Renewal';
        opTest.NSSales_Source_System__c='NonIntermodal';
        insert opTest;
        BU__c userPAC= new BU__c(Account__c=opTest.AccountId);
        insert userPAC;
        NSSales_Marketing_Manager_Assignment__c nmm = 
            new NSSales_Marketing_Manager_Assignment__c(NSSales_Account__c = testAccount.Id ,
                                                        Primary_Account_Classification__c = userPAC.Id,
                                                        NSSales_MarketingManager__c = user1.id);
        
       
         NSSales_Marketing_Manager_Assignment__c nmm2 = 
            new NSSales_Marketing_Manager_Assignment__c(NSSales_Account__c = testAccount.Id ,
                                                        Primary_Account_Classification__c = userPAC.Id,
                                                        NSSales_MarketingManager__c = user2.id);
        
        NSSales_Marketing_Manager_Assignment__c nmm3 = 
            new NSSales_Marketing_Manager_Assignment__c(NSSales_Account__c = testAccount.Id ,
                                                        Primary_Account_Classification__c = userPAC.Id,
                                                        NSSales_MarketingManager__c = user3.id);
        insert nmm; 
        insert nmm2;
        insert nmm3;
        
        system.assertNotEquals(null,nmm.id); 
        DataBase.executeBatch(new NSSales_NotifyMM());
        Test.stopTest();
    }
    
}