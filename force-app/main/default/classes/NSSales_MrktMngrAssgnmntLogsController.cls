/**@author  Accenture
* @Created Date Oct,2019
* @version  1.0
* @description This class contains Server side controller for Marketing Manager Assignment Log functionalities 
*/ 
public class NSSales_MrktMngrAssgnmntLogsController {

    @AuraEnabled
     public static List <NSSales_MarketingManagerAssignmentLog__c> getMarketingManagerAssignmentLog(String accountId) {
         return [SELECT NSSales_Account__c, 
                 NSSales_MarketingManager__c,
                 NSSales_Role__c,
               //  NSSales_AssociatedBusinessUnit__c,
                 NSSales_BusinessUnit__c,
                 NSSales_Action__c,
                 NSSales_OldValue__c,
                 NSSales_NewValue__c,
                 NSSales_ChangeDate__c,
                 CreatedBy.Name
                 FROM NSSales_MarketingManagerAssignmentLog__c
                 WHERE NSSales_Account__c = :accountId
                 ORDER BY createdDate DESC];
     }
}