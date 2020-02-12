trigger AccountClassificationTrigger on BU__c (before insert,before update) {
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
          NS_AccountClassificationTriggerHelper.vrForDuplicatePACRecordv2(trigger.new);
            
        }
    }
    NS_AccountClassificationTriggerHelper.insertRecordTypeField(trigger.new);  
}