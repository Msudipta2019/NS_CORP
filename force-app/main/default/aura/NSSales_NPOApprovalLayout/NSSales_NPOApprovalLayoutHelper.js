({
    fetchVisibility : function(cmp, event, helper, processInstanceWorkItemId) {
        var action = cmp.get('c.getVisibility');
        action.setParams({
            "strRecId":processInstanceWorkItemId
        });
        action.setCallback(this,function(response){
            //console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                var res = response.getReturnValue().split(',');
                var obj = res[0];
                var visibility = res[1];
                console.log("fetchVisibility -- Visibility Returned Succesfully,visibility : " +visibility);
                if (obj === "NPO" && visibility === "true")
                {
                    this.fetchProcessItemDetails(cmp, event, helper, processInstanceWorkItemId);                    
                }
                else
                {
                    cmp.set('v.showSpinner',true);
                    cmp.destroy();
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        cmp.set('v.showSpinner',false);
                    }
                } else {
                    console.log("Unknown error");
                    cmp.set('v.showSpinner',false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    fetchProcessItemDetails : function(cmp, event, helper, processInstanceWorkItemId) {
        var action = cmp.get('c.fetchProcessItemDetails');
        action.setParams({
            "processInstanceWorkItemId":processInstanceWorkItemId
        });
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                //console.log("Details Returned Succesfully" +JSON.stringify(response.getReturnValue()));
                console.log("fetchProcessItemDetails -- Details Returned Succesfully");
                cmp.set('v.pIDetails',response.getReturnValue());
                cmp.set('v.showSpinner',false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        cmp.set('v.showSpinner',false);
                    }
                } else {
                    console.log("Unknown error");
                    cmp.set('v.showSpinner',false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    callApprovalProcessOnApprove : function(cmp, event, helper) {
        var approveComments = cmp.find('approve_comments').get('v.value');
        var processInstanceWorkItemId = cmp.get("v.recordId");
        var approvalAction = "Approve";
        var action = cmp.get('c.callApprovalProcess');
        action.setParams({
            "processInstanceWorkItemId":processInstanceWorkItemId,
            "approveComments" : approveComments,
            "approvalAction" : approvalAction
        });
        action.setCallback(this,function(response){
            //console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log("callApprovalProcessOnApprove -- Approved Successfully" +response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Success",
                    "title": "Success!",
                    "message": "Successfully Approved"
                });
                toastEvent.fire();
                cmp.set('v.showSpinner',false); 
                this.reDirect(cmp, event, helper);
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        cmp.set('v.showSpinner',false);
                    }
                } else {
                    console.log("Unknown error");
                    cmp.set('v.showSpinner',false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    callApprovalProcessOnReject : function(cmp, event, helper) {
        var approveComments = cmp.find('reject_comments').get('v.value');
        var processInstanceWorkItemId = cmp.get("v.recordId");
        var approvalAction = "Reject";
        var action = cmp.get('c.callApprovalProcess');
        action.setParams({
            "processInstanceWorkItemId":processInstanceWorkItemId,
            "approveComments" : approveComments,
            "approvalAction" : approvalAction
        });
        action.setCallback(this,function(response){
            //console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log("callApprovalProcessOnReject -- Rejected Successfully" +response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Success",
                    "title": "Success!",
                    "message": "Successfully Rejected"
                });
                toastEvent.fire();  
                cmp.set('v.showSpinner',false); 
                this.reDirect(cmp, event, helper);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        cmp.set('v.showSpinner',false);
                    }
                } else {
                    console.log("Unknown error");
                    cmp.set('v.showSpinner',false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    callApprovalProcessOnReassign:function(cmp, event, helper) {
        var reassignApprover = cmp.find('reassign_approver').get('v.value');
        var reassignComments = cmp.find("reassign_comments").get("v.value");
        var processInstanceWorkItemId = cmp.get("v.recordId");
        var reassignAction = "Reassigned";
        var action = cmp.get('c.callReassignProcess');
        action.setParams({
            "processInstanceWorkItemId":processInstanceWorkItemId,
            "reassignApprover" : reassignApprover,
            "reassignComments" : reassignComments,
            "reassignAction" : reassignAction
            
        });
        action.setCallback(this,function(response){
            //console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log("callApprovalProcessOnReassign -- Reassigned Successfully" +response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Success",
                    "title": "Success!",
                    "message": "Successfully Reassigned"
                });
                toastEvent.fire();
                cmp.set('v.showSpinner',false); 
                this.reDirect(cmp, event, helper);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        cmp.set('v.showSpinner',false);
                    }
                } else {
                    console.log("Unknown error");
                    cmp.set('v.showSpinner',false);
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    reDirect : function(cmp, event, helper) {
        var ProcessInstanceId = cmp.find("processId").get("v.value");
        console.log("ProcessInstanceId " +ProcessInstanceId);
        var action = cmp.get('c.fetchProcessInstanceStepId');
        action.setParams({
            "ProcessInstanceId":ProcessInstanceId
        });
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                var pId = response.getReturnValue();
                console.log("pId Fetched Successfully " +pId);
                var redirectUrl = "/lightning/r/ProcessInstanceStep/" + pId + "/view";
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": redirectUrl
                });
                urlEvent.fire();
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        cmp.set('v.showSpinner',false);
                    }
                } else {
                    console.log("Unknown error");
                    cmp.set('v.showSpinner',false);
                }
            }
        });
        $A.enqueueAction(action);
        
    }
})