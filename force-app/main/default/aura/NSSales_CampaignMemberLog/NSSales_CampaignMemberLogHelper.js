({
    // Fetch the accounts from the Apex controller
    getAccountList: function(component) {
        var action = component.get('c.getLogs');
        var artId = component.get("v.recordId");
        action.setParams({
            "artId":artId
        });
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                $A.get('e.force:refreshView').fire();
                var internalcampMemberList = response.getReturnValue();
                for (var i = 0; i < internalcampMemberList.length; i++) {
                    var row = internalcampMemberList[i];
                    row.CreatedBy1 = row.CreatedBy.Name;
                }
                component.set("v.intMemberlogs", internalcampMemberList);
            }
        });
        $A.enqueueAction(action);
    },
    
    getCampaignMemberMethod : function(component, event, helper){
        var artId = component.get("v.recordId");
        var action = component.get("c.getCampaignMemberLogs");
        action.setParams({
            artId : artId
        });
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                var campMemberList = response.getReturnValue();
                for (var i = 0; i < campMemberList.length; i++) {
                    var row = campMemberList[i];
                    //console.log('row' +JSON.stringify(row));
                    if(row.NSSales_Action__c == 'Campaign Member Removed')
                    {
                        row.CreatedBy2 = row.CreatedBy.Name;
                    }
                    else
                    {
                        row.CreatedBy2 = '';
                    }
                    
                }
                component.set("v.campMemberlogs", campMemberList);
            }
        });
        $A.enqueueAction(action);
    }
})