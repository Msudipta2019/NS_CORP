global class NSSales_609_1_InboundEmail implements Messaging.InboundEmailHandler  {
    
    
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) { 
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String subject = email.subject;

        /***** parse the body to get the oppid,action and comments ****/
        String emailBody = email.plainTextBody;
        List<String> body = emailBody.split(',');
        String oppId = body[0];
        String action = body[1];
        String comment = body[2];
        System.debug('Opp Id For Inbound Email : ' +oppId);
        System.debug('Opp action For Inbound Email : ' +action);
        System.debug('Opp comment For Inbound Email : ' +comment);
        System.debug('Opp subject For Inbound Email : ' +subject);
        
        ProcessInstanceWorkitem[] piWorkItems = [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId = :oppId AND ProcessInstance.Status = 'Pending']; 
        
        System.debug('piWorkItems : ' +piWorkItems);
        
        if(piWorkItems.size() > 0){
            //Create Process Work Item Request
            Approval.ProcessWorkItemRequest pwiRequest = new Approval.ProcessWorkItemRequest();
            pwiRequest.setAction(action);
            pwiRequest.setComments(comment);
            pwiRequest.setWorkItemId(piWorkItems[0].Id);
            Approval.ProcessResult resultrecall = Approval.process(pwiRequest);
        }
        
        
        result.success = true;
        return result;
        
    }
}