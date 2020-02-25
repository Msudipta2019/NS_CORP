/*Task Trigger to fire on before Task Creation or Updation
***************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
***************************************************************************
09/25/2019          Sudipta Mukherjee  (RESPTIME) First Call/Email creation date stamp on Case for Reporting Purpose.
10/16/2019			Gidon Payenson 	   Merged to P3 (MERP3) 	
----------------------------------------------------------------------------
*/ 

trigger TaskTrigger on Task (before insert, before update,after insert,after update,before delete) {
    try{
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                NS_TaskTriggerHelper.filterInactiveContacts(Trigger.new);
            }
            if(Trigger.isUpdate){
                NS_TaskTriggerHelper.filterInactiveContacts(Trigger.new);
                NS_TaskTriggerHelper.updateTaskRestriction(Trigger.old,Trigger.new);
            }
            if(Trigger.isDelete){
                NS_TaskTriggerHelper.preventDeleteCompletedTask(trigger.old);
                NS_TaskTriggerHelper.deleteTaskRestriction(trigger.old);
            } 
        }
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                /*********IM02722496- New Calculated Field - "Hours Since Last Activity" by Sudipta*/
                NS_TaskTriggerHelper.LastActivityTrackeronCase(Trigger.new);
                NS_TaskTriggerHelper.countdaysForTask(Trigger.new); //MERP3 - Average Response time
                NS_TaskTriggerHelper.updateCase(Trigger.new); 
                NS_TaskTriggerHelper.updateStatus(Trigger.new); 
                
            }
            if(Trigger.isUpdate){
                //NS_TaskTriggerHelper.countdaysForTask(Trigger.new); //MERP3 - Average Response time
                NS_TaskTriggerHelper.updateCase(Trigger.new);
                NS_TaskTriggerHelper.updateStatus(Trigger.new); 
            }
        }
    }
    catch(Exception exp){
        NS_StaticVariablesUtility.createExceptionRecord(exp,NS_StaticVariablesUtility.CONST_BLANK,NS_StaticVariablesUtility.CONST_BLANK);
    }
}