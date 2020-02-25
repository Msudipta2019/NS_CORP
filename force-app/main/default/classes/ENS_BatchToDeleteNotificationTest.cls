@istest(SeeAllData=false)
public class ENS_BatchToDeleteNotificationTest {
    static testMethod void testMethod1()
    {
        Test.startTest();
        //List<Notification_Log__c> Notif = new List<Notification_Log__c>();
        ENS_BatchToDeleteNotification BC=new ENS_BatchToDeleteNotification();
        Notification_Log__c n1 = new Notification_Log__c();
        n1.Contact_Display_Name__c='XYZ';
        n1.Event_Name__c='BatchDelTest';
        Datetime dt = DateTime.parse('09/25/2019 11:46 AM');
        n1.CreatedDate=dt;
        insert n1;
        List<Notification_Log__c> alist=[SELECT ID,CreatedDate FROM Notification_Log__c where CreatedDate < LAST_N_DAYS:14];
        DataBase.executeBatch(BC,200);
        Test.stopTest();
        
    }

}