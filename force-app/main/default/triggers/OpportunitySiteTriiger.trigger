/************************************
Description  : Trigger on Opportunity Site
Developer    : Accenture Solutions
Date         : 05-07-2019
**************************************/
trigger OpportunitySiteTriiger on Opportunity_Site__c (after update,after insert) {
    
     if(trigger.isafter){
           
            if(trigger.isUpdate){
                
                NSSales_opportunitySiteTriggerHelper.updateOpportunity(Trigger.new);
            }
        }
    if(trigger.isafter){
           
            if(trigger.isInsert){
                
                NSSales_opportunitySiteTriggerHelper.updateOpportunity(Trigger.new);
            }
        }

}