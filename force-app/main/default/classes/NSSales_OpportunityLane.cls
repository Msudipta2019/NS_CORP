public class NSSales_OpportunityLane {
    
    @AuraEnabled
    public static List <NSSales_Opportunity_Lanes__c> fetchOpportunityLane(Id opptyId) {
       
     List<NSSales_Opportunity_Lanes__c> laneList = 
         [SELECT Id,Name,NSSales_LaneId__c,Opportunity_Name__c,fmlSTCC__c,NSSales_STCC__c,STCC_Group__c,NSSales_OriginRoad__c,NSSales_OriginCity__c,NSSales_OriginState__c,NSSales_DestinRoad__c,NSSales_DestinCity__c,NSSales_DestinState__c,
                NSSales_Route__c,NSSales_Rate__c,NSSales_Recommended_Rate__c,NSSales_Round_1_Rate__c,NSSales_Final_Rate__c,NSSales_Lane_Status__c,
                NSSales_Shipper__c,NSSales_Receiver__c,NSSales_EstVolume__c,NSSales_Committed_Volume__c,Orig_Location__c,Dest_Location__c,
				NSSales_RateSource__c,NSSales_Expiring_rate__c,NSSales_Expiring_NS_Factor__c,
				NSSales_OfferId__c,NSSales_New_Rate__c,NSSales_New_NS_Factor__c,
				NSSales_CompetitionType__c,NSSales_CarType__c,NSSales_CarOwnership__c,NSSales_Carloads_Moved__c,
				NSSales_Origin_Group_Number__c,NS_Sales_Origin_Group_City__c,NSSales_Origin_Group_Street__c,NSSales_OriginStation__c,NSSales_OriginHandlingLine__c,
				NSSales_Destination_Group_Number__c,NSSales_Destination_Group_City__c,NSSales_Destination_Group_Street__c,NSSales_DestinStation__c,NSSales_DestinHandlingLine__c,
				NSSales_Alk_Fuel_Miles__c,NSSales_Basis__c,
                NSSales_EP_Carloads__c,NSSales_EP_Days_Online__c,NSSales_EP_Equip_Cost__c,NSSales_EP_Loaded_Miles__c,NSSales_EP_Total_Cost__c,
                NSSales_EP_Total_Revenue__c,NSSales_EP_Tons__c,NSSales_EstRate__c,NSSales_EstVolumePeriod__c,NSSales_EstVolumeUnits__c,
                NSSales_Lading__c,NSSales_MinCars__c,NSSales_MinCarsPeriod__c,
                NSSales_MinWeight__c,NSSales_MinWeightUnits__c,NSSales_OffRamp__c,NSSales_OnRamp__c,
                NSSales_STCCMajorGroup__c,NSSales_STCCMinorGroup__c,
				NSSales_Th_Carloads__c,NSSales_TH_Tons__c,NSSales_TH_NS_Revenue__c,NSSales_TH_Total_Revenue__c from NSSales_Opportunity_Lanes__c where NSSales_Opportunity__c=: opptyId];
       
        system.debug('laneList'+laneList);
        return laneList;
    }

}