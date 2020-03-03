Global class NSSales_BatchForUpdateOpportunity implements Database.Batchable<sObject>{
    
    
    private static final String CLASS_NAME = 'NSSales_BatchForUpdateOpportunity';
    private static final String METHOD_NAME1='UpdateImplementationDate';
    
    
    Global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string nsStageName='Closed: Implementation Pending';
        Date TodaysDate = system.today();
        string query='select id,StageName,NSSales_Implementation_Date__c from Opportunity where StageName =: nsStageName and NSSales_Implementation_Date__c=:TodaysDate limit 10000';
        
        return Database.getQueryLocator(query); 
        
    }
    Global void execute(Database.BatchableContext bc,List<Opportunity> scope)
    {
        
        try{
            //string nsStageNameImplemented='Closed: Implemented';  
            for(Opportunity opp : scope)
            {
                //if(opp.NSSales_Implementation_Date__c==system.today())
               // {
                    opp.StageName=NS_StaticVariablesUtility.nsStageNameImplemented; 
               // }
            }
            update scope;
        }
        catch(Exception e){
            NS_StaticVariablesUtility.createExceptionRecord(e,CLASS_NAME,METHOD_NAME1);         
        }  
        
        
    }
    
    Global void finish(Database.BatchableContext bc)
    {
        
    }   
    
}