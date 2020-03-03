({
	fetchopplane : function(component, event, helper) {
        component.set('v.mycolumns', [
            {label: 'Oppty Lane', fieldName: 'linkName', type: 'url',typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
            {label: 'STCC', fieldName: 'fmlSTCC__c', type: 'text'},
            //{label: 'STCC Group', fieldName: 'STCC_Group__c', type: 'text'},
            {label: 'Origin', fieldName: 'Orig_Location__c', type: 'text'},
            {label: 'Destination', fieldName: 'Dest_Location__c', type: 'text'},
            {label: 'Route', fieldName: 'NSSales_Route__c', type: 'text'},
            {label: 'Recc/Target Rate', fieldName: 'NSSales_Recommended_Rate__c', type: 'text'},
            {label: 'Initial Offer', fieldName: 'NSSales_Round_1_Rate__c', type: 'text'},
            {label: 'Final Offer', fieldName: 'NSSales_Final_Rate__c', type: 'text'},
            {label: 'Lane Status', fieldName: 'NSSales_Lane_Status__c', type: 'text'},
            {label: 'Est Vol', fieldName: 'NSSales_EstVolume__c', type: 'text'},
            {label: 'Current Vol', fieldName: 'NSSales_Committed_Volume__c', type: 'text'}
        ]);
        var action = component.get("c.fetchOpportunityLane");
        action.setParams({opptyId:component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                var records =response.getReturnValue();
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                component.set("v.laneList", records);
            }
        });
        $A.enqueueAction(action);
    },
    
    downloadCsv : function(component,event,helper){
        var stockData = component.get("v.laneList");
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,stockData);   
         if (csv == null){return;} 
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
	     var hiddenElement = document.createElement('a');
          hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
          hiddenElement.target = '_self'; // 
          hiddenElement.download = 'OpportunityLane.csv';  // CSV file Name* you can change it.[only name not .csv] 
          document.body.appendChild(hiddenElement); // Required for FireFox browser
    	  hiddenElement.click(); // using click() js function to download csv file
        }, 
})