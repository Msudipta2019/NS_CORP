({
    //reRenderDataTable: function(component) {var records=component.get("v.rowData"),pageNumber=component.get("v.pageNumber"),pageRecords=records.slice(5*(pageNumber-1),5*pageNumber);component.set("v.sliceOfRowData",pageRecords),component.set("v.filteredpageNumber",1),component.set("v.filteredmaxPage",1),component.set("v.searchResultData","");},
    helperFun : function(component,event,secId) {
        var acc = component.find(secId);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    },
    
    setEquipmentNum : function(component,event,helper) {
        var action = component.get("c.setEquipNum");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this,$A.getCallback(function(response){
            var state=response.getState();
            if(state == "SUCCESS"){
                component.find('enumId').set("v.value",response.getReturnValue());
            }
            
            else if(state == "ERROR")e.getError()
                }));
        $A.enqueueAction(action);
        
    },

    callEquipmentServer:function(equ,component,event,helper) {
        var controllerMethod = component.get("c.getEquipmentData");
        controllerMethod.setParams({ "equId" : equ});
        // Configure response handler
        controllerMethod.setCallback(this,$A.getCallback(function(e){
            var t=e.getState();if("SUCCESS"===t){
                var response = e.getReturnValue();
                var a=JSON.parse(e.getReturnValue());
                a.forEach(function(record) {
                    if (record.etg) {
                        record.etg = record.etg.replace(" ", "T")+'00+00:00';
                    }
                    if (record.eta) {
                        record.eta = record.eta.replace(" ", "T")+'00+00:00';
                    }
                    if (record.deliverBy) {
                        record.deliverBy = record.deliverBy.replace(" ", "T")+'00+00:00';
                    }
                    if (record.waybillSerialNumber) {
                        //record.waybillSerialNumber = record.waybillSerialNumber.substring(5);
                        record.waybillSerialNumber = record.waybillSerialNumber;
                    }
                    
                    //*********Added By Gunjari for D-1851 : 11/11/2019************//
                    
                    var isEquipmentLate = "NA";
                    if(record.etg != undefined && record.eta != undefined)
                    {
                        var currentDETG = new Date(record.etg);
                        var scheduledAVl = new Date(record.eta);
                        //  var scheduledAVl = new Date('Oct 23 2019 17:51:00');
                        var seconds = Math.floor((scheduledAVl - currentDETG)/1000);
                        if(seconds<0){
                            seconds = seconds*(-1);
                            isEquipmentLate = "YES";
                            record.shipmentStatus = "LATE ";
						}
                        else if(seconds==0){
                            seconds = seconds*(-1);
                            isEquipmentLate = "NO";
                            record.shipmentStatus = "ON TIME ";
						}
                        else{
                            isEquipmentLate = "NO";
                            record.shipmentStatus = "EARLY ";
                        }
                        
                        var minutes = Math.floor(seconds/60);
                        var hours = Math.floor(minutes/60);
                        var days = Math.floor(hours/24);
                        
                        hours = hours-(days*24);
                        minutes = minutes-(days*24*60)-(hours*60);
                        // seconds = seconds-(days*24*60*60)-(hours*60*60)-(minutes*60);
                        record.shipmentStatus = record.shipmentStatus + " (" + days + " Days, " + hours + " Hours, " +  minutes + " Mins)"; 
                        record.classStatus = isEquipmentLate;
                    }
                    record.classStatus = isEquipmentLate;
                    
                    console.log("isEquipmentLate-->"+isEquipmentLate);
                    //console.log("classStatus -->"+record.classStatus);
                    
                    //*********End of changes for D-1851 ************//
                });
                component.set("v.List1",a);
            }
            
            else if("ERROR"===t)e.getError()
        }));
        $A.enqueueAction(controllerMethod);
    },
    
    callLastMoves:function(equ,component,event,helper) {
        var controllerMethod = component.get("c.getLastMoves");
        controllerMethod.setParams({ "equId" : equ});
        // Configure response handler
        controllerMethod.setCallback(this,$A.getCallback(function(e){
            var t=e.getState();if("SUCCESS"===t){
                var a=JSON.parse(e.getReturnValue());
                console.log(a),null!=a?(
                    component.set("v.gridData1",a),
                    component.set("v.rowData1",a.rows),
                    component.set("v.headerList1",a.headers)
                ):
                console.log("No data from server side");
                
            }
            
            else if("ERROR"===t)e.getError()
        }));
        $A.enqueueAction(controllerMethod);
    }
})