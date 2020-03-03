({
    fetchVisibility : function(cmp, event, helper, objectId){
        var action = cmp.get('c.getVisibility');
        action.setParams({
            "strRecId":objectId
        });
        action.setCallback(this,function(response){
            //console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                var res = response.getReturnValue().split(',');
                var visibility = res[0];
                var processInstanceWorkItem = res[1];
                var processInstanceStep = res[2];
                var Npo = res[3];
                var Opp = res[4];
                console.log("Response : " +res);
                console.log("Visibility Returned Succesfully,visibility : " +visibility);
                if (visibility === "false")
                {
                    cmp.set('v.showSpinner',false);
                    cmp.destroy();
                }
                else if (visibility === "true" && processInstanceWorkItem === "true" && Opp === "true")
                {
                    this.fetchCommentsProcessItemDetailsOpp(cmp, event, helper, objectId);                    
                }
                    else if(visibility === "true" && processInstanceWorkItem === "true" && Npo === "true")
                    {
                        this.fetchCommentsProcessItemDetailsNpo(cmp, event, helper, objectId);
                    }
                        else if(visibility === "true" && processInstanceStep === "true" && Opp === "true")
                        {
                            this.fetchCommentProcessInstanceStepOpp(cmp, event, helper, objectId);
                        }
                            else if(visibility === "true" && processInstanceStep === "true" && Npo === "true")
                            {
                                this.fetchCommentProcessInstanceStepNpo(cmp, event, helper, objectId);
                            }
                                else
                                {
                                    cmp.set('v.showSpinner',false);
                                    cmp.destroy();
                                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        cmp.set('v.showSpinner',false);
                    }
                } else {
                    console.log("Unknown error");
                    cmp.set('v.showSpinner',false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    fetchCommentsProcessItemDetailsOpp : function(cmp, event, helper, objectId) {
        var action = cmp.get('c.fetchCommentsProcessItemDetailsOpp');
        action.setParams({
            "objectId":objectId
        });
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                //console.log("Details Returned Succesfully" +JSON.stringify(response.getReturnValue()));
                console.log("fetchCommentsProcessItemDetailsOpp -- Details Returned Succesfully");
                cmp.set('v.isOppPage',true);
                cmp.set('v.cmtDetails',response.getReturnValue());
                cmp.set('v.showSpinner',false); 
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        cmp.set('v.showSpinner',false);
                    }
                } else {
                    console.log("Unknown error");
                    cmp.set('v.showSpinner',false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    fetchCommentsProcessItemDetailsNpo : function(cmp, event, helper, objectId) {
        var action = cmp.get('c.fetchCommentsProcessItemDetailsNpo');
        action.setParams({
            "objectId":objectId
        });
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                //console.log("Details Returned Succesfully" +JSON.stringify(response.getReturnValue()));
                console.log("fetchCommentsProcessItemDetailsNpo -- Details Returned Succesfully");
                cmp.set('v.isNPOPage',true);
                cmp.set('v.pIDetails',response.getReturnValue());
                cmp.set('v.showSpinner',false);   
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        cmp.set('v.showSpinner',false);
                    }
                } else {
                    console.log("Unknown error");
                    cmp.set('v.showSpinner',false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchCommentProcessInstanceStepOpp : function(cmp, event, helper, objectId) {
        var action = cmp.get('c.fetchCommentProcessInstanceStepOpp');
        action.setParams({
            "objectId":objectId
        });
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                //console.log("Details Returned Succesfully" +JSON.stringify(response.getReturnValue()));
                console.log("fetchCommentProcessInstanceStepOpp -- Details Returned Succesfully");
                cmp.set('v.isOppPageStep',true);
                cmp.set('v.cmtDetails',response.getReturnValue());
                cmp.set('v.showSpinner',false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        cmp.set('v.showSpinner',false);
                    }
                } else {
                    console.log("Unknown error");
                    cmp.set('v.showSpinner',false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    fetchCommentProcessInstanceStepNpo : function(cmp, event, helper, objectId) {
        var action = cmp.get('c.fetchCommentProcessInstanceStepNpo');
        action.setParams({
            "objectId":objectId
        });
        action.setCallback(this,function(response){
            console.log(response.getReturnValue());
            var state = response.getState();
            if(state == "SUCCESS"){
                //console.log("Details Returned Succesfully" +JSON.stringify(response.getReturnValue()));
                console.log("fetchCommentProcessInstanceStepNpo -- Details Returned Succesfully");
                cmp.set('v.isNPOPageStep',true);
                cmp.set('v.pIDetails',response.getReturnValue());
                cmp.set('v.showSpinner',false);  
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        cmp.set('v.showSpinner',false);
                    }
                } else {
                    console.log("Unknown error");
                    cmp.set('v.showSpinner',false);
                }
            }
        });
        $A.enqueueAction(action);
    },
})