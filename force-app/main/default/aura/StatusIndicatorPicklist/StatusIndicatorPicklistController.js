({
    doInit : function(component,event, helper) {
    	
        var fieldname =  component.get("v.fieldName");
        var action = component.get("c.getPickListValuesIntoList");
        console.log('StatusIndicator '+fieldname);
        action.setParams({
            objectType: component.get("v.sObjectName"),
            selectedField: component.get("v.fieldName")
        });
        action.setCallback(this, function(response) {
            var fieldname =  component.get("v.fieldName");
            var list = response.getReturnValue();
            if (fieldname == 'NS_StatusIndicator__c') {
            	component.set("v.StatusIndicatorpicklistValues", list);
            } else  if (fieldname == 'NS_Account_Business_Type__c') {
                component.set("v.AcctBiztypepicklistValues", list);
            } else if (fieldname == 'NS_AssociatedBusinessUnit__c') {
            	console.log('Picklist '+list.length);
		        var items = [];
		        for (var i = 1; i < list.length; i++) {
		            var item = {
		                "label": list[i],
		                "value": list[i],
		            };
		            
		            items.push(item);
		        }
		        
                component.set("v.AcctAsscBussUntpicklistValues", items);
                
            } else {
              component.set("v.StatusIndicatorpicklistValues", list);
            }
            console.log('StatusIndicatorPicklist Finished for '+fieldname);    
        })
        $A.enqueueAction(action);
        
    }

})