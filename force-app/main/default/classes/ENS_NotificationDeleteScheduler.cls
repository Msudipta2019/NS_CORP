global class ENS_NotificationDeleteScheduler Implements Schedulable{
    
        global void execute(SchedulableContext ctx) {
        ENS_BatchToDeleteNotification deleteNotification = new ENS_BatchToDeleteNotification();
        database.executebatch(deleteNotification);
    }
}