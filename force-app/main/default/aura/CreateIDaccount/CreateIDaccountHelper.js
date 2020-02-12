({

	InitialSysInformation: function(component,  event) {
	    var recordTypeId = component.get("v.recordTypeId");
	    var action = component.get("c.getCreatesysInfo");
        action.setParams({
            'recordTypeId': recordTypeId
          });	    
        action.setCallback(this, function(a) {
        	var recname = a.getReturnValue(recordTypeId);
            component.set("v.recordTypeName", a.getReturnValue(recordTypeId));
            component.set("v.modalContext", a.getReturnValue(recordTypeId));
            if (recname == 'Industrial Development') {
              component.set("v.isInD",true);
            }
            var workspaceAPI = component.find("CreateIDaccount");
	        workspaceAPI.isConsoleNavigation().then(function(response) {
	        	console.log(response);
	        	if (response == false) {
	        		component.set("v.ConsoleSite",'Sales');
	        	} else {
	        		component.set("v.ConsoleSite",'Service');
	        	}	
	        	var cmpEvent = component.getEvent("InitTabEvent");
	        	cmpEvent.fire();
	        	console.log('Fire InitTabEvent');
	        	var consolesite = component.get("v.ConsoleSite");
	        	var recordTypeId = component.get("v.pageReference").state.recordTypeId;
	        	if (recordTypeId != '0121I000000iPeTQAU' && consolesite == 'Sales') {
	        		// 	component.destroy();
	        		var cmpEvent = component.getEvent("CloseTabEvent");
	        		cmpEvent.fire();
	        		console.log('Fire CloseTabEvent');
	        		// component.set("v.refreshcomplete",true);
	        		// $A.get('e.force:refreshView').fire();
	        	}

	        	
	        })
	        .catch(function(error) {
	            console.log(error);
	            alert('Console nav error '+error);
	        });
            
        });
        $A.enqueueAction(action); 
           
	},
	
    navigateTo: function(component, recId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recId
        });
        navEvt.fire();
        
        console.log('navigateTo complete ');
        // $A.get('e.force:refreshView').fire();
    },

    openCreateTab : function(component, event, recId) {
        var workspaceAPI = component.find("CreateIDaccount");
        workspaceAPI.openTab({
            url: '/lightning/r/Account/'+recId+'/view',
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
            }).then(function(tabInfo) {
            console.log("The recordId for this tab is: " + tabInfo.recordId);
            });
        }).catch(function(error) {
                console.log(error);
        });
    },
  
    gotoAccountHome : function(component, event) {
    	var urlInstance = window.location.hostname;
    	var homeurl = "https://"+urlInstance+"/lightning/o/Account/home?filterName=Recent";
    	event.preventDefault();
		component.find("navigationService").navigate({ 
		    type: "standard__webPage", 
		    attributes: { 
		        "url": homeurl 
		    } 
		});    // ,true    	
    },
    delayedRefresh : function(component, milliseconds){
	    let ms = milliseconds || 500;
	    window.setTimeout($A.getCallback(function(){
	    	// component.set("v.refreshcomplete",true);
	        // $A.get('e.force:navigateToSObject').fire();
	        $A.get('e.force:refreshView').fire();
	    }),ms);
    },
     
})