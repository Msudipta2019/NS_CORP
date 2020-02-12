/*======================================================================================================
* @Class Name : NSSales_CS
* @author : Accenture
* @Purpose: This class is used to fetch customer statistics info and sending it to server side controller 
*           which invokes it based on the appropiate UI event.
* @created date: 20-06-2019
* @Change Logs:                                 
----------------------------------------------------------------------------------------------------------
Developer name        Date          Description        
----------------------------------------------------------------------------------------------------------
@Arjun Ghosh		  03-06-2019    Created the class.
@Arjun Ghosh		  24-06-2019    Added documentation,Exception Handling & removed hardcoding issues.
==========================================================================================================*/
public with sharing class NSSales_CS implements NS_WebService{
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
            String endpoint=NS_IntegrationUtility_WorkBench.ENDPOINT+EXT + datum.getGoodSpell();
            hres = NS_WSCallout.sendRequestRest(endpoint, NS_IntegrationUtility_WorkBench.GET, NS_IntegrationUtility_WorkBench.CONTENTTYPE, null); 
       		response=hres.getBody();
        } catch(Exception exp) {
            NS_ExceptionUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME1);
            throw new AuraHandledException('Something went wrong. Try refreshing the page again and if this happens again please contact admin with the following message: '+ exp.getMessage());   
           
        }
        
        return response;
    }    
}