/************************************
Description  : Trigger on Marketing Manager Assignment
Developer    : Accenture Solutions
Date         : 10-10-2019
**************************************/

trigger NSSales_MarketingManagerAssignmentTrigger on NSSales_Marketing_Manager_Assignment__c (before insert,after insert,before update, after update, before delete) {
    
    if(trigger.isInsert){  
        if(trigger.isBefore){
            //NSSales_MrktMngrAsgnmntTriggerHelper.autoUpdatePACinMMA(Trigger.new);
            NSSales_MrktMngrAsgnmntTriggerHelper.deleteAndUpdateDupAccountClassification(Trigger.new);
            
        }
        if(trigger.isAfter){
            NSSales_MrktMngrAsgnmntTriggerHelper.createLogOnMktMngrAsgnmntRecInsert(Trigger.new);
            NSSales_MrktMngrAsgnmntTriggerHelper.sendEmailToManagersOnRecCreate(Trigger.new);
            NSSales_MrktMngrAsgnmntTriggerHelper.updateaccountClassification(Trigger.new);
            NSSales_MrktMngrAsgnmntTriggerHelper.autoUpdatePACinMMA(Trigger.new);
            
        }
    }
    if(trigger.isUpdate){
        
        if(trigger.isBefore)
        {
            NSSales_MrktMngrAsgnmntTriggerHelper.deleteAndUpdateDupAccountClassification(Trigger.new);
        }
        if(trigger.isAfter){
            
            NSSales_MrktMngrAsgnmntTriggerHelper.createLogOnMktMngrAsgnmntRecUpdate(Trigger.newMap,Trigger.oldMap);
            NSSales_MrktMngrAsgnmntTriggerHelper.sendEmailToManagersOnRecUpdate(Trigger.newMap,Trigger.oldMap);
            NSSales_MrktMngrAsgnmntTriggerHelper.updateaccountClassification(Trigger.new);
            NSSales_MrktMngrAsgnmntTriggerHelper.autoUpdatePACinMMA(Trigger.new);
            
        }
    }
    if(trigger.isDelete){
        if(trigger.isBefore){
            NSSales_MrktMngrAsgnmntTriggerHelper.createLogOnMktMngrAsgnmntRecRemove(Trigger.old);
            NSSales_MrktMngrAsgnmntTriggerHelper.sendEmailToManagersOnRecDelete(Trigger.old);
        }
    }
}