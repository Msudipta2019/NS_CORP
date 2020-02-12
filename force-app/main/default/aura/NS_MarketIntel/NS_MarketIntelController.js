({
    
    handleLoad: function(cmp, event, helper) {
        //cmp.set('v.showSpinner', false);
        //console.log("on handleLoad");
        cmp.set('v.saved', false);
        /*******Changes for D-1834 on 18/11/2019**********/
        helper.handleAccountDetails(cmp, event, helper);
        /*******End of Changes for D-1834 on 18/11/2019**********/
    },
    
    handleSubmit: function(cmp, event, helper) {
        cmp.set('v.disabled', true);
        cmp.set('v.showSpinner', true);
        console.log("on handleSubmit");
    },
    
    handleError: function(cmp, event, helper) {
        // errors are handled by lightning:inputField and lightning:messages
        // so this just hides the spinner
        cmp.set('v.showSpinner', false);
        
    },
    
    handleSuccess: function(cmp, event, helper) {
        console.log("on handleSuccess");
        var params = event.getParams();
        var toastEvent = $A.get("e.force:showToast");
        var recordName = params.response.fields.Name.value;  
        var recordId = params.response.id;
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
        
        toastEvent.setParams({
            "type": "Success",
            "title": "Success!",
            "message": "Market Intel '"+ recordName +"' was created."
        });
        toastEvent.fire(); 
        cmp.set('v.showSpinner', true);
        helper.createMIRecOnAssociatedObject(cmp, event, helper);
        
        /*******Changes for D-1834 on 18/11/2019**********/
        var onAccPage = cmp.get('v.onAccountPage');
        console.log("checking src from js ctlr-->"+onAccPage);
        if(onAccPage == false){
            var selectedSource= cmp.find('Source').get('v.value');
            if(selectedSource !== 'Account'){
                var accId = cmp.find('acc2').get('v.value');
                cmp.find('acc2').reset();
                //cmp.find('Source').reset();
            }
            else{
                var accId = cmp.find('acc1').get('v.value');
                cmp.find('acc1').reset();
                //cmp.find('Source').reset();
            }
            console.log('Account Value -->'+accId);
            if(accId != null){
                helper.createMIAssociatedAccountRec(cmp, event, helper, accId);
            }
            cmp.find('Source').reset();
        }
        /*******End of Changes for D-1834 on 18/11/2019**********/
        
        cmp.set('v.showSpinner', false);
        cmp.set('v.disabled', false);
        //$A.get('e.force:refreshView').fire();
        cmp.find('marketForm').forEach(function(f) {
            f.reset();
        });
        helper.appfireEvent(cmp, event, helper,9);
        
        if(cmp.get("v.recordId") == undefined){
            var homeEvent = $A.get("e.force:navigateToObjectHome");
            homeEvent.setParams({
                "scope": "Market_Intelligence__c"
            });
            homeEvent.fire();
        }
        else{
            if ($A.get("$Browser.formFactor") != "DESKTOP"){
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": recordId
                });
                navEvt.fire();
            }
        }
    },
    
    /*******Changes for D-1834 on 18/11/2019**********/
    handleSourceChange: function(cmp, event, helper){
        var onAccPage = cmp.get('v.onAccountPage');
        var selectedSource= cmp.find('Source').get('v.value');
        if(selectedSource !== 'Account'){
            console.log('handleSourceChange -- > Not Account');
            cmp.set('v.isSourceAcc', false);
            
            console.log('handleSourceChange -- >before appfireEvent' +onAccPage);
            if(onAccPage)
            {
                cmp.set('v.AccId',cmp.get('v.recordId'));
            }
            else
            {
                cmp.set('v.AccId','');
            }
            helper.appfireEvent(cmp, event, helper,0);
            
        }
        else{
            console.log('handleSourceChange -- >Account');
            if(!onAccPage)
            {
                cmp.set('v.isSourceAcc', true);
                

            }
            
        }
    },
    
    cancel: function(cmp, event, helper){
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Market_Intelligence__c"
        });
        homeEvent.fire();
    },
    /*******End of Changes for D-1834 on 18/11/2019**********/
    
    
    /***** Code Change for D-1885 - Auto populate Account Classification on Market Intel by Sudipto G **/
    populateAccClassification: function(cmp, event, helper) {
        cmp.set('v.showSpinner', true);
        var selectedSource= cmp.find('Source').get('v.value');
        if(selectedSource !== 'Account'){
            var accId = cmp.find('acc2').get('v.value');
        }
        else{
            var accId = cmp.find('acc1').get('v.value');
        }
        cmp.set('v.AccId',accId);
        console.log('v.AccId --> ' +cmp.get('v.AccId'));
        helper.appfireEvent(cmp, event, helper,0);
        cmp.set('v.showSpinner', false);  
    },
    populateAccClassificationfromevent: function(cmp, event, helper) {
        var accClassId = event.getParam("accClassId");
        console.log('accClassId -- fromevent' +accClassId); 
        cmp.set('v.AccClassificationId',accClassId);
    },
    
});