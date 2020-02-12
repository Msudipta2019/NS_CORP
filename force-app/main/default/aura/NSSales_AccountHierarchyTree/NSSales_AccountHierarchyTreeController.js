({  
	doInit: function (cmp, event, helper) {  
     	helper.apexMethod(cmp);  
   	},  
    
    handleSelect: function (cmp, event, helper) {  
     	 var recordId = event.getParam('name');
         var sObectEvent = $A.get("e.force:navigateToSObject");
         sObectEvent.setParams({
        	            "recordId": recordId,
                        "slideDevName": "detail"
		});
        sObectEvent.fire();
  	
   	},
    
	expandAll: function (cmp, event, helper) {
        var action = cmp.get("c.expandAllItems");
     	action.setParams({ accountId : cmp.get("v.recordId"),
                          expand : true});  
     	action.setCallback(this, function(response) {  
       		var state = response.getState();  
       		
            if (state === "SUCCESS") {
         		cmp.set( "v.items", response.getReturnValue());  
       		}  
     	});  
     	$A.enqueueAction(action); 
    },
    
    collapseAll: function (cmp, event, helper) {
        helper.apexMethod(cmp);
    }    
 
 })