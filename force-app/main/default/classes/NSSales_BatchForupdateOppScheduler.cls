global class NSSales_BatchForupdateOppScheduler implements Schedulable {
   
    global void execute(SchedulableContext ctx) {
        NSSales_BatchForUpdateOpportunity batchToTransfer = new NSSales_BatchForUpdateOpportunity();
        database.executebatch(batchToTransfer );
    }
    
}