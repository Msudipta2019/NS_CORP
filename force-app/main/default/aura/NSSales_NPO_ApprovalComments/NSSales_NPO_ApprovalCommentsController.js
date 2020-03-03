({
    doInit : function(cmp, event, helper) {
        cmp.set('v.showSpinner',true);
        var objectId = cmp.get("v.recordId");
        helper.fetchVisibility(cmp, event, helper, objectId);
    },
})