@isTest(SeeAllData=false)

public class ENS_NotificationDeleteSchedulerTest {
    static testmethod void testTerminalInsert(){
        Test.startTest();
		ENS_NotificationDeleteScheduler sh1 = new ENS_NotificationDeleteScheduler();
        String sch = '0 0 6 * * ?';
		system.schedule('Test Territory Check', sch, sh1); 
		Test.stopTest();
		
    }

}