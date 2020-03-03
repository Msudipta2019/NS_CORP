global class NSSales_DeletePACWithNoAccBatchClassSch implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        
         database.executebatch(new NSSales_DeletePACWithNoAccountBatchClass());
    }
    
}