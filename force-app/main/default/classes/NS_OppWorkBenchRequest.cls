public class NS_OppWorkBenchRequest {
    
    Static Final String CLASS_NAME = 'NS_OppWorkBenchRequest';
    Static Final String METHOD_NAME = 'invokeOppStageChangeOnUpdateWB';
    Static Final String METHOD_NAME1 = 'invokeOppStageChangeOnInsertWB';
    
    public Final Static String BLANK = ''; /*For checking null values*/
    public Static String OppWorkBenchRequest = ''; /*For endpoint url*/
    public Final Static String ENDPOINT_VALUE = 'OppWorkBenchRequest';
   
    //Please remove this static block from here.Refer NS_IntegrationUtility_Workbench: Arjun
    static {
        Map<String,NS_Integration_Endpoints__c> endpoints = NS_Integration_Endpoints__c.getAll();  
        if(endpoints.containsKey(ENDPOINT_VALUE)){
            OppWorkBenchRequest = endpoints.get(ENDPOINT_VALUE).Endpoint_URL__c;
            
        }
    }
    
    public static void invokeOppStageChangeOnUpdateWB(map<Id,Opportunity> oldMap, map<Id,Opportunity> newMap){
        
        Map<String,String> stageMap = new Map<String,String>();
        
        List<ManageOpportunityWrapperWB> OpportunityWrapperList;
        OpportunityWrapperList = new List<ManageOpportunityWrapperWB>();
        
        boolean run = true;
        String ProfileName = [Select Profile.Name from user where ID = :UserInfo.getUserId()].Profile.Name;
        for(Opportunity opp : newMap.Values()){
            if(run == true){
                run = false;
                if(ProfileName != NS_IntegrationUtility_WorkBench.PROFILE_CHECK){
                if( oldMap.get(opp.Id).StageName != opp.StageName){ 
                if(opp.NS_WB_RequestID__c != null){
                if(opp.NS_Originating_Department__c == 'Industrial Products'){
                   System.debug('I m in');
                   ManageOpportunityWrapperWB mow = new ManageOpportunityWrapperWB();
                    mow.RequestID = opp.NS_WB_RequestID__c == null ? BLANK : opp.NS_WB_RequestID__c;
                    mow.RequestStatus = opp.StageName == null ? BLANK : opp.StageName;
                   // mow.RequestStatus = stageMap.get(opp.StageName);
                    
                    OpportunityWrapperList.add(mow);
                    
                    try{
                              prepareManageOpportunityRequestWB(OpportunityWrapperList);
                            }
                            catch(Exception e){
                                NS_ExceptionUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME);
                            }
                    }
                }
               }
              }
            }
        }
        
    }
    
    public class ManageOpportunityWrapperWB{
        public string RequestID = BLANK ;
        public string RequestStatus = BLANK ;
        public string OriginRoad = BLANK ;
        public string OriginCity = BLANK ;
        public string OriginState = BLANK ;
        public string DestinRoad = BLANK ;
        public string DestinCity = BLANK ;
        public string DestinState = BLANK ;
        public string Stcc = BLANK ;
        public string CustomerName = BLANK ;
        public string CustomerNumber = BLANK ;
        public string Status = BLANK ;
        public string Shipper = BLANK ;
        public string Receiver = BLANK ;
        public string EstimatedVolume = BLANK ;
        public string OppId = BLANK ;
    }
    
    private static void prepareManageOpportunityRequestWB(List<ManageOpportunityWrapperWB> OpportunityWrapperList){  
                
        String body;
        body = NS_WsRequestBodyFactory.OpportunityWBJSONContent(OpportunityWrapperList);//deployment issue
        
        invoke_ManageOpportunityWorkBench(body);
        
      }
    
     /*Invoking the request to send data from SF to Workbench server*/
     @future (callout=true)
    public static void invoke_ManageOpportunityWorkBench(String body){  
        String endpoint = OppWorkBenchRequest;
        endpoint +='/customer/request';
        system.debug('Body' +body);
        HttpResponse hres = NS_WSCallout.sendRequestRest(endpoint, NS_IntegrationUtility_WorkBench.PUTMETHOD, NS_IntegrationUtility_WorkBench.CONTENTTYPE, body);
        system.debug('Status: ' +hres.getstatus());
        system.debug('Debug: ' +hres.getbody());
    }
    
    public static void invokeOppStageChangeOnInsertWB(map<Id,Opportunity> newMap){
        
        List<ManageOpportunityWrapperWB> OpportunityWrapperList;
        OpportunityWrapperList = new List<ManageOpportunityWrapperWB>();
        
        boolean run = true;
        String ProfileName = [Select Profile.Name from user where ID = :UserInfo.getUserId()].Profile.Name;
        
        for(Opportunity opp : newMap.Values()){
            
            if(run == true){
                 run = false;
               if(ProfileName != NS_IntegrationUtility_WorkBench.PROFILE_CHECK && opp.NS_WB_RequestID__c == null &&
                 opp.StageName =='Proposal' && opp.NS_Originating_Department__c == 'Industrial Products'){
                    
                      ManageOpportunityWrapperWB mow = new ManageOpportunityWrapperWB();
                    mow.OppId = opp.Id == null ? BLANK : opp.Id;
                    mow.OriginRoad = opp.NS_Origin_Carrier__c == null ? BLANK : opp.NS_Origin_Carrier__c;
                    mow.OriginCity = opp.NS_Origin_City__c == null ? BLANK : opp.NS_Origin_City__c;
                    mow.OriginState = opp.Origin_State__c == null ? BLANK : opp.Origin_State__c;
                    mow.DestinRoad = opp.NS_Destination_Carrier__c == null ? BLANK : opp.NS_Destination_Carrier__c;
                    mow.DestinCity = opp.NS_Destination_City__c == null ? BLANK : opp.NS_Destination_City__c;
                    mow.DestinState = opp.NS_Destination_State__c == null ? BLANK : opp.NS_Destination_State__c;
                    //mow.CustomerName = opp.Account.Name == null ? BLANK : opp.Account.Name;
                    mow.CustomerName = opp.Account_Name__c == null ? BLANK : opp.Account_Name__c;
                    mow.Stcc = opp.NS_Commodity_STCC__c == null ? BLANK : opp.NS_Commodity_STCC__c;
                    mow.Status = opp.StageName == null ? BLANK : opp.StageName;
                    mow.Shipper = opp.NSSales_Shipper__c == null ? BLANK : opp.NSSales_Shipper__c;
                    mow.CustomerNumber = opp.Account.NS_CustomerPrimary__c == null ? BLANK : opp.Account.NS_CustomerPrimary__c;
                    mow.EstimatedVolume = opp.NS_Estimated_Volume__c == null ? BLANK : string.valueof(opp.NS_Estimated_Volume__c);
                    
                      
                    OpportunityWrapperList.add(mow);
                    
                    try{
                              prepareManageOpportunityInsertWithRequestIdWB(OpportunityWrapperList);
                            }
                            catch(Exception e){
                                NS_ExceptionUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME1);
                            }
                    
                }   
            }  
            
        }
        
        }
        
    private static void prepareManageOpportunityInsertWithRequestIdWB(List<ManageOpportunityWrapperWB> OpportunityWrapperList){
        system.debug('WrapperList' +OpportunityWrapperList[0].OppId);
        List<Id> recordId = new List<Id>();
        recordId.add(OpportunityWrapperList[0].OppId);
        String userFederationId = [Select FederationIdentifier from user where ID = :UserInfo.getUserId()].FederationIdentifier;        
        String body;
        body = NS_WsRequestBodyFactory.insertOpportunityRequestIdWBJSONContent(userFederationId,OpportunityWrapperList);
         
        invoke_ManageOpportunityRequestIDWorkBench(body,recordId);
        
      }
    
     /*Invoking the request to send data from SF to Workbench server*/ 
     @future (callout=true)
    public static void invoke_ManageOpportunityRequestIDWorkBench(String body, List<Id> recordId){  
        String endpoint = OppWorkBenchRequest;
        endpoint +='/customer/request';
        system.debug('Body' +body);
        system.debug('RecordId' +recordId);
        HttpResponse hres = NS_WSCallout.sendRequestRest(endpoint, NS_IntegrationUtility_WorkBench.POSTMETHOD, NS_IntegrationUtility_WorkBench.CONTENTTYPE, body);
        system.debug('Status: ' +hres.getstatus());
        system.debug('Debug: ' +hres.getbody());
        system.debug('Code: ' +hres.getStatusCode());
        
        if (hres.getStatusCode() == 200) {
               
            // parse the JSON
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(hres.getBody());
               System.debug('Results'+results);
            Map<String, Object> res = (Map<String, Object>)results.get('result');
            system.debug('RES' +res);
            // create empty string variable
            String retVal = null;
            String reqnum = null;
         //  System.debug('retVal'+string.valueof(res.get('requestId')));
            if(!Test.isRunningTest()){
            retVal = string.valueof(res.get('requestId'));
            reqnum = string.valueof(res.get('requestNumber'));
            }
            List<Opportunity> oppty = [SELECT id,Name,NS_WB_RequestID__c,NS_WB_RequestNum__c FROM Opportunity
                                 WHERE Id IN :recordId];
            
            for(Opportunity opp :oppty){
                
                opp.NS_WB_RequestID__c = retVal;
                opp.NS_WB_RequestNum__c = reqnum;
                update opp;
            }
        }
    }
    
}