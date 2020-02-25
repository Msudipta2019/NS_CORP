@isTest(SeeAllData=false)
public class NS_TerminalAccountUpdateTest {
    static testmethod void testinvokeTerminalAccount(){ 
        NS_Integration_Endpoints__c ie = new NS_Integration_Endpoints__c();
        ie.Name = 'Terminal';
        ie.Endpoint_URL__c = 'https://qaapi.nscorp.com/external/connectns-api/optcs/terminals';
        insert ie;
        NS_ServiceStations__c ss = new NS_ServiceStations__c();
        ss.NS_OperatingStationCode__c = '282W';
        insert ss;
        Account acc = new Account();
        acc.Name = 'APPLIANCE PARK';
        acc.NS_External_ID__c = 'APPLIANCE PARK-282W';
        insert acc;
        Test.startTest();
        NS_TerminalAccountUpdate ta = new NS_TerminalAccountUpdate();
        System.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
        NS_TerminalAccountUpdate.invokeCallout();
        NS_TerminalAccountUpdate.importTeminal();
        Test.stopTest();
        
    }

}