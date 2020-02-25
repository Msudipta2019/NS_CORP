({
    doInit : function(component, event, helper) {
       // helper.parseData(component, event, helper);
        helper.onInit(component, event, helper);
    },
      showSpinner: function(component, event, helper) {
      component.set("v.spinner", true);
   },
    hideSpinner : function(component, event, helper){
           component.set("v.spinner", false);
    }
})