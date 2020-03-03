/*======================================================================================================
* @Class Name : NSSales_RenewalLane
* @author : Accenture
* @Purpose: This class is used to fetch Renewal Lane data and sending it to server side controller 
*           which invokes it based on the appropiate UI event.
* @created date: 06-12-2019
* @Change Logs:                                 
----------------------------------------------------------------------------------------------------------
Developer name        Date          Description        
----------------------------------------------------------------------------------------------------------
@Debosmeeta paul      06-12-2019    Created the class for recieving & pardon Renewal Lane response
==========================================================================================================*/
public class NSSales_RenewalLane implements NS_WebService {
	 /*Table Column*/
    public Static Final String C_1 = 'STCC';
    /*Table Column*/
    public static Final String C_2 = 'O RD';
    /*Table Column*/
    public static Final String C_3 = 'O CITY';
    /*Table Column*/
    public static Final String C_4 = 'O ST';
    /*Table Column*/
    public static Final String C_5 = 'D RD';
    /*Table Column*/
    public static Final String C_6 = 'D CITY';   
    /*Table Column*/
    public static Final String C_7 = 'D ST';
    /*Table Column*/
    public static Final String C_8 = 'RATE';
    /*Table Column*/
    public static Final String C_9 = 'VOLUME';
    /*Table Column*/
    public static Final String C_10 = 'EQPT';
    /*Class Name*/
    private static final String CLASS_NAME = 'NSSales_RenewalLane';
    /*Method Name for Exception Handling*/ 
    private static final String METHOD_NAME1='invokeCallout';
    private static final String errmsgWsCall = 'Something went wrong. Try refreshing the page again and if this happens again please contact admin with the following message: ';
    public Final Static String ENDPOINT_VALUE = 'OmegaAuthRenewals';
    public Static String finalEndpoint;
    static {
        Map<String,NS_Integration_Endpoints__c> endpoints = NS_Integration_Endpoints__c.getAll();  
        if(endpoints.containsKey(ENDPOINT_VALUE)){
            finalEndpoint = endpoints.get(ENDPOINT_VALUE).Endpoint_URL__c;
        }
      }
    
    /*
	@Desc: invokes the actual callout method
	@Signature: Object of NS_IntegParams
	@Returns: Json as a string
	*/
    
    public string invokeCallout(NS_IntegParams datum){
        String response=null;
        try{
            NS_AuthenticationRESTAPI auth1 = new NS_AuthenticationRESTAPI();
            String accessToken;
            system.debug('SRV auth1'+auth1);
            accessToken = auth1.ReturnAccessToken (auth1);
            System.debug('Access Token' +accessToken);
            if(accessToken != null){
                 String endPoint = finalEndpoint+'/'+datum.getrenewalId()+'/lanes';
            Http h2 = new Http();
           HttpRequest req1 = new HttpRequest();
           req1.setHeader('Authorization', accessToken);
           req1.setHeader('Content-Type','application/json');
           req1.setMethod('GET');
           req1.setEndpoint(endPoint);
           HttpResponse res1 = h2.send(req1);
                system.debug('Omega Auth Renewal Lane endPoint' + endPoint);
           system.debug('Omega Auth Renewal Lane Body' + res1.getBody());
           response= responseParser('{"result":'+res1.getBody()+'}');
            }
       // String endpoint=NS_IntegrationUtility_WorkBench.ENDPOINT+ EXT + datum.getGoodSpell();
      //  System.debug('EP:'+endpoint);
       // HttpResponse hres = NS_WSCallout.sendRequestRest(endpoint, NS_IntegrationUtility_WorkBench.GET, NS_IntegrationUtility_WorkBench.CONTENTTYPE, null); 
       // response= responseParser(hres.getBody());
            }catch(Exception exp) {
            NS_ExceptionUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME1);
                system.debug('SRV EX '+exp.getLineNumber()+' : '+exp.getMessage());
                 system.debug('SRV EXCP '+exp);
            throw new AuraHandledException(errmsgWsCall + exp.getMessage());              
        }
      
        return response;
    } 
    /*
	@Desc: Parses the response 
	@Signature: String(Json Response)
	@Returns: Json as a string
	*/
    private String responseParser(String rawResponse){
        String processedResponse=null;
        List<String> args = new String[]{'0','number','###,###,##0.00'};

        JSONGenerator gen = JSON.createGenerator(true);    
        system.debug('Omega Auth Renewal Lane rawResponse' + rawResponse);
        NSSales_RenewalLaneWrapper wrapperList = NSSales_RenewalLaneWrapper.parse(rawResponse);
        gen.writeStartObject();     
        gen.writeFieldName(NSSales_ParsingConstants.ROWS);
        gen.writeStartArray();
        for(NSSales_RenewalLaneWrapper.result objt : wrapperList.result){
            Decimal totalRate = Decimal.valueof(objt.loadedRate) +Decimal.valueof(objt.emptyRate);
            String strRate =String.format(totalRate.format(), args);
            String strtotalRate ='$'+String.valueOf(strRate).substringBefore('.');
            system.debug('totalRate'+totalRate);
            gen.writeStartObject();
            gen.writeFieldName('vals1');
            gen.writeStartArray();
            gen.writeStartObject();
            gen.writeStringField('val1', objt.commodityCode != null ? objt.commodityCode : NSSales_ParsingConstants.BlANK);
            gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeObjectField('val1', objt.originRoad!=null ?objt.originRoad : NSSales_ParsingConstants.BlANK);
            gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject(); 
            gen.writeStringField('val1', objt.originCity != null ?  objt.originCity : NSSales_ParsingConstants.BlANK);
            gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField('val1',  objt.originState!= null ? objt.originState : NSSales_ParsingConstants.BlANK);
            gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField('val1',  objt.destRoad!= null ? objt.destRoad : NSSales_ParsingConstants.BlANK);
            gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField('val1',  objt.destCity!= null ? objt.destCity : NSSales_ParsingConstants.BlANK);
            gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField('val1', objt.destState != null ? objt.destState : NSSales_ParsingConstants.BlANK);
            gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField('val1', strtotalRate != null ? strtotalRate : NSSales_ParsingConstants.BlANK);
            gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField('val1', objt.volume != null ? objt.volume : NSSales_ParsingConstants.BlANK);
            gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField('val1', objt.equipment != null ? objt.equipment : NSSales_ParsingConstants.BlANK);
            gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeEndArray();
            gen.writeEndObject();
        }        
        gen.writeEndArray();  
        gen.writeFieldName(NSSales_ParsingConstants.HEADER);
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('title1',C_1);           
        gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('title1', C_2);         
        gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('title1', C_3);
        gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('title1', C_4);
        gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('title1', C_5);
        gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('title1', C_6);
        gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('title1', C_7);
        gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('title1', C_8);
        gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('title1', C_9);
        gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('title1', C_10);
        gen.writeStringField('cssClass1', NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeEndObject();
        processedResponse = gen.getAsString();
        return processedResponse;
    }
}