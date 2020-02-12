({
    doInit: function(component, event, helper) {
        component.set("v.showSpinner", true);
        console.log("on doInit");
        var optyRecordId = component.get("v.recordId");
        helper.fetchStageName(optyRecordId, component, event, helper);
        //helper.fetchState(component, event, helper);
    },
    onStateChange: function(component, event, helper) {
        component.set("v.showSpinner", true);
        var selectedState = event.getSource().get("v.value");
        component.set("v.stateSave", selectedState);
        console.log("on onStateChange,slected state" +selectedState);
        
        helper.fetchCounty(component, event, helper,selectedState);
    },
    onCountyChange: function(component, event, helper) {
        component.set("v.showSpinner", true);
        var selectedCounty = event.getSource().get("v.value");
        var selectedState = component.get("v.stateSave");
        component.set("v.countySave", selectedCounty);
        console.log("on onCountyChange,slected county" +selectedCounty);
        console.log("on onCountyChange,slected state" +selectedState);
        
        helper.fetchCity(component, event, helper,selectedCounty,selectedState);
    },
    onCityChange: function(component, event, helper) {
        var selectedCity = event.getSource().get("v.value");
        component.set("v.citySave", selectedCity);
        console.log("on onCityChange,slected city" +selectedCity);
    },
    handleSubmit: function(component, event, helper) {
        component.set("v.showSpinner", true);
        console.log("on handleSubmit,State :" +component.get("v.stateSave"));
        console.log("on handleSubmit,County :" +component.get("v.countySave"));
        console.log("on handleSubmit,City :" +component.get("v.citySave"));
        console.log("on handleSubmit,opratingDivison :" +component.find("operatingDivision").get("v.value"));
        console.log("on handleSubmit,prefix :" +component.find("prefix").get("v.value"));
        console.log("on handleSubmit,suffix :" +component.find("suffix").get("v.value"));
        console.log("on handleSubmit,milepost :" +component.find("milepost").get("v.value"));
        console.log("on handleSubmit,type of milepost :" +typeof component.find("milepost").get("v.value"));
        console.log("on handleSubmit,float value of milepost :" + parseFloat(component.find("milepost").get("v.value")));
        
        if(component.get("v.stateSave") == undefined || component.get("v.countySave") == undefined
           || component.get("v.citySave") == undefined || component.find("operatingDivision").get("v.value") == ""
           || component.find("milepost").get("v.value") == null){
            console.log("In if");  
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title":
                "Error",
                "duration":
                50,  
                "type":
                "error",
                "message": "Please select all the required fields"
            });
            toastEvent.fire();
            component.set("v.showSpinner", false);
        }
        else if(component.find("prefix").get("v.value") == "" && component.find("suffix").get("v.value") == ""){
            console.log("In else if");  
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title":
                "Error",
                "duration":
                50,  
                "type":
                "error",
                "message": "Please select either Prefix or Suffix in order to save the Opportunity"
            });
            toastEvent.fire();
            component.set("v.showSpinner", false);
        }
            else if(component.find("prefix").get("v.value") != "" && component.find("suffix").get("v.value") != ""){
                //Trying for D-1945
                if(component.find("prefix").get("v.value") == "N/A" && component.find("suffix").get("v.value") == "N/A"){
                    console.log("In if for prfix N/A and suffix N/A"); 
                    component.find("prefix").set("v.value", '');
                    component.find("suffix").set("v.value", '');
                    helper.checkMilepostRange(component, event, helper);
                }
                //Trying for D-1945 
               else{
                    console.log("In else if");  
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title":
                        "Error",
                        "duration":
                        50,  
                        "type":
                        "error",
                        "message": "Both Prefix and Suffix cannot be selected at the same time"
                    });
                    toastEvent.fire();
                    component.set("v.showSpinner", false);

                }
            }
                else{
                    console.log("In else"); 
                    helper.checkMilepostRange(component, event, helper);
                }
        
    }
})