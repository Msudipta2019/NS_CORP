/*Contact Trigger to fire on before and after Contact Creation or Updation*/
trigger ContactTrigger on Contact (before insert,before update,after insert,after update,before delete,after delete) {
    try{ 
        if(Trigger.isBefore){  
            if(Trigger.isInsert){
                system.debug('ContactTrigger Contact before insert Trigger***');
                NS_ContactTriggerHelper.beforeContactInsert(Trigger.new);
            }
            if(Trigger.isUpdate){
                NS_ContactTriggerHelper.beforeContactUpdate(Trigger.newMap, Trigger.oldMap);
            }
            if(Trigger.isDelete){       
                NS_ContactTriggerHelper.deleteAssociationRecordOnTyesWhenContatisDeleted();     
            }         
        }
        if(Trigger.isAfter){
            if(Trigger.isInsert){            
                system.debug('ContactTrigger Contact after insert Trigger  NS_ContactTriggerHelper.createAssociatedAccount');
                NS_ContactTriggerHelper.createAssociatedAccount(Trigger.new); 
                NS_IntegrationHelper.invokeManageOnlineCustomerContactOnInsert(Trigger.newMap); // changed by @DGLASER uncommented
               system.debug('ContactTrigger Contact after insert Trigger  NS_IntegrationHelper.onANIInsert');
                NS_IntegrationHelper.onANIInsert(Trigger.newMap);
                system.debug('ContactTrigger Contact after insert Trigger  done');
            }        
            if(Trigger.isUpdate){
                system.debug('***Checking Internal Contact Update Trigger***');
                //NS_OnlineCustomerContactTEP.invokeManageOnlineCustomerContactOnInsertTEP(Trigger.newMap,'Update');//testing
                NS_ContactTriggerHelper.updateAssociatedAccount(Trigger.newMap, Trigger.oldMap);
                NS_IntegrationHelper.deleteTyesContact(Trigger.newMap, Trigger.oldMap);
                // @dg commented out the call to invokeManageOnlineCustomerContactOnUpdate because 
                // the call to NS_IntegrationHelper.invoke_ContactUpdate line 36 calls this same method
                // NS_IntegrationHelper.invokeManageOnlineCustomerContactOnUpdate(Trigger.newMap, Trigger.oldMap);
                NS_IntegrationHelper.onANIUpdate(Trigger.newMap, Trigger.oldMap);
                NS_IntegrationHelper.contactupdate_3pl_Offline(Trigger.newMap,Trigger.oldMap);
                NS_OnlineCustomerContactTEP.invokeManageOnlineCustomerContactOnInsertTEP(Trigger.newMap,Trigger.oldMap,'Update');
                NS_IntegrationHelper.invoke_ContactUpdate(Trigger.newMap, Trigger.oldMap);
                NS_ContactTriggerHelper.deleteAssocAccountOnMerge(Trigger.newMap);
            } 
            if(Trigger.isDelete){
             
                NS_OnlineCustomerContactTEP.invokeManageOnlineCustomerContactOnDeleteTEP(Trigger.oldMap,'Delete');
                NS_IntegrationHelper.invoke_ContactDel(Trigger.oldMap);
            }          
        }
    }
    catch(Exception exp){
        system.debug('ContactTrigger Contact Trigger Exception');
        NS_StaticVariablesUtility.createExceptionRecord(exp,NS_StaticVariablesUtility.CONST_BLANK,NS_StaticVariablesUtility.CONST_BLANK);
    }
}