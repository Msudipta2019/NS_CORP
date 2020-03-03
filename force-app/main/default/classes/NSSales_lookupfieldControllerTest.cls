@isTest(SeeAllData=false)
public class NSSales_lookupfieldControllerTest {
	public static testmethod void positiveTest()
    {
		String objName = 'BU__c';
        List<String> returnFieldList = new List<String>{'Name','NSSales_Group_Name1__c'};
        Account Acc1 = AccountTestFactory.createAccountRecord(NS_StaticVariablesUtility.Name);
        String accountId =Acc1.id;
        BU__c objAccClass = new BU__c();
        objAccClass.Account__c = Acc1.Id;
        objAccClass.NSSales_Group_Name1__c ='test001';
        insert objAccClass;
        List<String> QueryFieldsList = new List<String>{'Name','NSSales_Group_Name1__c'};
		NSSales_lookupfieldController.getObjectDetails(objName);
        System.assertEquals('BU__c',objName);
		NSSales_lookupfieldController.findObjectIcon(objName); 
         System.assertEquals('BU__c',objName);
        NSSales_lookupfieldController.GetRecentRecords(objName,returnFieldList,10);
       	System.assert(returnFieldList != null);
       	NSSales_lookupfieldController.SearchRecords(accountId, objName, returnFieldList, QueryFieldsList, 'Acct', 'CreatedDate', 'DESC', 0);
        List<sobject> test1 = NSSales_lookupfieldController.SearchRecords(accountId, objName, returnFieldList, QueryFieldsList, 'Acct', 'CreatedDate', 'DESC', 0);
        System.debug(test1);
        System.assert(test1.size() > 0);
        NSSales_lookupfieldController.GetRecord(objName, returnFieldList, accountId, objAccClass.Name);
        System.assert(test1.size() > 0);
    }
}