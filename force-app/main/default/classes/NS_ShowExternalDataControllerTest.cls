/*
This class provides Mock reponse for NS webservice Implementation
Developer    : Accenture Solutions
Date         : 1-24-2018
*/

@isTest(SeeAllData=false)
private class NS_ShowExternalDataControllerTest {
    /*Constants*/
    public static final string USER_REP = 'OSS Rep';
    public static final string Sys_Admin = 'System Administrator';
    /*Constants*/
   /* We will use this later*/
    public static final string NS = 'NS';
     @testSetup static void setup() {
        
        AccountTestFactory.createOnlineServiceAccountRecord(NS_StaticVariablesUtility.Name);    
        AccountTestFactory.createOfflineServiceAccountRecord(NS_StaticVariablesUtility.Name+NS_StaticVariablesUtility.Name);    
    }
     
      @isTest(SeeAllData=false)
    static void testPipeLineData() {
        Account acc = [SELECT Id FROM Account WHERE Name=:NS_StaticVariablesUtility.Name LIMIT 1]; 
        Account offlineAacc = [SELECT Id FROM Account WHERE Name=:NS_StaticVariablesUtility.Name+NS_StaticVariablesUtility.Name LIMIT 1];       
        String accId = (String)acc.id;
        String offLineAccId = (String)offlineAacc.id;
        System.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
        system.test.StartTest();
        System.debug('PipeLine::'+NS_ShowExternalDataController.getPipeLineData(accId));
        System.assert(NS_ShowExternalDataController.getPipeLineData(accId)<>null);
        System.assert(NS_ShowExternalDataController.invokeTYESGetCustomerSummary(accId)<>null);
         System.assert(NS_ShowExternalDataController.GetCrewData(accId)<>null);
        System.assert(NS_ShowExternalDataController.getLopaData(accId)<>null);
        System.assert(NS_ShowExternalDataController.getCarRequestService(accId)<>null);
        System.assert(NS_ShowExternalDataController.invokeTransitExceptionCount(accId)<>null);
        System.assert(NS_ShowExternalDataController.hideSummarypage(accId)<>null);
        System.assert(NS_ShowExternalDataController.hideSummarypage(offLineAccId)<>null);
        
        System.assert(NS_ShowExternalDataController.invokeTransitExceptionDetail('accId', 'equipmentInit', 'equipmentNr', 'waybillSrNr')<>null);
        
        //System.assert(NS_ShowExternalDataController.getTrainSetEnquiry(accId)<>null);
        //System.assert(NS_ShowExternalDataController.getStationClassCode(accId)<>null);
        //System.assert(NS_ShowExternalDataController.getTeamsUrl(accId)<>null);
        System.test.StopTest();
       
    }
 
     @isTest(SeeAllData=false)
    static void testData() {
        Account acc = [SELECT Id FROM Account WHERE Name=:NS_StaticVariablesUtility.Name LIMIT 1]; 
         String accId = (String)acc.id;
        system.test.StartTest();
        NS_ShowExternalDataController.getTeamsUrl(accId);
        NS_ShowExternalDataController.getTrainSetEnquiry(accId);
        NS_ShowExternalDataController.getShipmentStatus(accId);
        NS_ShowExternalDataController.getAemsUrl(accId);
        NS_ShowExternalDataController.getStationClassCode(accId);
        NS_ShowExternalDataController.checkConditions(accId);
        System.test.StopTest();
    }
/*
    @isTest static void testLOPA() {
        
        NS_ServiceStations__c serviceStation = new NS_ServiceStations__c();
        serviceStation.NS_OperatingStationCode__c = 'test';
        Database.Insert(serviceStation); 
        
        Account acc = AccountTestFactory.createAccountRecord(NS_StaticVariablesUtility.Name);
        acc.NS_ClassCode__c = 'test';
        acc.NS_OperatingStation__c = serviceStation.Id;
        Database.update(acc);
        
        System.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
        system.test.StartTest();
        NS_ShowExternalDataController.GetCrewData(acc.Id);
        System.test.StopTest();
    }
    @isTest static void testRouteReport() {
        NS_ServiceStations__c serviceStation = new NS_ServiceStations__c();
        serviceStation.NS_OperatingStationCode__c = 'test';
        Database.Insert(serviceStation); 
        
        Account acc = AccountTestFactory.createAccountRecord(NS_StaticVariablesUtility.Name);
        acc.NS_ClassCode__c = 'test';
        acc.NS_OperatingStation__c = serviceStation.Id;
        Database.update(acc);
        
        System.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
        system.test.StartTest();
        NS_ShowExternalDataController.GetLOPAData(acc.Id);
        System.test.StopTest();
    }
    //
    @isTest static void testTransitExceptionCount() {
        NS_ServiceStations__c serviceStation = new NS_ServiceStations__c();
        serviceStation.NS_OperatingStationCode__c = 'test';
        Database.Insert(serviceStation); 
        
        Account acc = AccountTestFactory.createAccountRecord(NS_StaticVariablesUtility.Name);
        acc.NS_ClassCode__c = 'test';
        acc.NS_OperatingStation__c = serviceStation.Id;
        Database.update(acc);
        NS_ShowExternalDataController.getStationClassCode(NS_StaticVariablesUtility.Name);
        NS_ShowExternalDataController.getStationClassCode(acc.Id);
        System.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
        system.test.StartTest();
        NS_ShowExternalDataController.invokeTransitExceptionCount(acc.Id);
        System.test.StopTest();
    }
    //
    @isTest static void testgetAccount() {
        NS_ServiceStations__c serviceStation = new NS_ServiceStations__c();
        serviceStation.NS_OperatingStationCode__c = 'test';
        Database.Insert(serviceStation); 
        
        Account acc = AccountTestFactory.createAccountRecord(NS_StaticVariablesUtility.Name);
        acc.NS_ClassCode__c = 'test';
        acc.NS_OperatingStation__c = serviceStation.Id;
        Database.update(acc);
        
        system.test.StartTest();
      //  NS_ShowExternalDataController.getAccount(acc.Id);
        System.test.StopTest();
    }
    // Test TransitExceptionDetail
    @isTest static void invokeTransitExceptionDetail(){
         NS_ServiceStations__c serviceStation = new NS_ServiceStations__c();
        serviceStation.NS_OperatingStationCode__c = 'test';
        Database.Insert(serviceStation); 
        Account acc = AccountTestFactory.createAccountRecord(NS_StaticVariablesUtility.Name);
         acc.NS_ClassCode__c = 'test';
        acc.NS_OperatingStation__c = serviceStation.Id;
        Database.update(acc);
         NS_ShowExternalDataController.getStationClassCode(NS_StaticVariablesUtility.Name);
        NS_ShowExternalDataController.getStationClassCode(acc.Id);
        System.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
        system.test.StartTest();
        NS_ShowExternalDataController.invokeTransitExceptionDetail(acc.Id, 'EquipmentInit', '405', '202');
        System.test.StopTest(); 
    }*/
     @isTest(SeeAllData=false)
    static void testTransitData1() {
        Profile agent = UserTestFactory.createProfile(USER_REP);
        User testUser = UserTestFactory.createUser(25,agent.Id);  
        system.runAs(testUser){
             Account acc = AccountTestFactory.createAccountRecord(NS_StaticVariablesUtility.Name);
           Case abc = CaseTestFactory.createCaseRecord('Local Service Inquiry','Local Service',acc.Id);             
            insert abc;
            
            System.debug('case id'+abc.id);
            String abcId= (String)abc.id;
           
        //   NS_IntegParams datum= new NS_IntegParams();
         //   datum.setClassCode(acc.NS_ClassCode__c);
            //datum.setStationCode(GARDN);
          //  datum.setUserId(UserInfo.getUserId());
         //  datum.setequipmentID('EMHU 262418');
         //   System.debug('Datum'+ datum);
            System.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
            system.test.StartTest();
             NS_ShowExternalDataController.getLastMoves('EMHU 262418');
            NS_ShowExternalDataController.getEquipmentData('EMHU 262418');
           
        //  NS_ShowExternalDataController.setEquipNum(abc.Id);
          //  NS_WebService ar= new NS_LastMoves();
          //   NS_WebService ar1= new NS_EquipmentSummary(); 
          //  ar.invokeCallout(datum);
          //  ar1.invokeCallout(datum);
           System.test.StopTest();            
        }
    }
           @isTest(SeeAllData=false)
        static void testTransitData2(){
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        system.runAs(admin){
             Account acc = AccountTestFactory.createAccountRecord(NS_StaticVariablesUtility.Name);
            Case abc = CaseTestFactory.createCaseRecord('Local Service Inquiry','Local Service',acc.Id);             
       
            abc.NS_Equipment_Init_and_Number__c='HGIU 648916';
                insert abc;
            System.debug('case id'+abc.id);
            String abcId= (String)abc.id;
           List<Case> caseList  =[Select id,NS_Equipment_Init_and_Number__c from Case where id=:abcid LIMIT 1];
            System.debug('caseList'+caseList);
            if(caselist.size()>0) {
          abc=caselist[0];
            }
            system.debug(caseList);
              NS_ShowExternalDataController.setEquipNum(abc.Id);
    
    }
        }  
}