/*======================================================================================================
* @Class Name : NSSales_AuthRenewals
* @author : Accenture
* @Purpose: This class is used to fetch rate request data and sending it to server side controller 
*           which invokes it based on the appropiate UI event.
* @created date: 22-03-2019
* @Change Logs:                                 
----------------------------------------------------------------------------------------------------------
Developer name        Date          Description        
----------------------------------------------------------------------------------------------------------
@Arjun Ghosh       	  22-03-2019    Phase-II: Created the class for recieving & pardon Auth renewal response
==========================================================================================================*/

public class NSSales_AuthRenewals implements NS_WebService{
    /*Table Column*/
    public Static Final String C_0 = 'LANE(S)';
    /*Table Column*/
    public Static Final String C_1 = 'AUTH #';
    /*Table Column*/
    public static Final String C_2 = 'CUST';
    /*Table Column*/
    public static Final String C_3 = 'MANAGER';
    /*Table Column*/
    public static Final String C_4 = 'VOLUME';
    /*Table Column*/
    public static Final String C_5 = 'REVENUE';
    /*Table Column*/
    public static Final String C_6 = 'CONTR.';   
    /*Table Column*/
    public static Final String C_7 = 'EXP DATE';
    /*Table Column*/
    public static Final String C_8 = '#SECTIONS';
    /*Table Column*/
    public static Final String C_9 = '#LANES';
    /*Table Column*/
    public Static Final String C_10 = '+ OPTY';
    /*Table Column*/
    public Static Final String C_11 = 'EFFECTIVE DATE';
    /*Custom message 1*/  
    public Static Final String C_MSG1 = 'No response from Workbench';
    /* Endpoint Extension */
    public Static Final String EXT = '/renewals?good-spell=' ;
    /*Class Name*/
    private static final String CLASS_NAME = 'NSSales_AuthRenewals';
    /*Method Name for Exception Handling*/ 
    private static final String METHOD_NAME1='invokeCallout';
    
    private static final String errmsgWsCall = 'Something went wrong. Try refreshing the page again and if this happens again please contact admin with the following message: ';
    /*
	@Desc: invokes the actual callout method
	@Signature: Object of NS_IntegParams
	@Returns: Json as a string
	*/
    public string invokeCallout(NS_IntegParams datum){
        String response=null;
        try{
        String endpoint=NS_IntegrationUtility_WorkBench.ENDPOINT+ EXT + datum.getGoodSpell();
        System.debug('EP:'+endpoint);
        HttpResponse hres = NS_WSCallout.sendRequestRest(endpoint, NS_IntegrationUtility_WorkBench.GET, NS_IntegrationUtility_WorkBench.CONTENTTYPE, null); 
        response= responseParser(hres.getBody());
            System.debug('hres.getBody()'+hres.getBody());
        }catch(Exception exp) {
            NS_ExceptionUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME1);
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
        JSONGenerator gen = JSON.createGenerator(true);         
        NSSales_AuthRenewalWrapper wrapper=NSSales_AuthRenewalWrapper.parse(rawResponse);
        gen.writeStartObject();     
        gen.writeFieldName(NSSales_ParsingConstants.ROWS);
        gen.writeStartArray();
        for(NSSales_AuthRenewalWrapper.result objt : wrapper.result){
            gen.writeStartObject();
            gen.writeFieldName(NSSales_ParsingConstants.VALS);
            gen.writeStartArray();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.VAL, String.valueOf(objt.bureau)+' '+ String.valueOf(objt.authNum) != null ?String.valueOf(objt.bureau)+' '+String.valueOf(objt.authNum): NSSales_ParsingConstants.BlANK );
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.VAL, objt.custGrpName != null ? objt.custGrpName : NSSales_ParsingConstants.BlANK);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeObjectField(NSSales_ParsingConstants.VAL, String.valueOf(objt.officerName)!=null ?String.valueOf(objt.officerName) : NSSales_ParsingConstants.BlANK);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.VAL,  String.valueOf(objt.carloads)!= null ? String.valueOf(objt.carloads) : NSSales_ParsingConstants.BlANK);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.VAL,  objt.nsRevenue!= null ? objt.nsRevenue : NSSales_ParsingConstants.BlANK);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.VAL,  objt.contribution!= null ? objt.contribution : NSSales_ParsingConstants.BlANK);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.VAL,  objt.expDate!= null ? objt.expDate : NSSales_ParsingConstants.BlANK);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.VAL,  String.valueOf(objt.sections)!= null ? String.valueOf(objt.sections) : NSSales_ParsingConstants.BlANK);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.VAL,  String.valueOf(objt.laneCount)!= null ? String.valueOf(objt.laneCount) : NSSales_ParsingConstants.BlANK);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.VAL,  String.valueOf(objt.minEffDate)!= null ? String.valueOf(objt.minEffDate) : NSSales_ParsingConstants.BlANK);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeEndArray();
            gen.writeEndObject();
        }        
        gen.writeEndArray();  
        gen.writeFieldName(NSSales_ParsingConstants.HEADER);
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField(NSSales_ParsingConstants.TITLE,C_0);           
        gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField(NSSales_ParsingConstants.TITLE,C_1);           
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
        gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField(NSSales_ParsingConstants.TITLE, C_9);
        gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField(NSSales_ParsingConstants.TITLE, C_11);
        gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField(NSSales_ParsingConstants.TITLE, C_10);
        gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeEndObject();
        processedResponse = gen.getAsString();
        return processedResponse;
    }

}