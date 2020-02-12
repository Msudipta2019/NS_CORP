global class ENS_BatchToDeleteNotification implements Database.Batchable<sObject>{
    
    Global Database.QueryLocator start(Database.BatchableContext bc)
    {
         string query='SELECT ID,CreatedDate FROM Notification_Log__c where CreatedDate < LAST_N_DAYS:14 ';
        
        return Database.getQueryLocator(query);
    }
    Global void execute(Database.BatchableContext bc,List<Notification_Log__c> scope)
    {
        delete scope;
          
    }
    
    Global void finish(Database.BatchableContext bc)
    {
        
    }   

}