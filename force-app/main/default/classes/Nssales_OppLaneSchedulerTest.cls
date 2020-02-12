@isTest(SeeAllData=False)
public class Nssales_OppLaneSchedulerTest {
    static testmethod void testOppLaneExecute() {
        
        Test.startTest();
        Nssales_OppLaneScheduler sh1 = new Nssales_OppLaneScheduler();
        String sch = '0 0 8 1/1 * ? *';
        system.schedule('Test Territory Check', sch, sh1);
        Test.stopTest();
        
    }

}