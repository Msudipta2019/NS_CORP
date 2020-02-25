/************************************
Description  : Trigger on Marketing Manager Assignment
Developer    : Accenture Solutions
Date         : 19-11-2019
**************************************/
trigger NSSales_MarketIntelTrigger on Market_Intelligence__c (after update) {
    if(trigger.isUpdate){
        if(trigger.isAfter){
            NSSales_MarketIntelTriggerHelper.createNewMIAssocAccRec_DelPrevMIAccAssocRec(Trigger.newMap,Trigger.oldMap);
        }
    }
}