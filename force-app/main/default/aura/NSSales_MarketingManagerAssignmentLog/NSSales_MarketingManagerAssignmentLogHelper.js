({
    getLogs : function(component, event, helper){
        var accId = component.get("v.recordId");
        var action = component.get("c.getMarketingManagerAssignmentLog");
        action.setParams({
            accountId : accId
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var logList = response.getReturnValue();
                for (var i = 0; i < logList.length; i++) {
                    var row = logList[i];
                    if (row.NSSales_Account__c) row.CreatedBy = row.CreatedBy.Name;
                }
                component.set("v.data", logList);
                console.log(JSON.stringify(logList));
            }
        });
        $A.enqueueAction(action);
    }
})