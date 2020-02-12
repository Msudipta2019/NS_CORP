({
    fetchOptyId : function(cmp, event, helper, processInstanceWorkItemId) {
        var action = cmp.get('c.fetchOpportunityId');
        action.setParams({
            "processInstanceWorkItemId":processInstanceWorkItemId
        });
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                cmp.set('v.optyRecordId', response.getReturnValue());
                console.log("Value returned Successfully");
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
    fetchApprovalStatus : function(cmp, event, helper, processInstanceId) {
        var action = cmp.get('c.fetchApprovalStatus');
        action.setParams({
            "processInstanceId":processInstanceId
        });
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                cmp.set('v.approvalStatus', response.getReturnValue());
                console.log("Approval Status : "+response.getReturnValue());
                var status = response.getReturnValue();
                if (status=='Pending')
                {
                    $A.util.removeClass(cmp.find("pending"), 'slds-hide');
                    $A.util.removeClass(cmp.find("approvalbutton"), 'slds-hide');
                    $A.util.removeClass(cmp.find("pendingspan"), 'slds-hide');
                }
                else if (status=='Approved')
                {
                    $A.util.removeClass(cmp.find("approved"), 'slds-hide');
                    $A.util.removeClass(cmp.find("approvedspan"), 'slds-hide');
                }
                    else if (status=='Rejected')
                    {
                        $A.util.removeClass(cmp.find("rejected"), 'slds-hide');
                        $A.util.removeClass(cmp.find("rejectedspan"), 'slds-hide');
                    }
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
        console.log("In fetchApprovalStatus, status -->"+status);
        return status; 
    },
    fetchfinalApprovalStatus : function(cmp, event, helper, processInstanceId) {
        var action = cmp.get('c.fetchApprovalStatus');
        action.setParams({
            "processInstanceId":processInstanceId
        });
        action.setCallback(this,function(response){
            console.log('fetchApprovalStatus '+response.getReturnValue());
            var state = response.getState();
            var status = response.getReturnValue();
            if(state == "SUCCESS"){
                console.log("In callApprovalProcessOnApprove, status -->"+status);
                $A.util.addClass(cmp.find("approvalbutton"), 'slds-hide');
                if (status=='Approved')
                {
                    console.log("In callApprovalProcessOnApprove, on if Approved stat  -->"+status);
                    $A.util.addClass(cmp.find("pending"), 'slds-hide');
                    $A.util.addClass(cmp.find("pendingspan"), 'slds-hide');
                    $A.util.removeClass(cmp.find("approved"), 'slds-hide');
                    $A.util.removeClass(cmp.find("approvedspan"), 'slds-hide');
                    
                }
                var appEvent = $A.get("e.c:NSSales_609_1_ApprovalStatusChange");
                appEvent.setParams({
                    "Status" : "Changed"  ,
                	"recId" :  cmp.get("v.optyRecordId")});
                appEvent.fire();
                console.log('Event fired in fetchfinalApprovalStatus');
                cmp.set('v.showSpinner',false);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Success",
                    "title": "Success!",
                    "message": "Successfully Removed"
                });
                toastEvent.fire(); 
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
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log("Process callApprovalProcessOnApprove Successfully");
                var processInstanceId = cmp.get("v.processInstanceId");
                this.fetchfinalApprovalStatus(cmp, event, helper, processInstanceId);

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
    
    callApprovalProcessOnReject : function(cmp, event, helper,opty_609_1_status_Rejection) {
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
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log("Process Initiated Successfully");
                this.updateOptyOnReject(cmp, event, helper, opty_609_1_status_Rejection);
                $A.util.addClass(cmp.find("pending"), 'slds-hide');
                $A.util.addClass(cmp.find("approvalbutton"), 'slds-hide');
                $A.util.addClass(cmp.find("pendingspan"), 'slds-hide');
                $A.util.removeClass(cmp.find("rejected"), 'slds-hide');
                $A.util.removeClass(cmp.find("rejectedspan"), 'slds-hide');
                
                cmp.set('v.showSpinner',false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Success",
                    "title": "Success!",
                    "message": "Successfully Retained"
                });
                toastEvent.fire(); 
                var appEvent = $A.get("e.c:NSSales_609_1_ApprovalStatusChange");
                appEvent.setParams({
                    "Status" : "Changed" ,
                	"recId" :  cmp.get("v.optyRecordId")});
                appEvent.fire();
                console.log('Event fired in callApprovalProcessOnReject');
                
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
    
    updateOptyOnReject : function(cmp, event, helper, opty_609_1_status_Rejection) {
     //   var processInstanceWorkItemId = cmp.get("v.recordId");
        var optyRecordId = cmp.get("v.optyRecordId");
        // var opty_609_1_status_Rejection = cmp.find("opty_609_1_status_Rejection").get("v.value");
        var action = cmp.get('c.updateOpportunityOnReject');
        action.setParams({
            "optyRecordId":optyRecordId,
            "rejectStatus": opty_609_1_status_Rejection
        });
        
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log("Opportunity Updated Succesfully");
                
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
                console.log("Details Returned Succesfully");
                cmp.set('v.pIDetails',response.getReturnValue());
            }
            else if (state === "ERROR") {
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
    
    
    fetchprocessInstanceId : function(cmp, event, helper, processInstanceWorkItemId) {
        var action = cmp.get('c.fetchprocessInstanceId');
        action.setParams({
            "processInstanceWorkItemId":processInstanceWorkItemId
        });
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log("ProcessInstanceId Returned Succesfully");
                var processInstanceId = response.getReturnValue();
                cmp.set('v.processInstanceId',processInstanceId);
                this.fetchApprovalStatus(cmp, event, helper, processInstanceId);
            }
            else if (state === "ERROR") {
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
    
    
    popluteApprovalDecisionOnApprove : function(cmp, event, helper) {
       // var processInstanceWorkItemId = cmp.get("v.recordId");
        var optyRecordId = cmp.get("v.optyRecordId");
        var action = cmp.get('c.popluteApprovalDecisionOnApprove');
        action.setParams({
            "optyRecordId":optyRecordId
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log(response.getReturnValue());
            console.log('state :' +state);
            if(state == "SUCCESS"){
                console.log("Opportunity Recommendations Updated Succesfully");
                this.callApprovalProcessOnApprove(cmp, event, helper);
               
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