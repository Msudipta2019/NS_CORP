public class NSSales_RecallNPO {
    
    public static Final String StageName_SUSPECT = NSSales_NPOConstants.StageName_SUSPECT;
    public static Final String StageName_QA = NSSales_NPOConstants.StageName_QA;
    //Added by Sudipta for New OPS record type
    public static Final String StageName_NEW = NSSales_NPOConstants.StageName_NEW;
    
    @AuraEnabled
    public static boolean CheckAccess(Id oppId){
        
        Id usrId = UserInfo.getUserId();
        Opportunity op = [SELECT id, OwnerId, NS_SalesNPO_Approvers__c from Opportunity WHERE Id=:oppId LIMIT 1];
        if(usrId == op.OwnerId || usrId == op.NS_SalesNPO_Approvers__c){
            return false;
        }
        else{
            return true;
        }
    }
    
    
    @AuraEnabled
    public static void RecallAction(Id optyId, String recallComment) {
        
        List<Id> opportunityIds = new List<Id>();
        Opportunity op = [SELECT id,NSSales_isRecalled__c from Opportunity WHERE id=:optyId];
        op.NSSales_isRecalled__c = TRUE;
        update op;
        opportunityIds.add(op.id);
        
        BulkRecall(opportunityIds,recallComment);
        
    }
    
    public static void BulkRecall(List<Id> OptyIds,String recallComment){
        
        if(!NSSales_NPOConstants.updateOpportunity){
            NSSales_NPOConstants.updateOpportunity = true;
            Id RecordTypeIdGeneralOpty =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('General Opportunity').getRecordTypeId();
            Id RecordTypeIdIDOpty =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ID').getRecordTypeId();
            Id RecordTypeIdReadOnlyOpty =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Read Only').getRecordTypeId();
            //Added New  value by Sudipta for new record type
            Id RecordTypeIdOpsReadOnlyOpty =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NPO Operations ReadOnly').getRecordTypeId();
            Id RecordTypeIdOpsOpty =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NPO Operations Opportunity').getRecordTypeId();
            
            
            
            String emailbody;
            List<String> sendTo = new List<String>();
            List<Opportunity> finalOpporunities = new List<Opportunity>();
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            String emailServiceAddress = Label.emailServiceAddress;
            List<Id> sendToSingleMessage = new List<Id>();
            
            List<Opportunity> Opp = new List<Opportunity>([Select id, StageName, RecordTypeId,OwnerId,
                                                           NSSales_OPS_Planning_North__c,
                                                           NSSales_OPS_Planning_South__c,
                                                           NSSales_OPS_Planning_Central__c,
                                                           NSSales_Network_Capacity__c,
                                                           NSSales_Network_Optimization__c,
                                                           NSSales_Unit_Train__c,
                                                           NSSales_Auto_Intermodal__c,
                                                           NSSales_Interline_Services__c,
                                                           NSSales_Industrial_Products_Unit__c,
                                                           //Added New  value by Sudipta for new record type
                                                           NSSales_Power__c,
                                                           NSSales_OPS_Planning_NOC__c,
                                                           
                                                           NSSales_Industrial_Products_Unit_Status__c,
                                                           NSSales_Interline_Services_Status__c,
                                                           NSSales_Network_Capacity_Status__c,
                                                           NSSales_Network_Optimization_Status__c,
                                                           NSSales_OPS_Planning_Central_Status__c,
                                                           NSSales_OPS_Planning_North_Status__c,
                                                           NSSales_OPS_Planning_South_Status__c,
                                                           NSSales_Unit_Train_Status__c,
                                                           NSSales_Auto_Intermodal_Status__c,
                                                           //Added New  value by Sudipta for new record type
                                                           NSSales_OPS_Planning_NOC_Status__c,
                                                           NSSales_Power_Approval_Status__c,
                                                           
                                                           NSSales_isRecalled__c,
                                                           NSSales_Opportunity_Number__c,
                                                           NSSales_StageChanged__c
                                                           from Opportunity where id IN:OptyIds]);
            for(Opportunity o : Opp){
                if(o.RecordTypeId == RecordTypeIdIDOpty ){
                    // 7.18, jlong, comment stage revert on npo rejection
                    o.StageName= StageName_SUSPECT;
                    // 7.18, jlong, end  
                }
                else if((o.RecordTypeId == RecordTypeIdReadOnlyOpty) && o.NSSales_isRecalled__c == TRUE)
                {
                    // 7.18, jlong, comment stage revert on npo rejection
                    o.StageName = StageName_QA;
                    // 7.18, jlong, end
                    o.RecordTypeId = RecordTypeIdGeneralOpty;
                }
                
                //Added by Sudipta for New OPS record type
                 else if((o.RecordTypeId == RecordTypeIdOpsReadOnlyOpty) && o.NSSales_isRecalled__c == TRUE)
                {
                    // 7.18, jlong, comment stage revert on npo rejection
                    o.StageName = StageName_NEW;
                    // 7.18, jlong, end
                    o.RecordTypeId = RecordTypeIdOpsOpty;
                }
                
                else{
                    system.debug('failed all conditions');
                }
                o.NSSales_Approval_Needed__c = False;
                o.NSSales_OPS_Planning_Central__c = False;
                o.NSSales_OPS_Planning_North__c = False;
                o.NSSales_OPS_Planning_South__c = False;
                o.NSSales_Network_Capacity__c = False;
                o.NSSales_Network_Optimization__c = False;
                o.NSSales_Unit_Train__c = False;
                o.NSSales_Auto_Intermodal__c = False;
                o.NSSales_Interline_Services__c = False;
                o.NSSales_Industrial_Products_Unit__c = False;
                //Added New  value by Sudipta for new record type
                o.NSSales_OPS_Planning_NOC__c = False;
                o.NSSales_Power__c=False;
                
                o.NSSales_Industrial_Products_Unit_Status__c = '';
                o.NSSales_Interline_Services_Status__c = '';
                o.NSSales_Network_Capacity_Status__c = '';
                o.NSSales_Network_Optimization_Status__c = '';
                o.NSSales_OPS_Planning_Central_Status__c = '';
                o.NSSales_OPS_Planning_North_Status__c = '';
                o.NSSales_OPS_Planning_South_Status__c = '';
                o.NSSales_Unit_Train_Status__c = '';
                o.NSSales_Auto_Intermodal_Status__c = '';
                 //Added New  value by Sudipta for new record type
                o.NSSales_Power_Approval_Status__c='';
                o.NSSales_OPS_Planning_NOC_Status__c='';
                
                finalOpporunities.add(o);
                
            }
            update finalOpporunities;
            
            for(Opportunity op:finalOpporunities)
            {
                sendToSingleMessage.add(op.id);
            }
            singleEmailMessageSend(finalOpporunities,recallComment);
        }
    }
    
    public static void singleEmailMessageSend(List<Opportunity> finalOpporunities,String recallComment){
        
        String emailbody;
        List<String> sendTo = new List<String>();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        String emailServiceAddress = Label.emailServiceAddress;
        /*****sending email to the email service named NPOApprovalRecall****/
        for (Opportunity op : finalOpporunities)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            sendTo.clear();
            sendTo.add(emailServiceAddress);
            mail.setToAddresses(sendTo);
            mail.setSubject(op.NSSales_Opportunity_Number__c);
            emailbody = recallComment;
            mail.setHtmlBody(emailbody);
            emails.add(mail);
        }
        
        if(!Test.isRunningTest())
        {
            Messaging.sendEmail(emails);
        }
        /****end of sending email message****/   
    }
    
}