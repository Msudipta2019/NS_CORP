({
    loadData : function(component, event, helper) {var action=component.get("c.getAuthRenewalData");action.setParams({accId:component.get("v.accountId")}),action.setCallback(this,$A.getCallback(function(e){if("SUCCESS"===(a=e.getState())){component.set("{!v.isLoading}",!1);console.log("Return Value" +e.getReturnValue());var t=JSON.parse(e.getReturnValue());null!=t?(component.set("v.maxPage",Math.floor((t.rows.length+4)/5)),component.set("v.gridData",t),component.set("v.rowData",t.rows),component.set("v.headerList",t.headers),this.reRenderDataTable(component)):console.log("No data from server side")}else if("ERROR"===e.getState()){var a=e.getError();component.set("v.spinner",!1);var o=$A.get("e.force:showToast");o.setParams({title:"Error",duration:12e3,type:"error",message:a[0].message}),o.fire()}})),$A.enqueueAction(action);    },
    callServer:function(r_data,component,event,helper) {console.log(r_data);var action=component.get("c.getOppurtDataAuthRenWB");action.setParams({myMap:{AUTHORITY:r_data[0],CUSTOMER:r_data[1],MANAGER:r_data[2],CARLOADS:r_data[3],REVENUE:r_data[4],EXPDATE:r_data[5],ACC_ID:component.get("v.accountId")}}),action.setCallback(this,function(e){if("SUCCESS"===e.getState()){var a=e.getReturnValue();if(null!=a.Success||null!=a.Success)(r=$A.get("e.force:showToast")).setParams({type:"Success",duration:2e3,message:"Oppurtunity "+a.Success[1]+" has been created!"}),r.fire(),(t=$A.get("e.force:navigateToSObject")).setParams({recordId:a.Success[0],slideDevName:"detail"}),t.fire();else if(null!=a.E||null!=a.E){var t;(r=$A.get("e.force:showToast")).setParams({type:"warning",duration:2e3,message:"Oppurtunity "+a.E[1]+" already exists!"}),r.fire(),(t=$A.get("e.force:navigateToSObject")).setParams({recordId:a.E[0],slideDevName:"detail"}),t.fire()}else if(null!=a.Failure||null!=a.Failure){var r;(r=$A.get("e.force:showToast")).setParams({type:"error",duration:9e3,message:"Record Import failed due to "+a.Failure[0]}),r.fire()}}}),$A.enqueueAction(action);},
    reRenderDataTable: function(component) {var records=component.get("v.rowData"),pageNumber=component.get("v.pageNumber"),pageRecords=records.slice(5*(pageNumber-1),5*pageNumber);component.set("v.sliceOfRowData",pageRecords),component.set("v.filteredpageNumber",1),component.set("v.filteredmaxPage",1),component.set("v.searchResultData","");},
    paginationOfFilteredData: function(component) {var records=component.get("v.searchResultData"),pageNumber=component.get("v.filteredpageNumber"),pageRecords=records.slice(5*(pageNumber-1),5*pageNumber);component.set("v.filteredmaxPage",Math.floor((records.length+4)/5)),component.set("v.sliceOfRowData",pageRecords);},
   
    callAuthorityLaneServer : function(authReqId,expDate,component,event,helper) {
        component.set("v.AuthRenLaneNullCheck",false);
        var controllerMethod = component.get("c.getAuthorityRenewalLaneRequest");
        controllerMethod.setParams({ "reqId" : authReqId,
                                     "expDate" : expDate,
                                     "accId": component.get("v.accountId")
                                   });
        // Configure response handler
        controllerMethod.setCallback(this,$A.getCallback(function(e){
            var t=e.getState();if("SUCCESS"===t){
                
                component.set("v.spinner", false);
                console.log('Spinner : '+component.get("v.spinner"));
                console.log('e.getReturnValue()'+e.getReturnValue());
                var a=JSON.parse(e.getReturnValue());
                if(a == null){ 
                    component.set("v.AuthRenLaneNullCheck",true);
                }
                else{
                    console.log(a),null!=a?(                    
                        component.set("v.gridData1",a),
                        component.set("v.rowData1",a.rows),
                        component.set("v.headerList1",a.headers),
                        this.reRenderDataTable(component)):
                    console.log("No data from server side");
                }  
            }
            
            else if("ERROR"===t)e.getError()}));
        $A.enqueueAction(controllerMethod);      
    }   

})