/*======================================================================================================
* @Class Name : NS_WsRequestBodyFactory
* @author : Accenture
* @Purpose: This class serves as a factory to prepare body for making HTTP callouts.
* @created date: 09-01-2018
* @Change Logs:                                 
----------------------------------------------------------------------------------------------------------
Developer name        Date          Description        
----------------------------------------------------------------------------------------------------------
@Arjun Ghosh          09-01-2019    Request No.   , Phase-II
==========================================================================================================*/
public class NS_WsRequestBodyFactory{
    /*Customer Summary body */   
    public Final Static String tyes = 'http://schemas.datacontract.org/2004/07/Tyes.Web.SalesForce.Service.Entity';
    public static String resetUserIdOnNull(String uId){
        if(uId == null || uId == ''){
            uId = 'SFDC1';    
        } 
        return uId;
    }
    public static String getLOPAReqBody(String uId, String cCode, String sCode){
        String body = '<soapenv:Body xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:tyes="http://schemas.datacontract.org/2004/07/Tyes.Web.SalesForce.Service.Entity">';
        body += '<tem:GetLOPAMetricsReport>';
        body += '<tem:request>';
        body += '<tyes:UserId>'+resetUserIdOnNull(uId)+'</tyes:UserId>';
        body += '<tyes:ClassCode>'+cCode+'</tyes:ClassCode>';//T25
        body += '<tyes:StationCode>'+sCode+'</tyes:StationCode>';//659
        body += '</tem:request>';
        body += '</tem:GetLOPAMetricsReport>';
        body += '</soapenv:Body>';        
        return body;
    }
    
    public static String getTransitExCountReqBody(String uId, String cCode, String sCode){
        String body = '<soapenv:Body xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:tyes="http://schemas.datacontract.org/2004/07/Tyes.Web.SalesForce.Service.Entity">';
        body += '<tem:GetTransitExceptionQueueCounts>';
        body += '<tem:request>';
        body += '<tyes:UserId>'+resetUserIdOnNull(uId)+'</tyes:UserId>';
        body += '<tyes:ClassCode>'+cCode+'</tyes:ClassCode>';//F01
        body += '<tyes:StationCode>'+sCode+'</tyes:StationCode>';//148H
        body += '</tem:request>';
        body += '</tem:GetTransitExceptionQueueCounts>';
        body += '</soapenv:Body>';
        return body;
    }
    /* ================================================
* @Method Name : getCarRequestBody
* @author id: arjun.c.ghosh@accenture.com
* @Purpose: This method is used to create the request body Cryto Sign it and remove the X.509 tags from it for CAR_REQUEST_SERVICE(TEAMS) only
* @Parameters: String classcode, String Operating Station code, String Serving Road, String Start Week Date
* @return: String
* @created date: 02-01-2019
==================================================*/ 
    public static String getCarRequestBody(String cCode, String oSCode, String sRoad, String startWeekDate, String userId){        
        String body = '<soapenv:Body xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" >';
        body += '<tem:GetCarRequestSummary>';
        body += '<tem:ClassCode>'+cCode+'</tem:ClassCode>';
        body += '<tem:OperationStation>'+oSCode+'</tem:OperationStation>';        
        body += '<tem:ServingRoad>'+sRoad+'</tem:ServingRoad>';
        body += '<tem:StartWeekDate>'+startWeekDate+'</tem:StartWeekDate>';
        body += '<tem:RacfId>'+ resetUserIdOnNull(userId)+'</tem:RacfId>';
        body += '</tem:GetCarRequestSummary>';
        body += '</soapenv:Body>';
        
        return body;
    }
    
    public static String getCarRequestMockResBody(){
        String carRequestMockRes = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">';
        carRequestMockRes+='<s:Body>';
        carRequestMockRes+='<GetCarRequestSummaryResponse xmlns="http://tempuri.org/">';
        carRequestMockRes+='<GetCarRequestSummaryResult xmlns:a="http://schemas.datacontract.org/2004/07/NS.TEAMS.Web.Api.WCF.CarRequest.EmptyCarRequestService" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">';
        carRequestMockRes+='<a:CarRequestSummaryList xmlns:b="http://schemas.datacontract.org/2004/07/NS.TEAMS.Domain.Models.CarRequest">';
        carRequestMockRes+='<b:CarRequestSummary>';
        carRequestMockRes+='<b:Accepted>40</b:Accepted>';
        carRequestMockRes+='<b:CustomerPattern>COVERED HOPPER, SMALL CUBE</b:CustomerPattern>';
        carRequestMockRes+='<b:Fulfilled>11</b:Fulfilled>';
        carRequestMockRes+='<b:LoadFill>0</b:LoadFill>';
        carRequestMockRes+='<b:MarketingPriorityRank>542</b:MarketingPriorityRank>';
        carRequestMockRes+='<b:OrderFill>0</b:OrderFill>';
        carRequestMockRes+='<b:Projected>0</b:Projected>';
        carRequestMockRes+='<b:RequestFill>0</b:RequestFill>';
        carRequestMockRes+='<b:Requested>40</b:Requested>';
        carRequestMockRes+='<b:StartWeekDate>5/6/2019</b:StartWeekDate>';
        carRequestMockRes+='<b:SurplusShortage>-29</b:SurplusShortage>';
        carRequestMockRes+='<b:WeeklyFillTarget>50</b:WeeklyFillTarget>';
        carRequestMockRes+='</b:CarRequestSummary>';
        carRequestMockRes+='</a:CarRequestSummaryList>';
        carRequestMockRes+='<a:RequestStatus>Success</a:RequestStatus>';
        carRequestMockRes+='<a:WarningIndicator />';
        carRequestMockRes+='</GetCarRequestSummaryResult>';
        carRequestMockRes+='</GetCarRequestSummaryResponse>';
        carRequestMockRes+='</s:Body>';
        carRequestMockRes+='</s:Envelope>';
        
        return carRequestMockRes;
    } 
    public static String getTransitExDetailReqBody(String uId, String cCode, String sCode, String EquipmentInit, String EquipmentNr, String WaybillSrNr){
        String body = '<soapenv:Body xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:tyes="http://schemas.datacontract.org/2004/07/Tyes.Web.SalesForce.Service.Entity" xmlns:tyes1="http://schemas.datacontract.org/2004/07/Tyes.Web.SalesForce.Service.Entity.TransitExceptionQueue">';
        body += '<tem:GetTransitExceptionQueueDetails>';
        body += '<tem:request>';
        body += '<tyes:UserId>'+resetUserIdOnNull(uId)+'</tyes:UserId>';
        body += '<tyes:ClassCode>'+cCode+'</tyes:ClassCode>';
        body += '<tyes:StationCode>'+sCode+'</tyes:StationCode>';
        body += '<tyes1:EqInit>'+EquipmentInit+'</tyes1:EqInit>';//MTTX
        body += '<tyes1:EqNr>'+EquipmentNr+'</tyes1:EqNr>';// 0000941468
        body += '<tyes1:WaybillSerNr>'+WaybillSrNr+'</tyes1:WaybillSerNr>';//6174184322
        body += '</tem:request>';
        body += '</tem:GetTransitExceptionQueueDetails>';
        body += '</soapenv:Body>';
        
        return body;
    }
    
    public static String getCustomerRouteReportReqBody(String uId, String cCode, String sCode){
        String body = '<soapenv:Body xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:tyes="http://schemas.datacontract.org/2004/07/Tyes.Web.SalesForce.Service.Entity">';
        body += '<tem:GetCustomerRouteReport>';
        body += '<tem:request>';
        body += '<tyes:UserId>'+resetUserIdOnNull(uId)+'</tyes:UserId>';//jkd4b
        body += '<tyes:ClassCode>'+cCode+'</tyes:ClassCode>';//B52
        body += '<tyes:StationCode>'+sCode+'</tyes:StationCode>';//09141        
        body += '</tem:request>';
        body += '</tem:GetCustomerRouteReport>';
        body += '</soapenv:Body>';
        
        return body;
    }
    public static String getCustomerSummaryReqBody(String uId, String cCode, String sCode){
        String body = '<soapenv:Body xmlns:soapenv="'+NS_IntegrationUtility.SOAP_NS+'" xmlns:tem="'+NS_IntegrationUtility.TEM+'" xmlns:tyes="'+tyes+'">';
        body += '<tem:GetCustomerSummary>';     
        body += '<tem:request>'; 
        body += '<tyes:UserId>'+resetUserIdOnNull(uId)+'</tyes:UserId>';         
        body += '<tyes:ClassCode>'+cCode+'</tyes:ClassCode>';         
        body += '<tyes:StationCode>'+sCode+'</tyes:StationCode>';
        body += '</tem:request>';
        body += '</tem:GetCustomerSummary>';
        body += '</soapenv:Body>';
        
        return body;
    }
    public static String getCustomerSummaryMockResBody(){
        String cusSumRes = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">';
        cusSumRes += '<s:Body>';
        cusSumRes += '<GetCustomerSummaryResponse xmlns="http://tempuri.org/">';
        cusSumRes += '<GetCustomerSummaryResult xmlns:a="http://schemas.datacontract.org/2004/07/Tyes.Web.SalesForce.Service.Entity.CustomerSummary" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">';
        cusSumRes += '<Status xmlns="http://schemas.datacontract.org/2004/07/Tyes.Web.SalesForce.Service.Entity">';
        cusSumRes += '<Code>0</Code>';
        cusSumRes += '<Message/>';
        cusSumRes += '</Status>';
        cusSumRes += '<a:BusinessName>FABRICATION PLANT</a:BusinessName>';
        cusSumRes += '<a:ClassCode>F01</a:ClassCode>';
        cusSumRes += '<a:EquipmentSummary>';
        cusSumRes += '<a:OnTrackDetails>';
        cusSumRes += '<a:EmptyCount>69</a:EmptyCount>';
        cusSumRes += '<a:Length>5479</a:Length>';
        cusSumRes += '<a:LoadCount>22</a:LoadCount>';
        cusSumRes += '<a:TotalCount>91</a:TotalCount>';
        cusSumRes += '<a:Weight>4230</a:Weight>';
        cusSumRes += '</a:OnTrackDetails>';
        cusSumRes += '</a:EquipmentSummary>';
        cusSumRes += '<a:NotifyStations xmlns:b="http://schemas.microsoft.com/2003/10/Serialization/Arrays">';
        cusSumRes += '<b:string>ATLANTA, GA</b:string>';
        cusSumRes += '</a:NotifyStations>';
        cusSumRes += '<a:Schedule>';
        cusSumRes += '<a:CustomerSummaryServiceSchedule>';
        cusSumRes += '<a:CutOffDayOfWeek>Monday</a:CutOffDayOfWeek>';
        cusSumRes += '<a:CutoffTimeDisplay>6:59 AM</a:CutoffTimeDisplay>';
        cusSumRes += '<a:ScheduleCloseTime>3:59 PM</a:ScheduleCloseTime>';
        cusSumRes += '<a:ScheduleDayOfWeek>Monday</a:ScheduleDayOfWeek>';
        cusSumRes += '<a:ScheduleOpenTime>7:59 AM</a:ScheduleOpenTime>';
        cusSumRes += '</a:CustomerSummaryServiceSchedule>';
        cusSumRes += '</a:Schedule>';
        cusSumRes += '<a:SpecialInstructions xmlns:b="http://schemas.microsoft.com/2003/10/Serialization/Arrays">';
        cusSumRes += '<b:string>GE-98 FAB JOB- SWITCH LIST 5/11/18&#xD;';
        cusSumRes += '</b:string>';
        cusSumRes += '<b:string>GE-98 FAB JOB- SWITCH LIST 5/11/18&#xD;';
        cusSumRes += '</b:string>';
        cusSumRes += '</a:SpecialInstructions>';
        cusSumRes += '<a:StateAbbreviation>GA</a:StateAbbreviation>';
        cusSumRes += '<a:StationName>ATLANTA</a:StationName>';
        cusSumRes += '<a:SummaryBullets xmlns:b="http://schemas.microsoft.com/2003/10/Serialization/Arrays">';
        cusSumRes += '<b:string>Order for Placement</b:string>';
        cusSumRes += '<b:string>Operating Division - GEORGIA</b:string>';
        cusSumRes += '</a:SummaryBullets>';
        cusSumRes += '</GetCustomerSummaryResult>';
        cusSumRes += '</GetCustomerSummaryResponse>';
        cusSumRes += '</s:Body>';
        cusSumRes += '</s:Envelope>';
        
        return cusSumRes;
    }
    
    /*Debosmeeta- Request body for TEP server.
*/
    public static String ManageOnlineCustomerContactTEP(String uId, List<NS_OnlineCustomerContactTEP.ManageOnlineCustomerContactWrapperTEP> CustomerContactWrapperList){
        String body = '<soapenv:Body xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://www.nscorp.com/tep/customerchange/v1.0">';
        for(NS_OnlineCustomerContactTEP.ManageOnlineCustomerContactWrapperTEP mocw : CustomerContactWrapperList){
            body += '<v1:PublishContactRequest>';
            body += '<v1:Contact>';
            body += '<v1:ContactSourceName>'+ mocw.ContactSourceName+'</v1:ContactSourceName>';
            body += '<v1:ContactType>'+mocw.ContactType+'</v1:ContactType>';
            body += '<v1:DisplayName>'+mocw.DisplayName+'</v1:DisplayName>';
            body += '<v1:DisplayImage>'+mocw.DisplayImage+'</v1:DisplayImage>';
            body += '<v1:ContactUserId>'+mocw.ContactUserId+'</v1:ContactUserId>';
            body += '<v1:ContactRole>'+mocw.ContactRole+'</v1:ContactRole>';
            body += '<v1:ContactStatus>'+mocw.ContactStatus+'</v1:ContactStatus>';
            body += '<v1:NameTitle>'+mocw.NameTitle+'</v1:NameTitle>';
            body += '<v1:FirstName>'+mocw.FirstName+'</v1:FirstName>';
            body += '<v1:MiddleName>'+mocw.MiddleName+'</v1:MiddleName>';
            body += '<v1:LastName>'+mocw.LastName+'</v1:LastName>';
            body += '<v1:NameSuffix>'+mocw.NameSuffix+'</v1:NameSuffix>';
            body += '<v1:JobTitle>'+mocw.JobTitle+'</v1:JobTitle>';
            body += '<v1:ContactTimezone>'+mocw.ContactTimezone+'</v1:ContactTimezone>';
            body += '<v1:Comments>'+mocw.Comments+'</v1:Comments>';
            body += '<v1:UserId>'+resetUserIdOnNull(uId)+'</v1:UserId>';
            body += '<v1:SourceCode>'+mocw.SourceCode+'</v1:SourceCode>';
            body += '<v1:Confidentiality>'+mocw.Confidentiality+'</v1:Confidentiality>';
            body += '</v1:Contact>';
            if(mocw.PhoneNumber!=NS_OnlineCustomerContactTEP.BLANK){
                body += '<v1:ContactPhone>';
                body += '<v1:PhoneType>'+mocw.PhoneType+'</v1:PhoneType>';
                body += '<v1:PhonePriority>'+mocw.PhonePriority+'</v1:PhonePriority>';
                body += '<v1:PhoneNumber>'+mocw.PhoneNumber+'</v1:PhoneNumber>';
                body += '<v1:ProviderName>'+mocw.ProviderName+'</v1:ProviderName>';
                body += '<v1:Comments>'+mocw.PhoneComments+'</v1:Comments>';
                body += '</v1:ContactPhone>';
            }
            if(mocw.MobilePhoneNumber!=NS_OnlineCustomerContactTEP.BLANK){
                body += '<v1:ContactPhone>';
                body += '<v1:PhoneType>'+mocw.MobilePhoneType+'</v1:PhoneType>';
                body += '<v1:PhonePriority>'+mocw.MobilePhonePriority+'</v1:PhonePriority>';
                body += '<v1:PhoneNumber>'+mocw.MobilePhoneNumber+'</v1:PhoneNumber>';
                body += '<v1:ProviderName>'+mocw.MobileProviderName+'</v1:ProviderName>';
                body += '<v1:Comments>'+mocw.MobilePhoneComments+'</v1:Comments>';
                body += '</v1:ContactPhone>';
            }
            if(mocw.OtherPhoneNumber1!=NS_OnlineCustomerContactTEP.BLANK){
                body += '<v1:ContactPhone>';
                body += '<v1:PhoneType>'+mocw.OtherPhoneType1+'</v1:PhoneType>';
                body += '<v1:PhonePriority>'+mocw.OtherPhonePriority1+'</v1:PhonePriority>';
                body += '<v1:PhoneNumber>'+mocw.OtherPhoneNumber1+'</v1:PhoneNumber>';
                body += '<v1:ProviderName />';
                body += '<v1:Comments />';
                body += '</v1:ContactPhone>';
            }
            if(mocw.OtherPhoneNumber2!=NS_OnlineCustomerContactTEP.BLANK){
                body += '<v1:ContactPhone>';
                body += '<v1:PhoneType>'+mocw.OtherPhoneType2+'</v1:PhoneType>';
                body += '<v1:PhonePriority>'+mocw.OtherPhonePriority2+'</v1:PhonePriority>';
                body += '<v1:PhoneNumber>'+mocw.OtherPhoneNumber2+'</v1:PhoneNumber>';
                body += '<v1:ProviderName />';
                body += '<v1:Comments />';
                body += '</v1:ContactPhone>';
            }
            if(mocw.FaxPhoneNumber!=NS_OnlineCustomerContactTEP.BLANK){
                body += '<v1:ContactPhone>';
                body += '<v1:PhoneType>'+mocw.FaxPhoneType+'</v1:PhoneType>';
                body += '<v1:PhonePriority>'+mocw.FaxPhonePriority+'</v1:PhonePriority>';
                body += '<v1:PhoneNumber>'+mocw.FaxPhoneNumber+'</v1:PhoneNumber>';
                body += '<v1:ProviderName />';
                body += '<v1:Comments />';
                body += '</v1:ContactPhone>';
            }
            body += '<v1:ContactAddress>';
            body += '<v1:StreetAddressType>'+mocw.StreetAddressType+'</v1:StreetAddressType>';
            body += '<v1:Street_Address>'+mocw.Street_Address+'</v1:Street_Address>';
            body += '<v1:City>'+mocw.City+'</v1:City>';
            body += '<v1:State_Province_Region>'+mocw.State_Province_Region+'</v1:State_Province_Region>';
            body += '<v1:State_Province_Region_Abbreviation>'+mocw.State_Province_Region_Abbreviation+'</v1:State_Province_Region_Abbreviation>';
            body += '<v1:Country>'+mocw.Country+'</v1:Country>';
            body += '<v1:ZipCode>'+mocw.ZipCode+'</v1:ZipCode>';
            body += '<v1:Comments>'+mocw.AddressComments+'</v1:Comments>';
            body += '</v1:ContactAddress>';
            body += '<v1:ContactMedia>';
            body += '<v1:MediaType>'+mocw.MediaType+'</v1:MediaType>';
            body += '<v1:Media>'+mocw.Media+'</v1:Media>';
            body += '<v1:Comments>'+mocw.MediaComments+'</v1:Comments>';
            body += '</v1:ContactMedia>';
            body += '<v1:ContactCommodity>';
            body += '<v1:CommodityType>'+mocw.CommodityType+'</v1:CommodityType>';
            body += '<v1:CommodityDesc>'+mocw.CommodityDesc+'</v1:CommodityDesc>';
            body += '</v1:ContactCommodity>';
            body += '</v1:PublishContactRequest>';
        }    
        body += '</soapenv:Body>';
        
        return body;
    }
    public static String getPipeLineReqBodyAEMS( String sCode){
        String body ='<soapenv:Body xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:aem="http://aemsws.integration.aems.nscorp.com">';
        body +=  '<aem:getEquipmentSummary>';
        body += '<aem:operatingStationCode>'+sCode+'</aem:operatingStationCode>';
        body+='</aem:getEquipmentSummary>';
        body +=  '</soapenv:Body>';
        return body;
    }
    public static String getPipeLineMockResponseAEMS(){
        String body ='<?xml version="1.0" encoding="UTF-8"?>';
        body+='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        body+='<soapenv:Body>';
        body+='<getEquipmentSummaryResponse xmlns="http://aemsws.integration.aems.nscorp.com">';
        body+='<getEquipmentSummaryReturn>';
        body+='<onsite>0</onsite>';
        body+='<receiving>0</receiving>';
        body+='</getEquipmentSummaryReturn>';
        body+='</getEquipmentSummaryResponse>';
        body+='</soapenv:Body>';
        body+='</soapenv:Envelope>';
        return body;
    }
    public static String getMockReqBody(){
        String body ='<soapenv:Body xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:mock="http://mockUrl.com">';
        body +=  '<mock:parent>';
        body += '<mock:child>'+'</mock:child>';
        body+='</mock:parent>';
        body +=  '</soapenv:Body>';
        return body;
    }
    public static String getMockResponse(){
        String body = '{"example":"Response"}';
        
        return body;
    }
    
    public static String OpportunityWBJSONContent(List<NS_OppWorkBenchRequest.ManageOpportunityWrapperWB> OpportunityWrapperList) {
        
        String body = ''; 
        for(NS_OppWorkBenchRequest.ManageOpportunityWrapperWB mocw : OpportunityWrapperList){
            JSONGenerator gen = JSON.createGenerator(true);
            
            // Write data to the JSON string.
            gen.writeStartObject();
            gen.writeStringField('requestID', mocw.RequestID);
            gen.writeStringField('requestStatus', mocw.RequestStatus);
            gen.writeEndObject();
            
            body += gen.getAsString();
        }
        system.debug('Body' +body);
        return body;
        
        
    }
    
    public static String insertOpportunityWBJSONContent(List<NS_OppWorkBenchRequest.ManageOpportunityWrapperWB> OpportunityWrapperList) {
        
        String body = ''; 
        for(NS_OppWorkBenchRequest.ManageOpportunityWrapperWB mocw : OpportunityWrapperList){
            JSONGenerator gen = JSON.createGenerator(true);
            
            // Write data to the JSON string.
            gen.writeStartObject();
            gen.writeStringField('requestID', mocw.RequestID);
            gen.writeStringField('requestStatus', mocw.RequestStatus);
            gen.writeEndObject();
            
            body += gen.getAsString();
        }
        system.debug('Body' +body);
        return body;
        
        
    }
    
    public static String insertOpportunityRequestIdWBJSONContent(String uId,List<NS_OppWorkBenchRequest.ManageOpportunityWrapperWB> OpportunityWrapperList) {
        
        String body = ''; 
        for(NS_OppWorkBenchRequest.ManageOpportunityWrapperWB mocw : OpportunityWrapperList){
            JSONGenerator gen = JSON.createGenerator(true);
            
            // Write data to the JSON string.
            gen.writeStartObject();
            //gen.writeStringField('requestID', '1501206013415');
            gen.writeStringField('customerName', mocw.CustomerName);
            gen.writeStringField('customerNumber', mocw.CustomerNumber);
            gen.writeStringField('createdByRacf', resetUserIdOnNull(uId));
            gen.writeStringField('connectNsStatus', mocw.Status);
            gen.writeFieldName('lanes');
            gen.writeStartArray();
            gen.writeStartObject();
            gen.writeStringField('shipper', mocw.Shipper);
            gen.writeStringField('originRoad', mocw.OriginRoad); 
            gen.writeStringField('originCity', mocw.OriginCity);
            gen.writeStringField('originState', mocw.OriginState);
            gen.writeStringField('destinRoad', mocw.DestinRoad);
            gen.writeStringField('destinCity', mocw.DestinCity);
            gen.writeStringField('destinState', mocw.DestinState);
            gen.writeStringField('stcc', mocw.Stcc);
            gen.writeStringField('estVolume', mocw.EstimatedVolume);
            gen.writeEndObject();
            gen.writeEndArray();
            gen.writeEndObject();
            
            body += gen.getAsString();
        }
        system.debug('Body' +body);
        return body;
        
        
    }
    
    
    public static String getAuthRenewalBody() {
        String res='{"resultCode":0,"resultDescription":"Success","result":[{"renewalId":{"bureau":"NSSC","authNum":20032,"sectNum":13,"expDate":"2019-07-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":20032,"sectNum":13,"expDate":"2019-07-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05J","officerName":"ASPATORE, JE (05J)","minEffDate":"2018-08-01","laneCount":2,"nSRated":true,"status":"New","carloads":"8","nsRevenue":"$32,110","contribution":"$30,564","rcr":"2.46"},{"renewalId":{"bureau":"NSSC","authNum":20032,"sectNum":7,"expDate":"2019-07-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":20032,"sectNum":7,"expDate":"2019-07-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05J","officerName":"ASPATORE, JE (05J)","minEffDate":"2018-08-01","laneCount":1,"nSRated":true,"status":"New","carloads":"125","nsRevenue":"$361,992","contribution":"$107,940","rcr":"1.39"},{"renewalId":{"bureau":"NS","authNum":9407,"sectNum":2,"expDate":"2019-03-31"},"majorGrp":"COAL","bureau":"NS","authNum":9407,"sectNum":2,"expDate":"2019-03-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"08A","officerName":"DENTON, AC (08A)","minEffDate":"2019-01-01","laneCount":3,"nSRated":true,"status":"New","carloads":"1,267","nsRevenue":"$4,163,267","contribution":"$2,143,842","rcr":"2.06"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":74,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":74,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":2,"nSRated":true,"status":"New","carloads":null,"nsRevenue":null,"contribution":null,"rcr":null},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":1,"expDate":"2019-05-29"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":1,"expDate":"2019-05-29","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2019-05-25","laneCount":146,"nSRated":true,"status":"New","carloads":"4,616","nsRevenue":"$11,948,649","contribution":"$2,266,559","rcr":"1.24"},{"renewalId":{"bureau":"NSSC","authNum":83324,"sectNum":3,"expDate":"2019-03-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":83324,"sectNum":3,"expDate":"2019-03-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05Q","officerName":"BRADFORD-CALHOUN, MD (05Q)","minEffDate":"2018-04-01","laneCount":3,"nSRated":true,"status":"New","carloads":"8","nsRevenue":"$27,721","contribution":"$30,970","rcr":"1.38"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":56,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":56,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":"2","nsRevenue":"$7,294","contribution":"$545","rcr":"1.08"},{"renewalId":{"bureau":"NSSC","authNum":20032,"sectNum":2,"expDate":"2019-07-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":20032,"sectNum":2,"expDate":"2019-07-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05J","officerName":"ASPATORE, JE (05J)","minEffDate":"2018-08-01","laneCount":30,"nSRated":true,"status":"New","carloads":"665","nsRevenue":"$3,047,051","contribution":"$1,359,431","rcr":"1.79"},{"renewalId":{"bureau":"NSSC","authNum":20032,"sectNum":11,"expDate":"2019-07-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":20032,"sectNum":11,"expDate":"2019-07-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05J","officerName":"ASPATORE, JE (05J)","minEffDate":"2018-08-01","laneCount":10,"nSRated":true,"status":"New","carloads":"41","nsRevenue":"$158,673","contribution":"$61,199","rcr":"1.67"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":86,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":86,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":"2","nsRevenue":"$4,454","contribution":"$458","rcr":"1.11"},{"renewalId":{"bureau":"NSSC","authNum":83324,"sectNum":1,"expDate":"2019-03-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":83324,"sectNum":1,"expDate":"2019-03-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05Q","officerName":"BRADFORD-CALHOUN, MD (05Q)","minEffDate":"2018-04-01","laneCount":13,"nSRated":true,"status":"New","carloads":"4","nsRevenue":"$13,792","contribution":"$8,047","rcr":"1.56"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":7,"expDate":"2019-05-24"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":7,"expDate":"2019-05-24","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":2,"nSRated":true,"status":"New","carloads":"49","nsRevenue":"$131,529","contribution":"$41,390","rcr":"1.54"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":88,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":88,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":5,"nSRated":true,"status":"New","carloads":"10","nsRevenue":"$6,108","contribution":"$415","rcr":"3.10"},{"renewalId":{"bureau":"NSSC","authNum":20032,"sectNum":16,"expDate":"2019-09-30"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":20032,"sectNum":16,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"05J","officerName":"ASPATORE, JE (05J)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":"4","nsRevenue":"$10,919","contribution":"$10,280","rcr":"2.17"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":41,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":41,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":2,"nSRated":true,"status":"New","carloads":"32","nsRevenue":"$77,184","contribution":"$8,344","rcr":"1.31"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":62,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":62,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":"2","nsRevenue":"$4,796","contribution":"$1,038","rcr":"1.17"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":16,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":16,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":5,"nSRated":true,"status":"New","carloads":"21","nsRevenue":"$50,652","contribution":"$17,749","rcr":"1.48"},{"renewalId":{"bureau":"NSSC","authNum":83324,"sectNum":3,"expDate":"2019-07-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":83324,"sectNum":3,"expDate":"2019-07-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05Q","officerName":"BRADFORD-CALHOUN, MD (05Q)","minEffDate":"2019-04-01","laneCount":2,"nSRated":true,"status":"New","carloads":"8","nsRevenue":"$27,721","contribution":"$30,970","rcr":"1.38"},{"renewalId":{"bureau":"NSSC","authNum":20032,"sectNum":9,"expDate":"2019-07-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":20032,"sectNum":9,"expDate":"2019-07-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05J","officerName":"ASPATORE, JE (05J)","minEffDate":"2018-08-01","laneCount":1,"nSRated":true,"status":"New","carloads":"1","nsRevenue":"$3,791","contribution":"$1,385","rcr":"1.58"},{"renewalId":{"bureau":"NSSC","authNum":20032,"sectNum":5,"expDate":"2019-07-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":20032,"sectNum":5,"expDate":"2019-07-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05J","officerName":"ASPATORE, JE (05J)","minEffDate":"2018-08-01","laneCount":7,"nSRated":true,"status":"New","carloads":"100","nsRevenue":"$334,750","contribution":"$190,450","rcr":"1.87"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":48,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":48,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":null,"nsRevenue":null,"contribution":null,"rcr":null},{"renewalId":{"bureau":"NSSC","authNum":83324,"sectNum":2,"expDate":"2019-03-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":83324,"sectNum":2,"expDate":"2019-03-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05Q","officerName":"BRADFORD-CALHOUN, MD (05Q)","minEffDate":"2018-04-01","laneCount":10,"nSRated":true,"status":"New","carloads":"107","nsRevenue":"$338,164","contribution":"$96,629","rcr":"1.35"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":9,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":9,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":null,"nsRevenue":null,"contribution":null,"rcr":null},{"renewalId":{"bureau":"NSSC","authNum":6639,"sectNum":2,"expDate":"2019-03-31"},"majorGrp":"COAL","bureau":"NSSC","authNum":6639,"sectNum":2,"expDate":"2019-03-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"08R","officerName":"PHAM, AT (08R)","minEffDate":"2018-12-01","laneCount":1,"nSRated":true,"status":"New","carloads":"141","nsRevenue":"$641,753","contribution":"$33,179","rcr":"1.16"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":39,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":39,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":3,"nSRated":true,"status":"New","carloads":"13","nsRevenue":"$27,637","contribution":"$1,543","rcr":"1.06"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":1,"expDate":"2019-06-25"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":1,"expDate":"2019-06-25","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2019-05-30","laneCount":147,"nSRated":true,"status":"New","carloads":"4,616","nsRevenue":"$11,948,649","contribution":"$2,266,559","rcr":"1.24"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":70,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":70,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":3,"nSRated":true,"status":"New","carloads":"16","nsRevenue":"$35,650","contribution":"$4,208","rcr":"1.13"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":54,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":54,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":null,"nsRevenue":null,"contribution":null,"rcr":null},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":4,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":4,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":null,"nsRevenue":null,"contribution":null,"rcr":null},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":84,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":84,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":null,"nsRevenue":null,"contribution":null,"rcr":null},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":1,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":1,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2019-06-26","laneCount":147,"nSRated":true,"status":"New","carloads":"4,616","nsRevenue":"$11,948,649","contribution":"$2,266,559","rcr":"1.24"},{"renewalId":{"bureau":"NSSC","authNum":83324,"sectNum":9,"expDate":"2019-03-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":83324,"sectNum":9,"expDate":"2019-03-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05Q","officerName":"BRADFORD-CALHOUN, MD (05Q)","minEffDate":"2018-04-01","laneCount":1,"nSRated":true,"status":"New","carloads":null,"nsRevenue":null,"contribution":null,"rcr":null},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":60,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":60,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":null,"nsRevenue":null,"contribution":null,"rcr":null},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":72,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":72,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":"2","nsRevenue":"$5,508","contribution":"$2,450","rcr":"1.22"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":66,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":66,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":"1","nsRevenue":"$2,800","contribution":"$1,252","rcr":"1.81"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":50,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":50,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":2,"nSRated":true,"status":"New","carloads":"108","nsRevenue":"$251,620","contribution":"$60,957","rcr":"1.29"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":82,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":82,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":null,"nsRevenue":null,"contribution":null,"rcr":null},{"renewalId":{"bureau":"NSSC","authNum":20032,"sectNum":21,"expDate":"2019-03-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":20032,"sectNum":21,"expDate":"2019-03-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05Q","officerName":"BRADFORD-CALHOUN, MD (05Q)","minEffDate":"2019-01-01","laneCount":3,"nSRated":true,"status":"New","carloads":"2","nsRevenue":"$2,624","contribution":"$2,102","rcr":"5.03"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":80,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":80,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":"3","nsRevenue":"$6,429","contribution":"$488","rcr":"1.08"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":12,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":12,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":5,"nSRated":true,"status":"New","carloads":"89","nsRevenue":"$206,447","contribution":"$15,069","rcr":"1.09"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":46,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":46,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":2,"nSRated":true,"status":"New","carloads":"1","nsRevenue":"$2,144","contribution":"($367)","rcr":"0.85"},{"renewalId":{"bureau":"NSSC","authNum":20032,"sectNum":18,"expDate":"2019-07-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":20032,"sectNum":18,"expDate":"2019-07-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05J","officerName":"ASPATORE, JE (05J)","minEffDate":"2018-08-01","laneCount":1,"nSRated":true,"status":"New","carloads":"12","nsRevenue":"$47,795","contribution":"($6,734)","rcr":"0.93"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":58,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":58,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":"4","nsRevenue":"$8,892","contribution":"$5","rcr":"1.00"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":18,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":18,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":11,"nSRated":true,"status":"New","carloads":"255","nsRevenue":"$657,202","contribution":"$105,897","rcr":"1.22"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":35,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":35,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":null,"nsRevenue":null,"contribution":null,"rcr":null},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":21,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":21,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":2,"nSRated":true,"status":"New","carloads":null,"nsRevenue":null,"contribution":null,"rcr":null},{"renewalId":{"bureau":"NSSC","authNum":83324,"sectNum":2,"expDate":"2019-07-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":83324,"sectNum":2,"expDate":"2019-07-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05Q","officerName":"BRADFORD-CALHOUN, MD (05Q)","minEffDate":"2019-04-01","laneCount":4,"nSRated":true,"status":"New","carloads":"107","nsRevenue":"$338,164","contribution":"$96,629","rcr":"1.35"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":68,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":68,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":4,"nSRated":true,"status":"New","carloads":"108","nsRevenue":"$241,348","contribution":"$23,154","rcr":"1.11"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":76,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":76,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":null,"nsRevenue":null,"contribution":null,"rcr":null},{"renewalId":{"bureau":"NSSC","authNum":20032,"sectNum":15,"expDate":"2019-07-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":20032,"sectNum":15,"expDate":"2019-07-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05J","officerName":"ASPATORE, JE (05J)","minEffDate":"2018-08-01","laneCount":8,"nSRated":true,"status":"New","carloads":"42","nsRevenue":"$189,332","contribution":"$114,191","rcr":"2.04"},{"renewalId":{"bureau":"NS","authNum":9407,"sectNum":2,"expDate":"2019-06-30"},"majorGrp":"COAL","bureau":"NS","authNum":9407,"sectNum":2,"expDate":"2019-06-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"08R","officerName":"PHAM, AT (08R)","minEffDate":"2019-04-01","laneCount":4,"nSRated":true,"status":"New","carloads":"1,267","nsRevenue":"$4,163,267","contribution":"$2,143,842","rcr":"2.06"},{"renewalId":{"bureau":"NSSC","authNum":83324,"sectNum":4,"expDate":"2019-07-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":83324,"sectNum":4,"expDate":"2019-07-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05Q","officerName":"BRADFORD-CALHOUN, MD (05Q)","minEffDate":"2019-04-01","laneCount":4,"nSRated":true,"status":"New","carloads":"30","nsRevenue":"$82,282","contribution":"$9,568","rcr":"1.11"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":37,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":37,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":5,"nSRated":true,"status":"New","carloads":"27","nsRevenue":"$68,870","contribution":"$19,080","rcr":"1.40"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":52,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":52,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":null,"nsRevenue":null,"contribution":null,"rcr":null},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":64,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":64,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":"9","nsRevenue":"$22,475","contribution":"$4,276","rcr":"1.33"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":13,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":13,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":2,"nSRated":true,"status":"New","carloads":"4","nsRevenue":"$11,464","contribution":"$3,210","rcr":"1.39"},{"renewalId":{"bureau":"NSSC","authNum":20032,"sectNum":17,"expDate":"2019-07-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":20032,"sectNum":17,"expDate":"2019-07-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05J","officerName":"ASPATORE, JE (05J)","minEffDate":"2018-08-01","laneCount":2,"nSRated":true,"status":"New","carloads":"49","nsRevenue":"$269,445","contribution":"$117,854","rcr":"2.51"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":1,"expDate":"2019-05-24"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":1,"expDate":"2019-05-24","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2019-03-13","laneCount":145,"nSRated":true,"status":"New","carloads":"4,616","nsRevenue":"$11,948,649","contribution":"$2,266,559","rcr":"1.24"},{"renewalId":{"bureau":"NSSC","authNum":20032,"sectNum":3,"expDate":"2019-07-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":20032,"sectNum":3,"expDate":"2019-07-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05J","officerName":"ASPATORE, JE (05J)","minEffDate":"2018-08-01","laneCount":1,"nSRated":true,"status":"New","carloads":"2","nsRevenue":"$6,450","contribution":"$2,733","rcr":"1.74"},{"renewalId":{"bureau":"NSSC","authNum":20032,"sectNum":8,"expDate":"2019-07-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":20032,"sectNum":8,"expDate":"2019-07-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05J","officerName":"ASPATORE, JE (05J)","minEffDate":"2018-08-01","laneCount":14,"nSRated":true,"status":"New","carloads":"85","nsRevenue":"$321,850","contribution":"$132,470","rcr":"1.55"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":3,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":3,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":1,"nSRated":true,"status":"New","carloads":"22","nsRevenue":"$77,852","contribution":"$43,817","rcr":"1.80"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":7,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":7,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2019-05-25","laneCount":3,"nSRated":true,"status":"New","carloads":"49","nsRevenue":"$131,529","contribution":"$41,390","rcr":"1.54"},{"renewalId":{"bureau":"NSSC","authNum":83324,"sectNum":1,"expDate":"2019-07-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":83324,"sectNum":1,"expDate":"2019-07-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05Q","officerName":"BRADFORD-CALHOUN, MD (05Q)","minEffDate":"2019-04-01","laneCount":7,"nSRated":true,"status":"New","carloads":"4","nsRevenue":"$13,792","contribution":"$8,047","rcr":"1.56"},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":44,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":44,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":2,"nSRated":true,"status":"New","carloads":null,"nsRevenue":null,"contribution":null,"rcr":null},{"renewalId":{"bureau":"NS","authNum":19631,"sectNum":2,"expDate":"2019-09-30"},"majorGrp":"AGRI, CONSUMER & GOVT","bureau":"NS","authNum":19631,"sectNum":2,"expDate":"2019-09-30","custGrpName":"ADVANSIX INC","mktMgrDesk":"09N","officerName":"YOUNG, SB (09N)","minEffDate":"2018-10-01","laneCount":2,"nSRated":true,"status":"New","carloads":"47","nsRevenue":"$95,800","contribution":"$2,921","rcr":"1.06"},{"renewalId":{"bureau":"NSSC","authNum":83324,"sectNum":4,"expDate":"2019-03-31"},"majorGrp":"CHEMICALS","bureau":"NSSC","authNum":83324,"sectNum":4,"expDate":"2019-03-31","custGrpName":"ADVANSIX INC","mktMgrDesk":"05Q","officerName":"BRADFORD-CALHOUN, MD (05Q)","minEffDate":"2018-04-01","laneCount":7,"nSRated":true,"status":"New","carloads":"30","nsRevenue":"$82,282","contribution":"$9,568","rcr":"1.11"}]}';
            return res;
        
    }
    
     public static String getRateRequestBody() {
        String res='{"resultCode":0,"resultDescription":"Success","result":[{"requestId":"1494921627053","requestNumber":"11932","requestName":null,"customerName":"NUCOR CORP","customerNumber":"804589","customerType":null,"customerContactName":"Robert.L.Byrd@nucor.com","customerContactEmail":null,"customerContactPhone":null,"requestedShipDate":null,"estimatedShipDate":null,"customerComments":"","internalComments":"","requestSource":null,"requestStatus":"Priced","declinedReason":null,"originalAssignedToRacf":"NMH7K","originalAssignedToMajorGroup":"20","assignedToRacf":"NMH7K","assignedToMajorGroup":"20","createdByRacf":"NMH7K","createdDate":"2017-05-17","interlineDate":null,"pricedDate":"2017-05-30","archivedDate":"2018-02-09","lastModified":"2018-02-09","deleted":null,"connectNsStatus":null},{"requestId":"1530157675050","requestNumber":"26893","requestName":null,"customerName":"NUCOR CORP","customerNumber":"132281","customerType":"S & P","customerContactName":null,"customerContactEmail":null,"customerContactPhone":null,"requestedShipDate":null,"estimatedShipDate":null,"customerComments":"","internalComments":"CSXT division request","requestSource":"Workbench","requestStatus":"Priced","declinedReason":null,"originalAssignedToRacf":"MBP4Z","originalAssignedToMajorGroup":"10","assignedToRacf":"MBP4Z","assignedToMajorGroup":"10","createdByRacf":"MBP4Z","createdDate":"2018-07-11","interlineDate":null,"pricedDate":"2018-07-11","archivedDate":"2018-07-11","lastModified":"2018-07-11","deleted":null,"connectNsStatus":null},{"requestId":"1530157142871","requestNumber":"26732","requestName":null,"customerName":"NUCOR CORP","customerNumber":"132281","customerType":"S & P","customerContactName":null,"customerContactEmail":null,"customerContactPhone":null,"requestedShipDate":null,"estimatedShipDate":null,"customerComments":"","internalComments":"CSXT division request","requestSource":"Workbench","requestStatus":"Priced","declinedReason":null,"originalAssignedToRacf":"MBP4Z","originalAssignedToMajorGroup":"20","assignedToRacf":"MBP4Z","assignedToMajorGroup":"20","createdByRacf":"MBP4Z","createdDate":"2018-07-06","interlineDate":null,"pricedDate":"2018-07-06","archivedDate":"2018-07-06","lastModified":"2018-07-06","deleted":null,"connectNsStatus":null},{"requestId":"1530156529131","requestNumber":"26656","requestName":null,"customerName":"NUCOR CORP","customerNumber":"132281","customerType":"S/R/P?","customerContactName":"Suzy Lauderbaugh","customerContactEmail":"suzy.lauderbaugh@nucor.com","customerContactPhone":"7653594432","requestedShipDate":null,"estimatedShipDate":null,"customerComments":"RAIL STATION IS BUFFALO AND IT IS OPEN AND COVERED COIL CARS","internalComments":"UPMUL requested rate from accessNS.","requestSource":"accessNS","requestStatus":"Published","declinedReason":null,"originalAssignedToRacf":"KBSU9","originalAssignedToMajorGroup":"20","assignedToRacf":"KBSU9","assignedToMajorGroup":"20","createdByRacf":"UPMUL","createdDate":"2018-07-05","interlineDate":"2018-07-05","pricedDate":"2018-07-05","archivedDate":null,"lastModified":"2018-07-06","deleted":null,"connectNsStatus":null},{"requestId":"1530156235179","requestNumber":"26509","requestName":null,"customerName":"NUCOR STEEL BIRMINGHAM I","customerNumber":"132281","customerType":"S & P","customerContactName":"Michael Rhodes","customerContactEmail":"michael.rhodes@nsbhm.com","customerContactPhone":"2052507466","requestedShipDate":null,"estimatedShipDate":null,"customerComments":"RECEIVER IS RAIL RESOURCES OF NC CAROLINAS RELOAD 200 KITTY BENNETT RD. WADESBORO, NC","internalComments":"NFM7A requested rate from accessNS.","requestSource":"accessNS","requestStatus":"Priced","declinedReason":null,"originalAssignedToRacf":"MBP4Z","originalAssignedToMajorGroup":"20","assignedToRacf":"MBP4Z","assignedToMajorGroup":"20","createdByRacf":"NFM7A","createdDate":"2018-06-29","interlineDate":"2018-07-03","pricedDate":"2018-07-03","archivedDate":"2018-07-03","lastModified":"2018-07-03","deleted":null,"connectNsStatus":null},{"requestId":"1528726478305","requestNumber":"26356","requestName":null,"customerName":"NUCOR CORP","customerNumber":"132281","customerType":"S & P","customerContactName":null,"customerContactEmail":null,"customerContactPhone":null,"requestedShipDate":null,"estimatedShipDate":null,"customerComments":"","internalComments":"UP Division Request","requestSource":"Workbench","requestStatus":"Priced","declinedReason":null,"originalAssignedToRacf":"MBP4Z","originalAssignedToMajorGroup":"20","assignedToRacf":"MBP4Z","assignedToMajorGroup":"20","createdByRacf":"MBP4Z","createdDate":"2018-06-27","interlineDate":null,"pricedDate":"2018-06-27","archivedDate":"2018-07-05","lastModified":"2018-07-05","deleted":null,"connectNsStatus":null}]}';
            return res;
        
    }
    
    public static String getCustomerStatisticBody() {
        String res ='{"resultCode":0,"resultDescription":"Success","result":{"trafficHistoryAllRollingYear":{"carloads":20354.0,"carloadsVsPriorPeriod":163.0,"carloadsVsPriorPeriodPerc":0.008072903,"nsRevenue":6.5442416E7,"nsRevenueVsPriorPeriod":2430440.0,"nsRevenueVsPriorPeriodPerc":0.038571082,"nsRevenuePerCar":3215.2117,"nsRevenueVsPriorPeriodPerCar":94.416504,"nsRevenueVsPriorPeriodPerCarPerc":0.03025399,"nsRevenuePerTon":31.5176,"totalRevenue":6.8803952E7,"totalRevenueVsPriorPeriod":2459352.0,"totalRevenueVsPriorPeriodPerc":0.03706936,"totalRevenuePerCar":3380.3652,"totalRevenueVsPriorPeriodPerCar":94.51514,"totalRevenueVsPriorPeriodPerCarPerc":0.028764287,"totalRevenuePerTon":33.13654,"tons":2076377.0,"tonsVsPriorPeriod":31997.0,"tonsVsPriorPeriodPerc":0.0156512,"tonsPerCar":102.013214,"tonsPerCarVsPriorPeriod":0.76116943,"tonsPerCarVsPriorPeriodPerc":0.007517571,"nsRevenueWithoutFsc":6.4704632E7,"nsRevenueWithoutFscVsPriorPeriod":1792676.0,"nsRevenueWithoutFscVsPriorPeriodPerc":0.028494997,"nsRevenueWithoutFscPerCar":3178.9639,"nsRevenueWithoutFscPerTon":31.162275,"nsRevenueWithoutFscPerCarPriorPeriod":63.122314,"nsRevenueWithoutFscVsPriorPeriodPerCarPerc":0.020258512,"nsFuelSurcharge":429683.0,"nsFuelSurchargeVsPriorPeriod":368037.0,"nsFuelSurchargeVsPriorPeriodPerc":5.9701686,"nsFuelSurchargePerCar":21.110495,"nsFuelSurchargePerCarVsPriorPeriod":18.057352,"nsFuelSurchargeVsPriorPeriodPerCarPerc":5.9143496,"nsFuelSurchargePerTon":0.20693882,"totalRevenueWithoutFsc":6.7979E7,"totalRevenueWithoutFscVsPriorPeriod":1762200.0,"totalRevenueWithoutFscVsPriorPeriodPerc":0.026612582,"totalRevenueWithoutFscPerCar":3339.835,"totalRevenueWithoutFscPerCarVsPriorPeriod":60.314453,"totalRevenueWithoutFscPerCarVsPriorPeriodPerc":0.018391242,"totalRevenueWithoutFscPerTon":32.73924,"totalFuelSurcharge":500356.0,"totalFuelSurchargeVsPriorPeriod":415739.0,"totalFuelSurchargeVsPriorPeriodPerc":4.913185,"totalFuelSurchargePerCar":24.582687,"totalFuelSurchargePerCarVsPriorPeriod":20.391861,"totalFuelSurchargePerCarVsPriorPeriodPerc":4.865832,"totalFuelSurchargePerTon":0.24097551},"eyeProfitAllRollingYear":{"carloads":20189.0,"carloadsVsPriorPeriod":24.0,"carloadsVsPriorPeriodPerc":0.0011901810066947682,"totalRevenue":5.941049671845E7,"totalRevenueVsPriorPeriod":-16650.92975999415,"totalRevenueVsPriorPeriodPerc":-2.80190626993616E-4,"totalRevenuePerCar":2942.7161681336374,"totalRevenueVsPriorPeriodPerCar":null,"totalRevenueVsPriorPeriodPerCarPerc":-0.0014686237056478638,"totalRevenuePerTon":28.824171695330932,"tons":2061134.5695,"tonsVsPriorPeriod":16958.65599999996,"tonsVsPriorPeriodPerc":0.00829608444557184,"tonsPerCarVsPriorPeriod":0.7194866835112776,"tonsPerCarVsPriorPeriodPerc":0.0070974561813341285,"tonsPerCar":102.09195945812075,"vecRevCostRatio":1.5594996303392474,"vecRevCostRatioVsPriorPeriod":-0.06466158610693595,"vecRevCostRatioVsPriorPeriodPerc":-0.039812295388028995,"vecCost":3.809587098493E7,"vecCostVsPriorPeriod":1506432.05088,"vecCostVsPriorPeriodPerc":0.04117122576258254,"vecCostPerCar":1886.9617606087475,"vecCostPerCarVsPriorPeriod":72.45945790356518,"vecCostPerCarVsPriorPeriodPerc":0.03993351664284897,"vecCostPerTon":18.48296154392844,"vecContribution":2.131462573352E7,"vecContributionVsPriorPeriod":-1523082.9806399941,"vecContributionVsPriorPeriodPerc":-0.06669158450627062,"vecContributionPerCar":1055.7544075248898,"vecContrPerCarVsPriorPeriod":-76.78755697597785,"vecContrPerCarVsPriorPeriodPerc":-0.06780106996725685,"vecContrPerTon":10.341209310351145,"avgDaysOnLine":24.9449963907301,"avgDaysOnLineVsPriorPeriod":1.3762042076772865,"avgDaysOnLineVsPriorPeriodPerc":0.0583909517716758,"avgLoadedMiles":781.5428421417604,"avgLoadedMilesVsPriorPeriod":28.254045712303423,"avgLoadedMilesVsPriorPeriodPerc":0.03750758785505092,"emptyReturnRatio":0.9547025355603174,"emptyReturnRatioVsPriorPeriod":0.0019419501963242602,"emptyReturnRatioVsPriorPeriodPerc":0.002038235235751652,"nsRevenuePerTonMile":0.03688111532867529,"nsRevenuePerTonMileVsPriorPeriod":-0.001711579985511344,"nsRevenuePerTonMileVsPriorPeriodPerc":-0.04434984319123648,"contributionPerCarDay":42.32329365728922,"contributionPerCarDayVsPriorPeriod":-5.729316711425781,"contributionPerCarDayVsPriorPeriodPerc":-0.11923006477681578},"trafficHistoryAllYTD":{"carloads":5949.0,"carloadsVsPriorPeriod":-646.0,"carloadsVsPriorPeriodPerc":-0.09795299,"nsRevenue":1.9593224E7,"nsRevenueVsPriorPeriod":-680868.0,"nsRevenueVsPriorPeriodPerc":-0.033583157,"nsRevenuePerCar":3293.5325,"nsRevenueVsPriorPeriodPerCar":219.37134,"nsRevenueVsPriorPeriodPerCarPerc":0.07135974,"nsRevenuePerTon":31.99113,"totalRevenue":2.0475432E7,"totalRevenueVsPriorPeriod":-914368.0,"totalRevenueVsPriorPeriodPerc":-0.04274785,"totalRevenuePerCar":3441.8276,"totalRevenueVsPriorPeriodPerCar":198.4917,"totalRevenueVsPriorPeriodPerCarPerc":0.06119986,"totalRevenuePerTon":33.43157,"tons":612458.0,"tonsVsPriorPeriod":-65648.0,"tonsVsPriorPeriodPerc":-0.096810825,"tonsPerCar":102.95142,"tonsPerCarVsPriorPeriod":0.13019562,"tonsPerCarVsPriorPeriodPerc":0.0012662328,"nsRevenueWithoutFsc":1.8590012E7,"nsRevenueWithoutFscVsPriorPeriod":-1636658.0,"nsRevenueWithoutFscVsPriorPeriodPerc":-0.08091584,"nsRevenueWithoutFscPerCar":3124.897,"nsRevenueWithoutFscPerTon":30.35312,"nsRevenueWithoutFscPerCarPriorPeriod":57.926514,"nsRevenueWithoutFscVsPriorPeriodPerCarPerc":0.018887209,"nsFuelSurcharge":91398.0,"nsFuelSurchargeVsPriorPeriod":46941.0,"nsFuelSurchargeVsPriorPeriodPerc":1.0558742,"nsFuelSurchargePerCar":15.36359,"nsFuelSurchargePerCarVsPriorPeriod":8.622574,"nsFuelSurchargeVsPriorPeriodPerCarPerc":1.2791208,"nsFuelSurchargePerTon":0.14923146,"totalRevenueWithoutFsc":1.9451756E7,"totalRevenueWithoutFscVsPriorPeriod":-1875608.0,"totalRevenueWithoutFscVsPriorPeriodPerc":-0.08794373,"totalRevenueWithoutFscPerCar":3269.7522,"totalRevenueWithoutFscPerCarVsPriorPeriod":35.883545,"totalRevenueWithoutFscPerCarVsPriorPeriodPerc":0.011096166,"totalRevenueWithoutFscPerTon":31.760147,"totalFuelSurcharge":102342.0,"totalFuelSurchargeVsPriorPeriod":44344.0,"totalFuelSurchargeVsPriorPeriodPerc":0.7645781,"totalFuelSurchargePerCar":17.203228,"totalFuelSurchargePerCarVsPriorPeriod":8.40899,"totalFuelSurchargePerCarVsPriorPeriodPerc":0.9561931,"totalFuelSurchargePerTon":0.16710044},"eyeProfitAllYTD":{"carloads":1487.0,"carloadsVsPriorPeriod":-412.0,"carloadsVsPriorPeriodPerc":-0.21695629278567669,"totalRevenue":4554780.57667,"totalRevenueVsPriorPeriod":-933999.38155,"totalRevenueVsPriorPeriodPerc":-0.17016520768904972,"totalRevenuePerCar":3063.066964808339,"totalRevenueVsPriorPeriodPerCar":null,"totalRevenueVsPriorPeriodPerCarPerc":0.059755393812033916,"totalRevenuePerTon":29.501754938107876,"tons":154390.157,"tonsVsPriorPeriod":-41904.87049999999,"tonsVsPriorPeriodPerc":-0.21347902202973526,"tonsPerCarVsPriorPeriod":0.45902552700906085,"tonsPerCarVsPriorPeriodPerc":0.004440710938488784,"tonsPerCar":103.82660188298588,"vecRevCostRatio":1.5366645653062487,"vecRevCostRatioVsPriorPeriod":0.07175918827919481,"vecRevCostRatioVsPriorPeriodPerc":0.04898554500825589,"vecCost":2964069.5045,"vecCostVsPriorPeriod":-782779.9810000001,"vecCostVsPriorPeriodPerc":-0.20891684708160668,"vecCostPerCar":1993.3217918628109,"vecCostPerCarVsPriorPeriod":20.257291862810916,"vecCostPerCarVsPriorPeriodPerc":0.0102669182192528,"vecCostPerTon":19.198565258923857,"vecContribution":1590711.0721700005,"vecContributionVsPriorPeriod":-151219.4005499999,"vecContributionVsPriorPeriodPerc":-0.0868113870893325,"vecContributionPerCar":1069.7451729455283,"vecContrPerCarVsPriorPeriod":152.45687767433276,"vecContrPerCarVsPriorPeriodPerc":0.166203884275291,"vecContrPerTon":10.303189211731937,"avgDaysOnLine":20.200650605574985,"avgDaysOnLineVsPriorPeriod":-2.5662478822291206,"avgDaysOnLineVsPriorPeriodPerc":-0.1127183785531359,"avgLoadedMiles":804.0064425016812,"avgLoadedMilesVsPriorPeriod":26.799049136752274,"avgLoadedMilesVsPriorPeriodPerc":0.03448120715981028,"emptyReturnRatio":0.9105846808147876,"emptyReturnRatioVsPriorPeriod":-0.029622052601168236,"emptyReturnRatioVsPriorPeriodPerc":-0.03150589285140035,"nsRevenuePerTonMile":0.0366934310206677,"nsRevenuePerTonMileVsPriorPeriod":7.160455807953478E-4,"nsRevenuePerTonMileVsPriorPeriodPerc":0.019902657517791217,"contributionPerCarDay":52.95597621248395,"contributionPerCarDayVsPriorPeriod":12.665538787841797,"contributionPerCarDayVsPriorPeriodPerc":0.31435595653789894}}}';
        return res;
        
    }
    
     public static String getWonLaneBody() {
        String res='{"resultCode":0,"resultDescription":"Success","result":[{"laneId":"1494921627056","offerId":"1494921627053","requestId":"1494921627053","shipper":null,"receiver":"","originRoad":"NS","originStation":"72588","originCity":"CAMP HILL","originState":"PA","originHandlingLine":null,"destinRoad":"NS","destinStation":"24300","destinCity":"CHICAGO","destinState":"IL","destinHandlingLine":null,"stcc":"3312663","stccMajorGroup":"20","stccMinorGroup":"210","route":"NS DIRECT","estVolume":10,"estVolumeUnits":"cars","estVolumePeriod":"month","estRate":null,"competitionType":null,"carOwnership":"S","carType":"FB","minWeight":null,"minWeightUnits":null,"minCars":null,"minCarsPeriod":null,"lading":null,"basis":null,"rate":"$4,000.00","privateRate":null,"rateSource":null}]}';
         return res;
        
    }
    
    public static String getOpportunityWBInsertMockResponse(){
      //  String res='{"resultCode":0,"resultDescription":"Success","result":[{"requestId":"1494921627053","requestNumber":"11932","requestName":null,"customerName":"NUCOR CORP","customerNumber":"804589","customerType":null,"customerContactName":"Robert.L.Byrd@nucor.com","customerContactEmail":null,"customerContactPhone":null,"requestedShipDate":null,"estimatedShipDate":null,"customerComments":"","internalComments":"","requestSource":null,"requestStatus":"Priced","declinedReason":null,"originalAssignedToRacf":"NMH7K","originalAssignedToMajorGroup":"20","assignedToRacf":"NMH7K","assignedToMajorGroup":"20","createdByRacf":"NMH7K","createdDate":"2017-05-17","interlineDate":null,"pricedDate":"2017-05-30","archivedDate":"2018-02-09","lastModified":"2018-02-09","deleted":null,"connectNsStatus":null},{"requestId":"1530157675050","requestNumber":"26893","requestName":null,"customerName":"NUCOR CORP","customerNumber":"132281","customerType":"S & P","customerContactName":null,"customerContactEmail":null,"customerContactPhone":null,"requestedShipDate":null,"estimatedShipDate":null,"customerComments":"","internalComments":"CSXT division request","requestSource":"Workbench","requestStatus":"Priced","declinedReason":null,"originalAssignedToRacf":"MBP4Z","originalAssignedToMajorGroup":"10","assignedToRacf":"MBP4Z","assignedToMajorGroup":"10","createdByRacf":"MBP4Z","createdDate":"2018-07-11","interlineDate":null,"pricedDate":"2018-07-11","archivedDate":"2018-07-11","lastModified":"2018-07-11","deleted":null,"connectNsStatus":null},{"requestId":"1530157142871","requestNumber":"26732","requestName":null,"customerName":"NUCOR CORP","customerNumber":"132281","customerType":"S & P","customerContactName":null,"customerContactEmail":null,"customerContactPhone":null,"requestedShipDate":null,"estimatedShipDate":null,"customerComments":"","internalComments":"CSXT division request","requestSource":"Workbench","requestStatus":"Priced","declinedReason":null,"originalAssignedToRacf":"MBP4Z","originalAssignedToMajorGroup":"20","assignedToRacf":"MBP4Z","assignedToMajorGroup":"20","createdByRacf":"MBP4Z","createdDate":"2018-07-06","interlineDate":null,"pricedDate":"2018-07-06","archivedDate":"2018-07-06","lastModified":"2018-07-06","deleted":null,"connectNsStatus":null},{"requestId":"1530156529131","requestNumber":"26656","requestName":null,"customerName":"NUCOR CORP","customerNumber":"132281","customerType":"S/R/P?","customerContactName":"Suzy Lauderbaugh","customerContactEmail":"suzy.lauderbaugh@nucor.com","customerContactPhone":"7653594432","requestedShipDate":null,"estimatedShipDate":null,"customerComments":"RAIL STATION IS BUFFALO AND IT IS OPEN AND COVERED COIL CARS","internalComments":"UPMUL requested rate from accessNS.","requestSource":"accessNS","requestStatus":"Published","declinedReason":null,"originalAssignedToRacf":"KBSU9","originalAssignedToMajorGroup":"20","assignedToRacf":"KBSU9","assignedToMajorGroup":"20","createdByRacf":"UPMUL","createdDate":"2018-07-05","interlineDate":"2018-07-05","pricedDate":"2018-07-05","archivedDate":null,"lastModified":"2018-07-06","deleted":null,"connectNsStatus":null},{"requestId":"1530156235179","requestNumber":"26509","requestName":null,"customerName":"NUCOR STEEL BIRMINGHAM I","customerNumber":"132281","customerType":"S & P","customerContactName":"Michael Rhodes","customerContactEmail":"michael.rhodes@nsbhm.com","customerContactPhone":"2052507466","requestedShipDate":null,"estimatedShipDate":null,"customerComments":"RECEIVER IS RAIL RESOURCES OF NC CAROLINAS RELOAD 200 KITTY BENNETT RD. WADESBORO, NC","internalComments":"NFM7A requested rate from accessNS.","requestSource":"accessNS","requestStatus":"Priced","declinedReason":null,"originalAssignedToRacf":"MBP4Z","originalAssignedToMajorGroup":"20","assignedToRacf":"MBP4Z","assignedToMajorGroup":"20","createdByRacf":"NFM7A","createdDate":"2018-06-29","interlineDate":"2018-07-03","pricedDate":"2018-07-03","archivedDate":"2018-07-03","lastModified":"2018-07-03","deleted":null,"connectNsStatus":null},{"requestId":"1528726478305","requestNumber":"26356","requestName":null,"customerName":"NUCOR CORP","customerNumber":"132281","customerType":"S & P","customerContactName":null,"customerContactEmail":null,"customerContactPhone":null,"requestedShipDate":null,"estimatedShipDate":null,"customerComments":"","internalComments":"UP Division Request","requestSource":"Workbench","requestStatus":"Priced","declinedReason":null,"originalAssignedToRacf":"MBP4Z","originalAssignedToMajorGroup":"20","assignedToRacf":"MBP4Z","assignedToMajorGroup":"20","createdByRacf":"MBP4Z","createdDate":"2018-06-27","interlineDate":null,"pricedDate":"2018-06-27","archivedDate":"2018-07-05","lastModified":"2018-07-05","deleted":null,"connectNsStatus":null}]}';
          //  return res;
        String body = '{"customerName" : "WAL-MART STORES INC","customerNumber" : "","createdByRacf" : "PLITR","connectNsStatus" : "Qualification/Analysis","lanes" : [ {"shipper" : "","originRoad" : "NS","originCity" : "Norfolk","originState" : "VA","destinRoad" : "NS","destinCity" : "Atlanta", "destinState" : "GA","stcc" : "","estVolume" : ""} ]}';
        return body;
    }
    public static String getTerminalAccountMockResponse(){
        String body = '[{"terminal":"APPLIANCE PARK","operatingStation":"282W"},{"terminal":"ATLANTA","operatingStation":"148H"},{"terminal":"AUSTELL","operatingStation":"135H"},{"terminal":"AYER","operatingStation":"90013"},{"terminal":"BALTIMORE","operatingStation":"IP1"}]';
        return body;
    }
    public static String getLastMovesMockResponse(){
        System.debug('Pra');
        String body='{"Response":{"MoveHistoryStr":"Success","ResultCode":"0"},"MoveDetail":{"MoveEventHistory":[{"Initial":"JBHU","Number":"0000323979","EventCode":"ICHR", "EventDateTime":"2019-08-17T13:15:19-04:00","WaybillSerialNumber":"6455694086","AarCarType":"U249","accountRoad":null, "ActivityDateTime":"2019-08-17T13:16:30-04:00","ActivityEnvironment":"PROD","ActivityIndicator":"ADD","ActivitySource":"SIMS","ActivitySourceProgram":"IMB08001","ActivitysubSourceCode":null,"BillofLadingBookNumber":null,"BilltoLocationId":null,"CarReasoncCode":null,"CduIndicator":null, "ChassisInitial":"JBHZ","ChassisNumber":"0000166466","city":"ATLANTA","ClerkId":"RNJ0F","ClerkIdFmt":"F","ConsistSeqNumber":"0","CrewDistrict":null,"CrewId":null,"crspWaybillserialNumber":null,"CustCntlOsc":null,"DepartForOperatingStationCode":null,"Direction":null,"Drayman":"HJBT","EquipmentDisplayType":null,"EquipmentGroup":"CONT","EventLocation":null,"EventLocationRoad":"NS","EventLocationType":"O","EventTimeZone":null,"EventUpdateIndicator":null,"FlatInitial":null,"FlatNumber":null,"FromRoad":null,"FromSpot":"0","FromSubTrack":null,"FromTrack":null,"FSAC":null,"HandlingCode":null,"HostRoad":null,"IntermodalIndicator":null,"LinkSequenceNumber":"0","ListType":null,"LoadedEmptyIndicator":"L","LocalHandlingCode":null,"LocationSequenceNumber":"0","LocomotiveFuelLevel":"0","LocomotiveKWHours":"0","LocomotivePowerInTowIndicator":null,"NotifyLocationId":null,"OfflineRoadname":null,"OperatingStationCode":"148H","Orientation":null,"OutbKeepIndicator":null,"PlanBlockCode":null,"PlanBlockDestinationOperatingStationCode":null,"PlanBlockOnRoad":null,"PlanBlockOriginOperatingStationCode":null,"PlanBlockType":null,"PlanclassCode":null,"PlanclassoriginOperatingStationCode":null,"ProcessDateTime":"2019-08-17T13:16:30-04:00","ReportedBlockCode":null,"ReportedBlockFromOperatingStation":null,"ReportedBlockTermid":null,"ReportedBlocktoOperatingStation":null,"ReportedBlockType":null,"ReportedClassCode":null,"ReportedClassOriginOperatingStationCode":null,"RevNonRevIndicator":"R","SealNumber":null,"SendTrain2Ind":"Y","SeqNumber":"1","SpclHndlgMsg":null, "Speed":"0","Splc":null,"State":"GA","SwlistNumber":"0", "ToRoad":null,"ToSpot":"0","ToSubTrack":null,"ToTrack":null,"TrackType":null,"Train10Symbol":null,"TrainLineSegment":null,"TrainNumber":null,"TrainOriginDate":null,"TripEndMoveIndicator":null,"TyesecIndicator":null,"Type":null,"WaybillSAKey":"13153612912299", "WaybillVersionNumber":null,"Weight":"0", "Wolnnr":"0","WorkOrderNumber":null, "WorkOrderType":null}]}}';
       return body;
    }
    public static String getEquipmentTest(){
        String body='{"Response[{"billToParty":"JB HUNT TRANSPORT INC","notifyParty":"J B HUNT TRANSPORT INC","onlineOrigin":"CHICAGO","onlineDestination":"AYER","onlineOriginCode":"00510","onlineDestinationCode":"90013","initial":"JBHU","number":"323979","pickupNumber":"2573","waybillSerialNumber":"6480198219","waybillNumber":"104957","customerBillOfLadingNumber":"SK89513","status":"A","shipper":"JB HUNT TRANSPORT INC","onlineOriginRoad":"NS","onlineDestinationRoad":"NS"}]';
          return body;
    } 
    
    public static String getRenewalLaneTest(){
        String body = '[{"id" : {"quoteId" : 9000001,"id" : 1},"service" : "45","commodityCode" : "4611110  ","onRamp" : "CHGO ","onRampProportionalCode" : " ","originRoad" : 555,"originFsac" : 24300,"originCity" : "CHICAGO","originState" : "IL","offRamp" : "GBORO","offRampProportionalCode" : " ","destRoad" : 555,"destFsac" : 52335,"destCity" : "GREENSBORO","destState" : "NC","equipment" : "U53 ","container" : "E","loadedRate" : 575,"emptyRate" : 0,"loadedCrbId" : "925864000001","emptyCrbId" : "000000000000","loaded90DayVolume" : 0,"loadedVolume" : 0,"empty90DayVolume" : 0,"emptyVolume" : 0,"onRampStation" : null,"offRampStation" : null,"quote" : null,"division" : null,"notes" : null,"equipmentType" : "U","equipmentLength" : 53 }]';
  	return body;
}
    
     public static String getAuthorityLaneInfoIPTest(){
  	String body = '{"resultCode":0,"resultDescription":"Success","result":[{"laneID":null,"bureau":"CSXT","authNum":60504,"expDate":"2020-01-31","stcc":"","stccGrp":"500687049","originRoad":"RJCM","originCity":"RUSSELLVILLE","originState":"KY","originHandlingLine":"","originGrpNumber":"","originGrpCity":"","originGrpState":"","destinRoad":"NS","destinCity":"MANSFIELD","destinState":"OH","destinHandlingLine":"","destinGrpNumber":"","destinGrpCity":"","destinGrpState":"","route":"RJCM MEMJC CSXT CINTI NS","carOwnership":"P","basis":"CAR","newRate":"n/a","newNSFactor":"n/a","expiringRate":"$4,742.00","expiringNSFactor":"$1,606.00","thCarloads":"0","thNsRevenue":"$0","thTotalRevenue":"$0","thTons":"0.0","epCarloads":"0","epTotalRevenue":"$0","epTons":"0.0","epTotalCost":"n/a","epEquipmentCost":"$0","epDaysOnLine":"0.0","epLoadedMiles":"0.0","alkFuelMiles":"463.0"}]}';
    return body;
}
    
    public static String getCS_IM(){
  	String body = '{"resultCode":0,"resultDescription":"Success","result":{"trafficHistoryAllRollingYear":{"carloads":"0","carloadsVsPriorPeriod":"0","carloadsVsPriorPeriodPerc":"100.0%","nsRevenue":"$0","nsRevenueVsPriorPeriod":"$0","nsRevenueVsPriorPeriodPerc":"100.0%","nsRevenuePerCar":"$0","nsRevenueVsPriorPeriodPerCar":"$0","nsRevenueVsPriorPeriodPerCarPerc":"0.0%","nsRevenuePerTon":"$0","totalRevenue":"$0","totalRevenueVsPriorPeriod":"$0","totalRevenueVsPriorPeriodPerc":"100.0%","totalRevenuePerCar":"$0","totalRevenueVsPriorPeriodPerCar":"$0","totalRevenueVsPriorPeriodPerCarPerc":"0.0%","totalRevenuePerTon":"$0","tons":"0","tonsVsPriorPeriod":"0","tonsVsPriorPeriodPerc":"100.0%","tonsPerCar":"0","tonsPerCarVsPriorPeriod":"0","tonsPerCarVsPriorPeriodPerc":"0.0%","nsRevenueWithoutFsc":"$0","nsRevenueWithoutFscVsPriorPeriod":"$0","nsRevenueWithoutFscVsPriorPeriodPerc":"100.0%","nsRevenueWithoutFscPerCar":"$0","nsRevenueWithoutFscPerTon":"$0","nsRevenueWithoutFscPerCarPriorPeriod":"$0","nsRevenueWithoutFscVsPriorPeriodPerCarPerc":"0.0%","nsFuelSurcharge":"$0","nsFuelSurchargeVsPriorPeriod":"$0","nsFuelSurchargeVsPriorPeriodPerc":"100.0%","nsFuelSurchargePerCar":"$0","nsFuelSurchargePerCarVsPriorPeriod":"$0","nsFuelSurchargeVsPriorPeriodPerCarPerc":"0.0%","nsFuelSurchargePerTon":"$0","totalRevenueWithoutFsc":"$0","totalRevenueWithoutFscVsPriorPeriod":"$0","totalRevenueWithoutFscVsPriorPeriodPerc":"100.0%","totalRevenueWithoutFscPerCar":"$0","totalRevenueWithoutFscPerCarVsPriorPeriod":"$0","totalRevenueWithoutFscPerCarVsPriorPeriodPerc":"0.0%","totalRevenueWithoutFscPerTon":"$0","totalFuelSurcharge":"$0","totalFuelSurchargeVsPriorPeriod":"$0","totalFuelSurchargeVsPriorPeriodPerc":"100.0%","totalFuelSurchargePerCar":"$0","totalFuelSurchargePerCarVsPriorPeriod":"$0","totalFuelSurchargePerCarVsPriorPeriodPerc":"0.0%","totalFuelSurchargePerTon":"$0","dateRange":"2018-08-01 - 2019-07-31"},"eyeProfitAllRollingYear":null,"trafficHistoryAllYTD":{"carloads":"0","carloadsVsPriorPeriod":"0","carloadsVsPriorPeriodPerc":"100.0%","nsRevenue":"$0","nsRevenueVsPriorPeriod":"$0","nsRevenueVsPriorPeriodPerc":"100.0%","nsRevenuePerCar":"$0","nsRevenueVsPriorPeriodPerCar":"$0","nsRevenueVsPriorPeriodPerCarPerc":"0.0%","nsRevenuePerTon":"$0","totalRevenue":"$0","totalRevenueVsPriorPeriod":"$0","totalRevenueVsPriorPeriodPerc":"100.0%","totalRevenuePerCar":"$0","totalRevenueVsPriorPeriodPerCar":"$0","totalRevenueVsPriorPeriodPerCarPerc":"0.0%","totalRevenuePerTon":"$0","tons":"0","tonsVsPriorPeriod":"0","tonsVsPriorPeriodPerc":"100.0%","tonsPerCar":"0","tonsPerCarVsPriorPeriod":"0","tonsPerCarVsPriorPeriodPerc":"0.0%","nsRevenueWithoutFsc":"$0","nsRevenueWithoutFscVsPriorPeriod":"$0","nsRevenueWithoutFscVsPriorPeriodPerc":"100.0%","nsRevenueWithoutFscPerCar":"$0","nsRevenueWithoutFscPerTon":"$0","nsRevenueWithoutFscPerCarPriorPeriod":"$0","nsRevenueWithoutFscVsPriorPeriodPerCarPerc":"0.0%","nsFuelSurcharge":"$0","nsFuelSurchargeVsPriorPeriod":"$0","nsFuelSurchargeVsPriorPeriodPerc":"100.0%","nsFuelSurchargePerCar":"$0","nsFuelSurchargePerCarVsPriorPeriod":"$0","nsFuelSurchargeVsPriorPeriodPerCarPerc":"0.0%","nsFuelSurchargePerTon":"$0","totalRevenueWithoutFsc":"$0","totalRevenueWithoutFscVsPriorPeriod":"$0","totalRevenueWithoutFscVsPriorPeriodPerc":"100.0%","totalRevenueWithoutFscPerCar":"$0","totalRevenueWithoutFscPerCarVsPriorPeriod":"$0","totalRevenueWithoutFscPerCarVsPriorPeriodPerc":"0.0%","totalRevenueWithoutFscPerTon":"$0","totalFuelSurcharge":"$0","totalFuelSurchargeVsPriorPeriod":"$0","totalFuelSurchargeVsPriorPeriodPerc":"100.0%","totalFuelSurchargePerCar":"$0","totalFuelSurchargePerCarVsPriorPeriod":"$0","totalFuelSurchargePerCarVsPriorPeriodPerc":"0.0%","totalFuelSurchargePerTon":"$0","dateRange":"2019-01-01 - 2019-08-01"},"eyeProfitAllYTD":null}';
        return body;
}
    public static String getOmegaAuthRenewalsTest(){
        String body = '[ {"id" : 9000001,"quoteNumber" : 0,"section" : 1,"series" : " ","file" : "          ","pricingOfficerId" : "PAZS4","businessType" : "IMC  ","effectiveDate" : "2017-07-11T00:00:00-04:00","expirationDate" : "2017-09-21T00:00:00-04:00","status" : "A","beneficialOwnerNumber" : 418401,"beneficialOwner" : "KING JUICE               ","contractHolderNumber" : 8091,"contractHolder" : "CELTIC INTERNATIONAL LLC ","loaded90DayVolume" : 0,"loadedVolume" : 0,"empty90DayVolume" : 0,"emptyVolume" : 0,"loadedRevenue" : 0.0,"loadedContribution" : 0.0,"emptyRevenue" : 0.0,"emptyContribution" : 0.0,"lanes" : null} ]';
  	return body;
}
    public static String getAuthenticationRESTAPI(){

  String body = '{"access_token" : "a25a6b16-74e1-4912-9380-31da0ff7f6f6","token_type" : "bearer","refresh_token" : "655afdd7-e853-4bb1-8a54-620efc83091f","expires_in" : 1195,"scope" : "read write"}';
  return body;
}
}