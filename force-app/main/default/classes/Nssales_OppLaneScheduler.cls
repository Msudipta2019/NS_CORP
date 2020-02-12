global class Nssales_OppLaneScheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        
        
        //SchedulerCode
        //String sch = '0 0 8 1/1 * ? *';
        //String jobID = System.schedule(' Opportunity Stage Change Scheduler', sch, new Nssales_OppLaneCancelledSch());
         database.executebatch(new Nssales_OppLaneCancelledBatch());
        database.executebatch(new Nssales_OppLaneClosedLostBatch());
        database.executebatch(new Nssales_OppLaneClosedWonBatch());
    }
    
}