@isTest(SeeAllData=false)
private class NS_LocalServicePayloadWrapperTest {
    static testmethod void testNotificationInsert(){
        Notification_Log__c notifi = new Notification_Log__c();
        notifi.ENS_Message_Payload__c='{"eventtype":"PLANNED",'
            +'"eventdesc":"Local Service Planned",'
            +'"custclasscd":"H11",'
            +'"eqdtls":'
            +'{"eqdtl":'
            +'[{"action":"PLCE",'
            +'"eqinit":"BKTY",'
            +'"eqnr":"0000152146",'
            +'"wbsernr":"6460642492",'
            +'"emptyind":"L",'
            +'"cartype":"BOXCAR",'
            +'"classcd":"H11",'
            +'"commodity":"PPBRD",'
            +'"stcc":"2631117",'
            +'"wgt":"91",'
            +'"rlsereqtype":null,'
            +'"fromtk":null,'
            +'"fromspot":"0",'
            +'"totk":null,'
            +'"tospot":"0",'
            +'"eqloparsn":"test lopa"}]}}';
        insert notifi;  
        Test.startTest();
        NS_LocalServicePayloadWrapper.Eqdtl  abc=new NS_LocalServicePayloadWrapper.Eqdtl();
        abc.action='PLCE';
        abc.eqinit='BKTY';
        abc.eqnr='0000152146';
        abc.wbsernr='6460642492';
        abc.emptyind='L';
        abc.cartype='BOXCAR';
        abc.classcd='H11';
        abc.commodity='PPBRD';
        abc.stcc='2631117';
        abc.wgt='91';
        abc.fromspot='0';
        abc.fromtk='null';
        abc.tospot='1';
        abc.totk='2';
        abc.rlsereqtype='null';
        abc.eqloparsn='null'; 
        Test.stopTest();
        System.debug('abc.eqloparsn:'+ abc.eqloparsn );
        
    }
}