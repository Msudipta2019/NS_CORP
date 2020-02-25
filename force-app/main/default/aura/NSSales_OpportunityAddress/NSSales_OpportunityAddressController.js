({
    init: function (cmp, event, helper) {       
       // var action = cmp.get("c.getaddress");
        
        var optyId = cmp.get("v.recordId");
       // cmp.set("v.recId",optyId);
      //  console.log("id"+optyId);
        helper.fetchMap(cmp, event, helper,optyId);
        
    } ,
    
    handleSubmit: function(component, event, helper) {
        helper.saveMaprecord(component, event, helper);
        component.set("v.truthy",true);
        component.set("v.inptruthy",false);
        
    },
      handleEdit: function(component, event, helper) {
       
        component.set("v.truthy",false);
        component.set("v.inptruthy",true);
          var optyId = component.get("v.recordId");
          helper.fetchMap(component, event, helper,optyId);
        
    }
});