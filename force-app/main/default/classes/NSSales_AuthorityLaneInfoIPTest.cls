@isTest(SeeAllData=false)
public class NSSales_AuthorityLaneInfoIPTest {
    @isTest 
    public static void testAuthorityLane() 
    {
        NS_Integration_Endpoints__c setting = new NS_Integration_Endpoints__c();
        setting.Name = 'WorkbenchEndpoint';
        setting.Endpoint_URL__c = 'https://qaapi.nscorp.com/external/connectns-api/workbench/customer';
        insert setting;
        NS_IntegParams datum= new NS_IntegParams();
        datum.setrenewalId('NSSC 19480');
        datum.setexpDate('2020-09-30');
            System.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
            system.test.StartTest();
            NS_WebService ar= new NSSales_AuthorityLaneInfoIP(); 
            ar.invokeCallout(datum);
            System.test.StopTest();
        
    }
}