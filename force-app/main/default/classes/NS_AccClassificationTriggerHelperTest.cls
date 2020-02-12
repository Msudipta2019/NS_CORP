@isTest(SeeAllData=false)
public class NS_AccClassificationTriggerHelperTest {
	public static testmethod void positiveAccClassification()
    {
        Test.startTest();
        String testVariable='Test';
        Account testAccount = AccountTestFactory.createAccountRecord(testVariable);
        //BU__c testPAC = new BU__c(Account__c = testAccount.id,NS_Account_Type_BU__c='Customer',NSSales_Business_Group__c='Industrial Development',NS_Major_Group_BU__c='Coal',NS_Minor_Group_BU__c='Utility Coal',NS_Line_of_Business_BU__c='Utility North');
        BU__C testPAC = new BU__c();
        testPAC.RecordTypeId = Schema.SObjectType.BU__c.getRecordTypeInfosByName().get('Automotive').getRecordTypeId();
        testPAC.Account__c = testAccount.id;
        insert testPAC;
        
        BU__c testdupPAC = new BU__c();
         testdupPAC.RecordTypeId = Schema.SObjectType.BU__c.getRecordTypeInfosByName().get('Industrial Development').getRecordTypeId();
        testdupPAC.Account__c = testAccount.id;
        insert testdupPAC;
        System.assertNotEquals(testPAC.id, null);
         Test.stopTest(); 
    }
}