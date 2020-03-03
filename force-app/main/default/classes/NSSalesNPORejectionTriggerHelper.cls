public class NSSalesNPORejectionTriggerHelper {
    /*******not in use******/
    /*public static Final String npo_REJECTED = 'Rejected';
    public static Final String npo_REJECTION_REASON = 'Recalled due to Rejection';
    
    public static void retriveOptyData(List<NSSales_NPO_Approval__c> npoList){
        
        List<Id> npoRelatedOptyId = new List<Id>();
        List<Opportunity> optyFieldUpdate = new List<Opportunity>();
        List<string> OppNumList = new List<string>();
        boolean run = false;
        for(NSSales_NPO_Approval__c npo : npoList)
        {
            if(run == false){
                run = true;
                if(npo.NSSales_Status__c == npo_REJECTED)
                {
                    npoRelatedOptyId.add(npo.NSSales_Related_Opportunity__c);
                }   
            }
        }
        if(npoRelatedOptyId.size()>0){
        for(Opportunity op: [SELECT Id,NSSales_Any_NPO_Rejected__c,NSSales_Opportunity_Number__c from Opportunity WHERE ID IN: npoRelatedOptyId]){
            op.NSSales_Any_NPO_Rejected__c= TRUE;
            optyFieldUpdate.add(op);
            OppNumList.add(op.NSSales_Opportunity_Number__c);
        }
        update optyFieldUpdate;
        
        NSSales_RecallNPO.recall(OppNumList,npo_REJECTION_REASON);  
        }
    }
    */
}