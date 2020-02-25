public class NS_LastMoves implements NS_WebService{
    public final Static String ENDPOINT_KEY = 'LastMoves';
    public final Static String ENDPOINT1;
    static {
        Map<String,NS_Integration_Endpoints__c> endpoints = NS_Integration_Endpoints__c.getAll();  
        if(endpoints.containsKey(ENDPOINT_KEY)){
            ENDPOINT1 = endpoints.get(ENDPOINT_KEY).Endpoint_URL__c;
            
        }
    }
    public static string invokeCallout(NS_IntegParams datum){ 
        String endPoint;
        String response=null;
        String method = 'POST';
        String body = '{"EquipmentEventCode": [{"eventCodes":[]}]}';
        //11.2, jlong change start, replace all numeric to get initial; replace non-num to get equipment#
        String ipEquipStr = datum.getequipmentID();
		String equipNum = ipEquipStr.replaceAll(' ', '').replaceAll('[^\\d]','').trim().leftPad(10, '0');
		String equipInit = ipEquipStr.replaceAll(' ', '').replaceAll('[\\d]','').trim();
        
        try{
            endpoint=ENDPOINT1+equipInit+'&enumber='+equipNum+'&sort=desc&mvnumber=10'; 
            HttpResponse hres = NS_WSCallout.sendRequestRest(endpoint,method, NS_IntegrationUtility_WorkBench.CONTENTTYPE, body); 
            System.debug('response' +hres.getBody());
            response= responseParser(hres.getBody());
        }catch(Exception exp) {
            //NS_ExceptionUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME1);
            throw new AuraHandledException('Something went wrong with Rate request. Try refreshing the page again and if this happens again please contact admin with the following message: '+ exp.getMessage());   
        }
        System.debug('response----'+response);
        return response;  
        
    }
    
    private static String responseParser(String rawResponse){
        System.debug('Raw' +rawResponse);
        NS_LastMovesWrapper wrapperList = (NS_LastMovesWrapper)JSON.deserialize(rawResponse,NS_LastMovesWrapper.class);
        System.debug('wrapperList------'+wrapperList);
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();     
        gen.writeFieldName('rows');
        gen.writeStartArray();
        //  system.debug(wrapperList.result.size()); 
        for(NS_LastMovesWrapper.moveEventHistory obj : wrapperList.moveDetail.moveEventHistory){
            
            String trnDay  = obj.TrainOriginDate!=null?obj.TrainOriginDate.substring(8,10) : '';
            String trnNum = obj.TrainNumber !=null?obj.TrainNumber : '';
            String trnLine = obj.TrainLineSegment !=null?obj.TrainLineSegment : '';
            gen.writeStartObject();
            gen.writeFieldName('vals1');
            gen.writeStartArray();
            //for(integer i = 0; i < wrapperList.result.size(); i++){
            gen.writeStartObject();
            gen.writeStringField('val1', obj.EventCode != null ? obj.EventCode : '');
            gen.writeStringField('cssClass1', '');
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField('val1', obj.city != null ? obj.city : '');
            gen.writeStringField('cssClass1', '');
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeObjectField('val1', trnNum+trnLine+trnDay);
            gen.writeStringField('cssClass1', '');
            gen.writeEndObject();
            gen.writeStartObject();
         	//gen.writeStringField('val1', obj.EventDateTime != null ? obj.EventDateTime : '');
            //gen.writeStringField('val1', obj.EventDateTime != null ? dtConverted : '');
            gen.writeStringField('val1', obj.EventDateTime != null ? Datetime.valueOf(obj.EventDateTime.replaceAll('T', ' ')).format() : '');
            gen.writeStringField('cssClass1', '');
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField('val1', obj.EventLocationRoad != null ? obj.EventLocationRoad : '');
            gen.writeStringField('cssClass1', '');
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField('val1', obj.LoadedEmptyIndicator !=null ?obj.LoadedEmptyIndicator : '');
            gen.writeStringField('cssClass1', '');
            gen.writeEndObject();
            //}
            gen.writeEndArray();
            gen.writeEndObject();
            
            // }
        }
        
        gen.writeEndArray();  
        gen.writeFieldName('headers');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('title1', 'Event');
        gen.writeBooleanField('isSortable', true);
        gen.writeStringField('dataType', '');
        gen.writeStringField('cssClass1', '');
        gen.writeEndObject();
        
        gen.writeStartObject();
        gen.writeStringField('title1', 'Location');
        gen.writeBooleanField('isSortable', true);
        gen.writeStringField('dataType', '');
        gen.writeStringField('cssClass1', '');
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('title1', 'Train');
        gen.writeBooleanField('isSortable', false);
        gen.writeStringField('dataType', '');
        gen.writeStringField('cssClass1', '');
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('title1', 'Event Date/Time');
        gen.writeBooleanField('isSortable', false);
        gen.writeStringField('dataType', '');
        gen.writeStringField('cssClass1', '');
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('title1', 'OpRd');
        gen.writeBooleanField('isSortable', false);
        gen.writeStringField('dataType', '');
        gen.writeStringField('cssClass1', '');
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('title1', 'Load/Empty');
        gen.writeBooleanField('isSortable', false);
        gen.writeStringField('dataType', '');
        gen.writeStringField('cssClass1', '');
        gen.writeEndObject();
        
        
        gen.writeEndArray();
        gen.writeEndObject();
        
        String processedResponse = gen.getAsString();
        System.debug('processedResponse---'+processedResponse);
        return processedResponse; 
        
    }
    
}