global class NSSales_OppLaneClosedLostBatch implements Database.Batchable<sObject>,Database.Stateful {
    
    List<String> csvList = new List<String>();
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT id, NSSales_Round_1_Rate__c, NSSales_Round_1_Rate_Update__c, NSSales_Final_Rate__c,NSSales_Opportunity__c,NSSales_Opportunity__r.StageName,NSSales_Opportunity__r.Name,NSSales_Opportunity__r.CreatedDate from NSSales_Opportunity_Lanes__c where NSSales_Opportunity__r.NSSales_Parent_Opportunity__c != null and NSSales_Round_1_Rate_Update__c =  N_DAYS_AGO:120 ';
        System.debug(Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc, List<NSSales_Opportunity_Lanes__c> batch)
    {  
        List<NSSales_Opportunity_Lanes__c> updateOpp = new List<NSSales_Opportunity_Lanes__c>();
        List<Opportunity> opp = new List<Opportunity>();
       
        for(NSSales_Opportunity_Lanes__c op : batch)
        {
            if(op.NSSales_Final_Rate__c == null)
            {
            	Opportunity temp = op.NSSales_Opportunity__r;
            	opp.add(temp);
            }    
        }
        for(Opportunity obj : opp)
        {
            obj.StageName='Closed Lost';
            obj.NS_Lost_To__c='Other';
            obj.NS_Lost_Cancelled_Reason__c='Other';
            obj.NS_Lost_Cancelled_Description__c='Closed Lost';
            obj.NSSales_Rate_Renewal_Expiration_Date__c =System.today() + 2;
            obj.NS_Expiration_Notification_Timeframe__c=1.0;
            csvList.add(obj.id+','+obj.Name+','+obj.StageName+','+obj.CreatedDate);
            
        }
        System.debug(opp);
        Database.update(opp);
        
    }
    
    global void finish (Database.BatchableContext bc)
    {
        System.debug('email');
        AsyncApexJob batchJobStatus = [
            SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, 
            CreatedBy.Email
            FROM AsyncApexJob WHERE Id = :bc.getJobId()];
        string header = 'Id,Name,StageName,CreatedDate\n';
        string finalstr = header ;
        for(String a: csvList)
        {
            string recordString = a+'\n';
            finalstr = finalstr +recordString;
        }
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        string csvname= 'OppStageChangeToClosedLost'+(system.now()).format('yyyyMMddhhmmss')+'.csv';      
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        if(finalstr.length() != header.length()){
            String emailList = label.NSSales_oppStageChange;
            List<String> emailAdd = emailList.split(',');
            String[] SendToAddresses = emailAdd;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(SendToAddresses);
            String OrgName = URL.getSalesforceBaseUrl().toExternalForm().substringBetween('--','.');
            if(OrgName!=null){
                mail.setSubject('['+OrgName+']***Opportunity Stage Change to Closed Lost ' +system.now()+ ' and status is ' + batchJobStatus.Status+ '***');
                
            }else{
                mail.setSubject('***Opportunity Stage Change to Closed Lost ' +system.now()+ ' and status is ' + batchJobStatus.Status+ '***');
                
            }
            
            id owa = [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName='No Reply' limit 01].id;
            string HTMLTextBody='<html> <body style="background-color: #d5f4e6;"> <font face = "Verdana" size = "2"> Hi, <br><br>This is to inform you that these Opportunities Stages has been Changed to Closed Lost'
                +'<br><br><br><br>'
                + 'Thanks,<br>'
                + 'Connect NS Salesforce Support Team!'
                + '</font></body></html>';
            mail.setHtmlBody(HTMLTextBody);
            mail.setOrgWideEmailAddressId(owa);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

}