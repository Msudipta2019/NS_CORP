/**@author  Accenture
* @Created Date Aug,2019
* @version  1.0
* @description This class conatins methods which are invoked by NSSales_InternalCampaignMembersTrigger
*/ 

public Without sharing class NSSales_IntCampaignMembersTriggerHelper {
    
    /*Class Name*/
    private static final String CLASS_NAME = 'NSSales_IntCampaignMembersTriggerHelper';
    /*Method Name*/
    public static final String METHOD_NAME1='sendNotificationToMembers';
    
    /********Hypercare Release - 5 : Defect -1561 : Notifying Internal Campaign Members*********************/
    
    /*Gunjari 08/26 --on addition of an Internal Campaign Member to a campaign,  this method notifies the member about it */
    public static void sendNotificationToMembers(List<Internal_Campaign_Members__c> internalMemberList){
        try{
            Set<id> internalMemberIds = new Set<id>(); 
            Map<id, User> userDetailsMap = new Map<id, User>();
            Map<id, Campaign> campaignDetails = new  Map<id, Campaign>();
            Map<Id, Id> campaignMemberMap = new Map<Id, Id>();
            Set<id> internalUserIdSet = new Set<id>();
            String recipientName = '';
            String recipientEmail = '';
            
            for(Internal_Campaign_Members__c member : internalMemberList ){
                internalMemberIds.add(member.id);
                internalUserIdSet.add(member.NSSales_Internal_User__c);
            }
            for (User userDetail : [SELECT Id,Name,Email FROM USER where id IN : internalUserIdSet]){
                userDetailsMap.put(userDetail.id,userDetail);
            }
            for(Internal_Campaign_Members__c campMemberRec : [SELECT ID,NSSales_Campaign__c  FROM Internal_Campaign_Members__c WHERE Id IN :internalMemberIds]){
                if(campMemberRec.NSSales_Campaign__c != null){
                    campaignMemberMap.put(campMemberRec.Id, campMemberRec.NSSales_Campaign__c);
                }
            }
            
            for (Campaign  campaignDetail: [SELECT Id,Name FROM Campaign where id IN : campaignMemberMap.values()]){//my campaign.id
                campaignDetails.put(campaignDetail.id,campaignDetail);
            }
            
            Messaging.SingleEmailMessage [] emails = new Messaging.SingleEmailMessage[]{};
                for(Internal_Campaign_Members__c member : internalMemberList){
                    if(member.NSSales_Campaign__c != null){
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setSubject('You have been added to a Campaign in ConnectNS');
                        if(member.NSSales_Internal_User__c != null)
                        {
                            recipientName = userDetailsMap.get(member.NSSales_Internal_User__c).Name;
                            recipientEmail = userDetailsMap.get(member.NSSales_Internal_User__c).email;
                        }
                        else if(member.NSSale_Non_Connect_NS_User_Email_Address__c!=null )
                        {
                            recipientEmail = member.NSSale_Non_Connect_NS_User_Email_Address__c;
                            if(member.NSSales_Non_Connect_NS_User__c != null ){
                                recipientName = member.NSSales_Non_Connect_NS_User__c;
                            }  
                        }
                        email.setToAddresses(new List<String> {recipientEmail});
                        String body='';
                        body +='<html><body>';
                        body += 'Hi ' +recipientName+ ',<br/><br/>You have been added to the following Campaign ';
                        body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+campaignDetails.get(campaignMemberMap.get(member.id)).id+'">'+campaignDetails.get(campaignMemberMap.get(member.id)).name+'</a>';
                        body += ' as an Internal Campaign Member.';
                        //body +='<br/><br/>Regards<br/> Norfolk Southern'; 
                        email.setHtmlBody(body);
                        emails.add(email);
                    }
                }
            Messaging.sendEmail(emails);
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME1);
        }   
        
    }
    
    //Commenting out this code since Caroline confirmed that there will be no update of Campaign in an Internal Campaign Member Recod //
    /*Gunjari 08/26 --on update of an Internal Campaign Member with a different camapign , this method notifies the member about it 
    public static void sendNotificationToMembersOnUpdate(Map<Id,Internal_Campaign_Members__c> newCampMemberMap,Map<Id,Internal_Campaign_Members__c> oldCampMemberMap){
        List<Internal_Campaign_Members__c> intCampMemberListWithChangedCampaign = new List<Internal_Campaign_Members__c>(); 
        for (Internal_Campaign_Members__c campMemberRec : newCampMemberMap.values()){
            if(oldCampMemberMap.get(campMemberRec.id).NSSales_Campaign__c!=campMemberRec.NSSales_Campaign__c)
            {
                intCampMemberListWithChangedCampaign.add(campMemberRec);
            }
        }
        if(!intCampMemberListWithChangedCampaign.isEmpty()){
            sendNotificationToMembersOnCreate(intCampMemberListWithChangedCampaign);
        }
    }*/
    
    /********Hypercare Release - 5 : Defect -1561 : Notifying Internal Campaign Members*********************/
    
     
    
}