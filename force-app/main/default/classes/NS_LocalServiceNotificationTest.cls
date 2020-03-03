@isTest(SeeAllData=false)
private class NS_LocalServiceNotificationTest {
    static testmethod void testNotificationInsert(){
        //FOR ACCOUNT RECORD
        Account a = new Account();
        a.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        a.Name='NFS';
        a.NS_AssociatedBusinessUnit__c='oss';
        a.Phone='1234567';
        insert a;
        Account aaa=[select Name ,Phone from Account where id=:a.id];
        system.debug('Record Ids Are-->'+aaa);
        //FOR CONTACT RECORD
        Contact obj= new Contact();
        obj.FirstName='XYZ';
        obj.LastName='User';
        obj.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('General Contact').getRecordTypeId();
        obj.NS_ContactStatus__c='Active';
        obj.NS_PreferredName__c='ABC';
        obj.MobilePhone='1234567';
        obj.NS_BusinessUnit__c='oss';
        obj.NS_PrefConMethd__c='Work Phone';
        obj.Notification_Delivery_Hour_Starting__c='750';
        obj.Notification_Delivery_Hour_Ending__c='100';
        obj.NS_OSSContactRole__c='Manager';
        obj.NS_ContactRole__c='Tester';
        obj.NS_RACF_ID__c='ABCD';
        obj.Contact_Classification__c='Customer';
        obj.Notification_Phone_Number__c='1234567';
        obj.Notification_SMS_Enabled__c=true;
        obj.Notification_Push_Enabled__c=true;
        obj.Notification_Email_Enabled__c=true;
        obj.Notification_Delivery_Window_Enabled__c=true;
        obj.Notification_Delivery_Days__c='Mon;Tue;Wed;Fri;';
        obj.Accountid= a.id;
        insert obj;
        //FOR USER RECORD
        User atest;
        Profile agent = UserTestFactory.createProfile(NS_StaticVariablesUtility.SalesManager);
        atest = UserTestFactory.createUserSales(22,agent.Id);
        atest.FederationIdentifier='ABCD';
        update atest;
        atest=[SELECT  Associated_Business_Unit__c from User WHERE Id=:atest.Id ];
        System.assertEquals('OSS', atest.Associated_Business_Unit__c);
        //FOR NOTIFICATION RECORD
        Notification_Log__c notifi = new Notification_Log__c();//
        notifi.Event_Name__c = 'PLANNED';
        notifi.ENS_Message_Payload__c='{"eventtype":"PLANNED","eventdesc":"Local Service Planned","custclasscd":"H11","eqdtls":{"eqdtl":[{"action":"PLCE","eqinit":"BKTY","eqnr":"0000152146","wbsernr":"6460642492","emptyind":"L","cartype":"BOXCAR","classcd":"H11","commodity":"PPBRD","stcc":"2631117","wgt":"91","rlsereqtype":null,"fromtk":null,"fromspot":"0","totk":null,"tospot":"0","eqloparsn":"test lopa"},{"action":"PULL","eqinit":"NS","eqnr":"0000150291","wbsernr":"6460710473","emptyind":"L","cartype":"BOXCAR","classcd":"H11","commodity":"PPBRD","stcc":"2631117","wgt":"98","rlsereqtype":null,"fromtk":null,"fromspot":"0","totk":null,"tospot":"0","eqloparsn":"test lopa2"},{"action":"PLCE","eqinit":"TBOX","eqnr":"0000664011","wbsernr":"6460480971","emptyind":"E","cartype":"HOPPER","classcd":"B12","commodity":"CORN","stcc":"2631117","wgt":"125","rlsereqtype":"Loaded full","fromtk":null,"fromspot":"0","totk":2,"tospot":"1","eqloparsn":null}]}}';
        notifi.RACF_Id__c='ABCD';
        notifi.isInternalUser__c=false;
        notifi.Total_Cars_to_Place__c=1;
        notifi.Total_Cars_to_Pull__c=2;
        notifi.Est_Service_Window_From__c=datetime.newInstance(2019, 10, 10, 12, 30, 0);
        notifi.Est_Service_Window_To__c=datetime.newInstance(2019, 10, 11, 12, 30, 0);
        Test.startTest();  
        insert notifi;
        Test.stopTest();   
        notifi=[SELECT Event_Name__c from  Notification_Log__c WHERE Id =:notifi.Id];
        System.assertEquals('PLANNED', notifi.Event_Name__c);
    }
}