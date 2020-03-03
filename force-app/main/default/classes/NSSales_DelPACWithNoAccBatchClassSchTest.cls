@isTest
public class NSSales_DelPACWithNoAccBatchClassSchTest {
    
    public static String CRON_EXP = '0 0 7 ? * MON *';
    
    public static testmethod void positiveNSSales_DeletePACWithNoAccBatchClassSch()
    {
       	//SchedulerCode
        //String sch = '0 0 7 ? * MON *'; //0 0 7 1/1 * ? * //(EveryDay Morning 7A.M.)
        //String jobID = System.schedule('Notifying Deleted PAC with No Account', sch, new NSSales_DeletePACWithNoAccBatchClassSch());

        Test.startTest();
        system.schedule('Notifying Deleted PAC with No Account schldr Test', CRON_EXP, new NSSales_DeletePACWithNoAccBatchClassSch()); 
        Test.stopTest();
    }
}