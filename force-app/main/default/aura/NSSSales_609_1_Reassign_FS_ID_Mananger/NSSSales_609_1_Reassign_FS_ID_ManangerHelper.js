({
    fetchStageName : function(optyRecordId, component, event, helper) {
        var action = component.get('c.fetchStageName');
        action.setParams({
            "optyRecordId": optyRecordId
        });
        action.setCallback(this,function(response){
            var status = response.getState();
            if(status == "SUCCESS"){ 
                var result = response.getReturnValue();
                console.log('Stage Name-->' +result.StageName);
                if (result.StageName === 'Qualification/Analysis')
                {
                    console.log('Stage-->' +result.StageName);
                }
                else
                {
                    component.set('v.showSpinner',false);
                    component.destroy();
                }
            }
            else if (status === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        component.set('v.showSpinner',false);
                    }
                } else {
                    console.log("Unknown error");
                    component.set('v.showSpinner',false);
                }
            }
        });
        $A.enqueueAction(action);
    },
	initiate_609_1_ApprovalProcess : function(optyRecordId,component, event, helper) {
        var action = component.get('c.initiate_609_1_ApprovalProcess');
        action.setParams({
            "optyRecordId": optyRecordId
        });
        action.setCallback(this,function(response){
            var status = response.getState();
            if(status == "SUCCESS"){ 
                console.log("Approval Process triggered Successfully");
                component.set("v.showSpinner", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title":
                    "Success",
                    "duration":
                    50,  
                    "type":
                    "success",
                    "message": "Submitted for Approval"
                });
                toastEvent.fire();
                location.reload(true);
                
            }
            else if (status === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    updateOptyStage : function(optyRecordId,component, event, helper) {
        var action = component.get('c.updateOptyStage');
        action.setParams({
            "optyRecordId": optyRecordId
        });
        action.setCallback(this,function(response){
            var status = response.getState();
            if(status == "SUCCESS"){ 
                console.log("Opty Stage Changed Successfully");
                this.initiate_609_1_ApprovalProcess(optyRecordId, component, event, helper);
                
            }
            else if (status === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})