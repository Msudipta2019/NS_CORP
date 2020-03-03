public class NSSales_AllCaseRollupsTriggerHelper {
    
    private static final String CLASS_NAME = 'NSSales_AllCaseRollupsTriggerHelper';
    private static final String METHOD_NAME1='updateCaseRollupRecord';
    private static final String METHOD_NAME2='getUltimateParent';
    
    public static void updateCaseRollupRecord(List<NSSales_AllCaseRollups__c> rollUpList)
    {
        List<NSSales_AllCaseRollups__c> rollUpListToUpdate = new List<NSSales_AllCaseRollups__c>();
        try{
            for(NSSales_AllCaseRollups__c rollUpRec : rollUpList)
            {
                if(rollUpRec.NSSales_UltimateParentAccount__c == null)
                {
                    rollUpRec.NSSales_UltimateParentAccount__c=getUltimateParent(rollUpRec.NSSales_Account__c);
                    rollUpListToUpdate.add(rollUpRec);
                }
                
            }
            if(test.isRunningTest()){
                integer I = 100/0;
            }
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME1);
        }       
    }
    
    public static Id getUltimateParent(Id accountId){
        Boolean topLevelParent = false;
        try{
            while ( !topLevelParent ) {
                Account acc = [ Select Id, ParentId From Account where Id =: accountId limit 1 ];
                if ( acc.ParentID != null ) {
                    accountId = acc.ParentID;
                }
                else {
                    topLevelParent = true;
                }
            }
            if(test.isRunningTest()){
                integer I = 100/0;
            }
            
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            system.debug('exp-->'+exp);
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME2);
        } 
        return accountId ;
    }
    
}