({
    doInit : function(component, event, helper) {
        
        console.log("on doInit 2");
        console.log(component.get("v.recordId"));
        var optyRecordId = component.get("v.recordId");
        helper.fetchStageName(optyRecordId, component, event, helper);
        
    },
    handleSubmit: function(component, event, helper) {
        component.set("v.showSpinner", true);
        console.log("on SAVEEE"); 
        
    },
    handleSuccess: function(component, event, helper) {
        component.set("v.showSpinner", true);
        console.log("on Success");   
        var optyId = component.get("v.recordId");
        helper.updateOptyStage(optyId, component, event, helper);
    }
})