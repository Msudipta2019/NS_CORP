/*======================================================================================================
* @Component Name : NSSales_AccountSummaryComponentController
* @author : Accenture
* @Purpose: Parent Component for showing Authority Renewal, Rate/Request Data
* @created date: 23-05-2019
* @Change Logs:									
----------------------------------------------------------------------------------------------------------
Developer name        Date          Description        
----------------------------------------------------------------------------------------------------------
@Arjun Ghosh          23-05-2019    Request No.   , Phase-I
Bundle Created: component,style
==========================================================================================================*/
({
    onInit: function(component, event,helper) {
        console.log("onInit");
        var action = component.get("c.getIntermodalAcc");
        action.setParams({
            accId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var storeResponse = response.getReturnValue();
            var state = response.getState();
            console.log("state" +state);
            console.log("storeResponse" +storeResponse);
            if (storeResponse == 'IM') {
                    component.set("v.isVisibleIP", false);
                component.set("v.isVisibleIM", true);
                } else {
                    component.set("v.isVisibleIP", true);
                    component.set("v.isVisibleIM", false);
                }
            
        });
        $A.enqueueAction(action);
    },
    
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "Closed");
        } else {
            cmp.set('v.activeSectionsMessage',openSections.join(', '));
        }
    },
     custStat: function (cmp) {
         cmp.set('v.isDVisible', !cmp.get('v.isDVisible'));
    }
 
})