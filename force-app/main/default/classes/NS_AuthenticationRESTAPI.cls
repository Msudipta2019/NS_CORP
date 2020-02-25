public class NS_AuthenticationRESTAPI {
    
   public final String clientId = System.Label.NS_Omega_ClientID;
   public final String clientSecret = System.Label.NS_Omega_Client_Secret;
   public final String username = System.Label.NS_Omega_Username;
   public final String password = System.Label.NS_Omega_Password;
    public final Static String ENDPOINT_VALUE = 'Omega Authentication';
    public final Static String ENDPOINT;
    
    static {
        Map<String,NS_Integration_Endpoints__c> endpoints = NS_Integration_Endpoints__c.getAll();  
        if(endpoints.containsKey(ENDPOINT_VALUE)){
            ENDPOINT = endpoints.get(ENDPOINT_VALUE).Endpoint_URL__c;
            
        }
    }
    
  public class deserializeResponse
   {
      
       public String access_token;
       public String token_type;
       public String refresh_token;
       public String expires_in;
       public String scope;
   }
    
  public String ReturnAccessToken (NS_AuthenticationRESTAPI auth)
   {
      String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
     Http h = new Http();
      HttpRequest req = new HttpRequest();
      req.setBody(reqbody);
      req.setMethod('POST');
      req.setEndpoint(ENDPOINT);
      HttpResponse res = h.send(req);
     deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(res.getbody(),deserializeResponse.class);
     system.debug('@@@@access_token@@'+resp1 );
      return resp1.access_token;
   }

}