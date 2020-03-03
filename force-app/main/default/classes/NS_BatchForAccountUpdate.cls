Global class NS_BatchForAccountUpdate implements Database.Batchable<sObject>,Database.AllowsCallouts {    
    
    private static final String CLASS_NAME = 'NS_TerminalAccountUpdate';
    private static final String METHOD_NAME1='invokeCallout';
    
    Global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query='select id from Account limit 1';
        
        return Database.getQueryLocator(query);
    }
    Global void execute(Database.BatchableContext bc,List<Account> scope)
    {
        
        try{
            for(Account acct : scope){
                NS_TerminalAccountUpdate.invokeCallout();
            }
            
        }
        catch(Exception e){
            NS_StaticVariablesUtility.createExceptionRecord(e,CLASS_NAME,METHOD_NAME1);         
        }    
    }
    
    Global void finish(Database.BatchableContext bc)
    {
        
    }   
}