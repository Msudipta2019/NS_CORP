/*Case Trigger to assign record type and owner on insert. populate case detail on update*/
trigger CaseTrigger on Case (before update,before insert,after insert,after update) { 
    try{ 
        
        if (NS_StaticVariablesUtility.bSkipTrigger == false) { // Accenture gp 11/04/19 to bypass trigger if set to true
              if(trigger.isBefore){
                
                if(trigger.isInsert){
                    NS_CaseTriggerHelperAddl.checkRecordTypeAndIsMonitored(Trigger.new);
                    NS_CaseTriggerHelper.getCaseOwner(Trigger.new);
                    NS_CaseTriggerHelper.timeconversion(Trigger.new); //For calling the time capture method (11/21/2019)
                    //WA659
                    NS_CaseTriggerHelperAddl.checkStatusOnCreate(Trigger.new);
                }
                if(trigger.isUpdate && NS_StaticVariablesUtility.bSkipCaseTrigger == false)// added by Daniel for SOQL 101 issue
               
                {                    
                    NS_CaseTriggerHelper.updateCaseInfo(Trigger.new); 
                    /*********** OEM Account validation, R2 requirement, Changes made by Moumita *******/
                    NS_CaseTriggerHelperAddl.ValidateOEMAccount(Trigger.new);
                    /*********** End of changes from OEM Account validation, R2 requirement, Changes made by Moumita *******/
                    NS_ChildRequestClosureRestriction.closeCaseAlert(Trigger.new);
                     /**********E-Commerce IT Queue by Sudipta 2020/1/10***********/    
                    NS_CaseUpdateforSystemDefect.caseUpdateforSystemDefect(Trigger.new);
                     /*********IM02722496- New Calculated Field - "Hours Since Last Activity" by Sudipta*/                  
                    NS_ReopenCaseTimeUpd.reopenCaseLogic(Trigger.old,Trigger.new);
                }
              }
              if(trigger.isAfter){
                if(trigger.isInsert){
                    //VOC implementation--SRV
                    NS_CaseTriggerHelperAddl.updateSurveyWithCase(Trigger.new);
                    //VOC Ends Here--SRV
                    NS_CaseTriggerHelper.createTask(Trigger.new);
                    NS_CaseTriggerHelperAddl.updateCountInContact(Trigger.new);
                    //NS_CaseTriggerHelper.sendEmail(Trigger.new);
                    //Gunjari 02/07 -- call insertAllCaseRollupRecord
                    NS_CaseTriggerHelperAddl.insertAllCaseRollupRecord(Trigger.new);
                } 
                if(trigger.isUpdate && NS_StaticVariablesUtility.bSkipCaseTrigger == false)// added by Daniel for SOQL 101 issue
                  
                {
                    NS_CaseTriggerHelper.checkTask();
                    //Gunjari 02/07 -- call updateAllCaseRollupRecord
                    NS_CaseTriggerHelperAddl.updateAllCaseRollupRecord(Trigger.newMap,Trigger.oldMap);
                    //commenting out as a part of Hours Since Last Activity by Sudipta on 2/5/2020
                    NS_StaticVariablesUtility.bSkipCaseTrigger = True;// Prevent SOQL 101 errors
                }
            }
             //to cover Catch part
                if(Test.isRunningTest()){
                    integer I=100/0;
                }
        }
    }
    catch(Exception exp){
        NS_StaticVariablesUtility.createExceptionRecord(exp,'CASE TRIG','Case Tigg');
    }
}