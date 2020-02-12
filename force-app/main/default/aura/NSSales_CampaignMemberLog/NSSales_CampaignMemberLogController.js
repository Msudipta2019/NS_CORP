({
    doInit: function(component, event, helper) {
        component.set('v.intMembercolumns', [
            {label: 'Member Name', fieldName: 'NSSales_Campaign_Member_Name__c', type: 'text'},
            {label: 'Member Role', fieldName: 'NSSales_Role__c', type: 'text'},
            {label: 'Phone', fieldName: 'NSSales_Phone__c', type: 'text'},
            {label: 'Action', fieldName: 'NSSales_Action__c', type: 'text'},
            {label: 'Old Value', fieldName: 'NSSales_Old_Value__c', type: 'text'},
            {label: 'New Value', fieldName: 'NSSales_New_Value__c', type: 'text'},
            {label: 'Change Date', fieldName: 'NSSales_Audit_Date__c', type: 'text'},
            {label: 'Changed By', fieldName: 'CreatedBy1', type: 'text'}
        ]);
        helper.getAccountList(component);
        
        component.set('v.campMembercolumns', [
            {label: 'Type', fieldName: 'NSSales_Type__c', type: 'text'},
            {label: 'First Name', fieldName: 'NSSales_First_Name__c', type: 'text'},
            {label: 'Last Name', fieldName: 'NSSales_Last_Name__c', type: 'text'},
            {label: 'Company', fieldName: 'NSSales_Company__c', type: 'text'},
            {label: 'Action', fieldName: 'NSSales_Action__c', type: 'text'},
            {label: 'Status', fieldName: 'NSSales_Status__c', type: 'text'},
            {label: 'Date', fieldName: 'NSSales_Audit_Date__c', type: 'text'},
            {label: 'User', fieldName: 'CreatedBy2', type: 'text'}
        ]);
        helper.getCampaignMemberMethod(component, event, helper);
    },
    
    
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');
        
    }
})