public with sharing class NSSales_CS_IM implements NS_WebService{
    
     /* Endpoint Extension */
    public Static Final String EXT = '/statistics?good-spell=' ;
    /*Class Name*/
    private static final String CLASS_NAME = 'NSSales_CS';
    /*Method Name for Exception Handling*/ 
    private static final String METHOD_NAME1='invokeCallout';
  
    public string invokeCallout(NS_IntegParams datum){
        String response=null;
        HttpResponse hres;
        try{
            String endpoint=NS_IntegrationUtility_WorkBench.ENDPOINT+EXT + datum.getGoodSpell()+'&ns-business-group=im';
            System.Debug('EndPoint' +endpoint);
            hres = NS_WSCallout.sendRequestRest(endpoint, NS_IntegrationUtility_WorkBench.GET, NS_IntegrationUtility_WorkBench.CONTENTTYPE, null); 
       		response=hres.getBody();
        } catch(Exception exp) {
            NS_ExceptionUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME1);
            throw new AuraHandledException('Something went wrong. Try refreshing the page again and if this happens again please contact admin with the following message: '+ exp.getMessage());   
           
        }
        System.debug('Response' +response);
        return response;
    } 

}