({
	closeModal: function(component, event, helper) {
        component.set("v.open_Modal", false); 
    },
    openModal : function(component, event, helper)
    {       
        var equ1 = component.find('enumId').get("v.value"); 
        var equ = equ1.toUpperCase();
       
        if(equ == "" || equ == undefined)//Validation Rule for empty Equipment Id//
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                mode: 'dismissible',                
                type: 'error',
                "message": "Equipment ID cannot be empty.",      
            });
            toastEvent.fire();
            component.set("v.open_Modal", false);   
        }
        else 
        {
            var Strrep = equ.replace(/\D/g, "");
            var digitlen = Strrep.length;
            
            if(digitlen > 6 )//validation rule for more than 6 numeric characters
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: 'dismissible',
                    type: 'error',
                    "message": "Equipment ID has more than 6 numeric characters.",      
                });
                toastEvent.fire();
                component.set("v.open_Modal", false);   
            }
            else{
                var Stralpharep = equ.replace(/[^a-zA-Z]/g, '');
                var alphalen = Stralpharep.length;
                console.log('Alpha Length :' +alphalen);
                if(alphalen > 5 )//validation rule for more than 5 alphabetic characters.
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'dismissible',
                        type: 'error',
                        "message": "Equipment ID has more than 5 alphabetic characters.",      
                    });
                    toastEvent.fire();
                    component.set("v.open_Modal", false);   
                }
                else
                {
                    component.set("v.open_Modal", true);
                    //var eqs = component.find('enumId');
                    //var equz = component.find('enumId').get("v.value");  
                    //var equ = equz.toUpperCase();
                    component.set("v.equiNum", equ);
                    helper.callEquipmentServer(equ,component,event,helper);
                    helper.callLastMoves(equ,component,event,helper);
                }
            }
        }
    },
    sectionOne : function(component, event, helper) {
       helper.helperFun(component,event,'articleOne');
       // helper.callLastMoves(equ,component,event,helper);
    },
    
    onInit : function(component, event, helper) {
       helper.setEquipmentNum(component,event,helper);
     }
})