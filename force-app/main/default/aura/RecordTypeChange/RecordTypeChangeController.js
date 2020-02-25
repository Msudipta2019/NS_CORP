({
    ConvertAction: function(component, event, helper) {
        
        var action = component.get("c.opportunityConvert");
        action.setParams({ "oppId" : component.get("v.recordId")});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var respText = response.getReturnValue();
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
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
        
    },
    closeModal: function(component, event, helper)
    {
        $A.get("e.force:closeQuickAction").fire();
    }
})