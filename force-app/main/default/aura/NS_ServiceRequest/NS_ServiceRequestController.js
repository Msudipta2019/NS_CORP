({  
    doInit: function(component, event, helper) {
    helper.fetchPicklistValues(component, 'NS_Owner_Business_Unit__c', null, 'NS_Queue__c');
    helper.ifIs3PL(component);
    },
    redirect: function(component, event, helper) {
        var csid = component.get("v.myRecordId");
        var orgurl = $A.get("{!$Label.c.Org_URL}");
        //window.location = "https://connectns--sandbox01.lightning.force.com/"+csid;
        window.location = orgurl+csid;
    },
   closeModel: function(component, event, helper) {
       component.set("v.isOpen", false);
        //Sudipta 11-18-2019: IM02715489: Added this below two lines to make the Submit button disable once clicked.
        var button = component.find('disablebuttonid');
        button.set('v.disabled',false);
        //Sudipta 11-18-2019: IM02715489: Changes ended here.
        
     /*commented as requested - moumita
       var workspaceAPI = component.find("workspace");
       workspaceAPI.openTab({
            recordId: component.get("v.recordId"),
            focus: true
        }).then(function(response) {
            workspaceAPI.openSubtab({
                          parentTabId: response,
                recordId:component.get("v.myRecordId"),
                          focus:false
                      })
        })
        .catch(function(error) {
               console.log(error);
        });*/
       var caseNo = component.get("v.caseNumber");
       var caseId = component.get("v.myRecordId");
       var toastEvent = $A.get("e.force:showToast");
       toastEvent.setParams({
           "type":
           "Success",
           "message":
           "Service request "+caseNo+" has been created!",
        
       });
       toastEvent.fire();
   },
    
    onSubmit: function(component, event, helper) {
        //Sudipta 11-18-2019: IM02715489: Added this below two lines to make the Submit button disable once clicked.
         var button = component.find('disablebuttonid');
         button.set('v.disabled',true);
       //Sudipta 11-18-2019: IM02715489: Changes ended here.
       
        var srContactId =component.find("srContactid").get("v.value");
        var srSubject=component.find("srSubject").get("v.value");
        //var srOwnerid=component.find("srOwnerid").get("v.value");
        var trainId=component.find("trainId").get("v.value");       
        var equipment=component.find("equipment").get("v.value");
        var onBehalfofid =component.find("onbehalfofid").get("v.value");
       // var srShutdown=component.find("srShutdown").get("v.value").toString();
        var srDescription= component.find("srDescription").get("v.value");
        var SelectedQ = component.get("v.SelectedQ");
        var BU = component.get("v.SelectedBU");
        var accId = component.get("v.recordId");
        if(srContactId == ''){
        var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
                 "type":
                	 "warning",
                 "message":
                	 "Please select a Contact!"
             });
             toastEvent.fire();
         //Sudipta 11-18-2019: IM02715489: Added this below two lines to make the Submit button disable once clicked.
            var button = component.find('disablebuttonid');
             button.set('v.disabled',false);
       //Chnages Ended Here     
        }
        else if(srSubject == '' || srSubject == undefined){
          var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
                 "type":
                	 "warning",
                 "message":
                	 "Subject can not be blank!"
             });
                   toastEvent.fire();
            //Sudipta 11-18-2019: IM02715489: Added this below two lines to make the Submit button disable once clicked.
             var button = component.find('disablebuttonid');
             button.set('v.disabled',false);
        
            //Ended
        }
         /*else if(trainId !== undefined || trainId !== '' ){
             alert('here');
             if(trainId.length > 7){
          var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
                 "type":
                	 "warning",
                 "message":
                	 "Please enter valid Train ID/Permit Number!"
             });
             toastEvent.fire();  
        }
         }*/
        else if(BU == '--- None ---' || BU == undefined){
              var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
                 "type":
                	 "warning",
                 "message":
                	 "Please select Business Unit!"
             });
             toastEvent.fire(); 
            //Sudipta 11-18-2019: IM02715489: Added this below two lines to make the Submit button disable once clicked.
             var button = component.find('disablebuttonid');
             button.set('v.disabled',false);
            //Ended
               
            }
        else if(SelectedQ == '--- None ---' || SelectedQ == undefined){
              var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
                 "type":
                	 "warning",
                 "message":
                	 "Please select Queue!"
             });
             toastEvent.fire(); 
            //Sudipta 11-18-2019: IM02715489: Added this below two lines to make the Submit button disable once clicked.
             var button = component.find('disablebuttonid');
             button.set('v.disabled',false);
            //Ended
               
            }
        else if(onBehalfofid==='' && component.get("v.is_3pl")) {
               var toastEvent = $A.get("e.force:showToast");	
            toastEvent.setParams({	
                "type":
                	"warning",
                "message":
                	"Contacting on behalf of cannot be blank"	
            });	
             toastEvent.fire();
            //Sudipta 11-18-2019: IM02715489: Added this below two lines to make the Submit button disable once clicked.
            var button = component.find('disablebuttonid');
            button.set('v.disabled',false);
            //Ended
           	
          }
        
        else{
        helper.getData(component, event, helper, srContactId,srSubject,
                       trainId,equipment,srDescription,SelectedQ,accId,onBehalfofid);
            }
    },
  handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
      //  alert("Files uploaded : " + uploadedFiles[0].documentId);
    },
    showSpinner: function(component, event, helper) {
      component.set("v.spinner", true);
   },
    hideSpinner : function(component, event, helper){
           component.set("v.spinner", false);
    },
  onBUChange : function(component, event, helper)
    {
     
     var controllerValueKey = event.getSource().get("v.value");
     component.set("v.SelectedBU",controllerValueKey);
      var Map = component.get("v.QueueFieldMap");
      if (controllerValueKey != '--- None ---') {
         var ListOfDependentFields = Map[controllerValueKey];
         helper.fetchDepValues(component, ListOfDependentFields, 'NS_Queue__c');
 
      } else {
         var defaultVal = [{
            class: "optionClass",
            label: '--- None ---',
            value: '--- None ---'
         }];
         component.find('Queue').set("v.options", defaultVal);
         component.set("v.isBUDisabled", true);
      }
    },
    SelectedQueue : function(component, event, helper){
    var SelectedQ = event.getSource().get("v.value");
    component.set("v.SelectedQ",SelectedQ);
	}
 })