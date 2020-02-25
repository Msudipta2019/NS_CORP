@isTest
public class NSSales_NotifyMMSchedulerTest {
    
    public static String CRON_EXP = '0 0 8 1/1 * ? *';
    
    public static testmethod void positiveNSSales_NotifyMMSchedulerTest()
    {
        //SchedulerCode
        //String sch = '0 0 8 1/1 * ? *';
        //String jobID = System.schedule('Notifying MarkMan about their opportunity', sch, new NSSales_NotifyMMScheduler());
        Test.startTest();
        system.schedule('Notifying MarkMan about their opportunity schduler test', CRON_EXP, new NSSales_NotifyMMScheduler()); 
        Test.stopTest();
    }
}