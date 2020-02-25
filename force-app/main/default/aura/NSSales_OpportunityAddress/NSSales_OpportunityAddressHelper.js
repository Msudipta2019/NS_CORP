({
    fetchMap : function(cmp, event, helper,optyId) {
        var city;
        var street;
        var state;
       
        var action = cmp.get("c.getaddress");
        
        //console.log("id2 "+rec);
        action.setParams({
            "optyRecordId": optyId            
        });   
        action.setCallback(this,function(response){
            var status = response.getState();
            console.log("Sudipta"+status+optyId);
            if (response.getState() === "SUCCESS"){
                var respText = response.getReturnValue();
                var respJson = JSON.stringify(respText);
                console.log(respJson);
                var oppodetails = JSON.parse(respJson);
                city=oppodetails.NSSales_City__c;
                street=oppodetails.NSSales_Street__c;
                state=oppodetails.NSSales_State__c;
                var checkview=cmp.get("v.truthy");
               
                 if(checkview==false)
                 {
               cmp.find("streetOppty").set("v.value",street);
               cmp.find("cityOppty").set("v.value",city);
               cmp.find("stateOppty").set("v.value",state);
                 }
               if(checkview==true)
               {
                cmp.set("v.Addressdetails",street+','+city+','+state);
               }
                
                console.log(city);
                this.addressfetch(cmp,event,helper,city, street, state);    
                console.log(state);
            }
            
            
        });
        
        $A.enqueueAction(action);
        
    },
    addressfetch: function(cmp,event,helper,city, street, state)
    {
        console.log("City name"+city+"STREET"+street+"STATE"+state);  
        cmp.set('v.mapMarkers', [
            {
                location: {
                    Street: street,
                    City: city,
                    State: state
                },
                
            }
        ]);
        cmp.set('v.zoomLevel', 16);
    },
    saveMaprecord : function(cmp, event, helper) {
        var optyRecordId = cmp.get("v.recordId")
        var stateDetails = cmp.find("stateOppty").get("v.value");
        var streetDetails = cmp.find("streetOppty").get("v.value");
        var cityDetails = cmp.find("cityOppty").get("v.value");
        if(stateDetails!=''&&streetDetails!=''&&cityDetails!='')
        {
            this.addressfetch(cmp,event,helper,cityDetails, streetDetails, stateDetails);
            console.log("Details"+optyRecordId+stateDetails+streetDetails+cityDetails);
            
            var action = cmp.get('c.optymapaddress');
            action.setParams({
                "optyRecordId": optyRecordId,
                "streetDetails" : streetDetails,
                "cityDetails" : cityDetails,
                "stateDetails" : stateDetails
            });   
            
            action.setCallback(this,function(response){
                var status = response.getState();
                if(status == "SUCCESS"){ 
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Success!!!",
                        "message": "This Record has been updated successfully."
                    });
                    toastEvent.fire();
                    cmp.set("v.Addressdetails",streetDetails+','+cityDetails+','+stateDetails);
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
        }//end of if statement
        else{           
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "Please fill Shipping Street,Shipping city and Shipping state details."
                });
                toastEvent.fire();
            } 
    }
})