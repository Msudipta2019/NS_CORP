trigger NS_PartnerTrigger on NS_Partner__c (after insert, after update, after delete) {

    if(trigger.isinsert && trigger.isafter){
        NS_PartnerTriggerHelper.insertRelatedRecord(trigger.new);
    }
    if(trigger.isupdate &&trigger.isafter){
        NS_PartnerTriggerHelper.updateRelatedRecord(trigger.new);
    }
    if(trigger.isdelete &&trigger.isafter){
        NS_PartnerTriggerHelper.deleteRelatedRecord(trigger.old);
    }
    
    
}