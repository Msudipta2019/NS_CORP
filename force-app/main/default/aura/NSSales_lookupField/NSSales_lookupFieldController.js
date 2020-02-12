({
    doInit : function(component,event,helper){
        //console.log('----- doInit -----');
        var selectedId = component.get("v.selectedId");
        var AccId = component.get("v.AccId");
        var action = component.get("c.getObjectDetails");
        action.setParams({'ObjectName' : component.get("v.objectAPIName")});
        action.setCallback(this, function(response) {
            var details = response.getReturnValue();
            component.set("v.IconName", details.iconName);
            component.set("v.objectLabel", details.label);
            component.set("v.objectLabelPlural", details.pluralLabel);
            if (selectedId == null || selectedId.trim().length <= 0) {
                component.set("v.isLoading", false);
            }
        });
        $A.enqueueAction(action);
        
        var returnFields =  component.get("v.returnFields"),
            queryFields =  component.get("v.queryFields");
        
        if (returnFields == null || returnFields.length <= 0) {
            component.set("v.returnFields", ['Name']);
        }
        
        if (queryFields == null || queryFields.length <= 0) {
            component.set("v.queryFields", ['Name']);
        }
        
        //help for cancelling the create new record
        //find the latest accessed record for the user
        if (component.get("v.showAddNew")) {
            var action = component.get("c.GetRecentRecords");
            action.setParams({
                'ObjectName' : component.get("v.objectAPIName"),
                'ReturnFields' :  null,
                'MaxResults' : 1
            });
            action.setCallback(this, function(response) {
                var results = response.getReturnValue();
                if (results != null && results.length > 0) {
                    component.lastRecordId = results[0].Id;
                }
            });
            $A.enqueueAction(action);
        }
        
        console.log('AccId -- doInit----' +AccId);
        /*
        if (selectedId != null && selectedId.trim().length > 0) {
            var action = component.get("c.GetRecord"),
                returnFields = component.get("v.returnFields");
            action.setParams({'ObjectName' : component.get("v.objectAPIName"),
                              'ReturnFields': returnFields,
                              'AccId': AccId,
                              'Id': selectedId});
            action.setCallback(this, function(response) {
                var results = response.getReturnValue();
                results = helper.processResults(results, returnFields);
                component.set("v.selectedName", results[0].Field0);
                component.set("v.isLoading", false);
            });
            $A.enqueueAction(action);
        }*/
    },
    
    onFocus : function(component,event,helper){
        //console.log('----- onFocus -----');
        var inputBox = component.find("lookup-input-box"),
            searchText = component.get("v.searchText") || '';
        var AccId = component.get("v.AccId");
        var selectedId = component.get("v.selectedId");
        
        $A.util.addClass(inputBox, 'slds-is-open');
        $A.util.removeClass(inputBox, 'slds-is-close');
        
        if (component.get("v.showRecent") && searchText.trim() == '') {
            component.set("v.isSearching", true);        
            var action = component.get("c.GetRecentRecords"),
                returnFields = component.get("v.returnFields");
            
            action.setParams({
                'ObjectName' : component.get("v.objectAPIName"),
                'ReturnFields' :  returnFields,
                'MaxResults' : component.get("v.maxResults")
            });
            action.setCallback(this, function(response) {
                var results = response.getReturnValue();
                if (results != null) {
                    component.set("v.statusMessage", results.length > 0 ? null : 'No recent records.' );
                    component.set("v.searchResult", 
                                  helper.processResults(results, returnFields));
                } else {
                    component.set("v.statusMessage", "Search Error!" );
                }
                component.set("v.isSearching", false);
            });
            $A.enqueueAction(action);
        }
        
        if (!component.get("v.showRecent") && searchText.trim() == '') {
            component.set("v.isSearching", true);        
            var action = component.get("c.GetRecord"),
                returnFields = component.get("v.returnFields");
            
            action.setParams({'ObjectName' : component.get("v.objectAPIName"),
                              'ReturnFields': returnFields,
                              'AccId': AccId,
                              'Id': selectedId});
            action.setCallback(this, function(response) {
                var results = response.getReturnValue();
                
                if (results != null) {
                    component.set("v.statusMessage", results.length > 0 ? null : 'No Account Classification Found.' );
                    component.set("v.searchResult", 
                                  helper.processResults(results, returnFields));
                } else {
                    component.set("v.statusMessage", "Search Error!" );
                }
                component.set("v.isSearching", false);
            });
            $A.enqueueAction(action);
        }
        
        
    },
    
    onBlur : function(component,event,helper){    
        //console.log('----- onBlur -----');
        var inputBox = component.find("lookup-input-box");
        $A.util.addClass(inputBox, 'slds-is-close');
        $A.util.removeClass(inputBox, 'slds-is-open');
        
        $A.util.removeClass(component.find("lookup-input-box"),'slds-has-focus');
        
    },
    
    onKeyUp : function(component, event, helper) {
        //console.log('----- onKeyUp -----');
        var searchText = component.get('v.searchText');
        var AccId = component.get('v.AccId');
        console.log('AccId -- onKeyUp' +AccId);
        //do not repeat the search if nothing changed
        if (component.lastSearchText !== searchText) {
            component.lastSearchText = searchText;
        } else {
            return;
        }
        
        if (searchText == null || searchText.trim().length < 3) {
            component.set("v.searchResult", []);
            component.set("v.statusMessage", null);
            return;
        }
        
        component.set("v.isSearching", true);        
        var action = component.get("c.SearchRecords"),
            returnFields = component.get("v.returnFields");
        
        action.setParams({
            'Accid' : component.get("v.AccId"),
            'ObjectName' : component.get("v.objectAPIName"),
            'ReturnFields' :  returnFields,
            'QueryFields' :  component.get("v.queryFields"),
            'SearchText': searchText,
            'SortColumn' : component.get("v.sortColumn"),
            'SortOrder' : component.get("v.sortOrder"),
            'MaxResults' : component.get("v.maxResults")
        });
        
        action.setCallback(this, function(response) {
            var results = response.getReturnValue();
            if (results != null) {
                component.set("v.statusMessage", results.length > 0 ? null : 'No Account Classification Found.' );
                component.set("v.searchResult", 
                              helper.processResults(results, returnFields));
            } else {
                component.set("v.statusMessage", 'Search Error!' );
            }
            component.set("v.isSearching", false);
        });
        $A.enqueueAction(action);
        
    },
    
    onSelectItem : function(component, event, helper) {
        //console.log('----- onSelectItem -----');    
        var selectedId = event.currentTarget.dataset.id;
        component.set("v.selectedId", selectedId);
        console.log('selectedId -- > onSelectItem' +selectedId);
        var results = component.get("v.searchResult");
        for (var i = 0; i < results.length; i++) {
            if (results[i].Id == selectedId) {
                component.set("v.selectedName", results[i].Field0);
                break;
            }
        }
        helper.fireEvent(component, event, helper);
        
        $A.enqueueAction(component.get("c.onBlur"));
    },
    
    removeSelectedOption : function(component, event, helper) {
        //console.log('----- removeSelectedOption -----');
        component.set("v.selectedId", null);
        component.set('v.searchText',null);
        helper.fireEvent(component, event, helper);
    },
    onAccChange : function(component, event, helper) {
        //console.log('----- onAccChange -----');
        component.set("v.isLoading", true);
        
        var AccId = component.get('v.AccId');
        var selectedId = component.get("v.selectedId");
        
        var delOneAccStatus = event.getParam("delOneAccStatus");
        //console.log('delOneAccStatus -- fromevent' +delOneAccStatus); 
        component.set('v.delOneAccStatus',delOneAccStatus);
        component.set('v.searchText',null);
        
        console.log('----- onAccChange AccId -----' +AccId);
        if (AccId == '' || delOneAccStatus == 9)
        {
            component.set("v.selectedId", null);
            component.set("v.AccId", null);
            helper.fireEvent(component, event, helper);
            component.set("v.isLoading", false);
        }
        else{
            var action = component.get("c.GetRecord"),
                returnFields = component.get("v.returnFields");
            action.setParams({'ObjectName' : component.get("v.objectAPIName"),
                              'ReturnFields': returnFields,
                              'AccId': AccId,
                              'Id': selectedId});
            action.setCallback(this, function(response) {
                var results = response.getReturnValue();
                //console.log('----- onAccChange results -----' +JSON.stringify(results));
                if (results.length == 1 && component.get("v.delOneAccStatus") == 0)
                {
                    component.set("v.isLoading", false);
                    component.set("v.selectedId", results[0].Id);
                    component.set("v.selectedName", results[0].Name);
                    component.set("v.delOneAccStatus", 1);
                    helper.fireEvent(component, event, helper);
                }   
                component.set("v.isLoading", false);
            });
            
            $A.enqueueAction(action);
            
        }
        
    },
    
    createNewRecord : function(component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord"),
            objectName = component.get("v.objectAPIName"),
            returnFields = component.get("v.returnFields");
        createRecordEvent.setParams({
            "entityApiName": objectName,
            "navigationLocation" : "LOOKUP",
            "panelOnDestroyCallback": function(event) {
                let action = component.get("c.GetRecentRecords");
                action.setParams({'ObjectName' : objectName,
                                  'MaxResults' : 1,
                                  'ReturnFields': returnFields});
                action.setCallback(this, function(response) {
                    var records = response.getReturnValue();
                    if (records != null && records.length > 0) {
                        if (records[0].Id != component.lastRecordId) {
                            component.set("v.selectedId", records[0].Id);
                            component.set("v.selectedName", records[0][returnFields[0]]);
                            component.lastRecordId = records[0].Id;
                        }
                    }
                });
                $A.enqueueAction(action);              
            }
        });
        createRecordEvent.fire();
    },
    
    
})