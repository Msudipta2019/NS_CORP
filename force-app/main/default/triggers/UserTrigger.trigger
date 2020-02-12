/************************************
Description  : Trigger on User
Developer    : Accenture Solutions
Date         : 11-15-2019
**************************************/

trigger UserTrigger on User (before insert, before update,after update) {
    
    if(System.isBatch())
    {
        
        return; 
    }
    
    
    if(trigger.isInsert){
        if(trigger.isBefore){
            NSSales_UserTriggerHelper.updateTimeDeltaOnCreate(Trigger.new);
        }
    }
    if(trigger.isUpdate){
        system.debug('UPD 01 '+trigger.isBefore);
        system.debug('UPD 02 '+trigger.isAfter);
        if(trigger.isBefore){
            NSSales_UserTriggerHelper.updateTimeDeltaOnUpdate(Trigger.newMap,Trigger.oldMap);
        }
    }
    
    if(trigger.isUpdate){
        if(trigger.isAfter){
            NSSales_UserTriggerHelper.updateuser(Trigger.newMap,Trigger.oldMap);
            NSSales_UserTriggerHelper.updateusermanager(Trigger.newMap,Trigger.oldMap);
            NSSales_UserTriggerHelper.updateoppmanager(Trigger.newMap,Trigger.oldMap);
            NSSales_UserTriggerHelper.updatemanagerrole(Trigger.newMap,Trigger.oldMap);  
            
            
            
        }
    }
    
    
    
    
}