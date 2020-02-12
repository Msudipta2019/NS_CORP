@isTest(SeeAllData=false)
public class NSSales_RenewalLaneTest {
    @isTest
    static void testRenewalLaneTest() {
        NS_Integration_Endpoints__c setting = new NS_Integration_Endpoints__c();
        setting.Name = 'OmegaAuthRenewals';
        setting.Endpoint_URL__c = 'https://qaapi.nscorp.com/external/connectns-api/omega/api/v1/quotes';
        insert setting;
        NS_Integration_Endpoints__c setting1 = new NS_Integration_Endpoints__c();
        setting1.Name = 'Omega Authentication';
        setting1.Endpoint_URL__c = 'https://qaapi.nscorp.com/external/connectns-api/omega/oauth/token';
        insert setting1;
        test.startTest();
        system.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
        NS_IntegParams datum =  new NS_IntegParams();
        datum.setrenewalId('9000001');
       // system.test.StartTest();
        NS_WebService ar= new NSSales_RenewalLane(); 
        try{
            ar.invokeCallout(datum);
           }
        catch(Exception exp) {}
       test.StopTest();
    }
}