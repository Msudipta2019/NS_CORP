({
    convertArrayOfObjectsToCSV : function(component,objectRecords){
       console.log(objectRecords);
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
       
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
         }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';

		//create CSV file header row
        csvStringResult += 'Name,' +'Lane Id,' +'Oppty Name,' +'STCC,' +'STCC Group,' +'O Rd,' +'Origin City,' +'Origin State,' +'D Rd,' +'Destination City,' + 'Destination State,'
            +'Route,' +'Rate,' +'Recc/Target Rate,' +'Round-1 Rate,' +'Final Rate,' +'Lane Status,'
            +'Shipper,' +'Receiver,' +'Est Vol,' +'Committed Vol,' 
			+'Rate Source,'  +'Expiring Rate,' +'Expiring NS Factor,'
			+'Offer Id,' +'New Rate,' +'New NS Factor,' 
			+'Competition Type,' +'Car Type,' +'Car Ownership,' +'Carloads Moved,'
			+'O Group Num,' +'O Group City,' +'O Group Street,' +'O Station,' +'O Handling Line,'
			+'D Group Num,' +'D Group City,' +'D Group Street,' +'D Station,' +'D Handling Line,'
			+'Alk Fuel Miles,' +'Basis,'
            +'EP Carloads,' +'EP Days Online,' +'EP Equip Cost,' +'EP Loaded Miles,' +'EP Total Cost,'
            +'EP Total Revenue,' +'EP Tons,'  +'Est Rate,' +'Est Vol Period,' +'Est Vol Units,' 
            +'Lading,' +'Min Cars,' +'Min Cars Period,'
            +'Min Weight,' +'Min Weight Units,' 
			+'Off-Ramp,' +'On-Ramp,'			
            +'STCC Major Group,' +'STCC Minor Group,' 
			+'Th Carloads,' +'TH Tons,' +'TH NS Revenue,' +'TH Total Revenue';
        csvStringResult += lineDivider;
        // in the keys valirable store fields API Names as a key 
        // must align SOQL query API field sequence with above csv file header line  
        keys = ['Name','NSSales_LaneId__c','Opportunity_Name__c','NSSales_STCC__c','STCC_Group__c','NSSales_OriginRoad__c','NSSales_OriginCity__c','NSSales_OriginState__c','NSSales_DestinRoad__c','NSSales_DestinCity__c','NSSales_DestinState__c',
                'NSSales_Route__c','NSSales_Rate__c','NSSales_Recommended_Rate__c','NSSales_Round_1_Rate__c','NSSales_Final_Rate__c','NSSales_Lane_Status__c',
                'NSSales_Shipper__c','NSSales_Receiver__c','NSSales_EstVolume__c','NSSales_Committed_Volume__c',
				'NSSales_RateSource__c','NSSales_Expiring_rate__c','NSSales_Expiring_NS_Factor__c',
				'NSSales_OfferId__c','NSSales_New_Rate__c','NSSales_New_NS_Factor__c',
				'NSSales_CompetitionType__c','NSSales_CarType__c','NSSales_CarOwnership__c','NSSales_Carloads_Moved__c',
				'NSSales_Origin_Group_Number__c','NS_Sales_Origin_Group_City__c','NSSales_Origin_Group_Street__c','NSSales_OriginStation__c','NSSales_OriginHandlingLine__c',
				'NSSales_Destination_Group_Number__c','NSSales_Destination_Group_City__c','NSSales_Destination_Group_Street__c','NSSales_DestinStation__c','NSSales_DestinHandlingLine__c',
				'NSSales_Alk_Fuel_Miles__c','NSSales_Basis__c',
                'NSSales_EP_Carloads__c','NSSales_EP_Days_Online__c','NSSales_EP_Equip_Cost__c','NSSales_EP_Loaded_Miles__c','NSSales_EP_Total_Cost__c',
                'NSSales_EP_Total_Revenue__c','NSSales_EP_Tons__c','NSSales_EstRate__c','NSSales_EstVolumePeriod__c','NSSales_EstVolumeUnits__c',
                'NSSales_Lading__c','NSSales_MinCars__c','NSSales_MinCarsPeriod__c',
                'NSSales_MinWeight__c','NSSales_MinWeightUnits__c','NSSales_OffRamp__c','NSSales_OnRamp__c',
                'NSSales_STCCMajorGroup__c','NSSales_STCCMinorGroup__c',
				'NSSales_Th_Carloads__c','NSSales_TH_Tons__c','NSSales_TH_NS_Revenue__c','NSSales_TH_Total_Revenue__c'];
        //append csv data rows
		for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                counter++;
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
       	// return the CSV formate String
       	console.log(csvStringResult);
        var finalcsvStringResult = csvStringResult.replace(/undefined/gi," ");
        return finalcsvStringResult;        
    },
})