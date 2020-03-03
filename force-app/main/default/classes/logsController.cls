public class logsController {
    
      @AuraEnabled
      public static List <Campaign_Member_Log__c> getLogs(string artId) {
        return [SELECT   NSSales_Campaign_Member_Name__c,NSSales_Role__c,NSSales_Phone__c,NSSales_Action__c,NSSales_Old_Value__c, NSSales_New_Value__c ,NSSales_Audit_Date__c,CreatedBy.Name
                FROM Campaign_Member_Log__c where NSSales_Campaign__c =: artId AND NSSales_Object__c='InternalCampaign' ORDER BY createdDate DESC];
      }
    
    
    @AuraEnabled
      public static List <Campaign_Member_Log__c> getCampaignMemberLogs(string artId) {
        return [SELECT  NSSales_Action__c,
                NSSales_Old_Value__c, 
                NSSales_New_Value__c,
                NSSales_Audit_Date__c,
                CreatedBy.Name,
                NSSales_Type__c,
                NSSales_First_Name__c,
                NSSales_Last_Name__c,
                NSSales_Company__c,
                NSSales_Status__c
                FROM Campaign_Member_Log__c where NSSales_Campaign__c =: artId AND NSSales_Object__c='CampaignMember' ORDER BY createdDate DESC];
      }
   
    

}