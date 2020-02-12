trigger SurveyResultTrigger on Survey_Result__c (before insert) {
    NS_VOC_SurveyResultTriggerHelper.updateAccCont(trigger.new);

}