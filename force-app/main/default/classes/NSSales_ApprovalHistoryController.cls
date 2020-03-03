/**@author  Accenture
* @Created Date Dec,2019
* @version  1.0 
* @description This class contains Server side controller for fetching Approval History in NSSales_609_1_ApprovalHistory Component 
*/
public with sharing class NSSales_ApprovalHistoryController {  
    private static final String CLASS_NAME = 'NSSales_ApprovalHistoryController';
    private static final String METHOD_NAME1 = 'fetchHistory';
    private static final String METHOD_NAME2 = 'getOpportunityApprovalHistoryInformation';
    private static final String METHOD_NAME3 = 'findObjectNameFromRecordId';
    private static final String METHOD_NAME4 = 'fetchOpportunityIdfromProcessInstanceStep';
    private static final String METHOD_NAME5 = 'getObjectRecordType';
    private static final String METHOD_NAME6 = 'fetchObjectId';
    @AuraEnabled  
    public static QAWrapper wrapMain {get;set;}  
    @AuraEnabled  
    public static string fetchHistory(string strRecId){  
        wrapMain = new QAWrapper();  
        try{  
            if(strRecId !='')  
            {  
                
                System.debug('Opportunity Id -->NSSales_ApprovalHistoryController : '+strRecId);
                DescribeSObjectResult describeResult = Opportunity.getSObjectType().getDescribe();     
                List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );  
                String query = ' SELECT ' + String.join( fieldNames, ',') +' FROM Opportunity Where id =: strRecId';    
                wrapMain.objOpp = Database.query( query );  
                TimeZone tz = UserInfo.getTimeZone();  
                //Milliseconds to Day  
                wrapMain.offset = tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);  
                wrapMain.success = true;  
                
            }  
        }catch(exception e){  
            wrapMain.success = false;  
            system.debug('exp init-->'+e);
            NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME1);
        }  
        getOpportunityApprovalHistoryInformation(strRecId);  
        return Json.serialize(wrapMain);  
    }  
    // This method is used to return the Opportunity Approval History  
    @AuraEnabled  
    public static List<ProcessInstance> getOpportunityApprovalHistoryInformation(Id oppId){   
        
        Map<Id,ProcessInstance> mapProcessInstance = new Map<Id,ProcessInstance>([SELECT CompletedDate, CreatedById, CreatedDate,Id,IsDeleted,LastActor.Name,LastModifiedById,LastModifiedDate,ProcessDefinitionId,  
                                                                                  Status,SubmittedBy.name,SystemModstamp,TargetObjectId,   
                                                                                  (SELECT ID, ProcessNodeId, StepStatus,Comments,TargetObjectId,Actor.Name,CreatedById,IsDeleted,IsPending,OriginalActor.Name,  
                                                                                   ProcessInstanceId,RemindersSent,CreatedDate FROM StepsAndWorkitems order by CreatedDate DESC,Id DESC)FROM ProcessInstance   
                                                                                  where ProcessInstance.TargetObjectId =:oppId order By CreatedDate DESC,Id DESC]);  
        if(mapProcessInstance.size()>0)  
        {  
            wrapMain.OpportunityApprovalHistoryInformation = mapProcessInstance.values();  
        }else{  
            wrapMain.OpportunityApprovalHistoryInformation = new list<ProcessInstance>();  
        }  
        return wrapMain.OpportunityApprovalHistoryInformation;  
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
            system.debug('exp-->'+exp);
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME3);
        } 
        return objName;
    }
    
    @AuraEnabled
    public static String fetchOpportunityIdfromProcessInstanceStep(String ProcessInstanceStepId){
        List<ProcessInstanceStep >  ProcessInstanceStepList= [SELECT ProcessInstanceId FROM ProcessInstanceStep where id = :ProcessInstanceStepId];
        String processInstanceId = ProcessInstanceStepList[0].ProcessInstanceId;
        List<ProcessInstance> processInstanceList = [SELECT TargetObjectId FROM ProcessInstance WHERE Id = :processInstanceId];
        return processInstanceList[0].TargetObjectId;
    }
    
    @AuraEnabled
    public static String getObjectRecordType(String strRecId){
        String oppId = '';
        String objectId = '';
        Boolean visibility = false;
        Id rectypeId;
        rectypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NSSales_609_1').getRecordTypeId();
        String objectName = findObjectNameFromRecordId(strRecId);
        if(objectName.equalsIgnoreCase('ProcessInstanceWorkitem'))
        {
            objectId = fetchObjectId(strRecId);
            //System.debug('objectId -->NSSales_ApprovalHistoryController ProcessInstanceWorkitem : '+objectId);
        }
        else if(objectName.equalsIgnoreCase('ProcessInstanceStep'))
        {
            objectId = fetchOpportunityIdfromProcessInstanceStep(strRecId);
            //System.debug('objectId Id -->NSSales_ApprovalHistoryController ProcessInstanceStep : '+objectId);
        }
        else if(objectName.equalsIgnoreCase('Opportunity'))
        {
            objectId = strRecId;
            //System.debug('objectId Id -->NSSales_ApprovalHistoryController Opportunity : '+objectId);
        }
        
        String pobjectName = findObjectNameFromRecordId(objectId);
        System.debug('pobjectName -->NSSales_ApprovalHistoryController ProcessInstanceWorkitem : '+pobjectName);
        if(pobjectName.equalsIgnoreCase('Opportunity'))
        {
            List<Opportunity> optyRec = [Select name,RecordTypeId from Opportunity where id = :objectId];
            //system.debug('optyRec -->' +optyRec);
            if(optyRec.size() > 0 && rectypeId == optyRec[0].RecordTypeId){
                List<ProcessInstance>  ProcessInstanceList= [SELECT Id FROM ProcessInstance WHERE ProcessInstance.TargetObjectId = :objectId];
                if(ProcessInstanceList.size() > 0){
                    oppId = objectId;
                    visibility = true;    
                }
                else
                {
                    oppId = '';
                    visibility = false;
                }
                
            }
            else
            {
                oppId = '';
                visibility = false;
            }
        }
        else
        {
            oppId = '';
            visibility = false;
        }
        
        system.debug('visibility -->' +visibility);
        system.debug('oppId -->' +oppId);
        String response = oppId + ',' + visibility;
        return response;
    }
    
    @AuraEnabled
    public static String fetchObjectId(String processInstanceWorkItemId){
        String objId='';
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
        return objId;  
    }
    
    public class QAWrapper{  
        @AuraEnabled  
        public boolean success;  
        @AuraEnabled  
        public Opportunity objOpp;  
        @AuraEnabled  
        public List<ProcessInstance> OpportunityApprovalHistoryInformation;  
        @AuraEnabled  
        public map<id,list<ProcessInstanceStep>> mapProcessIdvsApprovalStep;  
        @AuraEnabled  
        public Double offset;  
    }  
}