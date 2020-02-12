@isTest(SeeAllData=false)
public class NSSales_DeletePACWithNoAccBatchClassTest {
    
    public static testmethod void NSSales_DeletePACWithNoAccBatchClassPositiveTest()
    {
         Test.startTest();
        BU__c b1= new BU__c();
        b1.NSSales_Group_Name1__c = 'Test';
        b1.Record_Type_Duplication_Check__c='Test';
        b1.NS_Account_Type_BU__c='Customer';
        b1.NS_Business_Group_BU__c='Merchandise';
        b1.NS_Sub_Business_Group_BU__c='Industrial Products';
        b1.Account__c=null;

        insert b1;
  
        Database.executeBatch(new NSSales_DeletePACWithNoAccountBatchClass());
        
        Test.stopTest();
    }
}