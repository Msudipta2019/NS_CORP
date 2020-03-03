({
    createMIRecOnAssociatedObject: function(cmp, event, helper) {
        var params = event.getParams();
        var action = cmp.get('c.createMarketIntelAssociatedObjectRec');
        var sourceId = cmp.get("v.recordId");
        var marketIntelRecordId = params.response.id;
        action.setParams({
            "sourceId":sourceId,
            "marketIntelRecordId" : marketIntelRecordId 
        });
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log("Record Inserted Successfully");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
   
    /*******Changes for D-1834 on 18/11/2019**********/
    createMIAssociatedAccountRec: function(cmp, event, helper,accId) {
        var params = event.getParams();
        var marketIntelRecordId = params.response.id;
        //var accId = cmp.find('acc').get('v.value');
        var action = cmp.get('c.createMarketIntelAssociatedAccountRec');
        action.setParams({
            "sourceId":accId,
            "marketIntelRecordId" : marketIntelRecordId 
        });
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log("Record Inserted Successfully");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    handleAccountDetails : function(cmp, event, helper) {
        var sourceId = cmp.get("v.recordId");
        var action = cmp.get('c.findObjectNameFromRecordId'); 
        action.setParams({
            "recordId":sourceId
        });
        
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log("Response Returned Successfully");
                if(response.getReturnValue() === 'Account' ){
                    cmp.set('v.onAccountPage', true);
                    console.log("on Account Record Page ... Div should be deleted");
                    var x = document.getElementById("accDetail"); 
                    x.remove();
                    //x.style.display = "none"; 
                    /***** Code Change for D-1885 - Auto populate Account Classification on Market Intel by Sudipto G **/
                    
                    cmp.set('v.AccId', sourceId);
                    cmp.set('v.accountId', sourceId);
                    this.appfireEvent(cmp, event, helper,0);
                    
                    /******  End of D-1885 Changes  ****/
                }
                else{
                    cmp.set('v.onAccountPage', false);
                }
                var onAccPage = cmp.get('v.onAccountPage');
                console.log("handleLoad --> onAccPage" +onAccPage);
                var selectedSource= cmp.find('Source').get('v.value');
                if(selectedSource == 'Account' && onAccPage){
                    console.log('handleSourceChange -- > Not Account');
                    cmp.set('v.isSourceAcc', false);
                }
                if((cmp.get("v.recordId") == undefined) && (cmp.get("v.source") != "email")){
                    console.log("on handleLoad if footercancel");
                    $A.util.addClass(cmp.find('MIDiv'), 'divmiddle');
                    $A.util.removeClass(cmp.find('footCanc'), 'slds-hide');
                }
                cmp.set('v.showSpinner', false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
        });
         $A.enqueueAction(action);
    },
        /*******End of Changes for D-1834 on 18/11/2019**********/
    
     /***** Code Change for D-1885 - Auto populate Account Classification on Market Intel by Sudipto G **/
    appfireEvent : function(component, event, helper, delStatus) {
        var appEvent = $A.get("e.c:NSSales_lookupField_AccClassificationPopulateChild");
        appEvent.setParams({
            "delOneAccStatus" : delStatus});
        appEvent.fire();
        
        console.log('Event fired in appfireEvent -- Market Intel');
    }
    /******  End of D-1885 Changes  ****/
	/*** delOneAccStatus defination 
	 
		 0 --> Populate the Account Classifcation  
         1 --> Populate for 1 Account Classification for Account
         9 --> For reset after Submit
    	 
         End of delOneAccStatus defination ***/
    
    
})