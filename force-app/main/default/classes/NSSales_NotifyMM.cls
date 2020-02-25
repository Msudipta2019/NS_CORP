global class NSSales_NotifyMM implements Database.Batchable<sObject> {
    
    global final String query;
    
    global Database.QueryLocator start(Database.BatchableContext bcx)
    {
        Date TodaysDate = system.today();
        String query = 'select id,Name,AccountId,NS_Expiration_Notification_Timeframe__c from Opportunity where NSSales_Renewal_Notification_Date__c =: TodaysDate';
        system.debug('Opportunity' +query);
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bcx, List<Opportunity> batch)
    {	
        
        System.debug('Batch' +batch);
        Set<id> accIds=new Set<id>(); 
        Map<id,id> accIdWithOppId = new Map<id,id>();
        Map<id,List<String>> accIdWithMM = new Map<id,List<String>>();
        for(Opportunity o:batch)
        {
            accIds.add(o.AccountId);
            accIdWithOppId.put(o.AccountId,o.id);
        }
        for(NSSales_Marketing_Manager_Assignment__c pp : [select NSSales_Account__c,NSSales_MarketingManager__r.Email from NSSales_Marketing_Manager_Assignment__c where NSSales_Account__c in: accIds])
        {
            if(accIdWithMM.keyset().contains(pp.NSSales_Account__c))
            {
                List<String> mails= accIdWithMM.get(pp.NSSales_Account__c);
                if(!mails.contains(pp.NSSales_MarketingManager__r.Email))
                {
                    mails.add(pp.NSSales_MarketingManager__r.Email);
                    accIdWithMM.put(pp.NSSales_Account__c,mails);
                }
            }
            else
            {
                accIdWithMM.Put(pp.NSSales_Account__c,new List<String>{pp.NSSales_MarketingManager__r.Email});
            }
        }
        
        System.debug('accIdWithOppId-------------->'+accIdWithOppId);
        System.debug('accIdWithMM-------------->' + accIdWithMM);
        for( Opportunity o : batch)
        { 
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            for(OrgWideEmailAddress owa : [select id from OrgWideEmailAddress where DisplayName='No Reply']) 
            {
                
                String subject='Attention To Opportunity needed';
                
                message.setOrgWideEmailAddressId(owa.Id); 
                message.toAddresses = accIdWithMM.get(o.AccountId);
                message.subject = subject;
                message.setHtmlBody('Please note that Rate Renewal for Opportunity <a href='+system.URL.getSalesforceBaseUrl().toExternalForm()+'/'+o.id+'>'+o.Name+'</a> is going to expire in '+o.NS_Expiration_Notification_Timeframe__c+' days');
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            }
        }
    }
    
    global void finish (Database.BatchableContext bcx)
    {
        
    }
    
}