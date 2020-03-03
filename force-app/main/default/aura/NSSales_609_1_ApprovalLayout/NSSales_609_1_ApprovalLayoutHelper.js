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
                this.checkIfApprover(cmp, event, helper, cmp.get('v.optyRecordId'));
                console.log("Value returned Successfully");
                //cmp.set('v.showSpinner',false);
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
    fetchObjectId : function(cmp, event, helper, objectId) {
        var action = cmp.get('c.setProcessInstanceWorkitemId');
        action.setParams({
            "objectId":objectId
        });
        action.setCallback(this,function(response){
            console.log("Response  : " +response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                var res = response.getReturnValue().split(',');
                var pId = res[0];
                var isOppPage = res[1];
                console.log("Process Instance workitemId : " +pId);
                console.log("isOppPage : " +isOppPage);
                cmp.set('v.processInstanceWorkItemId', pId);
                cmp.set('v.isOppPage', isOppPage);
                console.log("Value returned Successfully");
                if(pId == '')
                {
                    cmp.set('v.showSpinner',false);
                    cmp.destroy();
                }
                else
                {
                    this.fetchprocessInstanceId(cmp, event, helper, cmp.get('v.processInstanceWorkItemId'));
                    //this.fetchProcessItemDetails(cmp, event, helper, cmp.get('v.processInstanceWorkItemId'));
                    //this.fetchOptyId(cmp, event, helper, cmp.get('v.processInstanceWorkItemId'));
                    //cmp.set('v.showSpinner',false);
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
                this.fetchProcessItemDetails(cmp, event, helper, cmp.get('v.processInstanceWorkItemId'));
                //cmp.set('v.showSpinner',false);
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
                if(cmp.get('v.isOppPage') === "true")
                {
                    location.reload(true);
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
    
    callApprovalProcessOnApprove : function(cmp, event, helper) {
        var approveComments = cmp.find('approve_comments').get('v.value');
        //var processInstanceWorkItemId = cmp.get("v.recordId");
        var processInstanceWorkItemId = cmp.get("v.processInstanceWorkItemId");
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
        //var processInstanceWorkItemId = cmp.get("v.recordId");
        var processInstanceWorkItemId = cmp.get("v.processInstanceWorkItemId");
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
                if(cmp.get('v.isOppPage') === "true")
                {
                    location.reload(true);
                }
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
                this.fetchOptyId(cmp, event, helper, cmp.get('v.processInstanceWorkItemId'));
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
    },
    
    checkIfApprover : function(cmp, event, helper, objectId) {
        var action = cmp.get('c.checkApprover');
        action.setParams({
            "objectId":objectId
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('in populateApprovers method-->'+JSON.stringify(response.getReturnValue()));
            console.log('state :' +state);
            if(state == "SUCCESS"){
                console.log("Opportunity Approvers Fetched Succesfully");
                cmp.set("v.approver",response.getReturnValue());
                if(cmp.get("v.approver"))
                {
                    $A.util.removeClass(cmp.find("approvalbutton"), 'slds-hide');
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
    }
})