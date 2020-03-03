({
    doInit : function(component, event, helper) {helper.loadData(component, event, helper);},    
    reRenderTable: function(component, event, helper) {helper.reRenderDataTable(component);},
    filter: function(component, event, helper) {component.set("v.srchORtablePage",!1);var data=component.get("v.gridData"),searchTerm=component.get("v.searchText"),regex=new RegExp(searchTerm,"i");if(""===searchTerm)component.set("v.srchORtablePage",!0),helper.reRenderDataTable(component);else{var index=0;function myFunction(e,a){var t=e.rows.flat().filter(e=>regex.test(e.vals[0].val)||regex.test(e.vals[1].val)||regex.test(e.vals[2].val)||regex.test(e.vals[3].val)||regex.test(e.vals[4].val)||regex.test(e.vals[5].val));component.set("v.searchResultData",t),helper.paginationOfFilteredData(component)}data.forEach(myFunction)}},
    FilterPagination: function(component, event, helper) {helper.paginationOfFilteredData(component);},
    getSelectedRow : function(component, event, helper) {var row=event.currentTarget,v=row.dataset.v,v1=row.dataset.v1,v2=row.dataset.v2,v3=row.dataset.v3,v4=row.dataset.v4,v5=row.dataset.v5,v6=row.dataset.v6,r_data=[v,v1,v2,v3,v4,v5,v6],conf=confirm("Do you want to proceed with creating opportunity for Rate Request "+v+" ?");1==conf&&helper.callServer(r_data,component,event,helper);},
    closeModalWLD: function(component, event, helper) {
        component.set("v.open_wonLane_dtl", false);
        component.set("v.gridData1",null);
        component.set("v.rowData1",null);
        component.set("v.headerList1",null);
    },
    openWonLane : function(component, event, helper) {
        component.set("v.spinner", true);
        var row=event.currentTarget,rateReqId=row.dataset.v,rateReqNum=row.dataset.v1;
        rateReqNum=row.dataset.v1;
        console.log('Row'+row);
        component.set("v.wonLaneReqNum",rateReqNum);
        component.set("v.wonLaneReqId",rateReqId);
        component.set("v.open_wonLane_dtl", true);
        helper.callWonLaneServer(rateReqId,component,event,helper);   
    },
    downloadCsv : function(component,event,helper,fileTitle){
        
       //Getting table data to download it in CSV.
        var gridData = component.get("v.gridData1");
        var gridDataHeaders  = component.get("v.headerList1");
        var gridDataRows = component.get("v.rowData1");
        var laneID = component.get("v.wonLaneReqNum");
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
        hiddenElement.download = laneID+'_Rate Renewal Lane'+'.csv'; 
        hiddenElement.click();
    }
})