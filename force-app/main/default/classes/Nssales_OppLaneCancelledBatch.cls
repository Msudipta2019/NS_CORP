global class Nssales_OppLaneCancelledBatch implements Database.Batchable<sObject>,Database.Stateful {
    
    global final String query;
    List<String> csvList = new List<String>();
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'Select id,NSSales_Round_1_Rate__c,NSSales_Final_Rate__c,NSSales_Opportunity__c,NSSales_Opportunity__r.StageName,NSSales_Opportunity__r.NSSales_Parent_Opportunity__c,NSSales_Opportunity__r.Name,NSSales_Opportunity__r.CreatedDate from NSSales_Opportunity_Lanes__c where NSSales_Round_1_Rate__c = null AND NSSales_Final_Rate__c = null AND NSSales_Opportunity__r.NSSales_Parent_Opportunity__c != null AND CreatedDate < LAST_N_DAYS:121';
        return Database.getQueryLocator(query);
    }
    global void execute (Database.BatchableContext bc, List<NSSales_Opportunity_Lanes__c> batch)
    {  
        List<Opportunity> opp = new List<Opportunity>();
        for(NSSales_Opportunity_Lanes__c op : batch)
        {
            
            Opportunity temp = op.NSSales_Opportunity__r;
            opp.add(temp);
        }
        for(Opportunity obj : opp)
        {
            String s = obj.Name;
            System.debug('akfk----'+s);
            obj.StageName='Cancelled';
            obj.NS_Lost_Cancelled_Reason__c='Terms and Conditions';
            obj.NSSales_Rate_Renewal_Expiration_Date__c =System.today() + 2;
            obj.NS_Expiration_Notification_Timeframe__c=1.0;
            csvList.add(obj.id+','+obj.Name+','+obj.StageName+','+obj.CreatedDate);
        }
        System.debug('ttt----0'+csvList);
        System.debug(batch);
        update opp;
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
        string csvname= 'OppStageChangeToCancelled'+(system.now()).format('yyyyMMddhhmmss')+'.csv';      
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
                mail.setSubject('['+OrgName+']***Opportunity Stage Change to Cancelled ' +system.now()+ ' and status is ' + batchJobStatus.Status+ '***');
                
            }else{
                mail.setSubject('***Opportunity Stage Change to Cancelled ' +system.now()+ ' and status is ' + batchJobStatus.Status+ '***');
                
            }
            
            id owa = [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName='No Reply' limit 01].id;
            string HTMLTextBody='<html> <body style="background-color: #d5f4e6;"> <font face = "Verdana" size = "2"> Hi, <br><br>This is to inform you that these Opportunities Stages have been Changed to Cancelled'
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