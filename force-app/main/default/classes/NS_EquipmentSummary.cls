public with sharing class NS_EquipmentSummary implements NS_WebService{
    public final Static String ENDPOINT_KEY = 'EquipmentSummary';
    public final Static String ENDPOINT1;
    static {
        Map<String,NS_Integration_Endpoints__c> endpoints = NS_Integration_Endpoints__c.getAll();  
        if(endpoints.containsKey(ENDPOINT_KEY)){
            ENDPOINT1 = endpoints.get(ENDPOINT_KEY).Endpoint_URL__c;
            
        }
    }

    public string invokeCallout(NS_IntegParams datum){
        String response=null;
        String endpoint;
        String ipEquipStr = datum.getequipmentID();
        //11.2, jlong change start, replace all numeric to get initial; replace alpha to get eqpt num
        String equipNum = ipEquipStr.replaceAll(' ', '').replaceAll('[^\\d]','').trim().leftPad(6, '0');
		String equipInit = ipEquipStr.replaceAll(' ', '').replaceAll('[\\d]','').trim();
        
        HttpResponse hres;
        try{
            endpoint=ENDPOINT1+equipInit+'/'+equipNum;
            system.debug(endpoint);
            hres = NS_WSCallout.sendRequestRest(endpoint, NS_IntegrationUtility_WorkBench.GET, NS_IntegrationUtility_WorkBench.CONTENTTYPE, null); 
            response=hres.getBody();
        } catch(Exception exp) {
            
      }
        return response;
    }
}