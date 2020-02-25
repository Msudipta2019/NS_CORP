({
	    
    fetchState : function(component, event, helper) {
        var action = component.get('c.fetchState');
        action.setCallback(this,function(response){
            var status = response.getState();
            //alert("MYNAME"+status);
            if(status == "SUCCESS"){ 
                console.log("State returned Successfully");
                var result = response.getReturnValue();
                console.log("result" +result);
                /*
                result = result.map(u => ({NSSales_State_Name__c: u.NSSales_State_Name__c}));
                var jsonObject = result.map(JSON.stringify); 
                var uniqueSet = new Set(jsonObject); 
                var uniqueArray = Array.from(uniqueSet).map(JSON.parse); 
                //console.log("State :" +JSON.stringify(uniqueArray));
                
                component.set('v.state', uniqueArray);
                */
                component.set('v.state', result);
                component.set('v.showSpinner',false);
            }
            else if (status === "ERROR") {
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
    fetchCounty : function(component, event, helper,selectedState) {
        var action = component.get('c.fetchCounty');
        action.setParams({
            "state": selectedState
        });
        action.setCallback(this,function(response){
            var status = response.getState();
            if(status == "SUCCESS"){ 
                console.log("County returned Successfully");
                var result = response.getReturnValue();
                result = result.map(u => ({NSSales_County_Name__c: u.NSSales_County_Name__c}));
                var jsonObject = result.map(JSON.stringify); 
                var uniqueSet = new Set(jsonObject); 
                var uniqueArray = Array.from(uniqueSet).map(JSON.parse); 
                //console.log("County :" +JSON.stringify(uniqueArray));
                component.set('v.county', uniqueArray);
                component.set('v.showSpinner',false);
            }
            else if (status === "ERROR") {
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
    fetchCity : function(component, event, helper,selectedCounty,selectedState) {
        var action = component.get('c.fetchCity');
        action.setParams({
            "county": selectedCounty,
            "state" : selectedState
        });
        action.setCallback(this,function(response){
            var status = response.getState();
            if(status == "SUCCESS"){ 
                console.log("City returned Successfully");
                var result = response.getReturnValue();
                //sconsole.log("city :" +JSON.stringify(result));
                component.set('v.city', result);
                component.set('v.showSpinner',false);
            }
            else if (status === "ERROR") {
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
    changeOptyStageOn_609_1_LocationSelect : function(component, event, helper, operatingDivision, prefix, suffix, milepost) {
        var optyRecordId = component.get("v.recordId")
        var selectedState = component.get("v.stateSave");
        var selectedCounty = component.get("v.countySave");
        var selectedCity = component.get("v.citySave");               
        var action = component.get('c.changeOptyStageOn_609_1_LocationSelect');
        action.setParams({
            "optyRecordId": optyRecordId,
            "selectedState" : selectedState,
            "selectedCounty" : selectedCounty,
            "selectedCity" : selectedCity,
            "operatingDivision" : operatingDivision,
            "prefix" : prefix,
             "suffix" : suffix,
            "milepost" : milepost
        });
        action.setCallback(this,function(response){
            var status = response.getState();
            if(status == "SUCCESS"){ 
                //this.initiate_609_1_ApprovalProcess(optyRecordId,component, event, helper);
                //alert("submitted");
                 var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Success!!!",
                        "message": "This Record has been updated successfully."
                    });
                  toastEvent.fire();
                console.log("Opportunity Stage Changed Successfully");
                $A.get('e.force:refreshView').fire();
            }
            else if (status === "ERROR") {
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
      checkMilepostRange : function(component, event, helper) {
        
        var operatingDivision = component.find("operatingDivision").get("v.value");
        var prefix = component.find("prefix").get("v.value");
        var suffix = component.find("suffix").get("v.value");
        var milepost = component.find("milepost").get("v.value");
        console.log('operatingDivision in 609-->'+operatingDivision);
        var action = component.get('c.checkMilepostRange');
        action.setParams({
            "operatingDivision" : operatingDivision,
            "prefix" : prefix,
            "suffix" : suffix,
            "milepost" : milepost
        });
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            var status = response.getState();
            if(status == "SUCCESS"){ 
                console.log("Milepost validated successfully");
                //component.set("v.isValidMilepost", response.getReturnValue());
                if(response.getReturnValue() == true){
                    this.changeOptyStageOn_609_1_LocationSelect(component, event, helper, operatingDivision, prefix, suffix, milepost);
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title":
                        "Error",
                        "duration":
                        50,  
                        "type":
                        "error",
                        "message": "Please provide a valid milepost number"
                    });
                    toastEvent.fire();
                    component.set("v.showSpinner", false);
                }
            }
            else if (status === "ERROR") {
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
    }
})