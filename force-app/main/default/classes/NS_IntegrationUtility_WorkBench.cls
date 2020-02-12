public class NS_IntegrationUtility_WorkBench {
    
    public final Static String CONTENTTYPE = 'application/json;charset=UTF-8';
    public final Static String PUTMETHOD = 'PUT';
    public final Static String POSTMETHOD = 'POST';
    public final Static String GET = 'GET';
    public final Static String PROFILE_CHECK = 'NS Integration User';
	public final Static String ENDPOINT_KEY = 'WorkbenchEndpoint';
    public final Static String ENDPOINT;
    static {
        Map<String,NS_Integration_Endpoints__c> endpoints = NS_Integration_Endpoints__c.getAll();  
        if(endpoints.containsKey(ENDPOINT_KEY)){
            ENDPOINT = endpoints.get(ENDPOINT_KEY).Endpoint_URL__c;
            
        }
    }
}