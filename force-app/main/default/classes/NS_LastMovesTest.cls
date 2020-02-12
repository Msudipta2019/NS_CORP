@isTest(SeeAllData=false)
public class NS_LastMovesTest {
    @isTest
    static void testTransitData() {
        NS_Integration_Endpoints__c setting = new NS_Integration_Endpoints__c();
        setting.Name = 'LastMoves';
        setting.Endpoint_URL__c = 'https://api.nscorp.com/external/tep/equipmentlastmoves?einit=';
        insert setting;
        NS_IntegParams datum= new NS_IntegParams();
        datum.setequipmentID('EMHU 262418');
        System.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
        system.test.StartTest();
        NS_WebService ar= new NS_LastMoves(); 
        ar.invokeCallout(datum);
        System.test.StopTest(); 
    }
}