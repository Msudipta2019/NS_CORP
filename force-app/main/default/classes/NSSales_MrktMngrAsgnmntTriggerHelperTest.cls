/************************************
Description  : Test class for NSSales_MrktMngrAsgnmntTriggerHelper class
Developer    : Soomjeet Sahoo
Date         : 21 Oct'19
**************************************/
@isTest(SeeAllData=false)
public class NSSales_MrktMngrAsgnmntTriggerHelperTest {
    public static testmethod void positiveMrktMngrTriggerHelperTestMain()
    {
        
        String testVariable='Test';
        
        //Starting Test
        Test.startTest();
        
        /*Test Account Created*/
        Account testAccount = AccountTestFactory.createAccountRecord(testVariable);
        
        /*NS Sales Manager profiles*/
        Profile user1Profile=UserTestFactory.createProfile('NS Sales Manager');
        Profile user2Profile=UserTestFactory.createProfile('NS Sales Manager');
        
        /*TestUser Accounts*/
        User user1= UserTestFactory.createUser(65, user1Profile.Id);
        User user2= UserTestFactory.createUser(53, user2Profile.Id);
        BU__c accPac= new BU__c();
        accPac.RecordTypeId=Schema.SObjectType.BU__c.getRecordTypeInfosByName().get('Automotive').getRecordTypeId();
        insert accPac;  
        BU__c accPac2= new BU__c();
        accPac2.RecordTypeId=Schema.SObjectType.BU__c.getRecordTypeInfosByName().get('Industrial Development').getRecordTypeId();
        insert accPac2; 
         BU__c accPac3= new BU__c();
        accPac3.RecordTypeId=Schema.SObjectType.BU__c.getRecordTypeInfosByName().get('Industrial Development').getRecordTypeId();
        insert accPac3;  

        
        
        //Record created for Marketing Manager Assignment
        NSSales_Marketing_Manager_Assignment__c nsMarketingRec= new NSSales_Marketing_Manager_Assignment__c(NSSales_Account__c=testAccount.id, 
                                                                                                            NSSales_MarketingManager__c=user1.id,
                                                                                                            Primary_Account_Classification__c=accPac2.id,
                                                                                                            NSSales_Role__c='Field Sales Manager',
                                                                                                            NSSales_BusinessUnit__c='Automotive');
        NSSales_Marketing_Manager_Assignment__c nsMarketingRec2= new NSSales_Marketing_Manager_Assignment__c(NSSales_Account__c=testAccount.id, 
                                                                                                             NSSales_MarketingManager__c=user1.id,
                                                                                                             Primary_Account_Classification__c=accPac3.id,
                                                                                                             NSSales_Role__c='Field Sales Manager',
                                                                                                             NSSales_BusinessUnit__c='Automotive');
        
        
        //insert comment
        database.SaveResult insNSMarketingRec= Database.insert(nsMarketingRec, true);
        database.SaveResult insNSMarketingRec2= Database.insert(nsMarketingRec2, true);
        System.assert(insNSMarketingRec.isSuccess());
        
        //update comment
        nsMarketingRec.NSSales_Role__c='Market Manager';
        nsMarketingRec.NSSales_MarketingManager__c=user2.Id;
        database.SaveResult updNSMarketingRec= Database.update(nsMarketingRec, true);
        System.assert(updNSMarketingRec.isSuccess());
        
        
        //delete comment
        database.DeleteResult delNSMarketingRec= Database.delete(nsMarketingRec, true);
        System.assert(delNSMarketingRec.isSuccess());
        
        //Stopping Test
        Test.stopTest(); 
        
    }
}