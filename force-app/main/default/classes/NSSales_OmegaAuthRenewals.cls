/*======================================================================================================
* @Class Name : NSSales_OmegaAuthRenewals
* @author : Accenture
* @Purpose: This class is used to fetch Auth Renewals data and sending it to server side controller 
*           which invokes it based on the appropiate UI event.
* @created date: 04-12-2019
* @Change Logs:                                 
----------------------------------------------------------------------------------------------------------
Developer name        Date          Description        
----------------------------------------------------------------------------------------------------------
@Debosmeeta paul      04-12-2019    Created the class for recieving & pardon Auth renewal response
==========================================================================================================*/
public class NSSales_OmegaAuthRenewals implements NS_WebService {
    /*Table Column*/
    public Static Final String C_1 = 'LANE(s)';
    public static Final String C_2 = 'AUTH#';
    public static Final String C_3 = 'CUST';
    public static Final String C_4 = 'MANAGER';
    public static Final String C_5 = 'VOLUME';
    public static Final String C_6 = 'REVENUE';   
    public static Final String C_7 = 'CONTR.';
    public static Final String C_8 = 'EXP DATE';
    public static Final String C_9 = '#SECTIONS';
    public Static Final String C_10 = '#LANES';
    public Static Final String C_11 = 'EFFECTIVE DATE';
    public Static Final String C_12 = 'LANE ID';
    /*Class Name*/
    private static final String CLASS_NAME = 'NSSales_OmegaAuthRenewals';
    /*Method Name for Exception Handling*/ 
    private static final String METHOD_NAME1='invokeCallout';
    private static final String errmsgWsCall = 'Something went wrong. Try refreshing the page again and if this happens again please contact admin with the following message: ';
    public static Map<String,String> userNameList=new Map<String,String>();
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
            accessToken = auth1.ReturnAccessToken (auth1);
            System.debug('Access Token' +accessToken);
            if(accessToken != null){
                String endPoint = finalEndpoint+'?size=20&beneficialOwnerNumber.equals='+ datum.getprimaryCust()+'&sort=quoteNumber,asc';
                system.debug('SRV ENDPT '+endPoint);
                Http h2 = new Http();
                HttpRequest req1 = new HttpRequest();
                //req1.setHeader('Authorization','Bearer ' + accessToken);
                req1.setHeader('Authorization', accessToken);
                req1.setHeader('Content-Type','application/json');
                req1.setMethod('GET');
                req1.setEndpoint(endPoint);
                HttpResponse res1 = h2.send(req1);
                //  system.debug('Omega Auth RenewalBody' + res1.getBody());
                response= responseParser('{"result":'+res1.getBody()+'}');
            }
            
            // String endpoint=NS_IntegrationUtility_WorkBench.ENDPOINT+ EXT + datum.getGoodSpell();
            //  System.debug('EP:'+endpoint);
            // HttpResponse hres = NS_WSCallout.sendRequestRest(endpoint, NS_IntegrationUtility_WorkBench.GET, NS_IntegrationUtility_WorkBench.CONTENTTYPE, null); 
            // response= responseParser(hres.getBody());
        }catch(Exception exp) {
            system.debug('SRV DEVA '+exp.getLineNumber()+' $ '+exp);
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
        for(User usr : [Select FederationIdentifier,Name from User]){
            userNameList.put(usr.FederationIdentifier, usr.Name);       
        }
        System.debug('rawResponse--------'+rawResponse);
        
        String processedResponse=null;
        try{ 
            NSSales_OmegaAuthRenewalWrapper wrapperList = NSSales_OmegaAuthRenewalWrapper.parse(rawResponse);
            System.debug('wrapperList--------'+wrapperList);
            JSONGenerator gen = JSON.createGenerator(true);    
            //NSSales_OmegaAuthRenewalWrapper wrapperList = NSSales_OmegaAuthRenewalWrapper.parse(rawResponse);
            gen.writeStartObject();     
            gen.writeFieldName(NSSales_ParsingConstants.ROWS);
            gen.writeStartArray();
            for(NSSales_OmegaAuthRenewalWrapper.result objt : wrapperList.result){
                Decimal totalVolume = Decimal.valueof(objt.loadedVolume) +Decimal.valueof(objt.emptyVolume);
                String strtotalVolume =String.valueOf(totalVolume).substringBefore('.');
                system.debug('strtotalVolume'+strtotalVolume);
                Decimal totalRevenue = Decimal.valueof(objt.loadedRevenue) +Decimal.valueof(objt.emptyRevenue);
                String strtotalRevenue =String.valueOf(totalRevenue).substringBefore('.');
                system.debug('strtotalRevenue'+strtotalRevenue);
                Decimal totalContribution = Decimal.valueof(objt.loadedContribution) +Decimal.valueof(objt.emptyContribution);
                String strtotalContribution =String.valueOf(totalContribution).substringBefore('.');
                system.debug('totalContribution'+strtotalContribution);
                gen.writeStartObject();
                gen.writeFieldName(NSSales_ParsingConstants.VALS);
                gen.writeStartArray();
                gen.writeStartObject();
                gen.writeStringField(NSSales_ParsingConstants.VAL, objt.id != null ? objt.id : NSSales_ParsingConstants.BlANK);
                gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.H_FIELDS);
                gen.writeEndObject();
                gen.writeStartObject();
                gen.writeStringField(NSSales_ParsingConstants.VAL, objt.quoteNumber != null ? objt.quoteNumber : NSSales_ParsingConstants.BlANK);
                gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
                gen.writeEndObject();
                gen.writeStartObject();
                gen.writeObjectField(NSSales_ParsingConstants.VAL, objt.beneficialOwner!=null ?objt.beneficialOwner : NSSales_ParsingConstants.BlANK);
                gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
                gen.writeEndObject();
                gen.writeStartObject(); 
                gen.writeStringField(NSSales_ParsingConstants.VAL, userNameList.get(objt.pricingOfficerId) != null ?  userNameList.get(objt.pricingOfficerId) : objt.pricingOfficerId);
                gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
                gen.writeEndObject();
                gen.writeStartObject();
                gen.writeStringField(NSSales_ParsingConstants.VAL,  strtotalVolume!= null ? strtotalVolume : NSSales_ParsingConstants.BlANK);
                gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
                gen.writeEndObject();
                gen.writeStartObject();
                gen.writeStringField(NSSales_ParsingConstants.VAL,  strtotalRevenue!= null ? strtotalRevenue : NSSales_ParsingConstants.BlANK);
                gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
                gen.writeEndObject();
                gen.writeStartObject();
                gen.writeStringField(NSSales_ParsingConstants.VAL,  strtotalContribution!= null ? strtotalContribution : NSSales_ParsingConstants.BlANK);
                gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
                gen.writeEndObject();
                gen.writeStartObject();
                gen.writeStringField(NSSales_ParsingConstants.VAL, objt.expirationDate != null ? objt.expirationDate.substring(0,10) : NSSales_ParsingConstants.BlANK);
                gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
                gen.writeEndObject();
                gen.writeStartObject();
                gen.writeStringField(NSSales_ParsingConstants.VAL, objt.section != null ? objt.section : NSSales_ParsingConstants.BlANK);
                gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
                gen.writeEndObject();
                gen.writeStartObject();
                gen.writeStringField(NSSales_ParsingConstants.VAL, objt.numLanes != null ? objt.numLanes : NSSales_ParsingConstants.BlANK);
                gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
                gen.writeEndObject();
                gen.writeStartObject();
                gen.writeStringField(NSSales_ParsingConstants.VAL, objt.effectiveDate != null ? objt.effectiveDate.substring(0,10) : NSSales_ParsingConstants.BlANK);
                gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
                gen.writeEndObject(); 
                gen.writeStartObject();
                gen.writeStringField(NSSales_ParsingConstants.VAL, objt.id != null ? objt.id : NSSales_ParsingConstants.BlANK);
                gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.H_FIELDS);
                gen.writeEndObject();
                gen.writeEndArray();
                gen.writeEndObject();
            }        
            gen.writeEndArray();  
            gen.writeFieldName(NSSales_ParsingConstants.HEADER);
            gen.writeStartArray();
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
            gen.writeStringField(NSSales_ParsingConstants.TITLE, C_10);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.TITLE, C_11);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.BlANK);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField(NSSales_ParsingConstants.TITLE, C_12);
            gen.writeStringField(NSSales_ParsingConstants.CSS_CLASS, NSSales_ParsingConstants.H_FIELDS);
            gen.writeEndObject();
            gen.writeEndArray();
            gen.writeEndObject();
            processedResponse = gen.getAsString();

        }catch(Exception Excp){
            system.debug('DEVA XXX '+Excp.getLineNumber()+' @ '+Excp.getMessage());
        }
        return processedResponse;
    }
}