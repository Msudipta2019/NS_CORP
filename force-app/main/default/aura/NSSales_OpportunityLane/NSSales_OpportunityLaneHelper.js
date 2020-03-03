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
        csvStringResult += 'Name,' +'Oppty Name,' +'Lane ID,' +'Lane Status,'
        +'Shipper,' +'Receiver,'
        +'STCC,' +'STCC Group,' +'Major Group,' +'Minor Group,'
        +'O Road,' +'O City,' +'O State,' +'O Station,' +'O Handling Line,'
        +'O Group Number,' +'O Group City,' +'O Group State,' +'On Ramp,'
        +'D Road,' +'D City,' +'D State,' +'D Station,' +'D Handling Line,'
        +'D Group Number,' +'D Group City,' +'D Group State,' +'Off Ramp,'
        +'Route,' +'Car Ownership,' +'Car Type,'
        +'Min Weight,' +'Rate Basis,' +'Est Vol,' +'Lading,'
        +'Recc/Target Rate,' +'Expiring Thru Rate,'
        +'New Rate,' +'New NS Factor,' +'Active Rate,'
        +'Initial Offer,' +'Final Offer,'
        +'TH Carloads,' +'TH NS Revenue,' +'TH Total Revenue,' +'TH Tons,'
        +'EP Carloads,' +'EP Total Revenue,' +'EP_Tons,' 
        +'EP Total Cost,' +'EP Equip Cost,' +'EP Days Online,' +'EP Loaded Miles,'
        +'Alk Fuel Miles,' +'Carloads Moved';
        csvStringResult += lineDivider;
        // in the keys valirable store fields API Names as a key 
        // must align SOQL query API field sequence with above csv file header line  
        keys = ['Name','Opportunity_Name__c','NSSales_LaneId__c','NSSales_Lane_Status__c',
		'NSSales_Shipper__c','NSSales_Receiver__c',
		'NSSales_STCC__c','STCC_Group__c','NSSales_STCCMajorGroup__c','NSSales_STCCMinorGroup__c',		
		'NSSales_OriginRoad__c','NSSales_OriginCity__c','NSSales_OriginState__c','NSSales_OriginStation__c','NSSales_OriginHandlingLine__c',
		'NSSales_Origin_Group_Number__c','NS_Sales_Origin_Group_City__c','NSSales_Origin_Group_Street__c','NSSales_OnRamp__c',
		'NSSales_DestinRoad__c','NSSales_DestinCity__c','NSSales_DestinState__c','NSSales_DestinStation__c','NSSales_DestinHandlingLine__c',
		'NSSales_Destination_Group_Number__c','NSSales_Destination_Group_City__c','NSSales_Destination_Group_Street__c','NSSales_OffRamp__c',
		'NSSales_Route__c','NSSales_CarOwnership__c','NSSales_CarType__c',
		'NSSales_MinWeight__c','NSSales_Basis__c','NSSales_EstVolume__c','NSSales_Lading__c',
		'NSSales_Recommended_Rate__c','NSSales_Expiring_rate__c',
		'NSSales_New_Rate__c','NSSales_New_NS_Factor__c','NSSales_Rate__c',
		'NSSales_Round_1_Rate__c','NSSales_Final_Rate__c',
		'NSSales_Th_Carloads__c','NSSales_TH_NS_Revenue__c','NSSales_TH_Total_Revenue__c','NSSales_TH_Tons__c',
		'NSSales_EP_Carloads__c','NSSales_EP_Total_Revenue__c','NSSales_EP_Tons__c',
        'NSSales_EP_Total_Cost__c','NSSales_EP_Equip_Cost__c','NSSales_EP_Days_Online__c','NSSales_EP_Loaded_Miles__c',
		'NSSales_Alk_Fuel_Miles__c','NSSales_Carloads_Moved__c'];
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