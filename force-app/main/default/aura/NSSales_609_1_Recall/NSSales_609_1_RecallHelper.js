({
    checkRecallProcess: function(cmp, event, helper) {
        var oppId = cmp.get("v.recordId");
        console.log("oppId" + oppId);
        var recallAction = "Removed";
        var action = cmp.get("c.checkRecall");
        action.setParams({
            oppId: oppId
        });
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            var state = response.getState();
            if (state == "SUCCESS") {
                //cmp.set("v.showSpinner", false);
                var recallSize = response.getReturnValue();
                console.log('recallSize' +recallSize);
                if (recallSize == 0)
                {
                    cmp.set("v.recallShow", false);
                    cmp.set("v.norecallRequest", true);
                    cmp.set("v.showSpinner", false);
                }
                else
                {
                    this.checkRecallAccess(cmp, event, helper, oppId);
                    //cmp.set("v.recallShow", true);
                }
                console.log("Recall Initiated Successfully");


            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        cmp.set("v.showSpinner", false);
                    }
                } else {
                    console.log("Unknown error");
                    cmp.set("v.showSpinner", false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    checkRecallAccess: function(cmp, event, helper, oppId) {
        console.log("oppId" + oppId);
        var action = cmp.get("c.checkRecallAccess");
        action.setParams({
            oppId: oppId
        });
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            var state = response.getState();
            if (state == "SUCCESS") {
                cmp.set("v.showSpinner", false);
                var accessStatus = response.getReturnValue();
                console.log('accessStatus' +accessStatus);
                if (accessStatus == 'All_609_1_Access')
                {
                    cmp.set("v.recallShow", true);
                    cmp.set("v.norecallAccess", false);
                }
                else if (accessStatus == 'No_Access')
                {
                    cmp.set("v.recallShow", false);
                    cmp.set("v.norecallAccess", true);
                }
                else
                {
                    cmp.set("v.recallShow", false);
                    cmp.set("v.norecallAccess", true);   
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        cmp.set("v.showSpinner", false);
                    }
                } else {
                    console.log("Unknown error");
                    cmp.set("v.showSpinner", false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    callRecallProcessonSubmit: function(cmp, event, helper) {
        var recallComments = cmp.find("recall_comments").get("v.value");
        var oppId = cmp.get("v.recordId");
        console.log("oppId" + oppId);
        console.log("recallComments" + recallComments);
        var recallAction = "Removed";
        var action = cmp.get("c.callRecallProcess");
        action.setParams({
            oppId: oppId,
            approveComments: recallComments,
            approvalAction: recallAction
        });
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            var state = response.getState();
            if (state == "SUCCESS") {
                cmp.set("v.showSpinner", false);
                console.log("Recall Process Initiated Successfully--No waiting");
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Success",
                    "title": "Success!",
                    "message": "Opportunity Recalled successfully."
                });
                toastEvent.fire(); 
                location.reload(true);
                

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        cmp.set("v.showSpinner", false);
                    }
                } else {
                    console.log("Unknown error");
                    cmp.set("v.showSpinner", false);
                }
            }
        });
        $A.enqueueAction(action);
    }
});