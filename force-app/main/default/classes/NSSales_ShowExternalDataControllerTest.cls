@isTest(SeeAllData=false)
public class NSSales_ShowExternalDataControllerTest {
    @testSetup static void setup() {
        Account acc1 = AccountTestFactory.createAccountRecord('Test Acc01');
        acc1.NS_Goodspell__c='BUNG NOR A1';
        acc1.NS_Function_Type__c='IM Domestic';
        update acc1; 
        Account acc2= AccountTestFactory.createAccountRecord('Test Acc02');
        acc2.NS_Goodspell__c='testGoogspell';
        acc2.NS_Function_Type__c='';
        update acc2;
        NS_Integration_Endpoints__c setting = new NS_Integration_Endpoints__c();
        setting.Name = 'WorkbenchEndpoint';
        setting.Endpoint_URL__c = 'https://qaapi.nscorp.com/external/connectns-api/workbench/customer';
        insert setting; 
    }
    @isTest static void testNSSales_ShowExternalDataController() {
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        system.runAs(admin){
       Account acc = AccountTestFactory.getOnlineBusinessAccountRecord1('Test Acc01');
        insert acc;
            Map<String,String> xyz = new Map<String,String>();
            xyz.put('REQ_ID', '1234');
            xyz.put('ACC_ID', '1234');
            xyz.put('AUTHORITY', '1234');
            xyz.put('EXPDATE', '1234');
            String abcId= (String)acc.id;
            
            NS_IntegParams datum= new NS_IntegParams();
            datum.setGoodSpell(acc.NS_Goodspell__c);
            
        system.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
        test.startTest();
        NSSales_ShowExternalDataController.getCustomerStatisticsData(abcId);
        NSSales_ShowExternalDataController.getIntermodalAcc(abcId);  
        NSSales_ShowExternalDataController.getRateRequestData(abcId);
        NSSales_ShowExternalDataController.getWonLaneRequest('1234');
        NSSales_ShowExternalDataController.getWonLaneDetailRequest('1234');
        NSSales_ShowExternalDataController.getAuthRenewalLaneDetailIP('1234','2020-12-04');
        NSSales_ShowExternalDataController.getAuthorityRenewalLaneRequest('1234','2020-12-04',abcId);
        NSSales_ShowExternalDataController.getOppurtDataFromWB(xyz);
        NSSales_ShowExternalDataController.getCustomerStatisticsDataIM(abcId);
        NSSales_ShowExternalDataController.getAuthRenewalData(abcId);    
        test.StopTest();
        }
    }
    @isTest static void testNSSales_ShowExternalDataController1() {
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        system.runAs(admin){
      // Account acc = AccountTestFactory.getOnlineBusinessAccountRecord1('Test Acc01');
       // insert acc;
            Account acc = AccountTestFactory.getOnlineBusinessAccountRecord2('Test Acc01');
        insert acc;
         //   String abcId= (String)acc.id;
            String abcId= (String)acc.id;
            NS_IntegParams datum= new NS_IntegParams();
            datum.setGoodSpell(acc.NS_Goodspell__c);
            Map<String,String> xyz = new Map<String,String>();
            xyz.put('REQ_ID', '1234');
            xyz.put('ACC_ID', abcId);
            xyz.put('AUTHORITY', '1234');
            xyz.put('EXPDATE', '1234');
        system.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
        test.startTest();
            NSSales_ShowExternalDataController.getAuthRenewalData(abcId);
            NSSales_ShowExternalDataController.getOppurtDataAuthRenWB(xyz);
            NSSales_ShowExternalDataController.getAuthorityRenewalLaneRequest('1234','2020-12-04',abcId);
          
        test.StopTest();
        }
    }
    
 
    
   
    
}