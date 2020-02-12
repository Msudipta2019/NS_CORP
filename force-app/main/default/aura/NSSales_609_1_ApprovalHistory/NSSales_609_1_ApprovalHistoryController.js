({  
    doInit : function(component, event, helper) {  
        component.set('v.showSpinner',true);
        helper.doInit(component, event, helper);       
    },  
    refresh : function(component, event, helper) {  
        component.set('v.showSpinner',true);
        var status = event.getParam("Status");
        var recId = event.getParam("recId");
        console.log('status from Event :'+status);   
        console.log('recId from Event :'+recId);   
        if(status == "Changed")
        {
            helper.reFresh(component, event, helper, recId );  
        }
        else
        {
            component.set('v.showSpinner',false);
        }
    }, 
})