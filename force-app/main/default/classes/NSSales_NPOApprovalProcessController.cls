public withOut sharing class NSSales_NPOApprovalProcessController {
    private static final String CLASS_NAME = 'NSSales_NPOApprovalProcessController';
    private static final String METHOD_NAME1 = 'callApprovalProcess';
    private static final String METHOD_NAME2 = 'fetchProcessItemDetails';
    private static final String METHOD_NAME3 = 'fetchProcessInstanceStepId';
    private static final String METHOD_NAME4 = 'getVisibility';
    private static final String METHOD_NAME5 = 'findObjectNameFromRecordId';
    private static final String METHOD_NAME6 = 'fetchObjectId';
    private static final String METHOD_NAME7 = 'callReassignProcess';
    @AuraEnabled
    public static void callApprovalProcess(String processInstanceWorkItemId, String approveComments, String approvalAction){
        try{
            ProcessInstanceWorkitem  processInstanceWorkitemList= [SELECT ActorId,ProcessInstanceId,CreatedBy.Name  FROM ProcessInstanceWorkitem where id = :processInstanceWorkItemId];
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments(approveComments);
            req.setAction(approvalAction);
            req.setWorkitemId(processInstanceWorkItemId);
            Approval.ProcessResult result =  Approval.process(req);
            
            Date currDate =System.Today();
            
            ProcessInstanceStep  ProcessInstanceStepList= [SELECT Id  FROM ProcessInstanceStep where ActorId = :UserInfo.getUserId() 
                                                           AND CreatedDate >= :currDate order by CreatedDate DESC Limit 01 ];
            NSSales_NPO_Approval_Comments__c obj = new NSSales_NPO_Approval_Comments__c();
            obj.NSSales_Comments__c = approveComments;
            obj.NSSales_Commented_By__c = UserInfo.getUserId();
            obj.NSSales_ProcessInstanceStepID__c = ProcessInstanceStepList.Id;
            obj.NSSales_ProcessInstanceWorkItemId__c = processInstanceWorkItemId;
            obj.NSSales_ProcessInstanceID__c = processInstanceWorkitemList.ProcessInstanceId;
            
            insert obj;
        }
        catch(Exception exp){
            system.debug('exp-->'+exp);
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME1);
        }
    }
    
    @AuraEnabled
    public static List<ProcessInstanceWorkitem>  fetchProcessItemDetails(String processInstanceWorkItemId){
        List<ProcessInstanceWorkitem> ProcessInstanceWorkitemList = [SELECT CreatedBy.Name, CreatedDate, Actor.Name,ProcessInstanceId FROM ProcessInstanceWorkitem
                where id = :processInstanceWorkItemId];
        return ProcessInstanceWorkitemList;
    }
    
    @AuraEnabled
    public static String fetchProcessInstanceStepId(String ProcessInstanceId){
        Date currDate =System.Today();
            
        List<ProcessInstanceStep>  ProcessInstanceStepList= [SELECT ActorId,Comments,CreatedById,CreatedDate,Id,OriginalActorId,ProcessInstanceId
                                                             FROM ProcessInstanceStep where  ProcessInstanceId = :processInstanceId AND
                                                             CreatedDate >= :currDate order by CreatedDate DESC LIMIT 01 ];
        //System.debug('ProcessInstanceSteplist' +ProcessInstanceSteplist);
        return ProcessInstanceSteplist[0].Id;
    }
    
    @AuraEnabled
    public static String getVisibility(String strRecId){
        Boolean visibility = false;
        String objId;
        try{
            objId=fetchObjectId(strRecId);
            if(objId == '')
            {
                visibility = false;
            }
            else
            {
                String objectName = findObjectNameFromRecordId(objId);
                if(objectName.equalsIgnoreCase('NSSales_NPO_Approval__c'))
                {
                    visibility = true;
                }
                else
                {
                    visibility = false;
                }
            }  
            system.debug('visibility -->' +visibility);
        }
        catch(Exception exp){
            system.debug('exp-->'+exp);
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME4);
        }
        String response = 'NPO' + ',' + visibility;
        return response;
    }
    
    @AuraEnabled
    public static String findObjectNameFromRecordId(String recordId){
        String objName = '';
        try{
            String keyCode = recordId.subString(0,3);
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            for(Schema.SObjectType objectInstance : gd.values())
            {
                if(objectInstance.getDescribe().getKeyPrefix() == keyCode)
                {
                    objName = objectInstance.getDescribe().getName();
                }
            }
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            system.debug('exp-->'+exp);
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME5);
        } 
        return objName;
    }
    @AuraEnabled
    public static String fetchObjectId(String processInstanceWorkItemId){
        String objId=''; 
        try{
            List<ProcessInstanceWorkitem>  processInstanceWorkitemList= [SELECT ProcessInstanceId FROM ProcessInstanceWorkitem where id = :processInstanceWorkItemId];
            if(processInstanceWorkitemList.size() > 0 )
            {
                String processInstanceId = processInstanceWorkitemList[0].ProcessInstanceId;
                List<ProcessInstance> processInstanceList = [SELECT TargetObjectId FROM ProcessInstance WHERE Id = :processInstanceId];
                objId = processInstanceList[0].TargetObjectId;
            }
            else
            {
                objId = '';            
            }
        }
        catch(Exception exp){
            system.debug('exp-->'+exp);
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME6);
        }
        return objId;  
    }
    
    @AuraEnabled
    public static void callReassignProcess(String processInstanceWorkItemId, Id reassignApprover, String reassignComments, String reassignAction){
        try{
            ProcessInstanceWorkitem  processInstanceWorkitemList= [SELECT ActorId,ProcessInstanceId,CreatedBy.Name  FROM ProcessInstanceWorkitem where id = :processInstanceWorkItemId];
            processInstanceWorkitemList.ActorId = reassignApprover;
            update processInstanceWorkitemList;
            /*
            ProcessInstanceStep  ProcessInstanceStepList= [SELECT ActorId,Comments,StepStatus  FROM ProcessInstanceStep where ActorId = :reassignApprover AND StepStatus = :reassignAction];
            ProcessInstanceStepList.Comments = reassignComments;
            update ProcessInstanceStepList;
            */
            Date currDate =System.Today();
            ProcessInstanceStep  ProcessInstanceStepList= [SELECT Id  FROM ProcessInstanceStep where ActorId = :reassignApprover AND StepStatus = :reassignAction 
                                                           AND CreatedDate >= :currDate order by CreatedDate DESC Limit 01 ];
            
            System.debug('NSSales_NPOApprovalProcessController callReassignProcess -- ProcessInstanceStepList' +ProcessInstanceStepList);
            
            
            NSSales_NPO_Approval_Comments__c obj = new NSSales_NPO_Approval_Comments__c();
            obj.NSSales_Comments__c = reassignComments;
            obj.NSSales_Commented_By__c = UserInfo.getUserId();
            obj.NSSales_ProcessInstanceStepID__c = ProcessInstanceStepList.Id;
            obj.NSSales_ProcessInstanceWorkItemId__c = processInstanceWorkItemId;
            obj.NSSales_ProcessInstanceID__c = processInstanceWorkitemList.ProcessInstanceId;
            
            insert obj;
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            system.debug('exp-->'+exp);
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME7);
        } 
    }
}