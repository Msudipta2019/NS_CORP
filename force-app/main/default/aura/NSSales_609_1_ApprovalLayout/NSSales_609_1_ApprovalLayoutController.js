({
    doInit : function(cmp, event, helper) {
        cmp.set('v.showSpinner',true);
        var processInstanceWorkItemId = cmp.get("v.recordId");
        helper.fetchprocessInstanceId(cmp, event, helper, processInstanceWorkItemId);
        helper.fetchProcessItemDetails(cmp, event, helper, processInstanceWorkItemId);
        helper.fetchOptyId(cmp, event, helper, processInstanceWorkItemId);
        // helper.fetchApprovalStatus(cmp, event, helper, processInstanceWorkItemId);
    },
    openApprovalModal : function (cmp, event, helper) { 
        $A.util.removeClass(cmp.find('openApprovalModal'), 'slds-hide');
        $A.util.addClass(cmp.find('openApprovalModal'), 'slds-fade-in-open');
        // cmp.find("opty_609_1_status_Approval").set("v.value", 'Approved for Removal');
        
    },
    openRejectionModal : function (cmp, event, helper) {
        $A.util.removeClass(cmp.find('openRejectionModal'), 'slds-hide');
        $A.util.addClass(cmp.find('openRejectionModal'), 'slds-fade-in-open');
        // cmp.find("opty_609_1_status_Rejection").set("v.value", 'None');
    },
    closeModal : function (cmp, event, helper) { 
        $A.util.addClass(cmp.find('openApprovalModal'), 'slds-hide');
        $A.util.addClass(cmp.find('openRejectionModal'), 'slds-hide');
        
    },
    handleApprove : function (cmp, event, helper) { 
        cmp.set('v.showSpinner',true);
        var approveComments = cmp.find("approve_comments").get("v.value")
        console.log('approve_comments-->'+approveComments);
        if(typeof approveComments !== 'undefined'){
            helper.popluteApprovalDecisionOnApprove(cmp, event, helper);
            $A.util.addClass(cmp.find('openApprovalModal'), 'slds-hide'); 
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title":
                "Error",
                "duration":
                50,  
                "type":
                "error",
                "message": "Comments cannot be left blank"
            });
            toastEvent.fire();  
        }
    },
    handleReject : function (cmp, event, helper) {
        cmp.set('v.showSpinner',true);
        var opty_609_1_status_Rejection = cmp.find("opty_609_1_status_Rejection").get("v.value");
        var rejectComments = cmp.find("reject_comments").get("v.value");
        console.log('opty_609_1_status_Rejection-->'+opty_609_1_status_Rejection);
        if(opty_609_1_status_Rejection != "" && typeof rejectComments !== 'undefined'){
            //  helper.updateOptyOnReject(cmp, event, helper, opty_609_1_status_Rejection);
            helper.callApprovalProcessOnReject(cmp, event, helper,opty_609_1_status_Rejection);
            $A.util.addClass(cmp.find('openRejectionModal'), 'slds-hide');
        }
         else if(typeof rejectComments === 'undefined'){
            console.log('Inside else');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title":
                "Error",
                "duration":
                50,  
                "type":
                "error",
                "message": "Comments cannot be left blank"
            });
            toastEvent.fire();
        }
        else if(opty_609_1_status_Rejection == ""){
            console.log('Inside else');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title":
                "Error",
                "duration":
                50,  
                "type":
                "error",
                "message": "Please select a Retain Reason"
            });
            toastEvent.fire();
        }
    },
    
    handleError: function(component, event){
        var errorsArr  = event.getParam("errors");
        for (var i = 0; i < errorsArr.length; i++) {
            console.log("error " + i + ": " + JSON.stringify(errorsArr[i]));
        }
    }
})