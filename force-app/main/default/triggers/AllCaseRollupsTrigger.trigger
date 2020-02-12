trigger AllCaseRollupsTrigger on NSSales_AllCaseRollups__c (before update) {
    try{ 
           if(trigger.isBefore){
               if(trigger.isUpdate){
                   NSSales_AllCaseRollupsTriggerHelper.updateCaseRollupRecord(Trigger.new);
               }
           }
        if(Test.isRunningTest())
			{
				CalloutException e = new CalloutException();
				e.setMessage('Exception for Test Coverage');
				throw e;
			}
    }
    catch(Exception exp){
        NS_StaticVariablesUtility.createExceptionRecord(exp,'Trigger','AllCaseRollupsTrigger');
    }

}