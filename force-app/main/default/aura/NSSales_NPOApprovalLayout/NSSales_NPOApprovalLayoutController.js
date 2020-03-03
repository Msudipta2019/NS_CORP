({
    doInit : function(cmp, event, helper) {
        cmp.set('v.showSpinner',true);
        var processInstanceWorkItemId = cmp.get("v.recordId");
        helper.fetchVisibility(cmp, event, helper, processInstanceWorkItemId);
        
    },
    openApprovalModal : function (cmp, event, helper) { 
        $A.util.removeClass(cmp.find('openApprovalModal'), 'slds-hide');
        $A.util.addClass(cmp.find('openApprovalModal'), 'slds-fade-in-open');
        
    },
    openRejectionModal : function (cmp, event, helper) {
        $A.util.removeClass(cmp.find('openRejectionModal'), 'slds-hide');
        $A.util.addClass(cmp.find('openRejectionModal'), 'slds-fade-in-open');
    },
    openReassignModal : function (cmp, event, helper) {
        $A.util.removeClass(cmp.find('openReassignModal'), 'slds-hide');
        $A.util.addClass(cmp.find('openReassignModal'), 'slds-fade-in-open');
    },
    closeModal : function (cmp, event, helper) { 
        $A.util.addClass(cmp.find('openApprovalModal'), 'slds-hide');
        $A.util.addClass(cmp.find('openRejectionModal'), 'slds-hide');
        $A.util.addClass(cmp.find('openReassignModal'), 'slds-hide');
        
    },
    handleApprove : function (cmp, event, helper) { 
        cmp.set('v.showSpinner',true);
        var approveComments = cmp.find("approve_comments").get("v.value")
        console.log('approve_comments-->'+approveComments);
        
        helper.callApprovalProcessOnApprove(cmp, event, helper);
        $A.util.addClass(cmp.find('openApprovalModal'), 'slds-hide'); 
        
        
    },
    handleReject : function (cmp, event, helper) {
        cmp.set('v.showSpinner',true);
        
        var rejectComments = cmp.find("reject_comments").get("v.value");
        
        
        helper.callApprovalProcessOnReject(cmp, event, helper);
        $A.util.addClass(cmp.find('openRejectionModal'), 'slds-hide');
    },
    handleReassign : function (cmp, event, helper) {
        cmp.set('v.showSpinner',true);
        helper.callApprovalProcessOnReassign(cmp, event, helper);
        $A.util.addClass(cmp.find('openReassignModal'), 'slds-hide');
    },
    
    handleError: function(component, event){
        var errorsArr  = event.getParam("errors");
        for (var i = 0; i < errorsArr.length; i++) {
            console.log("error " + i + ": " + JSON.stringify(errorsArr[i]));
        }
    }
})