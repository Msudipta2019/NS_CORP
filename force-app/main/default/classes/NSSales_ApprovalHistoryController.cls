/**@author  Accenture
* @Created Date Dec,2019
* @version  1.0 
* @description This class contains Server side controller for fetching Approval History in NSSales_609_1_ApprovalHistory Component 
*/
public with sharing class NSSales_ApprovalHistoryController {  
    private static final String CLASS_NAME = 'NSSales_ApprovalHistoryController';
    private static final String METHOD_NAME1 = 'init';
    private static final String METHOD_NAME2 = 'getOpportunityApprovalHistoryInformation';
    private static final String METHOD_NAME3 = 'findObjectNameFromRecordId';
    @AuraEnabled  
    public static QAWrapper wrapMain {get;set;}  
    @AuraEnabled  
    public static string init(string strRecId){  
        wrapMain = new QAWrapper();  
        Id oppId;
        try{  
            if(strRecId !=null)  
            {  
                String objectName = findObjectNameFromRecordId(strRecId);
                if(objectName.equalsIgnoreCase('ProcessInstanceWorkitem'))
                {
                    oppId = NSSales_609_1_ApprovalProcessController.fetchOpportunityId(strRecId);
                    System.debug('Oppotunity Id -->NSSales_ApprovalHistoryController ProcessInstanceWorkitem : '+oppId);
                }
                else if(objectName.equalsIgnoreCase('ProcessInstanceStep'))
                {
                    oppId = fetchOpportunityIdfromProcessInstanceStep(strRecId);
                    System.debug('Oppotunity Id -->NSSales_ApprovalHistoryController ProcessInstanceStep : '+oppId);
                }
                else if(objectName.equalsIgnoreCase('Opportunity'))
                {
                    oppId = strRecId;
                    System.debug('Oppotunity Id -->NSSales_ApprovalHistoryController Opportunity : '+oppId);
                }
                
                //oppId = NSSales_609_1_ApprovalProcessController.fetchOpportunityId(strRecId);
                System.debug('Oppotunity Id -->NSSales_ApprovalHistoryController : '+oppId);
                DescribeSObjectResult describeResult = Opportunity.getSObjectType().getDescribe();     
                List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );  
                String query = ' SELECT ' + String.join( fieldNames, ',') +' FROM Opportunity Where id =: oppid';    
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
        getOpportunityApprovalHistoryInformation(oppId);  
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
                if(objectInstance.getDescribe().getKeyPrefix() == keyCode)
                {
                    objName = objectInstance.getDescribe().getName();
                }
            }
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
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