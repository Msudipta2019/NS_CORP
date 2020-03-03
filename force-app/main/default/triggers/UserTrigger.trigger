/************************************
Description  : Trigger on User
Developer    : Accenture Solutions
Date         : 11-15-2019
**************************************/

trigger UserTrigger on User (before insert, before update,after update) {
    if(trigger.isInsert){
        if(trigger.isBefore){
            NSSales_UserTriggerHelper.updateTimeDeltaOnCreate(Trigger.new);
        }
    }
    if(trigger.isUpdate){
        if(trigger.isBefore){
            NSSales_UserTriggerHelper.updateTimeDeltaOnUpdate(Trigger.newMap,Trigger.oldMap);
        }
    }
    
    if(trigger.isUpdate){
        if(trigger.isAfter){
            //  NSSales_UserTriggerHelper.sendMailtoMarketingManagers(Trigger.newMap,Trigger.oldMap);
            NSSales_UserTriggerHelper.updateuser(Trigger.newMap,Trigger.oldMap);
            NSSales_UserTriggerHelper.updateusermanager(Trigger.newMap,Trigger.oldMap);
            NSSales_UserTriggerHelper.updateoppmanager(Trigger.newMap,Trigger.oldMap);
            NSSales_UserTriggerHelper.updatemanagerrole(Trigger.newMap,Trigger.oldMap);
            
            
            
        }
    }
    
    
    
}