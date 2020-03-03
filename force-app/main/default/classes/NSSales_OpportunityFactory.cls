/*
Description  : This class is a factory Class for Creating Opportunity.
Developer    : Accenture Solutions
Date         : 19-06-2019
*/
public class NSSales_OpportunityFactory {
    
    Static Final String GENOPTYRECTYPE = 'General Opportunity';    
    Static Final String Success = 'Success';
    Static Final String Failure = 'Failure';
    Static Final String EXISTS = 'E';
    Static Final String Stage = 'Qualification/Analysis';
    Static Final String OriginatingDepartmentAutomotive='Automotive';
    Static Final String OriginatingDepartment = 'Industrial Products';
    Static Final String RequestId = 'REQ_ID';
    Static Final String RequestNumber = 'REQ_NUM';
    Static Final String Account = 'ACC_ID'; 
    Static Final String Authority = 'AUTHORITY';
    Static Final String ExpDate = 'EXPDATE';
    
    /*  public static  Map<String,String> createOppurtDataFromRateRequest(Map<String,String> rateRequestMap,NSSales_WonLaneInfoWrapper laneWrapper){

Map<String,String> response = new Map<String,String>(); 
Set<String> originCitySet = new Set<String>();
Set<String> originRoadSet = new Set<String>();
Set<String> originStateSet = new Set<String>();
Set<String> destinCitySet = new Set<String>();
Set<String> destinRoadSet = new Set<String>();
Set<String> destinStateSet = new Set<String>();
String originCity;
String originRoad;
String originState;
String destinationCity;
String destinationRoad;
String destinationState;
String stcc;
List<NSSales_Opportunity_Lanes__c> listOptyLane = new List<NSSales_Opportunity_Lanes__c>();
try{
List<Opportunity> oppty =[Select id,name,NS_WB_RequestID__c from Opportunity where NS_WB_RequestID__c =:rateRequestMap.get(RequestId)];
//Added By Pranay
for(NSSales_WonLaneInfoWrapper.result objt : laneWrapper.result){
originCitySet.add(objt.originCity);
originRoadSet.add(objt.originRoad);
originStateSet.add(objt.originState);
destinCitySet.add(objt.destinCity);
destinRoadSet.add(objt.destinRoad);
destinStateSet.add(objt.destinState);
stcc = objt.stcc;
}


if(originCitySet.size() == 1){
originCity = new List<String> (originCitySet).get(0); 
}
else if(originCitySet.size() > 1){
originCity = 'Various';
}

if(originRoadSet.size() == 1){
originRoad = new List<String> (originRoadSet).get(0); 
}
else if(originRoadSet.size() > 1){
originRoad = 'Various';
}
if(originStateSet.size() == 1){
originState = new List<String> (originStateSet).get(0); 
}
else if(originStateSet.size() > 1){
originState = 'Various';
}

if(destinCitySet.size() == 1){
destinationCity = new List<String> (destinCitySet).get(0); 
}
else if(destinCitySet.size() > 1){
destinationCity = 'Various';
}
if(destinRoadSet.size() == 1){
destinationRoad = new List<String> (destinRoadSet).get(0); 
}
else if(destinRoadSet.size() > 1){
destinationRoad = 'Various';
}
if(destinStateSet.size() == 1){
destinationState = new List<String> (destinStateSet).get(0); 
}
else if(destinStateSet.size() > 1){
destinationState = 'Various';
}

if(oppty.IsEmpty()){ 
Opportunity opp = new Opportunity();
opp.Name = 'Test';
opp.AccountId = rateRequestMap.get(Account);
opp.NS_Originating_Department__c = OriginatingDepartment;
opp.StageName = Stage;
opp.NS_WB_RequestID__c = rateRequestMap.get(RequestId);
opp.NS_WB_RequestNum__c = rateRequestMap.get(RequestNumber);
opp.CloseDate = System.Today();
opp.NS_Origin_City__c = originCity;
opp.NS_Origin_Carrier__c = originRoad;
opp.Origin_State__c = originState;
opp.NS_Destination_City__c = destinationCity;
opp.NS_Destination_Carrier__c = destinationRoad;
opp.NS_Destination_State__c = destinationState;
opp.NS_Commodity_STCC__c = stcc;
opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GENOPTYRECTYPE).getRecordTypeId();
insert opp;
system.debug(opp.id);

for(NSSales_WonLaneInfoWrapper.result objt : laneWrapper.result){

NSSales_Opportunity_Lanes__c optylanes = new NSSales_Opportunity_Lanes__c(
NSSales_LaneId__c = objt.laneId,
NSSales_OfferId__c = objt.offerId,
NSSales_RequestId__c = objt.requestId,
NSSales_Shipper__c = objt.shipper,
NSSales_Receiver__c = objt.receiver,
NSSales_OriginRoad__c = objt.originRoad,
NSSales_OriginStation__c = objt.originStation,
NSSales_OriginCity__c = objt.originCity,
NSSales_OriginState__c = objt.originState,
NSSales_OriginHandlingLine__c = objt.originHandlingLine,
NSSales_DestinRoad__c = objt.destinRoad,
NSSales_DestinStation__c = objt.destinStation,
NSSales_DestinCity__c = objt.destinCity,
NSSales_DestinState__c = objt.destinState,
NSSales_DestinHandlingLine__c = objt.destinHandlingLine,
NSSales_STCC__c = objt.stcc,
NSSales_STCCMajorGroup__c = objt.stccMajorGroup,
NSSales_STCCMinorGroup__c = objt.stccMinorGroup,
NSSales_Route__c = objt.route,
NSSales_EstVolume__c = objt.estVolume,
NSSales_EstVolumeUnits__c = objt.estVolumeUnits,
NSSales_EstVolumePeriod__c = objt.estVolumePeriod,
NSSales_EstRate__c = objt.estRate,
NSSales_CompetitionType__c = objt.competitionType,
NSSales_CarOwnership__c = objt.carOwnership,
NSSales_CarType__c = objt.carType,
NSSales_MinWeight__c = objt.minWeight,
NSSales_MinWeightUnits__c = objt.minWeightUnits,
NSSales_MinCars__c = objt.minCars,
NSSales_MinCarsPeriod__c = objt.minCarsPeriod,
NSSales_Lading__c = objt.lading,
NSSales_Basis__c = objt.basis,
NSSales_Rate__c = objt.rate,
NSSales_PrivateRate__c = objt.privateRate,
NSSales_RateSource__c = objt.rateSource,
NSSales_Opportunity__c = opp.Id);

listOptyLane.add(optylanes);
}

if(!listOptyLane.isEmpty()){
insert listOptyLane;
}

response.put(Success,opp.Id); 
}
else{
response.put(EXISTS,oppty[0].Id); 
}
}
catch (Exception ex){
response.put(Failure,ex.getMessage()); 
}

System.debug('Response' +response);
return response;
}
*/
    
    /* Author - Pranay Banerjee
Method - This method is added to create "NSSales_Opportunity_Lanes__c" record from Lane Information
*/
  /*  public static  Map<String,String> createOppurtDataFromRateRequestAndLane(Map<String,String> rateRequestMap,NSSales_WonLaneInfoWrapper laneWrapper){
        
        Map<String,String> response = new Map<String,String>(); 
        List<NSSales_Opportunity_Lanes__c> listOptyLane = new List<NSSales_Opportunity_Lanes__c>();
        
        try{
            List<Opportunity> oppty =[Select id,name,NS_WB_RequestID__c,NSSales_Opportunity_Number__c from Opportunity where NS_WB_RequestID__c =:rateRequestMap.get(RequestId)];
            
            
            if(oppty.IsEmpty()){ 
                Opportunity opp = new Opportunity();
                opp.Name = 'Test';
                opp.AccountId = rateRequestMap.get(Account);
                opp.NS_Originating_Department__c = OriginatingDepartment;
                opp.StageName = Stage;
                opp.NS_WB_RequestID__c = rateRequestMap.get(RequestId);
                opp.NS_WB_RequestNum__c = rateRequestMap.get(RequestNumber);
                opp.CloseDate = System.Today();
                
                opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GENOPTYRECTYPE).getRecordTypeId();
                insert opp;
                system.debug(opp.id);
                
                for(NSSales_WonLaneInfoWrapper.result objt : laneWrapper.result){
                    
                    NSSales_Opportunity_Lanes__c optylanes = new NSSales_Opportunity_Lanes__c(
                        NSSales_LaneId__c = objt.laneId,
                        NSSales_OfferId__c = objt.offerId,
                        NSSales_RequestId__c = objt.requestId,
                        NSSales_Shipper__c = objt.shipper,
                        NSSales_Receiver__c = objt.receiver,
                        NSSales_OriginRoad__c = objt.originRoad,
                        NSSales_OriginStation__c = objt.originStation,
                        NSSales_OriginCity__c = objt.originCity,
                        NSSales_OriginState__c = objt.originState,
                        NSSales_OriginHandlingLine__c = objt.originHandlingLine,
                        NSSales_DestinRoad__c = objt.destinRoad,
                        NSSales_DestinStation__c = objt.destinStation,
                        NSSales_DestinCity__c = objt.destinCity,
                        NSSales_DestinState__c = objt.destinState,
                        NSSales_DestinHandlingLine__c = objt.destinHandlingLine,
                        NSSales_STCC__c = objt.stcc,
                        NSSales_STCCMajorGroup__c = objt.stccMajorGroup,
                        NSSales_STCCMinorGroup__c = objt.stccMinorGroup,
                        NSSales_Route__c = objt.route,
                        NSSales_EstVolume__c = objt.estVolume,
                        NSSales_EstVolumeUnits__c = objt.estVolumeUnits,
                        NSSales_EstVolumePeriod__c = objt.estVolumePeriod,
                        NSSales_EstRate__c = objt.estRate,
                        NSSales_CompetitionType__c = objt.competitionType,
                        NSSales_CarOwnership__c = objt.carOwnership,
                        NSSales_CarType__c = objt.carType,
                        NSSales_MinWeight__c = objt.minWeight,
                        NSSales_MinWeightUnits__c = objt.minWeightUnits,
                        NSSales_MinCars__c = objt.minCars,
                        NSSales_MinCarsPeriod__c = objt.minCarsPeriod,
                        NSSales_Lading__c = objt.lading,
                        NSSales_Basis__c = objt.basis,
                        NSSales_Rate__c = objt.rate,
                        NSSales_PrivateRate__c = objt.privateRate,
                        NSSales_RateSource__c = objt.rateSource,
                        //NSSales_Initial_Offer__c = objt.initialOffer,
                        NSSales_Round_1_Rate__c = objt.initialOffer,
                        //NSSales_Final_Offer__c = objt.finalOffer,
                        NSSales_Final_Rate__c = objt.finalOffer,
                        NSSales_Lane_Status__c = objt.laneStatus,
                        NSSales_Carloads_Moved__c =objt.carloadsMoved,
                        NSSales_Opportunity__c = opp.Id);
                    
                    listOptyLane.add(optylanes);
                }
                
                if(!listOptyLane.isEmpty()){
                    insert listOptyLane;
                }
                
                response.put(Success,opp.NSSales_Opportunity_Number__c); 
            }
            else{
                response.put(EXISTS,oppty[0].NSSales_Opportunity_Number__c); 
            }
        }
        catch (Exception ex){
            response.put(Failure,ex.getMessage()); 
        }
        
        System.debug('Response' +response);
        return response;
    }*/
    public static  Map<String,List<String>> createOppurtDataFromRateRequestAndLane(Map<String,String> rateRequestMap,NSSales_WonLaneInfoWrapper laneWrapper){
        
        Map<String,List<String>> response = new Map<String,List<String>>(); 
	List<String> values= new List<String>();
        List<NSSales_Opportunity_Lanes__c> listOptyLane = new List<NSSales_Opportunity_Lanes__c>();
        
        try{
            List<Opportunity> oppty =[Select id,name,NS_WB_RequestID__c,NSSales_Opportunity_Number__c from Opportunity where NS_WB_RequestID__c =:rateRequestMap.get(RequestId)];
            
            
            if(oppty.IsEmpty()){ 
                Opportunity opp = new Opportunity();
                opp.Name = 'Test';
                opp.AccountId = rateRequestMap.get(Account);
                opp.NS_Originating_Department__c = OriginatingDepartment;
                opp.StageName = Stage;
                opp.NS_WB_RequestID__c = rateRequestMap.get(RequestId);
                opp.NS_WB_RequestNum__c = rateRequestMap.get(RequestNumber);
                opp.CloseDate = System.Today();
                
                opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GENOPTYRECTYPE).getRecordTypeId();
                insert opp;
                system.debug(opp.id);
                values.add(opp.id);
                List<Opportunity> opputy =[Select id,NSSales_Opportunity_Number__c from Opportunity where id =:opp.id];
                values.add(opputy[0].NSSales_Opportunity_Number__c);
                for(NSSales_WonLaneInfoWrapper.result objt : laneWrapper.result){
                    
                    NSSales_Opportunity_Lanes__c optylanes = new NSSales_Opportunity_Lanes__c(
                        NSSales_LaneId__c = objt.laneId,
                        NSSales_OfferId__c = objt.offerId,
                        NSSales_RequestId__c = objt.requestId,
                        NSSales_Shipper__c = objt.shipper,
                        NSSales_Receiver__c = objt.receiver,
                        NSSales_OriginRoad__c = objt.originRoad,
                        NSSales_OriginStation__c = objt.originStation,
                        NSSales_OriginCity__c = objt.originCity,
                        NSSales_OriginState__c = objt.originState,
                        NSSales_OriginHandlingLine__c = objt.originHandlingLine,
                        NSSales_DestinRoad__c = objt.destinRoad,
                        NSSales_DestinStation__c = objt.destinStation,
                        NSSales_DestinCity__c = objt.destinCity,
                        NSSales_DestinState__c = objt.destinState,
                        NSSales_DestinHandlingLine__c = objt.destinHandlingLine,
                        NSSales_STCC__c = objt.stcc,
                        NSSales_STCCMajorGroup__c = objt.stccMajorGroup,
                        NSSales_STCCMinorGroup__c = objt.stccMinorGroup,
                        NSSales_Route__c = objt.route,
                        NSSales_EstVolume__c = objt.estVolume,
                        NSSales_EstVolumeUnits__c = objt.estVolumeUnits,
                        NSSales_EstVolumePeriod__c = objt.estVolumePeriod,
                        NSSales_EstRate__c = objt.estRate,
                        NSSales_CompetitionType__c = objt.competitionType,
                        NSSales_CarOwnership__c = objt.carOwnership,
                        NSSales_CarType__c = objt.carType,
                        NSSales_MinWeight__c = objt.minWeight,
                        NSSales_MinWeightUnits__c = objt.minWeightUnits,
                        NSSales_MinCars__c = objt.minCars,
                        NSSales_MinCarsPeriod__c = objt.minCarsPeriod,
                        NSSales_Lading__c = objt.lading,
                        NSSales_Basis__c = objt.basis,
                        NSSales_Rate__c = objt.rate,
                        NSSales_PrivateRate__c = objt.privateRate,
                        NSSales_RateSource__c = objt.rateSource,
                        //NSSales_Initial_Offer__c = objt.initialOffer,
                        NSSales_Round_1_Rate__c = objt.initialOffer,
                        //NSSales_Final_Offer__c = objt.finalOffer,
                        NSSales_Final_Rate__c = objt.finalOffer,
                        NSSales_Lane_Status__c = objt.laneStatus,
                        NSSales_Carloads_Moved__c =objt.carloadsMoved,
                        NSSales_Opportunity__c = opp.Id);
                    
                    listOptyLane.add(optylanes);
                }
                
                if(!listOptyLane.isEmpty()){
                    insert listOptyLane;
                }
                
                response.put(success,values); 
            }
            else{
                values.add(oppty[0].id);
                values.add(oppty[0].NSSales_Opportunity_Number__c);
                response.put(EXISTS,values); 
            }
        }
        catch (Exception ex){
	    values.add(ex.getMessage());
            response.put(failure,values); 
        }
        
        System.debug('Response' +response);
        return response;
    }
    public static  Map<String,List<String>> createOppurtDataFromAuthorityRenewal(Map<String,String> AuthorityRenewalMap){
        
        Map<String,List<String>> response = new Map<String,List<String>>(); 
        List<String> values= new List<String>();
        try{
            List<Opportunity> oppty =[Select id,name,NS_WB_RequestID__c,NSSales_Opportunity_Number__c from Opportunity where NS_WB_RequestID__c =:AuthorityRenewalMap.get(Authority)];
            
            if(oppty.IsEmpty()){ 
                Opportunity opp = new Opportunity();
                opp.Name = 'Test';
                opp.AccountId = AuthorityRenewalMap.get(Account);
                opp.NS_Originating_Department__c = OriginatingDepartment;
                opp.StageName = Stage;
                DateTime yourDate = Date.valueOf(AuthorityRenewalMap.get(ExpDate));
				String dateOutput = yourDate.format('MMddyyyy');
				System.debug('Debug: '+dateOutput);
                opp.NS_WB_RequestID__c = AuthorityRenewalMap.get(Authority)+' '+dateOutput; //set null as these aren't technically rate requests
                opp.NS_WB_RequestNum__c = AuthorityRenewalMap.get(Authority)+' '+dateOutput;
                opp.CloseDate = System.Today();
                opp.Type ='Renewal';
                opp.NS_Expiration_Notification_Timeframe__c = 90;
                opp.NSSales_Rate_Renewal_Expiration_Date__c =Date.valueOf(AuthorityRenewalMap.get(ExpDate));
                opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GENOPTYRECTYPE).getRecordTypeId();
                system.debug('Date:'+Date.valueOf(AuthorityRenewalMap.get(ExpDate)));
                insert opp;
                system.debug('Test:'+opp.id);
                values.add(opp.id);
                List<Opportunity> opputy =[Select id,NSSales_Opportunity_Number__c from Opportunity where id =:opp.id];
                values.add(opputy[0].NSSales_Opportunity_Number__c);
                response.put(success,values); 
            }
            else{
                values.add(oppty[0].id);
                values.add(oppty[0].NSSales_Opportunity_Number__c);
                response.put(EXISTS,values); 
            }
        }
        catch (Exception ex){
            values.add(ex.getMessage());
            response.put(failure,values); 
        }
        
        System.debug('Response' +response);
        return response;
        
    }
    
    /* Author- Pranay Banerjee */
    /* Method - This method is used to create Opportunity and assosiate Opportunity Lane when Opportunity is created from
Authority Renewal for IP Account */ 
    
    public static  Map<String,List<String>> createOppurtDataFromAuthorityRenewalIP(Map<String,String> AuthorityRenewalMap,NSSales_AuthorityLaneInfoWrapper laneWrapperIP){
        
        Map<String,List<String>> response = new Map<String,List<String>>(); 
        List<String> values= new List<String>();
        String dateOutput = AuthorityRenewalMap.get(ExpDate).substring(5,7)+
                    				AuthorityRenewalMap.get(ExpDate).substring(8,10)+
                    				AuthorityRenewalMap.get(ExpDate).substring(0,4);
                System.debug('Debug - dateoutput : '+dateOutput);
        List<NSSales_Opportunity_Lanes__c> listOptyLane = new List<NSSales_Opportunity_Lanes__c>();
        try{
            List<Opportunity> oppty =[Select id,name,NS_WB_RequestID__c,NSSales_Opportunity_Number__c from Opportunity where NS_WB_RequestNum__c =:AuthorityRenewalMap.get(Authority)+' '+dateOutput];
            
            if(oppty.IsEmpty()){ 
                Opportunity opp = new Opportunity();
                opp.Name = 'Test';
                opp.AccountId = AuthorityRenewalMap.get(Account);
                opp.NS_Originating_Department__c = OriginatingDepartment;
                opp.StageName = Stage;
                //DateTime yourDate = Date.valueOf(AuthorityRenewalMap.get(ExpDate));
                //String dateOutput = yourDate.format('MMddyyyy');
                				
                opp.NS_WB_RequestID__c = AuthorityRenewalMap.get(Authority)+' '+dateOutput; //set null as these aren't technically rate requests
                opp.NS_WB_RequestNum__c = AuthorityRenewalMap.get(Authority)+' '+dateOutput;
                opp.CloseDate = System.Today();
                opp.Type ='Renewal';
                opp.NS_Expiration_Notification_Timeframe__c = 90;
                opp.NSSales_Rate_Renewal_Expiration_Date__c =Date.valueOf(AuthorityRenewalMap.get(ExpDate));
                opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GENOPTYRECTYPE).getRecordTypeId();
                system.debug('Date:'+Date.valueOf(AuthorityRenewalMap.get(ExpDate)));
                insert opp;
                system.debug('Test:'+opp.id);
                values.add(opp.id);
                List<Opportunity> opputy =[Select id,NSSales_Opportunity_Number__c from Opportunity where id =:opp.id];
                values.add(opputy[0].NSSales_Opportunity_Number__c);
                
                for(NSSales_AuthorityLaneInfoWrapper.result objt : laneWrapperIP.result){
                    NSSales_Opportunity_Lanes__c optyLane = new NSSales_Opportunity_Lanes__c(
                        NSSales_LaneId__c = objt.laneID,
                        NSSales_STCC__c = objt.stcc,
                        STCC_Group__c = objt.stccGrp,
                        NSSales_OriginRoad__c = objt.originRoad,
                        NSSales_OriginCity__c = objt.originCity,
                        NSSales_OriginState__c = objt.originState,
                        NSSales_OriginHandlingLine__c = objt.originHandlingLine,
                        NSSales_Origin_Group_Number__c = objt.originGrpNumber,
                        NS_Sales_Origin_Group_City__c = objt.originGrpCity,
                        NSSales_Origin_Group_Street__c = objt.originGrpState,
                        NSSales_DestinRoad__c = objt.destinRoad,
                        NSSales_DestinCity__c = objt.destinCity,
                        NSSales_DestinState__c = objt.destinState,
                        NSSales_DestinHandlingLine__c = objt.destinHandlingLine,
                        NSSales_Destination_Group_Number__c = objt.destinGrpNumber,
                        NSSales_Destination_Group_City__c = objt.destinGrpCity,
                        NSSales_Destination_Group_Street__c = objt.destinGrpState,
                        NSSales_Route__c = objt.route,
                        NSSales_CarOwnership__c = objt.carOwnership,
                        NSSales_Basis__c = objt.basis, 
                        NSSales_New_Rate__c = objt.newRate,
                        NSSales_New_NS_Factor__c = objt.newNSFactor,
                        NSSales_Expiring_rate__c = objt.expiringRate,
                        NSSales_Expiring_NS_Factor__c = objt.expiringNSFactor,
                        NSSales_Th_Carloads__c = objt.thCarloads,
                        NSSales_TH_NS_Revenue__c = objt.thNsRevenue,
                        NSSales_TH_Total_Revenue__c = objt.thTotalRevenue,
                        NSSales_TH_Tons__c = objt.thTons,
                        NSSales_EP_Carloads__c = objt.epCarloads,
                        NSSales_EP_Total_Revenue__c = objt.epTotalRevenue,
                        NSSales_EP_Tons__c = objt.epTons,
                        NSSales_EP_Total_Cost__c = objt.epTotalCost,
                        NSSales_EP_Equip_Cost__c = objt.epEquipmentCost,
                        NSSales_EP_Days_Online__c = objt.epDaysOnline,
                        NSSales_EP_Loaded_Miles__c = objt.epLoadedMiles,
                        NSSales_Alk_Fuel_Miles__c = objt.alkFuelMiles,
                        NSSales_Opportunity__c = opp.id); 
                    listOptyLane.add(optyLane);
                }
                if(!listOptyLane.isEmpty()){
                    insert listOptyLane;
                }
                response.put(success,values); 
            }
            else{
                values.add(oppty[0].id);
                values.add(oppty[0].NSSales_Opportunity_Number__c);
                response.put(EXISTS,values); 
            }
        }
        catch (Exception ex){
            values.add(ex.getMessage());
            response.put(failure,values); 
        }
        
        System.debug('Response' +response);
        return response;
        
    }
    
    /* Author- Pranay Banerjee */
    /* Method - This method is used to create Opportunity and assosiate Opportunity Lane when Opportunity is created from
Authority Renewal for IM Account */ 
    
  /*  public static  Map<String,List<String>> createOppurtDataFromAuthorityRenewalIM(Map<String,String> AuthorityRenewalMap,NSSales_RenewalLaneWrapper laneWrapperIM){
        
        Map<String,List<String>> response = new Map<String,List<String>>(); 
        List<String> values= new List<String>();
        List<NSSales_Opportunity_Lanes__c> listOptyLane = new List<NSSales_Opportunity_Lanes__c>();
        try{
            List<Opportunity> oppty =[Select id,name,NS_WB_RequestID__c,NSSales_Opportunity_Number__c from Opportunity where NS_WB_RequestID__c =:AuthorityRenewalMap.get(Authority)];
            
            if(oppty.IsEmpty()){ 
                Opportunity opp = new Opportunity();
                opp.Name = 'Test';
                opp.AccountId = AuthorityRenewalMap.get(Account);
                opp.NS_Originating_Department__c = OriginatingDepartment;
                opp.StageName = Stage;
                opp.NS_WB_RequestID__c = ''; //set null as these aren't technically rate requests
                opp.NS_WB_RequestNum__c = AuthorityRenewalMap.get(Authority);
                opp.CloseDate = System.Today();
                opp.Type ='Renewal';
                opp.NS_Expiration_Notification_Timeframe__c = 90;
                opp.NSSales_Rate_Renewal_Expiration_Date__c =Date.valueOf(AuthorityRenewalMap.get(ExpDate));
                opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GENOPTYRECTYPE).getRecordTypeId();
                system.debug('Date:'+Date.valueOf(AuthorityRenewalMap.get(ExpDate)));
                insert opp;
                system.debug('Test:'+opp.id);
                values.add(opp.id);
                List<Opportunity> opputy =[Select id,NSSales_Opportunity_Number__c from Opportunity where id =:opp.id];
                values.add(opputy[0].NSSales_Opportunity_Number__c);
                
                for(NSSales_RenewalLaneWrapper.result objt : laneWrapperIM.result){
                    NSSales_Opportunity_Lanes__c optyLane = new NSSales_Opportunity_Lanes__c(
                        NSSales_OriginRoad__c = objt.originRoad,
                        NSSales_OriginCity__c = objt.originCity,
                        NSSales_OriginState__c = objt.originState,
                        NSSales_DestinRoad__c = objt.destRoad,
                        NSSales_DestinCity__c = objt.destCity,
                        NSSales_DestinState__c = objt.destState,
                        NSSales_EP_Equip_Cost__c = objt.equipment,
                        NSSales_EstVolume__c = objt.volume,
                        NSSales_Opportunity__c = opp.id); 
                    listOptyLane.add(optyLane);
                }
                if(!listOptyLane.isEmpty()){
                    insert listOptyLane;
                }
                response.put(success,values); 
            }
            else{
                values.add(oppty[0].id);
                values.add(oppty[0].NSSales_Opportunity_Number__c);
                response.put(EXISTS,values); 
            }
        }
        catch (Exception ex){
            values.add(ex.getMessage());
            response.put(failure,values); 
        }
        
        System.debug('Response' +response);
        return response;
        
    } */
    
    
    public static  Opportunity  createOpportunityForHelper(){
        
        Try{
            // Creating an account for Opportunity
            Account acc = new Account(
                RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerBusiness' AND 
                                SobjectType ='Account' Limit 1].id,
                Name='AccountForOppotunity');
            insert acc;
            // Creating New Account Classification
            
            // Creating a New Opportunity
            Opportunity oppNew = new Opportunity();
            oppNew.Name = 'Test';
            oppNew.AccountId = acc.Id;
            oppNew.NS_Originating_Department__c = OriginatingDepartmentAutomotive;
            oppNew.NS_Origin_Station__c='Test'; 
            oppNew.StageName = Stage;                
            oppNew.CloseDate = System.Today();
            oppNew.NS_Estimated_Volume__c=50;
            oppNew.NS_Destination_Station__c='Test123';
            oppNew.NSSales_Commodity_Group__c='Test123';
            oppNew.Projected_Start_Date__c=System.Today();
            oppNew.NS_Contract_Start_Date__c=System.Today();
            oppNew.NS_Destination_State__c='Test';
            oppNew.Frequency__c='Weekly';
            oppNew.NSSales_Spot_Contract__c='Spot';
            oppNew.NSSales_Need_by_Date__c=System.Today();
            oppNew.NS_Origin_City__c='Kolkata';
            oppNew.NSSales_Route__c='Test';
            oppNew.NS_Destination_City__c='Kolkata';
            oppNew.Consignee__c=acc.id;                
            oppNew.NSSales_Shipper__c=acc.id;
            oppNew.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('General Opportunity').getRecordTypeId();
            insert oppNew; 
            
            return oppNew;
        }
        catch (Exception ex)
        {
            
            return null; 
        }
    }    
}