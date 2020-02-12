({  
    doInit: function(component, event, helper)   
    {    
        var action = component.get("c.init");  
        action.setParams({  
            strRecId : component.get("v.recordId")  
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
        var action = component.get("c.init");  
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