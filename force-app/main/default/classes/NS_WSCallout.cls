public class NS_WSCallout {
    
    /*Http request CONTENT_TYPE_CONST*/
    public final Static String CONTENT_TYPE_CONST = 'Content-Type';
    /*Http request SOAPAction*/
    public final static String SOAP_ACTION = 'SOAPAction';
	public final static String WSCLIENTCERT = System.Label.NS_IntegrationCertName;
    
    /* ================================================
* @Method Name : sendRequest
* @author id: arjun.c.ghosh@accenture.com
* @Purpose: This method is used to make webservice SOAP callout and can be used across all interfaces 
* @Parameters: String Endpoint, String Method, String contentType, String action, String body
* @return: String
* @created date: 07-02-2019
==================================================*/
    public Static String sendRequest(String endpoint, String method, String contentType, String action, String body){
        HttpRequest hreq = new HttpRequest();
        hreq.setEndpoint(endpoint);
        hreq.setMethod(method);
        hreq.setHeader(CONTENT_TYPE_CONST, contentType);
        hreq.setHeader(SOAP_ACTION, action);
        hreq.setBody(body);
        System.debug('Request Body:'+body);
        Http http = new Http();
        HTTPResponse hres = http.send(hreq);
        System.debug('Response from NS_WSCallout>>>>'+hres.getbody());
        return hres.getbody();
    }
    
    public Static HTTPResponse sendRequestRest(String endpoint, String method, String contentType, String body){
        HttpRequest hreq = new HttpRequest();
        hreq.setTimeout(40000);
        hreq.setEndpoint(endpoint);
        hreq.setMethod(method);
        hreq.setHeader(CONTENT_TYPE_CONST, contentType);
        hreq.setClientCertificateName(WSCLIENTCERT);
        if(body!=null){
            hreq.setBody(body);
        }
        Http http = new Http();
        HTTPResponse hres = http.send(hreq);
        System.debug('Hres:'+hres.getBody());
        return hres;
    }
    
}