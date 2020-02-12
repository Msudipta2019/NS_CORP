({
    doInit: function(component, event, helper) {
        
        var action = component.get("c.showIDOptyInfo");
        action.setParams({ "oppId" : component.get("v.recordId")});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var respText = response.getReturnValue();
                if(respText != null)
                {
                    respText = JSON.stringify(respText);
                    var resp = JSON.parse(respText);
                    component.set("v.newOpportunity",resp);
                    $A.get('e.force:refreshView').fire();
                }
            }         
            else if (state === "INCOMPLETE") {
                console.log("Incomplete");
            }
                else if (state === "ERROR") {
                    console.log("Error");
                }
                    else {
                        console.log("Unknown error");
                    }
        });
        $A.enqueueAction(action);    
        
    }
})