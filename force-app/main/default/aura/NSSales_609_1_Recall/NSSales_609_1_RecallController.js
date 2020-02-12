({
    doInit: function(component, event, helper) {
        component.set("v.showSpinner", true);
        helper.checkRecallProcess(component, event, helper);
    },
    handleSubmit: function(component, event, helper) {
        component.set("v.showSpinner", true);
        var recallComments = component.find("recall_comments").get("v.value");
        console.log("recallComments-->" + recallComments);
        if (typeof recallComments !== "undefined") {
            helper.callRecallProcessonSubmit(component, event, helper);
        } else {

            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                duration: 50,
                type: "error",
                message: "Comments cannot be left blank"
            });
            component.set("v.showSpinner", false);
            toastEvent.fire();
        }
    }
});