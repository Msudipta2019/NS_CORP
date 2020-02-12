global class NPOInboundEmail implements Messaging.InboundEmailHandler {
    
    public static Final String NPOStatus_RECALLED = NSSales_NPOConstants.NPOStatus_RECALLED;
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) { 
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        Opportunity opp = new Opportunity();
        String oppNum = '';
        Id OptyId;
        
        /******the email subject is the id of the opportunity that needs to be extracted ****/
        String emailsubject = email.subject;
        pattern myPattern = pattern.compile(NS_StaticVariablesUtility.NS_Opp); 
        matcher myMatcher = myPattern.matcher(emailsubject);
    	
        while (myMatcher.find()) 
        {
            oppNum = (myMatcher.group(0));
          break;                
        }
        /*****the recall comment sent as the body of the email that needs to be extracted and pass while recalling the approval requests****/
        String RecallComment = email.plainTextBody;
        
        /****retrive Opportunity Record and update Recall/reject checkbox***/
        List<Opportunity> Opty = [SELECT Id, NSSales_isRecalled__c,NSSales_Opportunity_Number__c from Opportunity WHERE NSSales_Opportunity_Number__c=:oppNum];
        
        for(Opportunity o : Opty){
            o.NSSales_isRecalled__c = FALSE;
            //o.NSSales_Any_NPO_Rejected__c  = FALSE;   
        }
        update Opty;
        
        /****retrieve list of NPO records under the opportunity****/
        List<NSSales_NPO_Approval__c> ListOfNPORecords = new List<NSSales_NPO_Approval__c>([SELECT Id,NSSales_Status__c from NSSales_NPO_Approval__c where NSSales_Related_Opportunity__c IN:Opty]);
        List<NSSales_NPO_Approval__c> updNPO = new List<NSSales_NPO_Approval__c>();
        system.debug('NPO Records'+ListOfNPORecords);
        
        for(NSSales_NPO_Approval__c lcc : ListOfNPORecords)
        {
            lcc.NSSales_Status__c = NPOStatus_RECALLED;
            lcc.NSSales_Approval_Date__c = NULL;
            updNPO.add(lcc);
            
        }
        
        update updNPO;  
        
        for(ProcessInstanceWorkitem wI : [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId IN : ListOfNPORecords])
        {
            Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();  
            pwr.setAction('Removed');
            pwr.setComments(RecallComment);
            pwr.setWorkItemId(wI.id);
            
            Approval.ProcessResult resultrecall = Approval.process(pwr);
        }
        
        result.success = true;
        return result;
        
    }
    
}