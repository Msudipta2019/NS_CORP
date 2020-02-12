public class CreateIDAccountController {



@AuraEnabled
    public static string getCreatesysInfo(string recordTypeId){
 		String theme = UserInfo.getUiThemeDisplayed();
        system.debug('getsysInfo getUiThemeDisplayed result '+theme+' recordTypeId '+recordTypeId);
        string recordtypename = Schema.SObjectType.Account.getRecordTypeInfosById().get(recordTypeId).getname();
        // string recordtypename = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(recordTypeId).getName();
        // Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Requests').getRecordTypeId();
        
        system.debug('getsysInfo getUiThemeDisplayed result '+recordtypename);
        // Code to check users Associated_Business_Unit__c
        return recordtypename;
    }
    
}