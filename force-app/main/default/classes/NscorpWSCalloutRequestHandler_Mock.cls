/*
This class provides Mock reponse for NS webservice Implementation
Developer    : Accenture Solutions
Date         : 1-24-2018
*/

@isTest
Global class NscorpWSCalloutRequestHandler_Mock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        system.debug('EndPoint' +req.getEndpoint());
        if(NS_StaticVariablesUtility.contentType.equals(req.getHeader(NS_StaticVariablesUtility.Content_Type))){
            res.setHeader(NS_StaticVariablesUtility.Content_Type, NS_StaticVariablesUtility.contentType);
            
            
            
            
            
            if(req.getHeader(NS_StaticVariablesUtility.SOAPAction).equals(NS_StaticVariablesUtility.TYES_getCustomerSummary_Action)){
                res.setBody(NS_WsRequestBodyFactory.getCustomerSummaryMockResBody());        
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
            }
            
            if(req.getHeader(NS_StaticVariablesUtility.SOAPAction).equals(NS_StaticVariablesUtility.LOPA_Action )){
                res.setBody(NS_StaticVariablesUtility.getLOPAMockResBody());        
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
            }
            
            if(req.getHeader(NS_StaticVariablesUtility.SOAPAction).equals(NS_StaticVariablesUtility.CustomerRouteReport_Action )){
                res.setBody(NS_StaticVariablesUtility.getCustomerRouteMockResBody());        
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
            }
            
            if(req.getHeader(NS_StaticVariablesUtility.SOAPAction).equals(NS_StaticVariablesUtility.TransitExceptionQueueCountsAction)){
                res.setBody(NS_StaticVariablesUtility.getMockTransitExCountResBody());        
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
            }
            
            if(req.getHeader(NS_StaticVariablesUtility.SOAPAction).equals(NS_StaticVariablesUtility.TransitExceptionQueueDetailAction)){
                res.setBody(NS_StaticVariablesUtility.getMockTransitExDetailResBody());        
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
            }      
            
            if(req.getHeader(NS_StaticVariablesUtility.SOAPAction).equals(NS_StaticVariablesUtility.VDNMaintenanceAction)){
                res.setBody(NS_StaticVariablesUtility.getVDNResponseBody());        
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
            }      
            if(req.getHeader(NS_StaticVariablesUtility.SOAPAction).equals(NS_PipeLineData.PIPELINE_ACTION)){
                res.setBody(NS_WsRequestBodyFactory.getPipeLineMockResponseAEMS());        
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
            }  
            if(req.getHeader(NS_StaticVariablesUtility.SOAPAction).equals(NS_StaticVariablesUtility.a1)){
                res.setBody(NS_StaticVariablesUtility.getCustomerRouteMockResBody());        
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
            } 
            if(req.getHeader(NS_StaticVariablesUtility.SOAPAction).equals(NS_IntegrationUtility_Teams.CAR_REQ_SUMMARY_ACTION)){
                
                res.setBody(NS_WsRequestBodyFactory.getCarRequestMockResBody());        
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
            } 
            if(req.getHeader(NS_StaticVariablesUtility.SOAPAction).equals(NS_StaticVariablesUtility.a_LOPA)){
                res.setBody(NS_StaticVariablesUtility.getLOPAMockResBody());        
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
            } 
            if(req.getHeader(NS_StaticVariablesUtility.SOAPAction).equals(NS_IntegrationUtility.MOCK_ACTION)){
                res.setBody(NS_WsRequestBodyFactory.getMockResponse());        
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
            }
        }
        else{
            System.debug('C-1');
            res.setHeader(NS_StaticVariablesUtility.Content_Type, 'application/json;charset=UTF-8');
            if('null/renewals?good-spell=testGoogspell'.equals(req.getEndpoint())){
                System.debug('C-2');
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
                res.setBody(NS_WsRequestBodyFactory.getAuthRenewalBody());
            }
            if('null/requests?good-spell=testGoogspell'.equals(req.getEndpoint())){
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
                res.setBody(NS_WsRequestBodyFactory.getRateRequestBody());
            }
            if('null/statistics?good-spell=testGoogspell'.equals(req.getEndpoint())){
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
                res.setBody(NS_WsRequestBodyFactory.getCustomerStatisticBody());
            }
             if('null/request/lanes?wb-request-id=1494921627053'.equals(req.getEndpoint())){
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
                res.setBody(NS_WsRequestBodyFactory.getWonLaneBody());
            }
            

            if(req.getMethod().equals(NS_IntegrationUtility_WorkBench.POSTMETHOD)){
                System.debug('C-3');
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
                res.setBody(NS_WsRequestBodyFactory.getOpportunityWBInsertMockResponse());
            }
           
            if('https://qaapi.nscorp.com/external/connectns-api/optcs/equipmentdetails/EMHU/262418'.equals(req.getEndpoint())){
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
                res.setBody(NS_WsRequestBodyFactory.getEquipmentTest());
                //https://qaapi.nscorp.com/external/connectns-api/omega/api/v1/quotes
            }
            if('https://qaapi.nscorp.com/external/connectns-api/omega/oauth/token'.equals(req.getEndpoint()))
            { 
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
                res.setBody(NS_WsRequestBodyFactory.getAuthenticationRESTAPI());   
            }
            
            if('https://qaapi.nscorp.com/external/connectns-api/omega/api/v1/quotes/9000001/lanes'.equals(req.getEndpoint()))
            {
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
                res.setBody(NS_WsRequestBodyFactory.getRenewalLaneTest());
                system.debug('DEBOSMEETA '+NS_WsRequestBodyFactory.getRenewalLaneTest());
                
            }
            if('https://qaapi.nscorp.com/external/connectns-api/omega/api/v1/quotes?size=20&beneficialOwnerNumber.equals=418401&sort=quoteNumber,asc'.equals(req.getEndpoint()))
            {
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
                res.setBody(NS_WsRequestBodyFactory.getOmegaAuthRenewalsTest());
                
            }
            if('https://qaapi.nscorp.com/external/connectns-api/workbench/customer/statistics?good-spell=BUNG+NOR+A&ns-business-group=im'.equals(req.getEndpoint()))
            {
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
                res.setBody(NS_WsRequestBodyFactory.getCS_IM());
                
            }

            if(('https://qaapi.nscorp.com/external/connectns-api/workbench/customer/renewal/lanes?bureau=NSSC&auth-num=19480&exp-date=2020-09-30').equals(req.getEndpoint()))
                system.debug('DEVA SRV ENDPT '+req.getEndpoint());
            {
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
                res.setBody(NS_WsRequestBodyFactory.getAuthorityLaneInfoIPTest());
                
            }
            if('https://api.nscorp.com/external/tep/equipmentlastmoves?einit=EMHU&enumber=0000262418&sort=desc&mvnumber=10'.equals(req.getEndpoint())){
                System.debug('C-4');
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
                res.setBody(NS_WsRequestBodyFactory.getLastMovesMockResponse());
                
            }
            if('https://qaapi.nscorp.com/external/connectns-api/optcs/terminals'.equals(req.getEndpoint())){
                res.setStatusCode(NS_StaticVariablesUtility.SuccessStatusCode);
                res.setBody(NS_WsRequestBodyFactory.getTerminalAccountMockResponse());
            }
            
        }
        
        return res;
    }
}