({
    doInit: function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Marketing Manager', fieldName: 'NSSales_MarketingManager__c', type: 'text'},
            {label: 'Role', fieldName: 'NSSales_Role__c', type: 'text'},
          //  {label: 'Associated Business Unit', fieldName: 'NSSales_AssociatedBusinessUnit__c', type: 'text'},
            {label: 'Business Unit', fieldName: 'NSSales_BusinessUnit__c', type: 'text'},
            {label: 'Action', fieldName: 'NSSales_Action__c', type: 'text'},
            {label: 'Old Value', fieldName: 'NSSales_OldValue__c', type: 'text'},
            {label: 'New Value', fieldName: 'NSSales_NewValue__c', type: 'text'},
            {label: 'Change Date', fieldName: 'NSSales_ChangeDate__c', type: 'text'},
            {label: 'Change By', fieldName: 'CreatedBy', type: 'text'}
        ]);
        helper.getLogs(component, event, helper);
    }  
})