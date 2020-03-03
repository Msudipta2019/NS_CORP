@isTest(SeeAllData=false)
public class NSSales_CS_IM_Test {
    
    @isTest
    static void testCS_IM() {
        NS_Integration_Endpoints__c setting = new NS_Integration_Endpoints__c();
        setting.Name = 'WorkbenchEndpoint';
        setting.Endpoint_URL__c = 'https://qaapi.nscorp.com/external/connectns-api/workbench/customer';
        insert setting;
        NS_IntegParams datum1 = new NS_IntegParams();
        datum1.setGoodSpell('BUNG NOR A1');
        NS_WebService ar1= new NSSales_CS_IM(); 
        try{
            ar1.invokeCallout(datum1);
           }
        catch(Exception exp) {}
        test.startTest();
        system.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
        NS_IntegParams datum = new NS_IntegParams();
        datum.setGoodSpell('BUNG NOR A');
        NS_WebService ar= new NSSales_CS_IM(); 
        try{
            ar.invokeCallout(datum);
           }
        catch(Exception exp) {}
        test.StopTest();
    }
}