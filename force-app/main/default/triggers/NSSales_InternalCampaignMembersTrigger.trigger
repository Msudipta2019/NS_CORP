/************************************
Description  : Trigger on Internal Campaign Members
Developer    : Accenture Solutions
Date         : 08-26-2019
**************************************/

trigger NSSales_InternalCampaignMembersTrigger on Internal_Campaign_Members__c (after insert,after update,before delete) {
     if(trigger.isInsert){
          if(trigger.isAfter){
              NSSales_IntCampaignMembersTriggerHelper.sendNotificationToMembers(Trigger.new);
              NSSales_insertIntCmpMemberLog.createRecordonCampaign_Member_Log(Trigger.new);
          }
     }
    if(trigger.isDelete){
          if(trigger.isbefore){
            
              NSSales_insertIntCmpMemberLog.deleteRecordonCampaign_Member_Log(Trigger.old);
          }
     }
    //Commenting out this code since Caroline confirmed that there will be no update of Campaign in an Internal Campaign Member Recod //
    if(trigger.isUpdate){
         if(trigger.isAfter){
             NSSales_insertIntCmpMemberLog.updateRecordonCampaign_Member_Log(Trigger.newMap,Trigger.oldMap);
         }
    }
}