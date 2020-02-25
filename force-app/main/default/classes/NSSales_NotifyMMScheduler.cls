global class NSSales_NotifyMMScheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        
        //String cron = '0 30 18 1/1 * ? *';
        //String jid = System.schedule('Notifying MarkMan about their opportunity', cron, new NSSales_NotifyMM());
        //String sch = '0 0 10 ? * SUN';  0 0 8 1/1 * ? *
         database.executebatch(new NSSales_NotifyMM());
    }
    
}