global class NSSales_DeletePACWithNoAccountBatchClass implements Database.Batchable<sObject>,Database.Stateful {
    
    global final String query;
    public List<String> accBatch = new list<String>();
    global Database.QueryLocator start(Database.BatchableContext bcx)
    {
        String query = 'select Id,Name,NSSales_Business_Group__c,NSSales_Group_Name1__c,NS_Account_Type_BU__c,NS_Business_Group_BU__c,NS_Line_of_Business_BU__c,NS_Major_Group_BU__c,NS_Minor_Group_BU__c,NS_Record_Type_Name__c,NS_Sub_Business_Group_BU__c,OwnerId from BU__c where Account__c = null';
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bcx, List<BU__c> batch)
    {	
	
		for(BU__c a: batch)
        {
            string recordString = a.Id+','+a.Name+','+a.NSSales_Business_Group__c+','+a.NSSales_Group_Name1__c+','+a.NS_Account_Type_BU__c+','+a.NS_Business_Group_BU__c+','+a.NS_Line_of_Business_BU__c+','+a.NS_Major_Group_BU__c+','+a.NS_Minor_Group_BU__c+','+a.NS_Record_Type_Name__c+','+a.NS_Sub_Business_Group_BU__c+','+a.OwnerId;
            accBatch.add(recordString);
        }
        database.delete(batch); //Deletion-Rule_UnCommented
    }
    
    global void finish (Database.BatchableContext bcx)
    {
        AsyncApexJob batchJobStatus = [
            SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, 
            CreatedBy.Email
            FROM AsyncApexJob WHERE Id = :bcx.getJobId()];
        
        string header = 'Id,Name,NSSales_Business_Group__c,NSSales_Group_Name1__c,NS_Account_Type_BU__c,NS_Business_Group_BU__c,NS_Line_of_Business_BU__c,NS_Major_Group_BU__c,NS_Minor_Group_BU__c,NS_Record_Type_Name__c,NS_Sub_Business_Group_BU__c,OwnerId\n';
        string finalstr = header ;
        for(String a: accBatch)
        {
            string recordString = a+'\n';
            finalstr = finalstr +recordString;
        }
		Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        string csvname= 'Deleted_PAC_on_'+(system.now()).format('yyyyMMddhhmmss')+'.csv';      
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        
        if(finalstr.length() != header.length()){
        
        String emailList = label.NSSales_DeletedPAC_CSVRecList;
        List<String> emailAdd = emailList.split(',');
        String[] SendToAddresses = emailAdd;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(SendToAddresses);
        String OrgName = URL.getSalesforceBaseUrl().toExternalForm().substringBetween('--','.');
        if(OrgName!=null){
            mail.setSubject('['+OrgName+']***Account Classification Deletion Batch Ran on ' +system.now()+ ' and status is ' + batchJobStatus.Status+ '***');
            
        }else{
            mail.setSubject('***Account Classification Deletion Batch Ran on ' +system.now()+ ' and status is ' + batchJobStatus.Status+ '***');
            
        }
        id owa = [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName='No Reply' limit 01].id;
        mail.setOrgWideEmailAddressId(owa);
        string HTMLTextBody='<html> <body style="background-color: #d5f4e6;"> <font face = "Verdana" size = "2"> Hi, <br><br>This is to inform you that these Primary Account Classifications Were Deleted'
                +'<br><br><br><br>'
                + 'Thanks,<br>'
                + 'Connect NS Salesforce Support Team!'
                + '</font></body></html>';
        mail.setHtmlBody(HTMLTextBody); 
        mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
    }
    
}