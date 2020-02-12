public class NSSales_WonLaneInfo implements NS_WebService{
    public static string invokeCallout(NS_IntegParams datum){        
        String endpoint=NS_IntegrationUtility_WorkBench.ENDPOINT+'/request/lanes?wb-request-id=' + datum.getwonLaneReqID();              
        System.debug('Endpoint for Won Lane Request:'+endpoint);
        HttpResponse hres = NS_WSCallout.sendRequestRest(endpoint, NS_IntegrationUtility_WorkBench.GET, NS_IntegrationUtility_WorkBench.CONTENTTYPE, null); 
        System.debug('RAw Lane Details' +hres.getBody());
        return responseParser(hres.getBody());
    }
    private static String responseParser(String rawResponse){
        system.debug('RawResponse' +rawResponse);
        NSSales_WonLaneInfoWrapper wrapperList = (NSSales_WonLaneInfoWrapper)JSON.deserialize(rawResponse,NSSales_WonLaneInfoWrapper.class);
        system.debug('WrapperList' +wrapperList.result[0].requestId);
     
        JSONGenerator gen = JSON.createGenerator(true);
    //rows
     gen.writeStartObject();     
     gen.writeFieldName('rows');
     gen.writeStartArray();
      system.debug(wrapperList.result.size()); 
     for(NSSales_WonLaneInfoWrapper.result objt : wrapperList.result){
         gen.writeStartObject();
         gen.writeFieldName('vals1');
         gen.writeStartArray();
         //for(integer i = 0; i < wrapperList.result.size(); i++){
         gen.writeStartObject();
         gen.writeStringField('val1', objt.laneId != null ? objt.laneId : '');
         gen.writeStringField('cssClass1', NSSales_ParsingConstants.H_FIELDS);
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('val1', objt.stcc != null ? objt.stcc : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('val1', objt.shipper != null ? objt.shipper : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeObjectField('val1', objt.originRoad !=null ?objt.originRoad : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('val1', objt.originCity != null ? objt.originCity : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('val1', objt.originState != null ? objt.originState : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('val1', objt.originHandlingLine !=null ?objt.originHandlingLine : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('val1', objt.receiver != null ? objt.receiver : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('val1', objt.destinRoad != null ? objt.destinRoad : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('val1', objt.destinCity != null ? objt.destinCity : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('val1', objt.destinState != null ? objt.destinState : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('val1', objt.destinHandlingLine != null ? objt.destinHandlingLine : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('val1', objt.route != null ? objt.route : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('val1', objt.carOwnership != null ? objt.carOwnership : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('val1', objt.lading != null ? objt.lading : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('val1', objt.basis != null ? objt.basis : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('val1', objt.estVolume != null ? objt.estVolume : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('val1', objt.rate != null ? objt.rate : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject(); 
         gen.writeStartObject();
         //gen.writeStringField('val1', String.valueOf(objt.initialOffer) != null ? String.valueOf(objt.initialOffer) : '');
         gen.writeStringField('val1', objt.initialOffer != null ? objt.initialOffer : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject(); 
         gen.writeStartObject();
         //gen.writeStringField('val1', String.valueOf(objt.finalOffer) != null ? String.valueOf(objt.finalOffer) : '');
         gen.writeStringField('val1', objt.finalOffer != null ? objt.finalOffer : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject(); 
         gen.writeStartObject();
         gen.writeStringField('val1', objt.laneStatus != null ? objt.laneStatus : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject(); 
         gen.writeStartObject();
         //gen.writeStringField('val1', String.valueOf(objt.carloadsMoved) != null ? String.valueOf(objt.carloadsMoved) : '');
         gen.writeStringField('val1', objt.carloadsMoved != null ? objt.carloadsMoved : '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject(); 
          
         //}
         gen.writeEndArray();
         gen.writeEndObject();
        
       }
        
      gen.writeEndArray();  
      gen.writeFieldName('headers');
       gen.writeStartArray();
        gen.writeStartObject();
         gen.writeStringField('title1', 'LaneID');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', NSSales_ParsingConstants.H_FIELDS);
         gen.writeEndObject();
        gen.writeStartObject();
         gen.writeStringField('title1', 'STCC');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();

        gen.writeStartObject();
         gen.writeStringField('title1', 'Shipper');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('title1', 'O Rd');
         gen.writeBooleanField('isSortable', false);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('title1', 'O City');
         gen.writeBooleanField('isSortable', false);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('title1', 'O St');
         gen.writeBooleanField('isSortable', false);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('title1', 'O HL');
         gen.writeBooleanField('isSortable', false);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('title1', 'Receiver');
         gen.writeBooleanField('isSortable', false);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('title1', 'D Rd');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('title1', 'D City');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('title1', 'D St');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('title1', 'D HL');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('title1', 'Route');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('title1', 'Car Owner');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('title1', 'Lading');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         gen.writeStartObject();
         gen.writeStringField('title1', 'Basis');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         
         gen.writeStartObject();
         gen.writeStringField('title1', 'Est Vol');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
        
         gen.writeStartObject();
         gen.writeStringField('title1', 'Target Rate');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
        
         gen.writeStartObject();
         gen.writeStringField('title1', 'Initial Offer');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
        
         gen.writeStartObject();
         gen.writeStringField('title1', 'Final Offer');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
        
         gen.writeStartObject();
         gen.writeStringField('title1', 'Lane Status');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
        
         gen.writeStartObject();
         gen.writeStringField('title1', 'Carloads Moved');
         gen.writeBooleanField('isSortable', true);
         gen.writeStringField('dataType', '');
         gen.writeStringField('cssClass1', '');
         gen.writeEndObject();
         
         

      gen.writeEndArray();
      gen.writeEndObject();
        
       String processedResponse = gen.getAsString();
      system.debug('processedResponse' +processedResponse); 
               return processedResponse; 

        }
}