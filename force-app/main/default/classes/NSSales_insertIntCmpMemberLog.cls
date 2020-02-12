public class NSSales_insertIntCmpMemberLog {
    private static final String CLASS_NAME = 'NSSales_insertIntCmpMemberLog';
    private static final String METHOD_NAME1='createRecordonCampaign_Member_Log';
    private static final String METHOD_NAME2='deleteRecordonCampaign_Member_Log';
    private static final String METHOD_NAME3='emailsend';
    private static final String METHOD_NAME4='updateRecordonCampaign_Member_Log';
    
    
    public static void createRecordonCampaign_Member_Log(List<Internal_Campaign_Members__c> newInternalCampaign){
        
        try{
            
            list<Campaign_Member_Log__c> insertIntMem = new list<Campaign_Member_Log__c>();
              /*Datetime now = Datetime.now();
                Integer offset = UserInfo.getTimezone().getOffset(now);
                Datetime local = now.addSeconds(offset/1000);*/
            Date todaysDate = Date.today();

            for(Internal_Campaign_Members__c intcamnew : newInternalCampaign)
            {
                Campaign_Member_Log__c cmpMemLog= new Campaign_Member_Log__c();
                cmpMemLog.Name=intcamnew.NSSales_Internal_Campaign_Member_Hidden__c;
                cmpMemLog.NSSales_Role__c=intcamnew.NSSales_Role_Hidden__c;
                cmpMemLog.NSSales_phone__c=intcamnew.NSSales_Phone_Hidden__c; 
                cmpMemlog.NSSales_Object__c='InternalCampaign';
                cmpMemlog.NSSales_Action__c='Internal Campaign Member Added';
                cmpMemlog.NSSales_Campaign_Member_Name__c=intcamnew.NSSales_Internal_Campaign_Member_Hidden__c;
                // cmpMemlog.NSSales_New_Value__c=intcamnew.NSSales_Internal_User__c;
                cmpMemlog.NSSales_Campaign__c=intcamnew.NSSales_Campaign__c;
            //    cmpMemlog.NSSales_Audit_Date__c=local;
                cmpMemlog.NSSales_Audit_Date__c=todaysDate;
                
                
                insertIntMem.add(cmpMemLog);
                
                
            }
            
            database.insert(insertIntMem,false);
            
        }
        catch(Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME1);
        } 
        
        
    }
    
    public static void deleteRecordonCampaign_Member_Log(List<Internal_Campaign_Members__c> oldInternalCampaign){
        
        list<Campaign_Member_Log__c> insertIntMem = new list<Campaign_Member_Log__c>();
        
         /* Datetime now = Datetime.now();
                Integer offset = UserInfo.getTimezone().getOffset(now);
                Datetime local = now.addSeconds(offset/1000);*/
        
        Date todaysDate = Date.today();

        try{
            for(Internal_Campaign_Members__c intcamnew : oldInternalCampaign)
            {
                Campaign_Member_Log__c cmpMemLog= new Campaign_Member_Log__c();
                cmpMemLog.Name=intcamnew.NSSales_Internal_Campaign_Member_Hidden__c;
                cmpMemLog.NSSales_Role__c=intcamnew.NSSales_Role_Hidden__c;
                cmpMemLog.NSSales_phone__c=intcamnew.NSSales_Phone_Hidden__c; 
                cmpMemlog.NSSales_Object__c='InternalCampaign';
                cmpMemlog.NSSales_Action__c='Internal Campaign Member Removed';
                cmpMemlog.NSSales_Old_Value__c=intcamnew.NSSales_Internal_User__r.FirstName;
                cmpMemlog.NSSales_Campaign__c=intcamnew.NSSales_Campaign__c;
                cmpMemlog.NSSales_Campaign_Member_Name__c=intcamnew.NSSales_Internal_Campaign_Member_Hidden__c;
               // cmpMemlog.NSSales_Audit_Date__c=local;
                cmpMemlog.NSSales_Audit_Date__c=todaysDate;                
                
                insertIntMem.add(cmpMemLog);
                if(intcamnew.NSSales_Email__c!=null)
                {
                    emailsend(intcamnew.NSSales_Email__c,intcamnew.NSSales_Campaign__c,intcamnew.NSSales_Internal_Campaign_Member_Hidden__c);
                }
                if(intcamnew.NSSale_Non_Connect_NS_User_Email_Address__c!=null)
                {
                    emailsend(intcamnew.NSSale_Non_Connect_NS_User_Email_Address__c,intcamnew.NSSales_Campaign__c,intcamnew.NSSales_Internal_Campaign_Member_Hidden__c);
                }
            }
            
            database.insert(insertIntMem,false);
            
        }
        catch(Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME2);
        } 
        
        
    }
    
    public static void emailsend(string useremail, id campid ,string username){
        
        Campaign campaignDetails = new Campaign();

        
        for (Campaign  campaignDetail: [SELECT Id,Name FROM Campaign where id =: campid]){//my campaign.id
               campaignDetails.Name=campaignDetail.Name;
               campaignDetails.id=campaignDetail.id;
            }
        
               
        Try{       
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {useremail};
            message.subject = 'You have been removed from a Campaign in ConnectNS';
           // message.plainTextBody = 'You are romved as a member of a campaign';
            String body='';
            body +='<html><body>';
            body += 'Hi ' +username+',<br/><br/>You have been removed from the following Campaign '+'<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+campaignDetails.id+'">'+campaignDetails.name+'</a>'+'<br/>as an Internal Campaign Member.';
            message.setHtmlBody(body);
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
                
            } else 
            {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
            
        }
        catch(Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME3);
        } 
        
        
        
    }
    
    
    
    public static void updateRecordonCampaign_Member_Log(Map<Id,Internal_Campaign_Members__c> NewInternalCampaign,Map<Id,Internal_Campaign_Members__c> oldInternalCampaign){
        list<Campaign_Member_Log__c> insertIntMem = new list<Campaign_Member_Log__c>();
         /*  Datetime now = Datetime.now();
                Integer offset = UserInfo.getTimezone().getOffset(now);
                Datetime local = now.addSeconds(offset/1000);*/
        Date todaysDate = Date.today();
        
        Map<id,string> userall= new Map<id,string>();
        set<id> userids=new set<id>();
        Try{
            for(Internal_Campaign_Members__c eachcampmember :NewInternalCampaign.values() )
            {
                userids.add(eachcampmember.NSSales_Internal_User__c);
            }
            for (user userid : [select id,name from user where id in :userids ])
            {
                userall.put(userid.id,userid.name);             
            }
            
            for(Internal_Campaign_Members__c eachIntecam :   NewInternalCampaign.values())
            {
                /*  User can't be modified :Logic in Validation Rule
*  if(oldInternalCampaign.get(eachIntecam.id).NSSales_Internal_User__c !=eachIntecam.NSSales_Internal_User__c) 

{
Campaign_Member_Log__c cmpMemLog1= new Campaign_Member_Log__c();   

cmpMemlog1.NSSales_Object__c='InternalCampaign';
cmpMemlog1.NSSales_Action__c='Name Change';
cmpMemlog1.NSSales_Campaign__c=eachIntecam.NSSales_Campaign__c;
cmpMemLog1.NSSales_Role__c=eachIntecam.NSSales_Role_Hidden__c;
cmpMemLog1.NSSales_phone__c=eachIntecam.NSSales_Phone_Hidden__c; 
cmpMemlog1.NSSales_Audit_Date__c=system.now();
cmpMemlog1.NSSales_Old_Value__c=userall.get(oldInternalCampaign.get(eachIntecam.id).NSSales_Internal_User__c);
cmpMemlog1.NSSales_New_Value__c=userall.get(eachIntecam.NSSales_Internal_User__c);
cmpMemlog1.NSSales_Campaign_Member_Name__c=eachIntecam.NSSales_Internal_Campaign_Member_Hidden__c;

insertIntMem.add(cmpMemlog1);

}
*/
                if(oldInternalCampaign.get(eachIntecam.id).NSSales_Role__c !=eachIntecam.NSSales_Role__c)
                {
                    Campaign_Member_Log__c cmpMemLog2= new Campaign_Member_Log__c();   
                    
                    
                    cmpMemlog2.NSSales_Object__c='InternalCampaign';
                    cmpMemlog2.NSSales_Action__c='Role Updated';
                    cmpMemlog2.NSSales_Campaign__c=eachIntecam.NSSales_Campaign__c;
                    cmpMemLog2.NSSales_Role__c=eachIntecam.NSSales_Role_Hidden__c;
                    cmpMemLog2.NSSales_phone__c=eachIntecam.NSSales_Phone_Hidden__c; 
                    //cmpMemlog2.NSSales_Audit_Date__c=local;
                    cmpMemlog2.NSSales_Audit_Date__c=todaysDate;
                   
                    cmpMemlog2.NSSales_Old_Value__c=oldInternalCampaign.get(eachIntecam.id).NSSales_Role__c;
                    cmpMemlog2.NSSales_New_Value__c=eachIntecam.NSSales_Role__c;
                    cmpMemlog2.NSSales_Campaign_Member_Name__c=eachIntecam.NSSales_Internal_Campaign_Member_Hidden__c;
                    insertIntMem.add(cmpMemlog2);
                }
                if(oldInternalCampaign.get(eachIntecam.id).NSSales_Phone__c !=eachIntecam.NSSales_Phone__c)
                {
                    Campaign_Member_Log__c cmpMemLog2= new Campaign_Member_Log__c();   
                    
                    cmpMemlog2.NSSales_Object__c='InternalCampaign';
                    cmpMemlog2.NSSales_Action__c='Phone Number Updated';
                    cmpMemlog2.NSSales_Campaign__c=eachIntecam.NSSales_Campaign__c;
                    cmpMemLog2.NSSales_Role__c=eachIntecam.NSSales_Role_Hidden__c;
                    cmpMemLog2.NSSales_phone__c=eachIntecam.NSSales_Phone_Hidden__c; 
                   // cmpMemlog2.NSSales_Audit_Date__c=local;
                    cmpMemlog2.NSSales_Audit_Date__c=todaysDate;
                    cmpMemlog2.NSSales_Old_Value__c=oldInternalCampaign.get(eachIntecam.id).NSSales_Phone__c;
                    cmpMemlog2.NSSales_New_Value__c=eachIntecam.NSSales_Phone__c;
                    cmpMemlog2.NSSales_Campaign_Member_Name__c=eachIntecam.NSSales_Internal_Campaign_Member_Hidden__c;
                    insertIntMem.add(cmpMemlog2);
                }
                
                /* User can't be modified :Logic in Validation Rule             * 
*  if(oldInternalCampaign.get(eachIntecam.id).NSSales_Non_Connect_NS_User__c !=eachIntecam.NSSales_Non_Connect_NS_User__c)
{
Campaign_Member_Log__c cmpMemLog3= new Campaign_Member_Log__c();   

cmpMemlog3.NSSales_Object__c='InternalCampaign';
cmpMemlog3.NSSales_Action__c='Name';
cmpMemlog3.NSSales_Campaign__c=eachIntecam.NSSales_Campaign__c;
cmpMemLog3.NSSales_Role__c=eachIntecam.NSSales_Role_Hidden__c;
cmpMemLog3.NSSales_phone__c=eachIntecam.NSSales_Phone_Hidden__c; 
cmpMemlog3.NSSales_Audit_Date__c=system.now();
cmpMemlog3.NSSales_Old_Value__c=oldInternalCampaign.get(eachIntecam.id).NSSales_Non_Connect_NS_User__c;
cmpMemlog3.NSSales_New_Value__c=eachIntecam.NSSales_Non_Connect_NS_User__c;
cmpMemlog3.NSSales_Campaign_Member_Name__c=eachIntecam.NSSales_Internal_Campaign_Member_Hidden__c;    
insertIntMem.add(cmpMemlog3);
}
*/
                if(oldInternalCampaign.get(eachIntecam.id).NSSales_Non_Connect_NS_User_Role__c !=eachIntecam.NSSales_Non_Connect_NS_User_Role__c)
                {
                    Campaign_Member_Log__c cmpMemLog4= new Campaign_Member_Log__c();   
                    
                    cmpMemlog4.NSSales_Object__c='InternalCampaign';
                    cmpMemlog4.NSSales_Action__c='Role Updated';
                    cmpMemlog4.NSSales_Campaign__c=eachIntecam.NSSales_Campaign__c;
                   // cmpMemlog4.NSSales_Audit_Date__c=local;
                    cmpMemlog4.NSSales_Audit_Date__c=todaysDate;
                    cmpMemLog4.NSSales_Role__c=eachIntecam.NSSales_Role_Hidden__c;
                    cmpMemLog4.NSSales_phone__c=eachIntecam.NSSales_Phone_Hidden__c; 
                    cmpMemlog4.NSSales_Old_Value__c=oldInternalCampaign.get(eachIntecam.id).NSSales_Non_Connect_NS_User_Role__c;
                    cmpMemlog4.NSSales_New_Value__c=eachIntecam.NSSales_Non_Connect_NS_User_Role__c;
                    cmpMemlog4.NSSales_Campaign_Member_Name__c=eachIntecam.NSSales_Internal_Campaign_Member_Hidden__c;
                    insertIntMem.add(cmpMemlog4);
                }
                if(oldInternalCampaign.get(eachIntecam.id).NSSale_Non_Connect_NS_User_Phone_Number__c !=eachIntecam.NSSale_Non_Connect_NS_User_Phone_Number__c)
                {
                    Campaign_Member_Log__c cmpMemLog4= new Campaign_Member_Log__c();   
                    
                    cmpMemlog4.NSSales_Object__c='InternalCampaign';
                    cmpMemlog4.NSSales_Action__c='Phone Number Updated';
                    cmpMemlog4.NSSales_Campaign__c=eachIntecam.NSSales_Campaign__c;
                   // cmpMemlog4.NSSales_Audit_Date__c=local;
                    cmpMemlog4.NSSales_Audit_Date__c=todaysDate;
                    cmpMemLog4.NSSales_Role__c=eachIntecam.NSSales_Role_Hidden__c;
                    cmpMemLog4.NSSales_phone__c=eachIntecam.NSSales_Phone_Hidden__c; 
                    cmpMemlog4.NSSales_Old_Value__c=oldInternalCampaign.get(eachIntecam.id).NSSale_Non_Connect_NS_User_Phone_Number__c;
                    cmpMemlog4.NSSales_New_Value__c=eachIntecam.NSSale_Non_Connect_NS_User_Phone_Number__c;
                    cmpMemlog4.NSSales_Campaign_Member_Name__c=eachIntecam.NSSales_Internal_Campaign_Member_Hidden__c;
                    insertIntMem.add(cmpMemlog4);
                }
                if(oldInternalCampaign.get(eachIntecam.id).NSSale_Non_Connect_NS_User_Email_Address__c !=eachIntecam.NSSale_Non_Connect_NS_User_Email_Address__c)
                {
                    Campaign_Member_Log__c cmpMemLog4= new Campaign_Member_Log__c();   
                    
                    cmpMemlog4.NSSales_Object__c='InternalCampaign';
                    cmpMemlog4.NSSales_Action__c='Email Updated';
                    cmpMemlog4.NSSales_Campaign__c=eachIntecam.NSSales_Campaign__c;
                   // cmpMemlog4.NSSales_Audit_Date__c=local;
                    cmpMemlog4.NSSales_Audit_Date__c=todaysDate;
                    cmpMemLog4.NSSales_Role__c=eachIntecam.NSSales_Role_Hidden__c;
                    cmpMemLog4.NSSales_phone__c=eachIntecam.NSSales_Phone_Hidden__c; 
                    cmpMemlog4.NSSales_Old_Value__c=oldInternalCampaign.get(eachIntecam.id).NSSale_Non_Connect_NS_User_Email_Address__c;
                    cmpMemlog4.NSSales_New_Value__c=eachIntecam.NSSale_Non_Connect_NS_User_Email_Address__c;
                    cmpMemlog4.NSSales_Campaign_Member_Name__c=eachIntecam.NSSales_Internal_Campaign_Member_Hidden__c;
                    insertIntMem.add(cmpMemlog4);
                }
                
            }
            database.insert(insertIntMem,false);
            
        }
        catch(Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME4);
        } 
        
    }
    
    
}