public class NS_VOC_SurveyResultTriggerHelper {
    public static void updateAccCont (List<Survey_Result__c> listSurvey){
        List<id> idCase = new List<id>();
        
        for(Survey_Result__c sr:listSurvey){
            idCase.add(sr.NS_ParentCaseNumber__c);           
            System.debug('SRV-genius');
        }
        Map<id, Case> mapCase = new Map<id, Case>([select id,AccountId,ContactId from case where id in :idCase ]);
        
        for(Survey_Result__c sr:listSurvey){
            case relCase =+mapCase.get(sr.NS_ParentCaseNumber__c);
            if(relCase.AccountId!=null && relCase.ContactId!=null){
                sr.NS_Account_Name__c=relCase.AccountId;
                //System.debug('Account Name '+sr.NS_Account_Name__c);
                sr.NS_Contact_Name__c=relCase.ContactId;
               // System.debug('Contact Name '+sr.NS_Contact_Name__c);
            }
            
        }
        
    }
    
    
}


/*sr.Account__c = sr.NS_ParentCaseNumber__r.AccountId;
system.debug('sos 001 '+sr.NS_ParentCaseNumber__c);
system.debug('sos 002 '+sr.NS_ParentCaseNumber__r.AccountId);
system.debug('sos 003 '+sr.Account__c);*/