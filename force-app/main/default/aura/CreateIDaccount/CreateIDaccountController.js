({
	doInit : function(component, event, helper) {
		var recordTypeId = component.get("v.pageReference").state.recordTypeId;
		component.set("v.recordTypeId",recordTypeId);
		
        // Sets the route to /lightning/o/Account/home
        component.set("v.NS_StatusIndicator__c",'-- none --');
        component.set("v.NS_Account_Business_Type__c",'-- none --');
        
        
		helper.InitialSysInformation(component, event);

		return;
		
	},
    
    saveRecord : function(component, event, helper) {
    	var consolesite = component.get("v.ConsoleSite");
    	var ParentRecordid = component.get("v.selectedLookUpRecord").Id;
    	var ParentRecord = component.get("v.selectedLookUpRecord").Name;
    	var AcctMrkOwnerId = component.get("v.selectedLookUpMrkOwner").Id;
    	var StatusIndicator = component.get("v.StatusIndicator");
    	var ContactRecordId = component.get("v.selectedLookUpContactRecord").Id;
    	component.set("v.AcctRecord.NS_ExistingContact__c",ContactRecordId);
    	console.log('saverecord '+ParentRecordid);
    	var newrecord = component.get("v.AcctRecord");
		var name = component.get("v.AcctRecord").Name;
		var status = component.get("v.AcctRecord").NS_StatusIndicator__c;
		var businesstype = component.get("v.AcctRecord").NS_Account_Business_Type__c;
		var savedopt = component.get('v.AssociatedBusinessUnit');
		var abu = '';
    	var Account_Business_Type = component.get("v.Account_Business_Type");
    	component.set("v.AcctRecord.NS_MarketingOwner__c",AcctMrkOwnerId);

		if (StatusIndicator == '-- null --') {
			alert('Validation Error: Status Indicator must contain a valid entry');
			console.log('Validation Error: Status Indicator must contain a valid entry');
			return;
		} else {
			component.set("v.NS_StatusIndicator__c",StatusIndicator);
		}
		if (Account_Business_Type == '-- null --' || Account_Business_Type == null || Account_Business_Type.length == 0) {
			alert('Validation Error: Account Buisness Type must contain a valid entry');
			console.log('Validation Error: Account Buisness Type must contain a valid entry');
			return;
		
		} else {
			component.set("v.NS_Account_Business_Type__c",Account_Business_Type);
		}
		
		savedopt.forEach(element => abu += element+';');
		
		component.set("v.AcctRecord.NS_AssociatedBusinessUnit__c",abu)
		if (ContactRecordId != null) {
			var contactfirst = component.get("v.AcctRecord").NS_OfflineContactFirstName__c;
			var contactlast = component.get("v.AcctRecord").NS_OfflineContactLastName__c;
			var contacttitle = component.get("v.AcctRecord").NS_ContactTitle__c;
			var contactwphone = component.get("v.AcctRecord").NS_OfflineContactWorkPhone__c;
			var contactmobile = component.get("v.AcctRecord").NS_OfflineContactMobile__c;
			var contactemail = component.get("v.AcctRecord").NS_OfflineContactEmail__c;
			if ((contactfirst != null && contactfirst.length > 0 ) || (contactlast != null && contactlast.length > 0)) {
				// if ( contactfirst.length > 0 || contactlast.length > 0 || contactwphone.length > 0 )
					alert('Validation Error: Cannot have both Existing Contact and Manual Contact entries');
			    	console.log('Validation Error: Cannot have both Existing Contact and Manual Contact entries');
			    	return;
			    // }
			}
		} 
		
        var tempRec = component.find("NewAccountRecord");
        tempRec.saveRecord($A.getCallback(function(result) {
            console.log(result.state);
            var resultsToast = $A.get("e.force:showToast");
            if (result.state === "SUCCESS") {
            	$A.get("e.force:closeQuickAction").fire();
                resultsToast.setParams({
                    "title": "Success!",
                    "message": "The record was saved."
                });
                
                resultsToast.fire();  
                if (consolesite == 'Service') {
	                // Close the original Tab
			        var workspaceAPI = component.find("CreateIDaccount");
			        workspaceAPI.getFocusedTabInfo().then(function(response) {
			            var focusedTabId = response.tabId;
			            workspaceAPI.closeTab({tabId: focusedTabId});
			        })
			        .catch(function(error) {
			        	alert('cancelDialog Close error:');
			            console.log(error);
			        });
		        } else {
		        	console.log('SaveRecord Sales close original tab');
		        }
                // Open the tab for the new account 
				var recId = result.recordId;
				// 
				if (consolesite == 'Service') {
					helper.openCreateTab(component, event, recId);
				} else {
					console.log('SaveRecord Sales navigateTo record');
					helper.navigateTo(component, recId);
				}
                
                console.log('Save complete');
                
            } else if (result.state === "ERROR") {
                console.log('Error: ' + JSON.stringify(result.error));
                resultsToast.setParams({
                    "title": "Error",
                    "message": "There was an error saving the record: " + JSON.stringify(result.error)
                });
                resultsToast.fire();
                
            } else {
                console.log('Unknown problem, state: ' + result.state + ', error: ' + JSON.stringify(result.error));
            }
        }));
        return;
	},
    
    cancelDialog: function(component, event, helper) {
    	console.log('cancelDialog tab ');
    	var consolesite = component.get("v.ConsoleSite");
    	if (consolesite == 'Sales') {

    		var navService = component.find("navigationService");
            var pageReference = {
                type: "standard__objectPage",
                attributes: {
                    objectApiName: "Account",
                    actionName: 'list'
	            },
	            state: {
	            	filterName: 'Recent'
	            },
            };
            
            navService.navigate(pageReference,false);

    		// $A.get('e.force:refreshView').fire();
    		return;
    		
    	} else {
	        var workspaceAPI = component.find("CreateIDaccount");
	        workspaceAPI.getFocusedTabInfo().then(function(response) {
	            var focusedTabId = response.tabId;
	            console.log('cancelDialog tab '+focusedTabId);
	            workspaceAPI.closeTab({tabId: focusedTabId});
	        })
	        .catch(function(error) {
	        	alert('cancelDialog Close error:'+error);
	            console.log(error);
	        });
        }
    },
    
    AssignAcctBusinessUnit: function (component, event) {
        // This will contain an array of the "value" attribute of the selected options
        var selectedOptionValue = event.getParam("value");
        var savedopt = component.get('v.AssociatedBusinessUnit');
        // component.set('v.AssociatedBusinessUnit',selectedOptionValue.toString());
        console.log("Option selected with value: '" + selectedOptionValue.toString() + "'");
    },
    
    handleTabDisplay: function (component, event, helper) {
        var recId = component.get("v.recordId");
        var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        var urlInstance = window.location.hostname;
        var url = 'https://'+urlInstance+ '/lightning/o/Account/new?count=1&nooverride=1&useRecordTypeCheck=1&navigationLocation=MRU_LIST&recordTypeId='+recordTypeId;
        console.log(component.get("v.pageReference").state.recordTypeId);
       
        console.log('recordTypeId '+recordTypeId);
        console.log('url '+url);
        if (recId) {
            component.set("v.modalContext", "Edit");
        }
        console.log('urlInstance '+urlInstance);
        if (!recId) {           
    	    var workspaceAPI = component.find("CreateIDaccount");    
	        var consolesite = component.get("v.ConsoleSite");
	        var recordTypeName = component.get("v.recordTypeName");
	        if (recordTypeName == 'Industrial Development') {
	            component.find("NewAccountRecord").getNewRecord(
	                "Account",
	                recordTypeId,
	                false,
	                $A.getCallback(function() {
	                    var rec = component.get("v.accountRecord");
	                    var error = component.get("v.recordError");
	                    if (error || (rec === null)) {
	                        console.log("Error initializing record template: " + error);
	                        return;
	                    }
	                    console.log("create NewAccount call back: ");
	                })
	            );
	            console.log("create NewAccount: ");
	        } else {
		        if (consolesite == 'Service') {
		        	// Close the original Tab
			        workspaceAPI.getFocusedTabInfo().then(function(response) {
			            var focusedTabId = response.tabId;
//			            workspaceAPI.closeTab({tabId: focusedTabId});
			        })
			        .catch(function(error) {
			        	alert('doInit Close error:');
			            console.log(error);
			            component.set("v.ConsoleSite",'Sales');
			            var consolesite = component.get("v.ConsoleSite");
			        });
		        
                }
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": url,
                    "isredirect" : true
                });
                urlEvent.fire();
                    
			}

            console.log("Finished processing do init");
        }
    
    },
	CloseTabDisplay: function (component, event, helper) {
		helper.gotoAccountHome(component, event);
		var urlInstance = window.location.hostname;
		var homeurl = "https://"+urlInstance+"/lightning/o/Account/home?filterName=Recent";
		console.log("Processing close original start page "+homeurl);
		// component.destroy();		
		$A.get('e.force:refreshView').fire(); 
	},
    
	reInit : function(component, event, helper) {
		console.log("Processing reInit ");
	    $A.get('e.force:refreshView').fire();
	}
})