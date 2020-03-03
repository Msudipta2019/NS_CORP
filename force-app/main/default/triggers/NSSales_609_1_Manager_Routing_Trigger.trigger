/************************************
Description  : Trigger on NSSales_609_1_Manager_Routing_Trigger
Developer    : Accenture Solutions
Date         : 22-01-2020
**************************************/
trigger NSSales_609_1_Manager_Routing_Trigger on NSSales_609_1_Manager_Routing__c (before insert, after update, after delete) {
    if(Trigger.isBefore){  
        if(Trigger.isInsert){
            NSSales_609_1_MgrRoutingTriggerHelper.insertStates(trigger.new);
        }
    }
     if(Trigger.isAfter){
        if(Trigger.isUpdate){
        //    NSSales_609_1_MgrRoutingTriggerHelper.editStates(trigger.oldMap, trigger.newMap);
        }
        if(Trigger.isDelete){
            NSSales_609_1_MgrRoutingTriggerHelper.deleteStates(trigger.old);
        }
    }
}