/**@author  Accenture
* @Created Date Oct,2019
* @version  1.0 
* @description This class contains Server side controller for NSSales_609_1_ApprovalLayout Component 
*/ 
public withOut sharing  class NSSales_609_1_ApprovalProcessController {
    
    private static final String CLASS_NAME = 'NSSales_ApprovalHistoryController';
    private static final String METHOD_NAME1 = 'fetchOpportunityId';
    private static final String METHOD_NAME2 = 'setProcessInstanceWorkitemId';
    private static final String METHOD_NAME3 = 'findObjectNameFromRecordId';
    
    @AuraEnabled
    public static String fetchOpportunityId(String processInstanceWorkItemId){
        List<ProcessInstanceWorkitem>  processInstanceWorkitemList= [SELECT ProcessInstanceId FROM ProcessInstanceWorkitem where id = :processInstanceWorkItemId];
        String processInstanceId = processInstanceWorkitemList[0].ProcessInstanceId;
        List<ProcessInstance> processInstanceList = [SELECT TargetObjectId FROM ProcessInstance WHERE Id = :processInstanceId];
        return processInstanceList[0].TargetObjectId;
    }
    
    /*
    @AuraEnabled
    public static String setProcessInstanceWorkitemId(String objectId){
        String processInstanceWorkitemId = '';
        boolean isOpp = false;
        String objectName = findObjectNameFromRecordId(objectId);
        
        if(objectName.equalsIgnoreCase('ProcessInstanceWorkitem'))
        {
            processInstanceWorkitemId = objectId;
            isOpp = false;
        }
        else if(objectName.equalsIgnoreCase('Opportunity'))
        {
            List<ProcessInstanceWorkitem>  processInstanceWorkitemList= [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId = :objectId AND ProcessInstance.Status = 'Pending' AND OriginalActorId = :UserInfo.getUserId()];
        	if(processInstanceWorkitemList.size() > 0){
                processInstanceWorkitemId = processInstanceWorkitemList[0].Id;   
            }
            else
            {
                processInstanceWorkitemId = '';
            }
            isOpp = true;  
        }
        String response = processInstanceWorkitemId + ',' + isOpp;
        
        return response;
    }
    
    @AuraEnabled
    public static String findObjectNameFromRecordId(String recordId){
        String objName = '';
        try{
            String keyCode = recordId.subString(0,3);
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            for(Schema.SObjectType objectInstance : gd.values())
            {
                if(objectInstance.getDescribe().getKeyPrefix() == keyCode)
                {
                    objName = objectInstance.getDescribe().getName();
                }
            }
        }
        catch (Exception exp) {
            system.debug('exp-->'+exp);
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME3);
        } 
        return objName;
    }
*/
    
    @AuraEnabled
    public static String fetchprocessInstanceId(String processInstanceWorkItemId){
        List<ProcessInstanceWorkitem>  processInstanceWorkitemList= [SELECT ProcessInstanceId FROM ProcessInstanceWorkitem where id = :processInstanceWorkItemId];
        String processInstanceId = processInstanceWorkitemList[0].ProcessInstanceId;
        return processInstanceId;
    }
    
    
    @AuraEnabled
    public static String fetchApprovalStatus(String processInstanceId){
        /* List<ProcessInstanceWorkitem>  processInstanceWorkitemList= [SELECT ProcessInstanceId FROM ProcessInstanceWorkitem where id = :processInstanceWorkItemId];
String processInstanceId = processInstanceWorkitemList[0].ProcessInstanceId;*/
        List<ProcessInstanceNode> processInstanceList = [SELECT NodeStatus FROM ProcessInstanceNode WHERE ProcessInstanceId = :processInstanceId];
        return processInstanceList[0].NodeStatus;
    }
    
    
    @AuraEnabled
    public static void callApprovalProcess(String processInstanceWorkItemId, String approveComments, String approvalAction){
        
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments(approveComments);
        req.setAction(approvalAction);
        req.setWorkitemId(processInstanceWorkItemId);
        Approval.ProcessResult result =  Approval.process(req);
    }
    
    @AuraEnabled
    public static void callRecallProcess(String oppId, String approveComments, String approvalAction){
 
        List<Profile> allProfile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
		String userProfile = allProfile[0].Name;
        if(userProfile == 'System Administrator')
        {
            system.debug('Recall Context -->'+userProfile);
            ProcessInstanceWorkitem[] piWorkItems = [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId = :oppId AND ProcessInstance.Status = 'Pending']; 

            if(piWorkItems.size() > 0){
                //Create Process Work Item Request
                Approval.ProcessWorkItemRequest pwiRequest = new Approval.ProcessWorkItemRequest();
                pwiRequest.setAction(approvalAction);
                pwiRequest.setComments(approveComments);
                pwiRequest.setWorkItemId(piWorkItems[0].Id);
                Approval.ProcessResult result = Approval.process(pwiRequest);
            }
        }
        else
        {
            system.debug('Recall Context Inbound Email -->'+userProfile);
            Opportunity opty = [Select StageName,NSSales_SendFor609_1_Approval__c,NSSales_Is_609_1_Recalled__c,
                                NSSales_609_1_FSManagerApprovalOwner__c,NSSales_Opportunity_Number__c
                                from Opportunity 
                                where id = :oppId];
            singleEmailMessageSend(opty,approveComments,approvalAction);
        }

        Opportunity optyRec = [Select StageName,NSSales_SendFor609_1_Approval__c,NSSales_Is_609_1_Recalled__c,
                               NSSales_609_1_FSManagerApprovalOwner__c
                               from Opportunity 
                               where id = :oppId];
        optyRec.StageName = 'Qualification/Analysis';
        optyRec.NSSales_SendFor609_1_Approval__c = 0;
        optyRec.NSSales_Is_609_1_Recalled__c = true;
        optyRec.NSSales_609_1_status__c = '';
        update optyRec;
        
    }   
    
    public static void singleEmailMessageSend(Opportunity opp,String comment,String action){
        
        String emailbody;
        List<String> sendTo = new List<String>();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        String emailServiceAddress = Label.NS_609_1_Email_service;
        /*****sending email to the email service named NS_609_1_Process****/
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        sendTo.clear();
        sendTo.add(emailServiceAddress);
        mail.setToAddresses(sendTo);
        mail.setSubject('Email Service Invoked');
        emailbody = opp.Id+','+action+','+comment;
        mail.setHtmlBody(emailbody);
        emails.add(mail);
        
        if(!Test.isRunningTest())
        {
            Messaging.sendEmail(emails);
        }
        /****end of sending email message****/   
    }
    
    @AuraEnabled
    public static Integer checkRecall(String oppId){
        
        ProcessInstanceWorkitem[] piWorkItems = [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId = :oppId AND ProcessInstance.Status = 'Pending']; 
        return piWorkItems.size();
    }   
    @AuraEnabled
    public static String checkRecallAccess(String oppId){
        String accessStatus = '';
        Opportunity optyRec = [Select name,OwnerId
                               from Opportunity 
                               where id = :oppId];
        List<Profile> allProfile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
		String userProfile = allProfile[0].Name;
        
        List<Id> usersIdsInGroup= new List<Id>();
        List<GroupMember> groupMembers=[Select Id, group.type, UserOrGroupId
                                        From GroupMember
                                        where group.DeveloperName = 'All_609_1_Access'];
        for(GroupMember gm : groupMembers)
        {
            usersIdsInGroup.add(gm.UserOrGroupId);
        }        
        usersIdsInGroup.add(optyRec.OwnerId);
        system.debug('usersIdsInGroup-->'+usersIdsInGroup);
        system.debug('userProfile-->'+userProfile);
        if(usersIdsInGroup.contains(userInfo.getUserId()) || userProfile == 'System Administrator')
        {
            accessStatus = 'All_609_1_Access';
        }
        else
        {
            accessStatus = 'No_Access';
        }
        return accessStatus;
    }
    
    @AuraEnabled
    public static void updateOpportunityOnReject(String optyRecordId, String rejectStatus){
        system.debug('Inside updateOpportunityOnReject');
        //String optyId = fetchOpportunityId(processInstanceWorkItemId);
        Opportunity optyRec = [Select name,recordType.DeveloperName,StageName,NSSales_609_1_status__c, 
                               NSSales_609_1_IDManagerApprovalOwner__c,NSSales_609_1_IDManagerApprovalOwner__r.name,
                               NSSales_609_1_FSManagerApprovalOwner__c,NSSales_609_1_FSManagerApprovalOwner__r.name,
                               NSSales609_1_CompletedDate__c
                               from Opportunity 
                               where id = :optyRecordId];
        if(rejectStatus == '1'){
            optyRec.StageName = 'Closed Won';
            optyRec.NSSales_609_1_status__c = 'Retained - Strategic Asset';
            optyRec.NSSales609_1_CompletedDate__c = system.today();
        }  
        else if(rejectStatus == '2'){
            optyRec.StageName = 'Closed Won';
            optyRec.NSSales_609_1_status__c = 'Retained - Turnout Maintenance Fee Paid';
            optyRec.NSSales609_1_CompletedDate__c = system.today();
        }
        else if(rejectStatus == '3'){
            optyRec.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NS_General_Opportunity').getRecordTypeId();
            optyRec.NSSales_609_1_SwitchRemovalRequest__c = false;
            optyRec.StageName = 'Qualification/Analysis';
            optyRec.NSSales_609_1_status__c = 'Retained - New Business Opportunity';
            optyRec.NSSales_609_1_Identified__c = TRUE;
            
        }
        else if(rejectStatus == '4'){
            optyRec.StageName = 'Cancelled';
            optyRec.NSSales_609_1_status__c = 'Retained - Not Applicable for 609.1 Review';
        }
        
        String approverName = ''; 
        if(optyRec.NSSales_609_1_IDManagerApprovalOwner__c == UserInfo.getUserId()){
            system.debug('Inside if updateOpportunityOnReject');
            optyRec.NSSales_609_1_IndustrialDevRecommendatio__c = 'Retain';
            approverName = optyRec.NSSales_609_1_IDManagerApprovalOwner__r.name;
            notify_Specific_Users_On_609_1_Create(optyRec, 'Retain', approverName);
        }
        else if(optyRec.NSSales_609_1_FSManagerApprovalOwner__c == UserInfo.getUserId()){
            optyRec.NSSales_609_1_FieldSalesRecommendation__c = 'Retain';
            approverName = optyRec.NSSales_609_1_FSManagerApprovalOwner__r.name;
            notify_Specific_Users_On_609_1_Create(optyRec, 'Retain', approverName);
        }
        
        optyRec.NSSales_SendFor609_1_Approval__c = 0;
        update optyRec;
        
    }
    
    @AuraEnabled
    public static List<ProcessInstanceWorkitem>  fetchProcessItemDetails(String processInstanceWorkItemId){
        return [SELECT CreatedBy.Name, CreatedDate, Actor.Name FROM ProcessInstanceWorkitem
                where id = :processInstanceWorkItemId];
    }
    
    @AuraEnabled
    public static void popluteApprovalDecisionOnApprove(String optyRecordId){
        system.debug('Inside popluteApprovalDecisionOnApprove');
        //  String optyId = fetchOpportunityId(processInstanceWorkItemId);
        Opportunity optyRec = [Select id, name, recordType.DeveloperName,StageName,NSSales_609_1_status__c,
                               NSSales_609_1_IDManagerApprovalOwner__c,NSSales_609_1_IDManagerApprovalOwner__r.name, 
                               NSSales_609_1_FSManagerApprovalOwner__c,NSSales_609_1_FSManagerApprovalOwner__r.name,
                               NSSales_609_1_IDManagerApprovalOwnerEmai__c, NSSales_609_1_FSMngrApprvlOwnerEmail__c, NSSales609_1_CompletedDate__c 
                               from Opportunity 
                               where id = :optyRecordId];
        String approver = '';
        if(optyRec.NSSales_609_1_IDManagerApprovalOwner__c == UserInfo.getUserId()){
            system.debug('Inside if in popluteApprovalDecisionOnApprove');
            optyRec.NSSales_609_1_IndustrialDevRecommendatio__c = 'Remove';
            //optyRec.NSSales609_1_CompletedDate__c = system.today();
            approver = 'ID';
        }
        else if(optyRec.NSSales_609_1_FSManagerApprovalOwner__c == UserInfo.getUserId()){
            optyRec.NSSales_609_1_FieldSalesRecommendation__c = 'Remove';
            //optyRec.NSSales609_1_CompletedDate__c = system.today();
            approver = 'FS';
        }
        // sendEmailOnEitherAproval(optyRec,approver);
        createBellNotfication(optyRec,approver);
        update optyRec;
    }
    
    @AuraEnabled
    public static Opportunity fetchStageName(Id optyRecordId){
        return [SELECT StageName FROM Opportunity where Id = :optyRecordId];
        
    }
    @AuraEnabled
    public static List<String> fetchState(){
        List<String> stateNames = new List<String>();
        for(NSSales_State__c stateRec : [Select name from NSSales_State__c order by name limit 500]){
            stateNames.add(stateRec.name);
        }
        return stateNames;
    }
    @AuraEnabled
    public static List<Object> fetchCounty(String state){
       
        AggregateResult[] result = [SELECT NSSales_County_Name__c FROM NSSales_609_1_Manager_Routing__c where NSSales_State_Name__c = :state GROUP BY NSSales_County_Name__c ORDER by NSSales_County_Name__c];
        List<Object> countyAdd = new List<Object>();
        for(AggregateResult ct:result){
            Object  county = ct.get('NSSales_County_Name__c');
            countyAdd.add(county);
        }
        return countyAdd;
        
    }
    @AuraEnabled
    public static NSSales_609_1_Manager_Routing__c[] fetchCity(String county,String state){
        return [SELECT NSSales_City_Name__c FROM NSSales_609_1_Manager_Routing__c where NSSales_County_Name__c = :county 
                and NSSales_State_Name__c = :state
                ORDER BY NSSales_City_Name__c];    
    }
    
    @AuraEnabled
    public static void changeOptyStageOn_609_1_LocationSelect(String optyRecordId, String selectedState, String selectedCounty, String selectedCity, String operatingDivision, String prefix, String suffix, String milepost){
        
        Opportunity optyRec = [Select NSSales_609_1_Submitter__c,NSSales_609_1_SubmitterEmail__c, 
                               NSSales_609_1_IDManagerApprovalOwner__c,NSSales_609_1_IDManagerApprovalOwnerEmai__c,
                               NSSales_609_1_FSManagerApprovalOwner__c, NSSales_609_1_FSMngrApprvlOwnerEmail__c, StageName, NSSales_SendFor609_1_Approval__c,
                               NSSales_609_1_State__c, NSSales_609_1_County__c, NSSales_609_1_City__c
                               from Opportunity 
                               where id = :optyRecordId];
        
        String routingLocation = selectedState+':'+selectedCounty+':'+selectedCity;
        NSSales_609_1_Manager_Routing__c routingRec = [SELECT id,NSSales_ID_Manager_Name__c, NSSales_ID_Manager_Email_ID__c,
                                                       NSSales_State_Name__c, NSSales_County_Name__c, NSSales_City_Name__c
                                                       FROM NSSales_609_1_Manager_Routing__c
                                                       WHERE NSSales_LocationIdentifier__c = :routingLocation LIMIT 1];
        optyRec.NSSales_609_1_Submitter__c = UserInfo.getName();
        optyRec.NSSales_609_1_SubmitterEmail__c = UserInfo.getUserEmail();                                                      
        optyRec.NSSales_609_1_IDManagerApprovalOwner__c = routingRec.NSSales_ID_Manager_Name__c;
        optyRec.NSSales_609_1_IDManagerApprovalOwnerEmai__c = routingRec.NSSales_ID_Manager_Email_ID__c;
        optyRec.StageName = 'Internal Review';
        optyRec.NSSales_609_1_State__c = selectedState;
        optyRec.NSSales_609_1_County__c = selectedCounty;
        optyRec.NSSales_609_1_City__c = selectedCity;
        optyRec.NSSales_609_1_OperatingDivision__c = operatingDivision;
        optyRec.NSSales_609_1_Prefix__c = prefix;
        optyRec.NSSales_609_1_Suffix__c = suffix;
        optyRec.NSSales_609_1_Milepost__c = decimal.valueOf(milepost);
        optyRec.NSSales_SendFor609_1_Approval__c = 0;
        optyRec.NSSales_Is_609_1_Recalled__c = false;
        NSSales_609_1FSSalesManager__c fsRoutingRec = selectFieldSalesManager(operatingDivision, prefix, suffix, milepost);  
        optyRec.NSSales_609_1_FSManagerApprovalOwner__c = fsRoutingRec.NSSales_609_1_Field_Sales_Manager__c;
        optyRec.NSSales_609_1_FSMngrApprvlOwnerEmail__c = fsRoutingRec.NSSales_609_1_FSM_Email__c;
        
        update optyRec;
        
    }
    
    @AuraEnabled
    public static void initiate_609_1_ApprovalProcess(String optyRecordId){
        
        Opportunity optyRec = [Select NSSales_609_1_IDManagerApprovalOwner__c,
                               NSSales_609_1_FSManagerApprovalOwner__c
                               from Opportunity 
                               where id = :optyRecordId];

        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting request for approval');
        req.setObjectId(optyRecordId);
        req.setSubmitterId(UserInfo.getUserId());
        req.setProcessDefinitionNameOrId('NSSales_609_1_SwitchRmvlApprovalProcess');
        req.setNextApproverIds(new Id[] {optyRec.NSSales_609_1_IDManagerApprovalOwner__c,optyRec.NSSales_609_1_FSManagerApprovalOwner__c});
        Approval.process(req);
        
        
        
        // Unlock the accounts
        Approval.UnlockResult oppUnlock = Approval.unlock(optyRecordId, false);
        
        if (oppUnlock.isSuccess()) {
            // Operation was successful, so get the ID of the record that was processed
            System.debug('Successfully unlocked account with ID: ' + oppUnlock.getId());
        }
        else {
            // Operation failed, so get all errors                
            for(Database.Error err : oppUnlock.getErrors()) {
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Account fields that affected this error: ' + err.getFields());
            }
        }
        
        
    }
    @AuraEnabled
    public static void updateOptyStage(String optyRecordId){
        
        Opportunity optyRec = [Select StageName,NSSales_609_1_IDManagerApprovalOwner__c,
                               NSSales_609_1_FSManagerApprovalOwner__c
                               from Opportunity 
                               where id = :optyRecordId];
        optyRec.StageName = 'Internal Review';
        optyRec.NSSales_SendFor609_1_Approval__c = 0;
        optyRec.NSSales_Is_609_1_Recalled__c = false;
        update optyRec;
        
    }

    public static void createBellNotfication(Opportunity opty, String approver){
        FeedItem post = new FeedItem();
        String approverName = '';
        String body = '';
        if(approver.equalsIgnoreCase('ID')){
            body = '609.1 Approval Request for Opportunity Approved by '+opty.NSSales_609_1_IDManagerApprovalOwner__r.name;
            post.ParentId = opty.NSSales_609_1_FSManagerApprovalOwner__c;
            post.Body = body;
            post.Title = opty.name;
            post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Opportunity/'+opty.id+'/view';
            approverName = opty.NSSales_609_1_IDManagerApprovalOwner__r.name;
            notify_Specific_Users_On_609_1_Create(opty, 'Remove', approverName);
        } 
        else if(approver.equalsIgnoreCase('FS')){
            body = '609.1 Approval Request for Opportunity Approved by '+opty.NSSales_609_1_FSManagerApprovalOwner__r.name;
            post.ParentId = opty.NSSales_609_1_IDManagerApprovalOwner__c;
            post.Body = body;
            post.Title = opty.name;
            post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Opportunity/'+opty.id+'/view';
            approverName = opty.NSSales_609_1_FSManagerApprovalOwner__r.name;
            notify_Specific_Users_On_609_1_Create(opty, 'Remove', approverName);
        }
        insert post;   
    }
    
    
    @AuraEnabled
    public static NSSales_609_1FSSalesManager__c selectFieldSalesManager(String operatingDivision, String prefix, String suffix, String milepost){
        
        NSSales_609_1FSSalesManager__c fsRoutingRec = new NSSales_609_1FSSalesManager__c();
        
        if(prefix!= null){
            fsRoutingRec = [Select  NSSales_609_1_Field_Sales_Manager__c, NSSales_609_1_FSM_Email__c                              
                            from NSSales_609_1FSSalesManager__c 
                            where NSSales_609_1_OperatingDivision__c = :operatingDivision
                            and NSSales_609_1_Sales_Prefix__c = :prefix 
                            and NSSales_609_1_LMP__c <= : decimal.valueOf(milepost)
                            and NSSales_609_1_HMP__c >= : decimal.valueOf(milepost) limit 1
                           ];               
        }
        else if(suffix!= null){
            fsRoutingRec = [Select  NSSales_609_1_Field_Sales_Manager__c, NSSales_609_1_FSM_Email__c                              
                            from NSSales_609_1FSSalesManager__c 
                            where NSSales_609_1_OperatingDivision__c = :operatingDivision
                            and NSSales_609_1_Suffix__c = :suffix
                            and NSSales_609_1_LMP__c <= : decimal.valueOf(milepost)
                            and NSSales_609_1_HMP__c >= : decimal.valueOf(milepost) limit 1];
            
        }
        return fsRoutingRec;
    }
    
    @AuraEnabled
    public static Boolean checkMilepostRange(String operatingDivision, String prefix, String suffix, String milepost){
        Boolean isValidMilepost = false;
        system.debug('prefix-->'+prefix);
        system.debug('suffix-->'+suffix);
       // String uniqueKey =  operatingDivision +':'+ (prefix != '' ? prefix : '') +':'+ (suffix != '' ? suffix : ''); 
        String uniqueKey =  operatingDivision +':'+ prefix +':'+ suffix; 
        system.debug('uniqueKey-->'+uniqueKey);
        List<NSSales_609_1FSSalesManager__c> fsRoutingRecList = [SELECT NSSales_609_1_LMP__c, NSSales_609_1_HMP__c 
                                                                 From NSSales_609_1FSSalesManager__c
                                                                 WHERE NSSales_609_1_UniqueIdentifier__c = : uniqueKey];
        system.debug('fsRoutingRecList-->'+fsRoutingRecList);
        if(fsRoutingRecList.size()>0){
            for(NSSales_609_1FSSalesManager__c fsRoutingRec : fsRoutingRecList){
                if((decimal.valueOf(milepost) >= fsRoutingRec.NSSales_609_1_LMP__c 
                    && decimal.valueOf(milepost) <= fsRoutingRec.NSSales_609_1_HMP__c)){
                        isValidMilepost = true;
                    }
            }
        }
        system.debug('isValidMilepost-->'+isValidMilepost);
        return isValidMilepost;
    } 
    
    public static void notify_Specific_Users_On_609_1_Create(Opportunity opty, String action, String approverName){
        
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
        
        
        if(action.equalsIgnoreCase('Remove')){
            for(integer i=0; i<usersIdsInGroup.size(); i++)
            {
                /*Send Bell Notification*/
                FeedItem post = new FeedItem();
                String body = '609.1 Approval Request for Opportunity removed by '+approverName;
                post.ParentId = usersIdsInGroup.get(i);
                post.Body = body;
                post.Title = opty.name;
                post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Opportunity/'+opty.id+'/view';
                //insert post;
                postList.add(post);
                /*End of Send Bell Notification*/
            }
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('609.1 Approval Request Removal Alert');
            email.setToAddresses(userEmails);
            email.setOrgWideEmailAddressId(noRpl.Id); 
            String emailBody='';
            emailBody +='<html><body>';
            emailBody += '609.1 Approval Request for Opportunity has been removed by '+approverName+'.<br/><br/>For your convenience you can click the following link to access the Opportunity in ConnectNS: ';
            emailBody += '<br/><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Opportunity/'+opty.id+'/view">'+opty.Name+'</a>';
            email.setHtmlBody(emailBody);
            emails.add(email);
            
        }
        else if(action.equalsIgnoreCase('Retain')){
            for(integer i=0; i<usersIdsInGroup.size(); i++)
            {
                FeedItem post = new FeedItem();
                String body = '609.1 Approval Request for Opportunity retained by '+approverName;
                post.ParentId = usersIdsInGroup.get(i);
                post.Body = body;
                post.Title = opty.name;
                post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Opportunity/'+opty.id+'/view';
                postList.add(post);
            }  
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('609.1 Approval Request Retention Alert');
            email.setToAddresses(userEmails);
            email.setOrgWideEmailAddressId(noRpl.Id); 
            String emailBody='';
            emailBody +='<html><body>';
            emailBody += '609.1 Approval Request for Opportunity has been retained by '+approverName+'.<br/><br/>For your convenience you can click the following link to access the Opportunity in ConnectNS: ';
            emailBody += '<br/><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Opportunity/'+opty.id+'/view">'+opty.Name+'</a>';
            email.setHtmlBody(emailBody);
            emails.add(email);
        }
        insert postList;
        Messaging.sendEmail(emails);
    }
    
}