@isTest(SeeAllData=false)
private class NS_BatchForAccountUpdateSchedulerTest {
    static testmethod void testTerminalInsert(){
        Test.startTest();
NS_BatchForAccountUpdateScheduler sh1 = new NS_BatchForAccountUpdateScheduler();
String sch = '0 0 2 * * ?'; 
system.schedule('Test Territory Check', sch, sh1); 
Test.stopTest();
// add system asserts to check your expected behaviour

    }
}