({
    doInit : function(component, event, helper) {         
        helper.loadData(component, event, helper); 
        var action = component.get("c.getIntermodalAcc");
        action.setParams({
            accId: component.get("v.accountId")
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
    reRenderTable: function(component, event, helper) {
        helper.reRenderDataTable(component);
    },
    filter: function(component, event, helper) {
      component.set("v.srchORtablePage",!1);var data=component.get("v.gridData"),searchTerm=component.get("v.searchText"),regex=new RegExp(searchTerm,"i");if(""===searchTerm)component.set("v.srchORtablePage",!0),helper.reRenderDataTable(component);else{var index=0;function myFunction(e,a){var t=e.rows.flat().filter(e=>regex.test(e.vals[0].val)||regex.test(e.vals[1].val)||regex.test(e.vals[2].val)||regex.test(e.vals[3].val)||regex.test(e.vals[4].val)||regex.test(e.vals[5].val)||regex.test(e.vals[6].val)||regex.test(e.vals[7].val)||regex.test(e.vals[8].val));component.set("v.searchResultData",t),helper.paginationOfFilteredData(component)}data.forEach(myFunction)}
    },
    FilterPagination: function(component, event, helper) {
        helper.paginationOfFilteredData(component);
    },
    getSelectedRow : function(component, event, helper) {
        var row=event.currentTarget,v=row.dataset.v,v1=row.dataset.v1,v2=row.dataset.v2,v3=row.dataset.v3,v4=row.dataset.v4,v5=row.dataset.v5,r_data=[v,v1,v2,v3,v4,v5],conf=confirm("Do you want to proceed with creating opportunity for Authority Renewal "+v+" ?");1==conf&&helper.callServer(r_data,component,event,helper);       
    },
    closeAuthorityLane: function(component, event, helper) {
        component.set("v.open_authLane_dtl", false);
        component.set("v.gridData1",null);
        component.set("v.rowData1",null);
        component.set("v.headerList1",null);
    },
    openAuthorityLane : function(component, event, helper) {
       component.set("v.spinner", true); 
        console.log(component.get("v.spinner"));
        var row=event.currentTarget,authReqId=row.dataset.v,expDate=row.dataset.v1;
        console.log('AccountID' +component.get("v.accountId"));
        console.log('row'+row);
        console.log(row.dataset.v1);
        console.log(row.dataset.v);

       // component.set("v.wonAuthReqId",authReqId);
        component.set("v.open_authLane_dtl", true);
        helper.callAuthorityLaneServer(authReqId,expDate,component,event,helper);   
    },
    downloadCsv : function(component,event,helper,fileTitle){
        
       //Getting table data to download it in CSV.
        var gridData = component.get("v.gridData1");
        var gridDataHeaders  = component.get("v.headerList1");
        var gridDataRows = component.get("v.rowData1");;
        // CSV download.
        console.log(gridDataHeaders.length);
        var csv = '';
        for(var i = 0; i < gridDataHeaders .length; i++){         
            csv += (i === (gridDataHeaders .length - 1)) ? gridDataHeaders [i]["title1"] : gridDataHeaders [i]["title1"] + ','; 
        }
        csv += "\n";
        var data = [];
        for(var i = 0; i < gridDataRows.length; i++){
            var gridRowIns = gridDataRows[i];
            var gridRowInsVals = gridRowIns["vals1"];
            var tempRow = [];
            for(var j = 0; j < gridRowInsVals.length; j++){                                     
                var tempValue = gridRowInsVals[j]["val1"];
                if(tempValue.includes(',')){
                    tempValue = "\"" + tempValue + "\"";
                }
                tempValue = tempValue.replace(/(\r\n|\n|\r)/gm,"");                 
                tempRow.push(tempValue);
            }
            data.push(tempRow); 
        }
        data.forEach(function(row){
            csv += row.join(',');
            csv += "\n";
        });
        // 6. To download table in CSV format.
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_blank';
        hiddenElement.download = 'Authority Renewal Lane'+'.csv'; 
        hiddenElement.click();
    }
    
    
})