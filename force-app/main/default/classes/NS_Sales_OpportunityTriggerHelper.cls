/**@author  Accenture
* @Created Date Apr,2019
* @version  1.0
* @description This class conatins methods which are invoked by OpportunityTrigger l 


*/ 
public Without sharing class NS_Sales_OpportunityTriggerHelper {
    
    /*Class Name*/
    private static final String CLASS_NAME = 'NS_Sales_OpportunityTriggerHelper';
    /*Method Name*/ /*Gunjari 03/07*/
    private static final String METHOD_NAME1='insertAllOpportunityRollupRecord';
    private static final String METHOD_NAME2='updateAllOpportunityRollupRecord';
    private static final String METHOD_NAME3='updateCounterForFinalApproval';
    
    /*Gunjari 03/07*/
    private static List<Id> BUId = new List<Id>();
    private static List<BU__c> buList = new List<BU__c>();
    private static List<BU__c> buUpdateList = new List<BU__c>();
    /*constatnts*/
    //public static Final String StageName_QA = NSSales_NPOConstants.StageName_QA;
    //public static Final String StageName_IR = NSSales_NPOConstants.StageName_IR;
    /*Method Name*/
    private static final String METHOD_NAME4='updateOpportunity';
    private static final String METHOD_NAME5='checkUpdateOnInsert';
    private static final String METHOD_NAME6='sendEmailToCampaignMembersOnOptyCreate';
    private static final String METHOD_NAME7='sendEmailToCampaignMembersOnOptyUpdate';
    private static final String METHOD_NAME8='updateAccount';
    private static final String METHOD_NAME9='oppStageChangeUpdate';
    private static final String METHOD_NAME10='changeRecTypeOn_609_1_Create';
    private static final String METHOD_NAME11='set_609_1_SendForApproval';
    private static final String METHOD_NAME12='fetchSwitchCoordinates_609_1';
    private static final String METHOD_NAME13='updateOptyName';
    private static final String METHOD_NAME14='notify_Specific_Users_On_609_1_Create';
    
    
    public static void updateCounterForFinalApproval(List<Opportunity> OptyList){
        
        Integer checkBoxCount = 0;
        Integer approvalCount = 0;
        try{
            for(Opportunity opp : OptyList){
                //removed true=true check
                if(opp.StageName.equalsIgnoreCase(NSSales_NPOConstants.StageName_IR) &&
                   (opp.NSSales_OPS_Planning_North__c  || opp.NSSales_OPS_Planning_South__c  || opp.NSSales_OPS_Planning_Central__c  || 
                    opp.NSSales_Unit_Train__c  || opp.NSSales_Network_Capacity__c  || opp.NSSales_Network_Optimization__c  ||
                    opp.NSSales_Interline_Services__c || opp.NSSales_Auto_Intermodal__c  || opp.NSSales_Industrial_Products_Unit__c
                    || opp.NSSales_Power__c ||opp.NSSales_OPS_Planning_NOC__c )){
                        if(opp.NSSales_OPS_Planning_North__c)
                        {CheckBoxCount = CheckBoxCount + 1;}
                        if(opp.NSSales_OPS_Planning_South__c )
                        {CheckBoxCount = CheckBoxCount + 1;}
                        if(opp.NSSales_OPS_Planning_Central__c )
                        {CheckBoxCount = CheckBoxCount + 1;}
                        if(opp.NSSales_Unit_Train__c )
                        {CheckBoxCount = CheckBoxCount + 1;}
                        if(opp.NSSales_Network_Capacity__c )
                        { CheckBoxCount = CheckBoxCount + 1;}
                        if(opp.NSSales_Network_Optimization__c )
                        {CheckBoxCount = CheckBoxCount + 1;}
                        if(opp.NSSales_Auto_Intermodal__c )
                        {CheckBoxCount = CheckBoxCount + 1;}
                        if(opp.NSSales_Industrial_Products_Unit__c)
                        { CheckBoxCount = CheckBoxCount + 1;}
                        if(opp.NSSales_Interline_Services__c )
                        { CheckBoxCount = CheckBoxCount + 1;}
                        //Added by Sudipta For New 2 Region of Approval . Power & NOC on 09-08-2019
                        if(opp.NSSales_OPS_Planning_NOC__c )
                        { CheckBoxCount = CheckBoxCount + 1;}
                        if(opp.NSSales_Power__c )
                        { CheckBoxCount = CheckBoxCount + 1;}
                        
                        if(opp.NSSales_OPS_Planning_North__c && 
                           (NSSales_NPOConstants.NPOStatus_APPROVED).equalsIgnoreCase(opp.NSSales_OPS_Planning_North_Status__c))
                        {ApprovalCount = ApprovalCount + 1;}
                        if(opp.NSSales_OPS_Planning_South__c  && 
                           (NSSales_NPOConstants.NPOStatus_APPROVED).equalsIgnoreCase(opp.NSSales_OPS_Planning_South_Status__c))
                        {ApprovalCount = ApprovalCount + 1;}
                        if(opp.NSSales_OPS_Planning_Central__c  &&
                           (NSSales_NPOConstants.NPOStatus_APPROVED).equalsIgnoreCase(opp.NSSales_OPS_Planning_Central_Status__c))
                        {ApprovalCount = ApprovalCount + 1;}
                        if(opp.NSSales_Unit_Train__c  && 
                           (NSSales_NPOConstants.NPOStatus_APPROVED).equalsIgnoreCase(opp.NSSales_Unit_Train_Status__c))
                        {ApprovalCount = ApprovalCount + 1;}
                        if(opp.NSSales_Network_Capacity__c  && 
                           (NSSales_NPOConstants.NPOStatus_APPROVED).equalsIgnoreCase(opp.NSSales_Network_Capacity_Status__c))
                        {ApprovalCount = ApprovalCount + 1;}
                        if(opp.NSSales_Network_Optimization__c && 
                           (NSSales_NPOConstants.NPOStatus_APPROVED).equalsIgnoreCase(opp.NSSales_Network_Optimization_Status__c))
                        {ApprovalCount = ApprovalCount + 1;}
                        if(opp.NSSales_Interline_Services__c  && 
                           (NSSales_NPOConstants.NPOStatus_APPROVED).equalsIgnoreCase(opp.NSSales_Interline_Services_Status__c))
                        {ApprovalCount = ApprovalCount + 1;}
                        if(opp.NSSales_Auto_Intermodal__c  && 
                           (NSSales_NPOConstants.NPOStatus_APPROVED).equalsIgnoreCase(opp.NSSales_Auto_Intermodal_Status__c))
                        { ApprovalCount = ApprovalCount + 1;}
                        if(opp.NSSales_Industrial_Products_Unit__c && 
                           (NSSales_NPOConstants.NPOStatus_APPROVED).equalsIgnoreCase(opp.NSSales_Industrial_Products_Unit_Status__c))   
                        {ApprovalCount = ApprovalCount + 1;}
                        //Added by Sudipta For New 2 Region of Approval . Power & NOC on 09-08-2019 
                        if(opp.NSSales_OPS_Planning_NOC__c && 
                           (NSSales_NPOConstants.NPOStatus_APPROVED).equalsIgnoreCase(opp.NSSales_OPS_Planning_NOC_Status__c))   
                        {ApprovalCount = ApprovalCount + 1;} 
                        if(opp.NSSales_Power__c && 
                           (NSSales_NPOConstants.NPOStatus_APPROVED).equalsIgnoreCase(opp.NSSales_Power_Approval_Status__c))   
                        {ApprovalCount = ApprovalCount + 1;}
                        
                        
                        if(CheckBoxCount == ApprovalCount)
                        {opp.NSSales_All_Approval_Received__c = TRUE;}
                    }
            }
        }
        catch (Exception exp) {
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME3);
        }        
    }
    
    /*** On opportunity stage change from Internal Review to Qualification/Analysis  ***/
    public static void updateOpportunity(List<Opportunity> oppOldList,List<Opportunity> oppNewList){
        
        try{
            
            List<Opportunity> updOpty = new List<Opportunity>();
            for(Opportunity opOld:oppOldList)
            {
                for(Opportunity opNew:oppNewList)
                {
                    if((opOld.StageName != opNew.StageName) && 
                       ((opOld.StageName == NSSales_NPOConstants.StageName_IR && opNew.StageName == NSSales_NPOConstants.StageName_QA)||
                        (opOld.StageName == NSSales_NPOConstants.StageName_IR && opNew.StageName == NSSales_NPOConstants.StageName_NEW)||
                        (opOld.StageName == NSSales_NPOConstants.StageName_PROPOSAL && opNew.StageName == NSSales_NPOConstants.StageName_QA)))//Added by Gunjari for New Request on 05/09
                    {
                        updOpty.add(opNew);
                    }
                    
                }
            }
            if(updOpty.size()>0){
                if(!NSSales_NPOConstants.updateOpportunity){
                    NSSales_NPOConstants.updateOpportunity = true;
                    for(Opportunity op:updOpty)
                    {
                        if(!(op.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NSSales_609_1').getRecordTypeId()))
                        {
                            op.NSSales_StageChanged__c = TRUE;
                        }
                        if(op.RecordTypeId==Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Read Only').getRecordTypeId())
                        {
                            op.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('General Opportunity').getRecordTypeId();
                            op.StageName = NSSales_NPOConstants.StageName_QA;
                        }
                        if(op.RecordTypeId==Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NPO Operations ReadOnly').getRecordTypeId())
                        {
                            op.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NPO Operations Opportunity').getRecordTypeId();
                            op.StageName=NSSales_NPOConstants.StageName_NEW;
                        }
                        op.NSSales_Approval_Needed__c = False;
                        op.NSSales_OPS_Planning_North__c = False;
                        op.NSSales_OPS_Planning_South__c = False;
                        op.NSSales_OPS_Planning_Central__c = False;
                        op.NSSales_Network_Capacity__c = False;
                        op.NSSales_Network_Optimization__c = False;
                        op.NSSales_Unit_Train__c = False;
                        op.NSSales_Auto_Intermodal__c = False;
                        op.NSSales_Interline_Services__c = False;
                        op.NSSales_Industrial_Products_Unit__c = False;
                        op.NSSales_Power__c=False;
                        op.NSSales_OPS_Planning_NOC__c=False;
                        
                        
                        op.NSSales_Industrial_Products_Unit_Status__c = NS_StaticVariablesUtility.CONST_BLANK;
                        op.NSSales_Interline_Services_Status__c = NS_StaticVariablesUtility.CONST_BLANK;
                        op.NSSales_Network_Capacity_Status__c = NS_StaticVariablesUtility.CONST_BLANK;
                        op.NSSales_Network_Optimization_Status__c = NS_StaticVariablesUtility.CONST_BLANK;
                        op.NSSales_OPS_Planning_North_Status__c = NS_StaticVariablesUtility.CONST_BLANK;
                        op.NSSales_OPS_Planning_South_Status__c = NS_StaticVariablesUtility.CONST_BLANK;
                        op.NSSales_OPS_Planning_Central_Status__c = NS_StaticVariablesUtility.CONST_BLANK;
                        op.NSSales_Unit_Train_Status__c = NS_StaticVariablesUtility.CONST_BLANK;
                        op.NSSales_Auto_Intermodal_Status__c = NS_StaticVariablesUtility.CONST_BLANK;
                        op.NSSales_OPS_Planning_NOC_Status__c = NS_StaticVariablesUtility.CONST_BLANK;
                        op.NSSales_Power_Approval_Status__c=NS_StaticVariablesUtility.CONST_BLANK;
                        
                        //op.StageName = NSSales_NPOConstants.StageName_QA;
                    }
                }
                NSSales_RecallNPO.singleEmailMessageSend(updOpty,NS_StaticVariablesUtility.CONST_BLANK);
            }
        }
        catch (Exception exp) {
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME4);
        }
        
    }
    //31/7 End of on opportunity stage change from Internal Review to Qualification/Analysis ***/
    public static void checkUpdateOnInsert(Map<ID,Opportunity> oldMap, Map<ID,Opportunity> newMap){
        try{
            list<Opportunity> opList = new list<Opportunity>();
            for(Opportunity Oppo: oldMap.values() )
            {
                Opportunity newOpp =  newMap.get(Oppo.Id);
                if(newOpp.Name!=Oppo.Name){
                    opList.add(newOpp);
                }
            }
            if(!opList.isEmpty())
            {
                updateAccount(opList);
            }
            //   for(Opportunity oldops : oldlist){
            //  for(Opportunity newops : newList){
            //      if(oldops.Name==newops.Name){
            //updateAccount();
            // }
            //       }
            //    }
            //  }
        }
        catch (Exception exp) {
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME5);
        }
        
        
    }
    
    
    
    
    public static void updateAccount(List<Opportunity> oppList){
        List<Id> optyAccountIds = new List<Id>();
        list<id> listToDel=new list<id>();
        list<BU__c> listTOUpdate= new list<BU__c>();
        set<id> oppAccClass =new set<Id>();
        List<BU__c> validBUList = new List<BU__c>();
        try{
            
            for(Opportunity op:oppList){ // previous code
                optyAccountIds.add(op.AccountId);
                if(op.NSSales_Account_Classification__c != null){
                    OppAccClass.add(op.NSSales_Account_Classification__c);
                    
                }
            }
            validBUList = [Select id,Account__c,
                           NS_Account_Type_BU__c,
                           NS_Business_Group_BU__c,
                           NSSales_Group_Name1__c,
                           NS_Line_of_Business_BU__c,
                           NS_Major_Group_BU__c,
                           NS_Minor_Group_BU__c,
                           recordtypeid,
                           NS_Sub_Business_Group_BU__c from BU__c where Account__c IN:optyAccountIds 
                           and id not IN:OppAccClass LIMIT 50000];
            
            if(OppAccClass.size()>0){
                BU__c accC = [Select id,Name,Account__c,
                              NS_Account_Type_BU__c,
                              NS_Business_Group_BU__c,
                              NSSales_Group_Name1__c,
                              NS_Line_of_Business_BU__c,
                              NS_Major_Group_BU__c,
                              NS_Minor_Group_BU__c,
                              recordtypeid,
                              NS_Sub_Business_Group_BU__c from BU__c where id IN:OppAccClass limit 01];
                
                
                if(validBUList.size()>0){
                    for(BU__c bu:validBUList)
                    {
                        
                        
                        
                        if(AccC.NS_Account_Type_BU__c == bu.NS_Account_Type_BU__c &&
                           AccC.NS_Business_Group_BU__c == bu.NS_Business_Group_BU__c &&
                           AccC.recordtypeid == bu.recordtypeid &&
                           AccC.NS_Line_of_Business_BU__c == bu.NS_Line_of_Business_BU__c &&
                           AccC.NS_Major_Group_BU__c == bu.NS_Major_Group_BU__c &&
                           AccC.NS_Minor_Group_BU__c == bu.NS_Minor_Group_BU__c &&
                           AccC.NS_Sub_Business_Group_BU__c == bu.NS_Sub_Business_Group_BU__c)
                        {
                            for(Opportunity op:oppList){ 
                                if(op.NSSales_Account_Classification__c==AccC.Id ){
                                    op.NSSales_Account_Classification__c=bu.Id;
                                    listToDel.add(AccC.Id);
                                    break;
                                }
                            }
                        }
                        else{
                            for(Opportunity op:oppList){ 
                                if(op.NSSales_Account_Classification__c==AccC.Id ){
                                    AccC.Account__c=op.AccountId;
                                    listTOUpdate.Add(AccC);
                                }
                            }
                        }
                        
                    }
                }else{
                    for(Opportunity op:oppList){ 
                        if(op.NSSales_Account_Classification__c==AccC.Id ){
                            AccC.Account__c=op.AccountId;
                            listTOUpdate.Add(AccC);
                        }
                    }
                }
                database.delete(listToDel);
                Map<id,BU__c> updateMap = new map<id,BU__c>();
                updateMap.putAll(listTOUpdate);
                database.update(updateMap.values());
                
            }
        }
        catch (Exception exp) {
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME8);
        }
        
    }
    
    
    /*****Start of Req - Account Cases & Opportunities Roll-Up****************************/
    
    /*Gunjari 03/07 -- insert a new record in All Opportunity Rollups object when a new opportunity is created */
    public static void insertAllOpportunityRollupRecord(List<Opportunity> optyList){
        List<NSSales_AllOpportunityRollups__c> optyListToInsert = new List<NSSales_AllOpportunityRollups__c>();
        try{ 
            for (Opportunity opty : optyList){
                if(opty.AccountId!= null){
                    Id ultimateParentAccId = getUltimateParent(opty.AccountId); 
                    NSSales_AllOpportunityRollups__c optyRecord = new NSSales_AllOpportunityRollups__c();
                    optyRecord.NSSales_Opportunity__c = opty.Id;
                    optyRecord.NSSales_Account__c = opty.AccountId;
                    optyRecord.NSSales_UltimateParentAccount__c = ultimateParentAccId;
                    optyListToInsert.add(optyRecord);
                    
                }
            }
            if(!optyListToInsert.isEmpty()){
                Database.SaveResult[] srList = Database.insert(optyListToInsert,false); 
                NS_Utility.databaseSvResult(srList,METHOD_NAME1,CLASS_NAME);
            }
        }
        
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME1);
        }
        
    }
    
    /*Gunjari 03/07 -- update the corresponding record from All Opportunity Rollups object when an existing opportunity is updated */
    public static void updateAllOpportunityRollupRecord(Map<Id,Opportunity> newOptyMap,Map<Id,Opportunity> oldOptyMap){
        
        NSSales_AllOpportunityRollups__c optyRec= new NSSales_AllOpportunityRollups__c(); 
        List<NSSales_AllOpportunityRollups__c> optyListToUpdate = new List<NSSales_AllOpportunityRollups__c>();
        Map<Id,NSSales_AllOpportunityRollups__c> allOptyRollupMap= new Map<Id,NSSales_AllOpportunityRollups__c>();   
        List <NSSales_AllOpportunityRollups__c> tempAllOptyRollupList = new list <NSSales_AllOpportunityRollups__c>
            ([select Name, NSSales_Opportunity__c, NSSales_Account__c, NSSales_UltimateParentAccount__c from NSSales_AllOpportunityRollups__c 
              where NSSales_Opportunity__c = :newOptyMap.keySet() LIMIT 50000]);
        try{
            if(!tempAllOptyRollupList.isEmpty()){
                for(NSSales_AllOpportunityRollups__c rec :  tempAllOptyRollupList ){
                    allOptyRollupMap.put(rec.NSSales_Opportunity__c,rec);
                }
                
                for (Opportunity opty : newOptyMap.values()){
                    if(oldOptyMap.get(opty.Id).AccountId!=opty.AccountId)
                    {
                        if(opty.AccountId!= null){
                            optyRec= allOptyRollupMap.get(opty.Id);
                            optyRec.NSSales_Account__c=opty.AccountId;
                            Id ultimateParentAccId = getUltimateParent(opty.AccountId);
                            optyRec.NSSales_UltimateParentAccount__c = ultimateParentAccId;
                        }
                    }
                    if(optyRec.id !=null)
                        optyListToUpdate.add(optyRec);  
                    
                }
                if(!optyListToUpdate.isEmpty()){
                    Database.SaveResult[] srList = Database.update(optyListToUpdate,false); 
                    
                    NS_Utility.databaseSvResult(srList,METHOD_NAME2,CLASS_NAME);
                }
            }
            else{
                insertAllOpportunityRollupRecord(newOptyMap.values());
            }
        }  
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME2);
        }
        
    }
    
    
    /*Gunjari 03/07 -- get the ultimate parent account id from the account entered in opportunity*/
    private static Id getUltimateParent(Id accountId){
        Boolean topLevelParent = false;
        while ( !topLevelParent ) {
            Account acc = [ Select Id, ParentId From Account where Id =: accountId limit 1 ];
            if ( acc.ParentID != null ) {
                accountId = acc.ParentID;
            }
            else {
                topLevelParent = true;
            }
        }
        
        return accountId ;
    }
    
    /*****End of Req - Account Cases & Opportunities Roll-Up****************************/
    
    /********Hypercare Release - 5 : Defect -1561 : Notifying Internal Campaign Members*********************/
    
    /*Gunjari 08/26 -- on creation of a new opportunity, it sends an email to the internal campaign members
associated to the campaign, that the opportunity has been created with*/
    public static void sendEmailToCampaignMembersOnOptyCreate(List<Opportunity> optyList){
        try{
            List<Id> optyIdList = new List<Id>();
            for(Opportunity opty : optyList){
                optyIdList.add(opty.id); 
            }
            Map<Id, Id> optyCampaignMap = new Map<Id,Id>();
            for(Opportunity opty : [SELECT ID, CampaignId FROM Opportunity WHERE Id IN :optyIdList]) {
                if(opty.CampaignId != null){
                    optyCampaignMap.put(opty.Id, opty.CampaignId);//test opty,campaign
                }
            }
            Map<id,Campaign> campaignDetailsMap = new Map<id,Campaign>(
                [select id, Name FROM Campaign where id in :optyCampaignMap.values()]);
            Map<id,list<id>> campaignMemberMap = new Map<id,list<id>>();
            List<id> members = new List<id>();
            for(Internal_Campaign_Members__c campMemberRec : 
                [SELECT NSSales_Campaign__c, NSSales_Internal_User__c FROM Internal_Campaign_Members__c WHERE NSSales_Campaign__c IN : optyCampaignMap.values()]){
                    if(campaignMemberMap.containsKey(campMemberRec.NSSales_Campaign__c)){
                        List<Id> relatedCampaignMembers = campaignMemberMap.get(campMemberRec.NSSales_Campaign__c);
                        if(!relatedCampaignMembers.contains(campMemberRec.NSSales_Internal_User__c))
                        {
                            if(campMemberRec.NSSales_Internal_User__c != null){
                                relatedCampaignMembers.add(campMemberRec.NSSales_Internal_User__c); 
                            }
                            campaignMemberMap.put(campMemberRec.NSSales_Campaign__c,relatedCampaignMembers); 
                        }
                    }
                    else{
                        List<Id> relatedCampaignMembers = new List<Id>();
                        if(campMemberRec.NSSales_Internal_User__c != null){
                            relatedCampaignMembers.add(campMemberRec.NSSales_Internal_User__c);
                        }
                        campaignMemberMap.put(campMemberRec.NSSales_Campaign__c,relatedCampaignMembers); // campaign, sourav,GG
                    }
                }
            
            Map<id, User> userDetailsMap = new Map<id, User>();
            set<id> userIds = new set<id>();
            for(List<Id> idRec : campaignMemberMap.values()){
                userIds.addall(idRec);
            }
            for (User userDetail : [SELECT Id,Name,Email FROM USER where id IN : userIds]){
                userDetailsMap.put(userDetail.id,userDetail);
            }
            Messaging.SingleEmailMessage [] emails = new Messaging.SingleEmailMessage[]{};
                for(Opportunity opty : optyList) {
                    if(opty.CampaignId != null){
                        for(Id memberId : campaignMemberMap.get(optyCampaignMap.get(opty.id))){
                            
                            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                            email.setSubject('Opportunity : ' +opty.Account_Name__c+': '+opty.NS_Orig_Department_for_Oppty_Name__c +': '+ opty.NS_Created_Date_as_Text__c+' resulted from Campaign : '+campaignDetailsMap.get(opty.CampaignId).Name );
                            email.setToAddresses(new List<String> {userDetailsMap.get(memberId).email});
                            String body='';
                            body +='<html><body>'; 
                            body += 'Hi ' +userDetailsMap.get(memberId).Name + ',<br/><br/>This is to notify that a new opportunity ';
                            body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+opty.id+'">'+opty.Account_Name__c+': '+opty.NS_Orig_Department_for_Oppty_Name__c +': '+ opty.NS_Created_Date_as_Text__c+'</a>';
                            body += ' has been added to the campaign ';
                            body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+campaignDetailsMap.get(opty.CampaignId).id+'">'+campaignDetailsMap.get(opty.CampaignId).Name+'</a>';
                            body +='.<br/><br/>Regards<br/> Norfolk Southern'; 
                            body +='</body></html>'; 
                            email.setHtmlBody(body);
                            emails.add(email);
                        }
                    }
                }
            Messaging.sendEmail(emails);
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME6);
        }
        
    }
    
    
    /*Gunjari 08/26 -- on update of a new opportunity, it sends an email to the internal campaign members
associated to the campaign, that the opportunity is updated with*/
    public static void sendEmailToCampaignMembersOnOptyUpdate(Map<Id,Opportunity> newOptyMap,Map<Id,Opportunity> oldOptyMap){
        try{
            List<Opportunity> optyListWithChangedCampaign = new List<Opportunity>();
            for (Opportunity opty : newOptyMap.values()){
                if(oldOptyMap.get(opty.Id).campaignId!=opty.campaignId)
                {
                    optyListWithChangedCampaign.add(opty);
                }
            }
            if(!optyListWithChangedCampaign.isEmpty())
            {
                sendEmailToCampaignMembersOnOptyCreate(optyListWithChangedCampaign);
            }
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME7);
        }          
        
    }
    
    /*********Hypercare Release - 5 : Defect -1561 : Notifying Internal Campaign Members*********************/
    
    /******POC for 609.1 Switch Removal***************************/
    public static void changeRecTypeOn_609_1_Create(List<Opportunity> optyList){
        try{
            String loggedInUserprofile =[Select Id, Name from Profile where Id=:UserInfo.getProfileId()].Name;
            for(Opportunity opty:optyList){
                if(opty.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NS_General_Opportunity').getRecordTypeId() 
                   && opty.NSSales_609_1_SwitchRemovalRequest__c == TRUE 
                   && (loggedInUserprofile == 'NS Industrial Development Manager' || loggedInUserprofile == 'System Administrator' || loggedInUserprofile == 'NS Sales Manager'))
                {
                    opty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NSSales_609_1').getRecordTypeId();
                }  
            }
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME10);
        }  
    }
    
    
    
    
    
    public static void set_609_1_SendForApproval(List<Opportunity> optyList){
        try{
            for(Opportunity opty : optyList){
                if(opty.StageName == 'Qualification/Analysis' &&
                   opty.NSSales_609_1_SwitchIdentificationNumber__c != null &&
                   opty.RecordTypeId == 
                   Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NSSales_609_1').getRecordTypeId()
                   && opty.NSSales_SendFor609_1_Approval__c == 0
                  ){
                      opty.NSSales_SendFor609_1_Approval__c = 1;
                      
                  }
            }
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME11);
        }  
        
    }
    //update 12/6
    
    public static void updateTimeinStatus(Map<id,Opportunity>newOppmap,Map<id,Opportunity> OldOppmap)
    {
        for(Opportunity op : newOppmap.values())
        {
            if(op.NSSales_609_1_status__c != OldOppmap.get(op.Id).NSSales_609_1_status__c && op.NSSales_609_1_status__c =='Under Review')
            {
                
                op.NS_Date_to_update_time_in_status__c = System.Today();
                // op.NSSales_609_1_TimeinStatus__c = (System.Today()).daysBetween( Date.valueOf(OldOppmap.get(op.Id).LastModifiedDate));
            }
            /* if(op.NSSales_609_1_status__c != OldOppmap.get(op.Id).NSSales_609_1_status__c && OldOppmap.get(op.Id).NSSales_609_1_status__c =='Under Review' && op.NS_Date_to_update_time_in_status__c != null)
{

Date myDate = Date.valueOf(OldOppmap.get(op.Id).NS_Date_to_update_time_in_status__c);

op.NSSales_609_1_TimeinStatus__c = ((myDate).daysBetween(date.Today())) +1;  


}*/
        }
    }
    
    
    
    //
    public static void oppStageChangeUpdate(Map<id,Opportunity> optyOld,Map<id,Opportunity> optyNew)
    {
        try{
            List<FeedItem> notifications= new List<FeedItem>();
            List<FeedItem> notificationsNgo= new List<FeedItem>();
            List<FeedItem> notificationsUser= new List<FeedItem>();
            List<FeedItem> notificationsNgoUser= new List<FeedItem>();
            List<Id> appOwners= new List<ID>();
            List<Id> oppOwners= new List<ID>();
            for(Opportunity ouser : optyNew.values())
            {
                appOwners.add(ouser.NS_SalesNPO_Approvers__c);
                oppOwners.add(ouser.OwnerId);
            }
            
            
            
            Map<id,User> userFetch=new map<id,User>();
            
            
            for(User usr : [SELECT id, name from User WHERE id IN : appOwners]){
                userFetch.put(usr.id, usr);
            }
            
            Map<id,User> useroppOwnerFetch=new map<id,User>();
            
            
            for(User usr : [SELECT id, name from User WHERE id IN : oppOwners]){
                useroppOwnerFetch.put(usr.id, usr);
            }
            
            for(Opportunity o : optyNew.values())
            {
                
                if(o.StageName == 'Negotiation' &&  optyOld.get(o.id).StageName == 'Proposal' )
                    // &&  o.RecordType.DeveloperName == 'NS_General_Opportunity'
                {
                    FeedItem post = new FeedItem(); 
                    FeedItem postuser = new FeedItem(); 
                    post.ParentId = o.Id; 
                    post.Body = '@'+userFetch.get(o.NS_SalesNPO_Approvers__c).name+',Please review updates made by ' +useroppOwnerFetch.get(o.OwnerId).name+
                        ' in the "Opportunity Owner NPO Updates" field : '+o.Opportunity_Owner_NPO_Updates__c +' ';
                    post.Title = o.Name ; 
                    post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Opportunity/'+o.id+'/view';
                    notifications.add(post);
                    postuser.ParentId = o.NS_SalesNPO_Approvers__c; 
                    postuser.Body = '@'+userFetch.get(o.NS_SalesNPO_Approvers__c).name+',Please review updates made by ' +useroppOwnerFetch.get(o.OwnerId).name+
                        ' in the "Opportunity Owner NPO Updates" field : '+o.Opportunity_Owner_NPO_Updates__c +' ';
                    postuser.Title = o.Name ; 
                    postuser.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Opportunity/'+o.id+'/view';
                    notificationsUser.add(postuser);
                    
                    o.Opportunity_Owner_NPO_Updates__c = '';
                    o.NS_30DaysStatusPro__c = 3;
                }
                if((o.StageName == 'Closed Won' || o.StageName == 'Closed Lost' || o.StageName == 'Cancelled') &&  optyOld.get(o.id).StageName == 'Negotiation' )
                    // &&  o.RecordType.DeveloperName == 'NS_General_Opportunity'
                {
                    FeedItem post = new FeedItem(); 
                    FeedItem postuser = new FeedItem(); 
                    post.ParentId = o.Id; 
                    post.Body = '@'+userFetch.get(o.NS_SalesNPO_Approvers__c).name+',Please review updates made by ' +useroppOwnerFetch.get(o.OwnerId).name+
                        ' in the "Opportunity Owner NPO Updates" field : '+o.Opportunity_Owner_NPO_Updates__c +' ';
                    post.Title = o.Name ; 
                    post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Opportunity/'+o.id+'/view';
                    notifications.add(post);
                    
                    
                    postuser.ParentId = o.NS_SalesNPO_Approvers__c; 
                    postuser.Body = '@'+userFetch.get(o.NS_SalesNPO_Approvers__c).name+',Please review updates made by ' +useroppOwnerFetch.get(o.OwnerId).name+
                        ' in the "Opportunity Owner NPO Updates" field : '+o.Opportunity_Owner_NPO_Updates__c +' ';
                    postuser.Title = o.Name ; 
                    postuser.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Opportunity/'+o.id+'/view';
                    notificationsNgoUser.add(postuser);
                    
                    
                    o.Opportunity_Owner_NPO_Updates__c = '';
                    o.NS_30DaysStatusNgo__c = 3;
                }
            }
            if(notifications.size()>0)
            {
                insert notifications;
            }
            if(notificationsUser.size()>0)
            {
                insert notificationsUser;
            }
            if(notificationsNgo.size()>0)
            {
                insert notificationsNgo;
            }
            if(notificationsNgoUser.size()>0)
            {
                insert notificationsNgoUser;
            }
        }
        catch(Exception e)
        {
            NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME9);
        }
        
    }
    
    public static void updateTimeStamps(Map<id,Opportunity> optyOldMap,Map<id,Opportunity> optyNewMap){
        
        for(Opportunity newOps:optyNewMap.values()){
            
            Opportunity oldOps = optyOldMap.get(newOps.Id);
            
            if((oldOps.StageName!=newOps.StageName)&&(newOps.StageName=='Internal Review')){
                newOps.Date_Opportunity_Owner_NPO_Updates__c =null;
                newOps.Date_Opportunity_Owner_NPO_Updates_NGO__c =null;
                newOps.NS_30DaysStatusPro__c=0;
                newOps.NS_30DaysStatusNgo__c=0;
                newOps.NS_7Days_Mail__c=null;
                newOps.NS_7Days_Mail_NGO__c=null;
                
            }
            
            
            if((oldOps.StageName!=newOps.StageName)&&(newOps.StageName=='Proposal')){
                newOps.Date_Opportunity_Owner_NPO_Updates__c =system.now();
                
            }
            if((oldOps.StageName!=newOps.StageName)&&(newOps.StageName=='Negotiation')){
                newOps.Date_Opportunity_Owner_NPO_Updates_NGO__c =system.now();
                
            }
            
            if((oldOps.StageName==newOps.StageName)
               &&(oldOps.Opportunity_Owner_NPO_Updates__c!=newOps.Opportunity_Owner_NPO_Updates__c)
               &&((oldOps.Opportunity_Owner_NPO_Updates__c==null)||(oldOps.Opportunity_Owner_NPO_Updates__c==''))
              ){
                  
                  if(oldOps.StageName=='Proposal'){
                      
                      newOps.NS_30DaysStatusPro__c=2;
                      newOps.Date_Opportunity_Owner_NPO_Updates__c =system.now();
                  }
                  else if(oldOps.StageName=='Negotiation'){
                      
                      newOps.NS_30DaysStatusNgo__c=2;
                      newOps.Date_Opportunity_Owner_NPO_Updates_NGO__c =system.now();
                  }
                  
              }
        }
    } 
    
    public static void alertValidationStageChange30Days (Map<id,Opportunity> optyOldMap,Map<id,Opportunity> optyNewMap){
        for(Opportunity newOps:optyNewMap.values()){
            Opportunity oldOps = optyOldMap.get(newOps.Id);
            
            if((oldOps.StageName!=newOps.StageName)&&(oldOps.StageName=='Proposal')
               &&((oldOps.Opportunity_Owner_NPO_Updates__c==null)||(oldOps.Opportunity_Owner_NPO_Updates__c==''))
               &&((newOps.Opportunity_Owner_NPO_Updates__c==null)||(newOps.Opportunity_Owner_NPO_Updates__c==''))
               &&(oldOps.NS_30DaysStatusPro__c==1)
              ){
                  
                  
                  newOps.adderror('Please provide an update in the Opportunity Owner NPO Updates field in order to move the Opportunity forward.');
                  
              }
            if((oldOps.StageName!=newOps.StageName)&&(oldOps.StageName=='Negotiation')
               &&((oldOps.Opportunity_Owner_NPO_Updates__c==null)||(oldOps.Opportunity_Owner_NPO_Updates__c==''))
               &&((newOps.Opportunity_Owner_NPO_Updates__c==null)||(newOps.Opportunity_Owner_NPO_Updates__c==''))
               &&(oldOps.NS_30DaysStatusNgo__c==1)
              ){
                  newOps.adderror('Please provide an update in the Opportunity Owner NPO Updates field in order to move the Opportunity forward.');   
              }
        }
    }
    
    
    public static void fetchSwitchCoordinates_609_1(List<Opportunity> OptyList){
        try{
            List<String> selectedSwitchIdList = new List<String>();
            for(Opportunity opty : optyList){
                selectedSwitchIdList.add(opty.NSSales_609_1_SwitchIdentificationNumber__c);
            }
            
            Map<String, NSSales_609_1_All_Switch_Coordinates__c> switchCoordinateMap = new Map<String, NSSales_609_1_All_Switch_Coordinates__c>();
            for(NSSales_609_1_All_Switch_Coordinates__c  switchCoordinateRec:[SELECT id,NSSales_Switch_Identification_Numbers__c,
                                                                              NSSales_Latitude__c,NSSales_Longitude__c
                                                                              FROM NSSales_609_1_All_Switch_Coordinates__c
                                                                              WHERE NSSales_Switch_Identification_Numbers__c IN :selectedSwitchIdList]){
                                                                                  switchCoordinateMap.put(switchCoordinateRec.NSSales_Switch_Identification_Numbers__c,switchCoordinateRec);
                                                                                  
                                                                              }
            
            for(Opportunity opty : optyList){
                if(opty.NSSales_609_1_SwitchIdentificationNumber__c!= null){
                    if(switchCoordinateMap.keyset().contains(opty.NSSales_609_1_SwitchIdentificationNumber__c)){
                        opty.NSSales_609_1_Latitude__c = switchCoordinateMap.get(opty.NSSales_609_1_SwitchIdentificationNumber__c).NSSales_Latitude__c;
                        opty.NSSales_609_1_Longitude__c = switchCoordinateMap.get(opty.NSSales_609_1_SwitchIdentificationNumber__c).NSSales_Longitude__c;
                    }
                    else{
                        opty.addError('No details found for the selected Switch Identification Number'); 
                    }
                    
                }
            }
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME12);
        }  
    }
    
    public static void updateOptyName(List<Opportunity> OptyList){
        try{
            list<id> accIdList =new list<id>();
            for(Opportunity opty : OptyList){
                accIdList.add(opty.AccountId);
            }
            map<id,Account> accountMap = new map<id,Account>([Select id,Name from Account where id IN : accIdList]);
            for(Opportunity opty : OptyList){
                opty.Name = accountMap.get(opty.AccountId).Name +': '+opty.NS_Orig_Department_for_Oppty_Name__c+': '+String.valueOf(Date.today()).removeEnd(' 00:00:00');
            }
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME13);
        }  
        
        
    }
    public static void primary_Account_Classification_AutoPopulate(List<Opportunity> opList)
    {
        for(Opportunity pp : opList){
            system.debug('SRV '+pp.NSSales_Account_Classification__c);
            if(pp.NSSales_Account_Classification__c!=null){
                pp.addError('Please do not add Account Classification until the Opportunity has been created');
                
            }
            
        }
        Set<id> AccIds= new Set<id>();
        
        for(Opportunity o : opList)
        {
            AccIds.add(o.AccountId);
        }
        System.debug('AccIds' +AccIds);
        
        
        List<NSSales_Marketing_Manager_Assignment__c> reqMMAs = 
            [select Primary_Account_Classification__c from NSSales_Marketing_Manager_Assignment__c where NSSales_Account__c in: AccIds AND NSSales_MarketingManager__c =: UserInfo.getUserId()];
        //System.debug(''+[select Primary_Account_Classification__c from NSSales_Marketing_Manager_Assignment__c where NSSales_Account__c in: AccIds]);                       
        System.debug('reqMMAs' +reqMMAs);
        Map<id,id> primaryAccClassAndAccount = new Map<id,id>(); 
        //Set<NSSales_Marketing_Manager_Assignment__c> checkIds=new Set<NSSales_Marketing_Manager_Assignment__c>();
        
        for(NSSales_Marketing_Manager_Assignment__c NSM:[select NSSales_Account__c,Primary_Account_Classification__c from NSSales_Marketing_Manager_Assignment__c where NSSales_Account__c in: AccIds AND NSSales_MarketingManager__c =: UserInfo.getUserId( )])
        {
            primaryAccClassAndAccount.put(NSM.NSSales_Account__c,NSM.Primary_Account_Classification__c);
        }
        
        /* for (integer i : reqMMAs.size())
{
checkIds.add(reqMMAs.get(i));
}*/
        
        for(Opportunity o2 : opList)
        {
            if(primaryAccClassAndAccount.get(o2.AccountId)!=null || primaryAccClassAndAccount.size()==1  )
                
            {
                o2.NSSales_Account_Classification__c=primaryAccClassAndAccount.get(o2.AccountId);
            }
        }
        
        System.debug('primaryAccClassAndAccount::::::'+ primaryAccClassAndAccount);
    }
    
    //Changes added on 01/15 as part of D-1908//
    public static void notify_Specific_Users_On_609_1_Create(List<Opportunity> optyList){
        try{
            List<Id> usersIdsInGroup= new List<Id>();
            List<GroupMember> groupMembers=[Select Id, group.type, UserOrGroupId
                                            From GroupMember
                                            where group.DeveloperName = 'NSSales_All_609_1_Notifications'];
            for(GroupMember gm : groupMembers)
            {
                usersIdsInGroup.add(gm.UserOrGroupId);
            }        
            system.debug('usersIdsInGroup-->'+usersIdsInGroup);
            List<String> userEmails = new List<String>();
            for(User userRec : [Select email from User where id in: usersIdsInGroup]){
                userEmails.add(userRec.Email);
            }
            
            
            Messaging.SingleEmailMessage [] emails = new Messaging.SingleEmailMessage[]{};
                List<FeedItem> postList = new List<FeedItem>();
            
            OrgWideEmailAddress noRpl = [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName='No Reply'].get(0);
            
            for(Opportunity opty : optyList){
                if(opty.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NSSales_609_1').getRecordTypeId())
                {
                    
                    for(integer i=0; i<usersIdsInGroup.size(); i++)
                    {
                        /*Send Bell Notification*/
                        FeedItem post = new FeedItem();
                        post.ParentId = usersIdsInGroup.get(i);
                        post.Body = 'A new 609.1 Opportunity has been created';
                        post.Title = opty.name;
                        post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Opportunity/'+opty.id+'/view';
                        postList.add(post);
                    }
                    
                    insert postList;
                    /*End of Send Bell Notification*/
                    
                    /*Send Email Notification*/
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setSubject('New 609.1 Opportunity Creation Alert');
                    email.setToAddresses(userEmails);
                    email.setOrgWideEmailAddressId(noRpl.Id);
                    String emailBody='';
                    emailBody +='<html><body>';
                    emailBody += 'A new 609.1 Opportunity has been created. <br/><br/>For your convenience you can click the following link to access the Opportunity in ConnectNS: ';
                    emailBody += '<br/><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Opportunity/'+opty.id+'/view">'+opty.Name+'</a>';
                    email.setHtmlBody(emailBody);
                    emails.add(email);  
                    Messaging.sendEmail(emails);
                    /*End of Send Email Notification*/
                    
                }
            }
            
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME14);
        }  
    }
    
    //SRV
    public static void validateAccess(List<Opportunity> opList){
        List<GroupMember> groupMembers=[Select Id, group.type, UserOrGroupId
                                        From GroupMember
                                        where group.DeveloperName = 'All_609_1_Access'];
        Map<id,User> mapUserid = new  Map<id,User>([SELECT id,Profile.Name FROM User]);
        list<id> allGroupUserId = new list<id>();
        for(GroupMember gg:groupMembers){
            allGroupUserId.add(gg.UserOrGroupId);
        }
        for(Opportunity op:opList){
            if(op.NsSales_Record_Locked__c==true){
                user u=mapUserid.get(userinfo.getUserId());
                if((op.OwnerId!=u.Id)&&(op.NSSales_609_1_FSManagerApprovalOwner__c!=u.Id)&&(op.NSSales_609_1_IDManagerApprovalOwner__c!=u.Id)&&(u.Profile.name!='System Administrator')&&(!allGroupUserId.contains(u.Id)))
                {
                    op.addError('The 609.1 Opportunity fields cannot be edited when in Internal Review');
                }
            }
        }
        
    }
    /*public static void update609StageChangeDate(List<Opportunity> OptyList,Map<id,Opportunity> oldOppoMap,boolean isInsert){

for(Opportunity oo: OptyList){
if(isInsert||oldOppoMap.get(oo.id).NSSales_609_1_status__c!=oo.NSSales_609_1_status__c){
oo.NSSales_609_1_Stage_Change__c=system.today();
}
}
}*/
}