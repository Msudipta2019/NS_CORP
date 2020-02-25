/*======================================================================================================
* @Class Name : NS_TerminalAccountUpdate
* @author : Accenture
* @Purpose: This class upsert Account object with record coming Terminal server.
* @created date: 09-01-2018
* @Change Logs:                                 
----------------------------------------------------------------------------------------------------------
Developer name        Date          Description        
----------------------------------------------------------------------------------------------------------
@Debosmeeta Paul      15-09-2019    Request No.   , Phase-II
==========================================================================================================*/
public class NS_TerminalAccountUpdate {
    Static Final Id ACCOUNTRECORDTYPE = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_FieldLocation'].Id; /*Only for General Contact we have sent data to server.*/
    public final Static String ENDPOINT_KEY = 'Terminal';
    public final Static String ENDPOINT;
    static {
        Map<String,NS_Integration_Endpoints__c> endpoints = NS_Integration_Endpoints__c.getAll();  
        if(endpoints.containsKey(ENDPOINT_KEY)){
            ENDPOINT = endpoints.get(ENDPOINT_KEY).Endpoint_URL__c;
            
        }
    }
    public static void invokeCallout(){
       List<Account> acc = new List<Account>();
      // System.debug('Endpoint:'+endpoint);
       HttpResponse hres = NS_WSCallout.sendRequestRest(ENDPOINT, NS_IntegrationUtility_WorkBench.GET, NS_IntegrationUtility_WorkBench.CONTENTTYPE, null); 
      // System.debug('Response Body"' +hres.getBody());
       List<TerminalWrapper> wrapperList = (List<TerminalWrapper>)JSON.deserialize(hres.getBody(),List<TerminalWrapper>.class);
      // System.debug('WrapperList:' +wrapperList);
       Map<String, String> opStationLst = new Map<String,String>();
       Map<String, String> accLst = new Map<String,String>();
       for(NS_ServiceStations__c ss: [Select id,NS_OperatingStationCode__c from NS_ServiceStations__c]){
            opStationLst.put(ss.NS_OperatingStationCode__c,ss.Id);
        }
        for(Account acct: [Select id,NS_External_ID__c from Account]){
            accLst.put(acct.NS_External_ID__c,acct.Id);
        }
       for(TerminalWrapper tw : wrapperList)
       {
            Account newAcc = new Account();
            newAcc.RecordTypeId = ACCOUNTRECORDTYPE;
            newAcc.NS_External_ID__c = tw.terminal+'-'+tw.operatingStation;
            newAcc.Name = tw.terminal;
            newAcc.NS_OperatingStation__c = opStationLst.get(tw.operatingStation);
           	if(accLst.get(newAcc.NS_External_ID__c)!= null)
                newAcc.id = accLst.get(newAcc.NS_External_ID__c);
           
            acc.add(newAcc);
       }
        upsert acc;
    }
    public class TerminalWrapper{
        public String terminal;
    	public String operatingStation;
    }
    @AuraEnabled
	public static void importTeminal() {
    	Id jobId = Database.executeBatch(new NS_BatchForAccountUpdate()); 
	}

}