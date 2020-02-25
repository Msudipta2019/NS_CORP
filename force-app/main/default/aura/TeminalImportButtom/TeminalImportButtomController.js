({
	importTerminal : function(component, event, helper) {
        var controllerMethod = component.get("c.importTeminal");
        controllerMethod.setCallback(this,$A.getCallback(function(e){
            var t=e.getState();if("SUCCESS"===t){          
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Terminal Account imported successfully',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();     
            }
            
            else if("ERROR"===t){
       var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message: 'Terminal Account imported successfully',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
            }
            }));
              
                
        $A.enqueueAction(controllerMethod);  
    }
})