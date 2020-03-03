({  
    checkVisibility : function(component, event, helper, processInstanceWorkItemId) {
        var action = component.get('c.getObjectRecordType');
        action.setParams({  
            strRecId : component.get("v.recordId")  
        }); 
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                //console.log('Response: ', response.getReturnValue());
                //console.log("Value returned Successfully");
                var res = response.getReturnValue().split(',');
                var oppId = res[0];
                var visibility = res[1];
                console.log("OppId : " +oppId);
                console.log("visibility : " +visibility);
                component.set('v.oppId', oppId);
                component.set('v.visibility', visibility);  
                if(oppId === '' && visibility === "false")
                {
                    component.set('v.showSpinner',false);
                    component.destroy();
                }
                else
                {
                    this.doInit(component, event, helper);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        component.set('v.showSpinner',false);
                    }
                } else {
                    console.log("Unknown error");
                    component.set('v.showSpinner',false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    doInit: function(component, event, helper)   
    {    
        var action = component.get("c.fetchHistory");  
        action.setParams({  
            strRecId : component.get("v.oppId")  
        });  
        action.setCallback(this, function(response) {    
            if(response.getState() === "SUCCESS" && JSON.parse(response.getReturnValue()).success ) {  
                console.log('Approval History returned Succesfully');
                component.set("v.wrapMain", JSON.parse(response.getReturnValue()));  
                var appParent = component.get('v.wrapMain.OpportunityApprovalHistoryInformation');  
                var custs = [];  
                for(var i=0; i < appParent.length; i++)  
                {  
                    for(var j in appParent[i].StepsAndWorkitems)  
                    {  
                        for(var childitems in appParent[i].StepsAndWorkitems[j])  
                        {  
                            custs.push(appParent[i].StepsAndWorkitems[j][childitems]);  
                        }  
                    }  
                }  
                component.set('v.mapvalue', custs);  
            }  
            component.set('v.showSpinner',false);
        });  
        $A.enqueueAction(action);    
    },  
    reFresh: function(component, event, helper, recId)   
    {    
        var action = component.get("c.fetchHistory");  
        action.setParams({  
            strRecId : recId 
        });  
        action.setCallback(this, function(response) {  
            console.log('response.getState()...'+response.getState());  
            console.log('strRecId -> '+recId);  
            if(response.getState() === "SUCCESS" && JSON.parse(response.getReturnValue()).success ) {  
                component.set("v.wrapMain", JSON.parse(response.getReturnValue()));  
                var appParent = component.get('v.wrapMain.OpportunityApprovalHistoryInformation');  
                var custs = [];  
                for(var i=0; i < appParent.length; i++)  
                {  
                    for(var j in appParent[i].StepsAndWorkitems)  
                    {  
                        for(var childitems in appParent[i].StepsAndWorkitems[j])  
                        {  
                            custs.push(appParent[i].StepsAndWorkitems[j][childitems]);  
                        }  
                    }  
                }  
                component.set('v.mapvalue', custs);  
                
            }  
            component.set('v.showSpinner',false);
        });  
        $A.enqueueAction(action);    
    }
})