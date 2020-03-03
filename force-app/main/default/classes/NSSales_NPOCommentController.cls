public class NSSales_NPOCommentController {
    private static final String CLASS_NAME = 'NSSales_NPOCommentController';
    private static final String METHOD_NAME1 = 'getVisibility';
    private static final String METHOD_NAME2 = 'findObjectNameFromRecordId';
    private static final String METHOD_NAME3 = 'fetchObjectId';
    private static final String METHOD_NAME4 = 'fetchObjectIdfromProcessInstance';
    private static final String METHOD_NAME5 = 'fetchCommentsProcessItemDetailsOpp';
    private static final String METHOD_NAME6 = 'fetchCommentsProcessItemDetailsNpo';
    private static final String METHOD_NAME7 = 'fetchCommentProcessInstanceStepOpp';
    private static final String METHOD_NAME8 = 'fetchCommentProcessInstanceStepNpo';
    @AuraEnabled
    public static String getVisibility(String strRecId){
        Boolean visibility = false;
        Boolean isNpo = false;
        Boolean isOpp = false;
        Boolean isProcessInstanceWorkitem = false;
        Boolean isProcessInstanceStep = false;
        String objId;
        try{
           
            String mainObjectName = findObjectNameFromRecordId(strRecId);
         
            if(mainObjectName.equalsIgnoreCase('ProcessInstanceWorkitem'))
            {
                visibility = true;
                isProcessInstanceWorkitem = true; 
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
                        isNpo = true;
                    }
                    else if(objectName.equalsIgnoreCase('Opportunity'))
                    {
                        isOpp = true;
                    }
                }  
            }
            else if(mainObjectName.equalsIgnoreCase('ProcessInstanceStep'))
            {
                visibility = true;
                isProcessInstanceStep = true;   
                objId=fetchObjectIdfromProcessInstance(strRecId);
                if(objId == '')
                {
                    visibility = false;
                }
                else
                {
                    String objectName = findObjectNameFromRecordId(objId);
                    if(objectName.equalsIgnoreCase('NSSales_NPO_Approval__c'))
                    {
                        isNpo = true;
                    }
                    else if(objectName.equalsIgnoreCase('Opportunity'))
                    {
                        isOpp = true;
                    }
                }  
            }
            else
            {
                visibility = false;
            }
            system.debug('visibility -->' +visibility);
            system.debug('isProcessInstanceWorkitem -->' +isProcessInstanceWorkitem);
            system.debug('isProcessInstanceStep -->' +isProcessInstanceStep);
            system.debug('isNpo -->' +isNpo);
            system.debug('isOpp -->' +isOpp);
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            system.debug('exp-->'+exp);
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME1);
        } 
        String response = visibility + ',' + isProcessInstanceWorkitem + ',' + isProcessInstanceStep + ',' + isNpo + ',' + isOpp;
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
                String schemaKey = objectInstance.getDescribe().getKeyPrefix();
                String keyCode_ESC = '04I';
                if(schemaKey == keyCode)
                {
                    if(!schemaKey.equals(keyCode_ESC))
                    {
                       objName = objectInstance.getDescribe().getName();
                    }
                }
            }
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            system.debug('exp-->'+exp);
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME2);
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
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            system.debug('exp-->'+exp);
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME3);
        } 
        return objId;  
    }
    
    @AuraEnabled
    public static String fetchObjectIdfromProcessInstance(String ProcessInstanceStepId){
        String objId=''; 
        try{
            List<ProcessInstanceStep>  ProcessInstanceStepList = [SELECT ProcessInstanceId FROM ProcessInstanceStep where id = :ProcessInstanceStepId];
            if(ProcessInstanceStepList.size() > 0 )
            {
                String processInstanceId = ProcessInstanceStepList[0].ProcessInstanceId;
                List<ProcessInstance> processInstanceList = [SELECT TargetObjectId FROM ProcessInstance WHERE Id = :processInstanceId];
                objId = processInstanceList[0].TargetObjectId;
            }
            else
            {
                objId = '';            
            }
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            system.debug('exp-->'+exp);
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME4);
        } 
        return objId;  
    }
    @AuraEnabled
    public static List<ProcessInstanceStep>  fetchCommentsProcessItemDetailsOpp(String objectId){
        ProcessInstanceWorkitem  processInstanceWorkitemList= [SELECT ActorId,ProcessInstanceId  FROM ProcessInstanceWorkitem where id = :objectId];
        Id processid = processInstanceWorkitemList.ProcessInstanceId;
        List<ProcessInstanceStep> commentList = [SELECT ActorId,Comments,CreatedById,CreatedBy.Name,CreatedBy.SmallPhotoUrl,CreatedDate,Id,OriginalActorId,ProcessInstanceId  FROM ProcessInstanceStep 
                                                 where ProcessInstanceId = :processid AND Comments !='' order by CreatedDate DESC];
        
        return commentList;
        
    }
    @AuraEnabled
    public static List<NSSales_NPO_Approval_Comments__c>  fetchCommentsProcessItemDetailsNpo(String objectId){
        ProcessInstanceWorkitem  processInstanceWorkitemList= [SELECT ActorId,ProcessInstanceId  FROM ProcessInstanceWorkitem where id = :objectId];
        //system.debug('processInstanceWorkitemList-->'+processInstanceWorkitemList);
        Id processid = processInstanceWorkitemList.ProcessInstanceId;
        List<NSSales_NPO_Approval_Comments__c> commentList = [Select NSSales_Commented_By__c,NSSales_Commented_By__r.Name,NSSales_Commented_By__r.SmallPhotoUrl,CreatedDate,NSSales_ProcessInstanceWorkItemId__c,NSSales_ProcessInstanceID__c,NSSales_Comments__c
                                                              from NSSales_NPO_Approval_Comments__c where NSSales_ProcessInstanceID__c = :processid order by CreatedDate DESC];
        //system.debug('commentList-->'+commentList);
        List<NSSales_NPO_Approval_Comments__c> filteredcommentList = new List<NSSales_NPO_Approval_Comments__c>();
        for(NSSales_NPO_Approval_Comments__c cmt : commentList) {  
            if((cmt.NSSales_Comments__c != '') && (cmt.NSSales_Comments__c != null)) {   
                filteredcommentList.add(cmt);       
            }    
        }
     
        
        return filteredcommentList;
        
    }
    @AuraEnabled
    public static List<ProcessInstanceStep>  fetchCommentProcessInstanceStepOpp(String objectId){
        Date currDate =System.Today();
        List<ProcessInstanceStep>  commentList= [SELECT ActorId,Comments,CreatedById,CreatedBy.Name,CreatedBy.SmallPhotoUrl,CreatedDate,Id,OriginalActorId,ProcessInstanceId
                                                 FROM ProcessInstanceStep where  Id = :objectId AND Comments !='' ];
        return commentList;
        
    }
    @AuraEnabled
    public static List<NSSales_NPO_Approval_Comments__c>  fetchCommentProcessInstanceStepNpo(String objectId){
        List<NSSales_NPO_Approval_Comments__c> commentList =  [SELECT NSSales_Commented_By__c,NSSales_Commented_By__r.Name,NSSales_Commented_By__r.SmallPhotoUrl,CreatedDate,NSSales_ProcessInstanceWorkItemId__c,NSSales_ProcessInstanceID__c,NSSales_Comments__c 
                                                               FROM NSSales_NPO_Approval_Comments__c
                                                               where NSSales_ProcessInstanceStepID__c = :objectId];
         
        List<NSSales_NPO_Approval_Comments__c> filteredcommentList = new List<NSSales_NPO_Approval_Comments__c>();
        for(NSSales_NPO_Approval_Comments__c cmt : commentList) { 
            if((cmt.NSSales_Comments__c != '') && (cmt.NSSales_Comments__c != null)) {   
                filteredcommentList.add(cmt);       
            }    
        }
     
        return filteredcommentList;
    }
}