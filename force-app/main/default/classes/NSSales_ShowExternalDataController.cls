/*======================================================================================================
* @Class Name : NSSales_ShowExternalDataController
* @author : Accenture
* @Purpose: This class is used to fetch customer statistics info and sending it to server side controller 
*           which invokes it based on the appropiate UI event.
* @created date: 20-06-2019
* @Change Logs:                                 
----------------------------------------------------------------------------------------------------------
Developer name        Date          Description        
----------------------------------------------------------------------------------------------------------
@Arjun Ghosh          03-05-2019    Created the class. Implemented Customer Statistics, Auth Renewals
@Pranay Banerjeee                   Implemented Rate Request
@Debosmeeta paul                    Implemented Won Lane
@Pranay Banerjeee                   Removed Oppurtionity Creation logic from here to a factory class
@Arjun Ghosh          24-06-2019    Added documentation & removed hardcoding some issues.
@Debosmeeta paul      04-12-2019    Implemented Auth Renewals & Lane Details for Omega Server
==========================================================================================================*/
public with sharing class NSSales_ShowExternalDataController {
    /*Class Variables*/
    Static String goodSpell;
    Static String functionType;
    Static String primaryCust;
    Static String classCode;
    Static String stationCode;
    Static String servingRoad;
    Static String nsAcctNum;
    /*Class Name*/
    private static final String CLASS_NAME = 'NSSales_ShowExternalDataController';
    private static final String METHOD_NAME1='getParamCallouts';
    private static final String METHOD_NAME2='getCustomerStatisticsData';
    private static final String METHOD_NAME3='getAuthRenewalData';
    /* Constant used for encoding*/
    private static final String UTF='UTF-8';
    /* Constant used for error msg*/
    private static final String errmsgGoodSpell ='There is no good-spell value on the account thus no data available to display';
    
    /*Get Account Related Data*/
    public static void getParamCallouts(String accId){
        try{
            system.debug('Im in');
            Account acc = [Select Id,NS_ClassCode__c,NS_CustomerPrimary__c, NS_Goodspell__c,NS_Function_Type__c, NS_OperatingStation__r.NS_OperatingStationCode__c , AccountNumber
                           from Account 
                           where Id =:accId ];
            classCode = acc.NS_ClassCode__c;
            stationCode = acc.NS_OperatingStation__r.NS_OperatingStationCode__c;
            if(acc.NS_Goodspell__c != null){
                goodSpell = EncodingUtil.urlEncode(acc.NS_Goodspell__c,UTF);  
            }
            nsAcctNum =acc.AccountNumber;
            functionType = acc.NS_Function_Type__c;
            primaryCust = acc.NS_CustomerPrimary__c;
            
        }
        
        catch (Exception exp) {
            NS_ExceptionUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME1);
        }
    }
    
    /*Invokes Customer statistics for IM*/
    @AuraEnabled
    public static String getCustomerStatisticsDataIM(String accId){
        String response=null;
        getParamCallouts(accId);
        NS_IntegParams datum= new NS_IntegParams();
        datum.setGoodSpell(goodSpell);
        NS_WebService cs= new NSSales_CS_IM();        
        if(goodSpell != null ){
            response =cs.invokeCallout(datum); 
        }else{
            throw new AuraHandledException(errmsgGoodSpell);   
        }
        
        System.debug('Response from Cust. Stats for IM:'+response);
        return response;
    }
    
    /*Invokes Customer statistics for IP*/
    @AuraEnabled
    public static String getCustomerStatisticsData(String accId){
        String response=null;
        getParamCallouts(accId);
        NS_IntegParams datum= new NS_IntegParams();
        datum.setGoodSpell(goodSpell);
        NS_WebService cs= new NSSales_CS();        
        
        if(goodSpell != null ){
            //response =cs.invokeCallout(datum); 
            
            try{
                response =cs.invokeCallout(datum); 
                
            }catch(exception ex)
            {
                System.debug('getCustomerStatisticsData..error line='+ex.getLineNumber() +' : '+ex.getMessage() );
            }
            
        }else{
            throw new AuraHandledException(errmsgGoodSpell);   
        }
        
        System.debug('Response from Cust. Stats:'+response);
        return response;
    }
    /* Invokes Authority renewal*/
    @AuraEnabled
    public static String getAuthRenewalData(String accId){
        String response=null;
        getParamCallouts(accId);
        system.debug('Function'+functionType);
        system.debug('CustNum' +primaryCust);
        if(functionType != null){
            NS_IntegParams datum= new NS_IntegParams();
            datum.setprimaryCust(primaryCust);
            NS_WebService ar= new NSSales_OmegaAuthRenewals(); 
            if(primaryCust!=null){
                response =ar.invokeCallout(datum); 
            }
        }else{
            NS_IntegParams datum= new NS_IntegParams();
            datum.setGoodSpell(goodSpell);
            NS_WebService ar= new NSSales_AuthRenewals();        
            if(goodSpell != null ){
                response =ar.invokeCallout(datum); 
            }
            else{
                throw new AuraHandledException(errmsgGoodSpell);   
            } 
        }
        System.debug('Response from Auth. Renewal: '+response);
        return response;
    }
    /* Invokes Rate Request*/
    @AuraEnabled
    public static String getRateRequestData(String accId){
        String response=null;
        getParamCallouts(accId);
        NS_IntegParams datum= new NS_IntegParams();
        datum.setGoodSpell(goodSpell);
        NS_WebService cs= new NSSales_RateRequest(); 
        
        if(goodSpell != null ){
            try{
                response =NSSales_RateRequest.invokeCallout(datum); 
            }
            catch (Exception exp) {
                NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME2);
            }
        }
        System.debug('Response from Rate Request:'+response);
        return response;
    }
    /* Invokes  Won lane*/
    @AuraEnabled
    public static String getWonLaneRequest(String reqId){
        
        String response=null;
        
        NS_IntegParams datum= new NS_IntegParams();
        datum.setwonLaneReqID(reqId);
        NS_WebService cs= new NSSales_WonLaneInfo(); 
        if(reqId != null ){
            try{
                response =NSSales_WonLaneInfo.invokeCallout(datum); 
            }
            catch (Exception exp) {
                NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME2);
            }
        }
        System.debug('Response from Won Lane Request:'+response);
        return response;
    }
    
    
    public static NSSales_WonLaneInfoWrapper getWonLaneDetailRequest(String reqId){
        
        String endpoint=NS_IntegrationUtility_WorkBench.ENDPOINT+'/request/lanes?wb-request-id=' + reqId;              
        
        HttpResponse hres = NS_WSCallout.sendRequestRest(endpoint, NS_IntegrationUtility_WorkBench.GET, NS_IntegrationUtility_WorkBench.CONTENTTYPE, null); 
        System.debug('Raw Lane Details' +hres.getBody());
        NSSales_WonLaneInfoWrapper wrapperList = (NSSales_WonLaneInfoWrapper)JSON.deserialize(hres.getBody(),NSSales_WonLaneInfoWrapper.class);
        system.debug('WrapperList' +wrapperList);
        return wrapperList;
    }
    /* This method is used to pass the Lane Info for Authority Lane IP */
    public static NSSales_AuthorityLaneInfoWrapper getAuthRenewalLaneDetailIP(String authNum, String expDate){
        
        String endpoint=NS_IntegrationUtility_WorkBench.ENDPOINT+'/renewal/lanes?bureau='+authNum.substringBefore(' ')+'&auth-num='+authNum.substringAfter(' ')+'&exp-date='+expDate;              
        
        HttpResponse hres = NS_WSCallout.sendRequestRest(endpoint, NS_IntegrationUtility_WorkBench.GET, NS_IntegrationUtility_WorkBench.CONTENTTYPE, null); 
        System.debug('Raw Lane Details' +hres.getBody());
        NSSales_AuthorityLaneInfoWrapper wrapperList = (NSSales_AuthorityLaneInfoWrapper)JSON.deserialize(hres.getBody(),NSSales_AuthorityLaneInfoWrapper.class);
        system.debug('WrapperList' +wrapperList);
        return wrapperList;
    }
    
    /* This method is used to pass the Lane Info for Authority Lane IM */
    /*  public static NSSales_RenewalLaneWrapper getAuthRenewalLaneDetailIM(String authNum, String expDate){

String endpoint=NS_IntegrationUtility_WorkBench.ENDPOINT+'/renewal/lanes?bureau='+authNum.substringBefore(' ')+'&auth-num='+authNum.substringAfter(' ')+'&exp-date='+expDate;              

HttpResponse hres = NS_WSCallout.sendRequestRest(endpoint, NS_IntegrationUtility_WorkBench.GET, NS_IntegrationUtility_WorkBench.CONTENTTYPE, null); 
System.debug('Raw Lane Details' +hres.getBody());
NSSales_RenewalLaneWrapper wrapperList = (NSSales_RenewalLaneWrapper)JSON.deserialize(hres.getBody(),NSSales_RenewalLaneWrapper.class);
system.debug('WrapperList' +wrapperList);
return wrapperList;
}*/
    
    
    /*
* Parameters: Gets an map with self explanatory keys. Keys are:REQ_NUM,CUST_NAME,TYPE,STATUS,CREATED_DATE,PRICED_DATE,REQ_ID,ACC_ID   
* Return type should be a map: If Oppurtunity record is created return Success as Key and record id as Value
*                              If already there return Exists as key and Already exists as Value
*                              If fails due to any other reason, send  Failure as key and the exact reason as value 
*/
    @AuraEnabled
    public static  Map<String,List<String>> getOppurtDataFromWB(Map<String,String> myMap){
        
        Map<String,List<String>> response = new Map<String,List<String>>();
        //Added by Pranay - To get the Won Lane Details
        getWonLaneDetailRequest(myMap.get('REQ_ID'));
        // response=NSSales_OpportunityFactory.createOppurtDataFromRateRequest(myMap,getWonLaneDetailRequest(myMap.get('REQ_ID')));
        response=NSSales_OpportunityFactory.createOppurtDataFromRateRequestAndLane(myMap,getWonLaneDetailRequest(myMap.get('REQ_ID')));
        System.debug('Response' +response);
        return response;
    }
    /*
* Parameters: Gets an map with self explanatory keys. Keys are:REQ_NUM,CUST_NAME,TYPE,STATUS,CREATED_DATE,PRICED_DATE,REQ_ID,ACC_ID   
* Return type should be a map: If Oppurtunity record is created return Success as Key and record id as Value
*                              If already there return Exists as key and Already exists as Value
*                              If fails due to any other reason, send  Failure as key and the exact reason as value 
*/
    @AuraEnabled
    public static  Map<String,List<String>> getOppurtDataAuthRenWB(Map<String,String> myMap){
        Map<String,List<String>> response = new Map<String,List<String>>();
        String functionType;
        
        List<Account> accList =[Select id,name,NS_Function_Type__c from Account where id=:myMap.get('ACC_ID')];
        system.debug('SRV SS '+myMap.get('ACC_ID')); 
        functionType = accList[0].NS_Function_Type__c;
        if(functionType!= null && functionType.containsIgnoreCase('IM')){
            //getAuthRenewalLaneDetailIM(myMap.get('AUTHORITY'),myMap.get('EXPDATE'));
            //  response=NSSales_OpportunityFactory.createOppurtDataFromAuthorityRenewalIM(myMap,getAuthRenewalLaneDetailIM(myMap.get('AUTHORITY'),myMap.get('EXPDATE')));
        }
        else{
            getAuthRenewalLaneDetailIP(myMap.get('AUTHORITY'),myMap.get('EXPDATE'));
            response=NSSales_OpportunityFactory.createOppurtDataFromAuthorityRenewalIP(myMap,getAuthRenewalLaneDetailIP(myMap.get('AUTHORITY'),myMap.get('EXPDATE')));
            
        }
        System.debug('response'+response);
        
        return response;
    } 
    /*Invoke this method to display Rate Request and Authority Renewal Based on IP and IM Accounts*/ 
    @AuraEnabled
    public static String getIntermodalAcc(String accId){
        System.debug('..in getIntermodalAcc..');
        String functionType;
        String response;
        List<Account> accList =[Select id,name,NS_Function_Type__c from Account where id=:accId];
        functionType = accList[0].NS_Function_Type__c;
        // if(functionType == 'IM Primary Domestic' || functionType == 'IM Primary Intl'){
        if(functionType!= null && functionType.containsIgnoreCase('IM')){
            response ='IM';
        }
        else{
            response ='IP';
        }
        System.debug('response'+response);
        return response;
    }
    /* Invokes Authority Renewal lane*/
    @AuraEnabled
    public static String getAuthorityRenewalLaneRequest(String reqId,String expDate,String accId){
        
        String response=null;
        System.debug('accId'+accId);
        getParamCallouts(accId);
        if(functionType!= null && functionType.containsIgnoreCase('IM')){
            NS_IntegParams datum= new NS_IntegParams();
            datum.setrenewalId(reqId);
            NS_WebService cs= new NSSales_RenewalLane(); 
            if(reqId != null ){
                try{
                    response =cs.invokeCallout(datum); 
                }
                catch (Exception exp) {
                    NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME2);
                }
            }
        }
        else{
            NS_IntegParams datum= new NS_IntegParams();
            datum.setrenewalId(reqId);
            datum.setexpDate(expDate);
            NS_WebService cs= new NSSales_AuthorityLaneInfoIP(); 
            if(reqId != null ){
                try{
                    response =cs.invokeCallout(datum); 
                }
                catch (Exception exp) {
                    NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME2);
                }
            }
        }
        System.debug('Response from Renewal Lane Request:'+response);
        return response;
    }
}