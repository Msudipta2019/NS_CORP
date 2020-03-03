/*======================================================================================================
* @Class Name : NSSales_RateRequest
* @author : Accenture
* @Purpose: This class is used to fetch rate request data and sending it to server side controller 
*           which invokes it based on the appropiate UI event.
* @created date: 20-06-2019
* @Change Logs:                                 
----------------------------------------------------------------------------------------------------------
Developer name        Date          Description        
----------------------------------------------------------------------------------------------------------
@PranayBanerjee		  11-06-2019    Created the class.
@Arjun Ghosh		  24-06-2019    Added documentation & removed hardcoding issues.
==========================================================================================================*/
public class NSSales_RateRequest implements NS_WebService{
    
    /*Table Column*/
    public Static Final String C_1 = 'LANE';
    /*Table Column*/
    public static Final String C_2 = 'REQ NUM';
    /*Table Column*/
    public static Final String C_3 = 'CUST NAME';
    /*Table Column*/
    public static Final String C_4 = 'TYPE';
    /*Table Column*/
    public static Final String C_5 = 'STATUS';
    /*Table Column*/
    public static Final String C_6 = 'CREATED DATE';   
    /*Table Column*/
    public static Final String C_7 = 'PRICED DATE';
    /*Table Column*/
    public static Final String C_8 = 'REQUEST ID';
    /*Table Column*/
    public static Final String C_9 = '+ OPTY';
    /* Endpoint Extension */
    public Static Final String EXT = '/requests?good-spell=' ;
    
    /*Class Name*/
    private static final String CLASS_NAME = 'NSSales_RateRequest';
    /*Method Name for Exception Handling*/ 
    private static final String METHOD_NAME1='invokeCallout';
    /*
@Desc: invokes the actual callout method
@Signature: Object of NS_IntegParams
@Returns: Json as a string
*/
    public static string invokeCallout(NS_IntegParams datum){   
        String response=null;
        try{
            String endpoint=NS_IntegrationUtility_WorkBench.ENDPOINT+EXT + datum.getGoodSpell();
            HttpResponse hres = NS_WSCallout.sendRequestRest(endpoint, NS_IntegrationUtility_WorkBench.GET, NS_IntegrationUtility_WorkBench.CONTENTTYPE, null); 
            response= responseParser(hres.getBody());
        }catch(Exception exp) {
            NS_ExceptionUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME1);
            throw new AuraHandledException('Something went wrong with Rate request. Try refreshing the page again and if this happens again please contact admin with the following message: '+ exp.getMessage());   
        }
        return response;    
    }
    /*
@Desc: Parses the response 
@Signature: String(Json Response)
@Returns: Json as a string
*/
    private static String responseParser(String rawResponse){
        NSSales_ResponseRateRequestWrapper wrapperList = (NSSales_ResponseRateRequestWrapper)JSON.deserialize(rawResponse,NSSales_ResponseRateRequestWrapper.class);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();     
        gen.writeFieldName(NSSales_ParsingConstants.ROWS);
        gen.writeStartArray();
        system.debug(wrapperList.result.size()); 
        for(NSSales_ResponseRateRequestWrapper.result objt : wrapperList.result){
            gen.writeStartObject();
            gen.writeFieldName(NSSales_ParsingConstants.VALS);
            gen.writeStartArray();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.VAL, objt.requestNumber != null ? objt.requestNumber : NSSales_ParsingConstants.BlANK);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.VAL, objt.customerName != null ? objt.customerName : NSSales_ParsingConstants.BlANK);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeObjectField(NSSales_ParsingConstants.VAL, String.valueOf(objt.customerType)!=null ?objt.customerType : NSSales_ParsingConstants.BlANK);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.VAL, objt.requestStatus != null ? objt.requestStatus : NSSales_ParsingConstants.BlANK);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.VAL, objt.createdDate != null ? objt.createdDate.substring(0,10) : NSSales_ParsingConstants.BlANK);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.VAL, String.valueOf(objt.pricedDate)!=null ?objt.pricedDate.substring(0,10) : NSSales_ParsingConstants.BlANK);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.VAL, objt.requestId != null ? objt.requestId : NSSales_ParsingConstants.BlANK);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.H_FIELDS);
            gen.writeEndObject();
            gen.writeEndArray();
            gen.writeEndObject();
            
        }
        
        gen.writeEndArray();  
        gen.writeFieldName(NSSales_ParsingConstants.HEADER);
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField(NSSales_ParsingConstants.TITLE, C_1);
        
        gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        
        gen.writeStartObject();
        gen.writeStringField(NSSales_ParsingConstants.TITLE, C_2);
        
        gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField(NSSales_ParsingConstants.TITLE, C_3);
        
        gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField(NSSales_ParsingConstants.TITLE, C_4);
        
        gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField(NSSales_ParsingConstants.TITLE, C_5);
        
        gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField(NSSales_ParsingConstants.TITLE, C_6);
        
        gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField(NSSales_ParsingConstants.TITLE, C_7);
        
        gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField(NSSales_ParsingConstants.TITLE, C_8);
        
        gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.H_FIELDS);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField(NSSales_ParsingConstants.TITLE, C_9);
        
        gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();        
        gen.writeEndArray();
        gen.writeEndObject();        
        String processedResponse = gen.getAsString();
        
        return processedResponse; 
    }
    
}