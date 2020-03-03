({
    doInit: function(component, event, helper) {
     	
        var doInitMethod = component.get("c.CheckAccess");
        doInitMethod.setParams({ "oppId" : component.get("v.recordId")});
        
        doInitMethod.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
            var respText = response.getReturnValue();
            component.set("v.CheckUserAccess",respText);
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
        $A.enqueueAction(doInitMethod);    
        
    },
    
    ConfirmAction : function(component, event, helper) {
        component.set("v.ConfirmModalOpen",true);
        //helper.showHideDiv(component, true);
        var showhide = component.find('showhide');
        $A.util.removeClass(showhide,'slds-show');
        $A.util.addClass(showhide,'slds-hide');
    },
    closeModal: function(component, event, helper)
    {
        $A.get("e.force:closeQuickAction").fire();
    }, 
    
    RecallActionCall: function(component, event, helper){
    var recallComment = component.get("v.CommentOnRecall");
        if(recallComment === '' || recallComment === undefined){
            component.find("comment").set("v.errors", [{
            message:
            	"Please mention the recall comment"}] );
        }
        else{
    var controllerMethod = component.get("c.RecallAction");
        controllerMethod.setParams({ "optyId" : component.get("v.recordId"),
                                    "recallComment" : recallComment});
        
        controllerMethod.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
			$A.get('e.force:refreshView').fire();
            $A.get("e.force:closeQuickAction").fire();
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
        $A.enqueueAction(controllerMethod);    
    }
    }
    
})