@IsTest
private class NSSales_OpportunityRequestServiceTest {

    static testMethod void testDoPost(){
        
        String Json = '{"soucreSys": "Intermodal","soucreSysId": "20200117","custName": "800 Flower","custNum": "432850","requestDate": "2020-01-10","closeDate": "2020-03-10","lanes": [{"laneId": "12345","imcNum": "20562","originRoad": "NS","originCity": "Chicago (Landers)","originState": "IL","originHandlingLine": "","destinRoad": "NS","destinCity": "Jacksonville","destinState": "FL","stcc": "4611110","reqVolume": "63","reccRate": "892","offerRate": "909","laneStatus": "offered","finalRate": "909"},{"laneId": "67890","imcNum": "20561","originRoad": "NS","originCity": "Rutherford","originState": "PA","originHandlingLine": "","destinRoad": "FEC","destinCity": "Miami","destinState": "FL","stcc": "4611110","reqVolume": "91","reccRate": "1441","offerRate": "1470","laneStatus": "offered"}]}';

      
        
  Test.startTest();
   Account acc = new Account();
        acc.Name='Test';
        acc.NS_CustomerPrimary__c ='432850';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Corporate').getRecordTypeId();
        insert acc;
   
         Account acc2 = new Account();
        acc2.Name='Test';
        acc2.NS_CustomerPrimary__c ='20562';
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Corporate').getRecordTypeId();
        insert acc2;
   //As Per Best Practice it is important to instantiate the Rest Context 
   
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();
         
   req.requestURI = '/services/apexrest/Opportunity/v1';  //Request URL
   req.httpMethod = 'POST';//HTTP Request Type
   req.requestBody = Blob.valueof(Json);
   RestContext.request = req;
   RestContext.response= res;
        
   NSSales_OpportunityRequestService.doPost();
         Test.stopTest();
    }
    
     static testMethod void testDoPostNegative(){
        
        String Json = '{"soucreSys": "Intermodal","soucreSysId": "20200117","custName": "800 Flower","custNum": "435271","requestDate": "2020-01-10","closeDate": "2020-03-10","lanes": [{"laneId": "12345","imcNum": "20561","originRoad": "NS","originCity": "Chicago (Landers)","originState": "IL","originHandlingLine": "","destinRoad": "NS","destinCity": "Jacksonville","destinState": "FL","stcc": "4611110","reqVolume": "63","reccRate": "892","offerRate": "909","laneStatus": "offered"},{"laneId": "67890","imcNum": "20561","originRoad": "NS","originCity": "Rutherford","originState": "PA","originHandlingLine": "","destinRoad": "FEC","destinCity": "Miami","destinState": "FL","stcc": "4611110","reqVolume": "91","reccRate": "1441","offerRate": "1470","laneStatus": "offered"}]}';

      
        
  Test.startTest();
   Account acc = new Account();
        acc.Name='Test';
        acc.NS_CustomerPrimary__c ='20561';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Corporate').getRecordTypeId();
        insert acc;
   //As Per Best Practice it is important to instantiate the Rest Context 
   
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();
         
   req.requestURI = '/services/apexrest/Opportunity/v1';  //Request URL
   req.httpMethod = 'POST';//HTTP Request Type
   req.requestBody = Blob.valueof(Json);
   RestContext.request = req;
   RestContext.response= res;
        
   NSSales_OpportunityRequestService.doPost();
         Test.stopTest();
    }
    
    static testMethod void testupdateLane(){
        
        String Json = '{"soucreSys": "Intermodal","soucreSysId": "20200117","custName": "800 Flower","custNum": "432850","requestDate": "2020-01-10","closeDate": "2020-03-10","lanes": [{"laneId": "12345","imcNum": "20561","originRoad": "NS","originCity": "Chicago (Landers)","originState": "IL","originHandlingLine": "","destinRoad": "NS","destinCity": "Jacksonville","destinState": "FL","stcc": "4611110","reqVolume": "63","reccRate": "892","offerRate": "909","laneStatus": "offered"},{"laneId": "67890","imcNum": "20561","originRoad": "NS","originCity": "Rutherford","originState": "PA","originHandlingLine": "","destinRoad": "FEC","destinCity": "Miami","destinState": "FL","stcc": "4611110","reqVolume": "91","reccRate": "1441","offerRate": "1470","laneStatus": "offered"}]}';

      
        
  Test.startTest();
   Account acc = new Account();
        acc.Name='Test';
        acc.NS_CustomerPrimary__c ='432850';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Corporate').getRecordTypeId();
        insert acc;
        
        NSSales_Opportunity_Lanes__c optylanes = new NSSales_Opportunity_Lanes__c();
        optylanes.NSSales_LaneId__c = '12345';
        insert optylanes;
   //As Per Best Practice it is important to instantiate the Rest Context 
   
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();
         
   req.requestURI = '/services/apexrest/Opportunity/v1';  //Request URL
   req.httpMethod = 'PUT';//HTTP Request Type
   req.requestBody = Blob.valueof(Json);
   RestContext.request = req;
   RestContext.response= res;
        
   NSSales_OpportunityRequestService.updateLane();
         Test.stopTest();
    }

}