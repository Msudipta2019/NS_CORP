@isTest (SeeAllData=false)
public class NSSales_609_1_ApprovalProcessTest {
    
    /*Method to create 609.1 Opportunity*/
    public static  Opportunity create_609_1_Opty(){
        Account acc = new Account(
            RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerBusiness' AND 
                            SobjectType ='Account' Limit 1].id,
            Name='AccountForOppotunity');
         system.assertEquals(null, acc.id);
       insert acc;
        Opportunity opty = new Opportunity();
        opty.Name = 'Test';
        opty.AccountId = acc.Id;
        opty.NS_Originating_Department__c = 'Automotive';
        opty.StageName = 'Qualification/Analysis';                
        opty.CloseDate = System.Today();
        opty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NS_General_Opportunity').getRecordTypeId();
        opty.NSSales_609_1_SwitchRemovalRequest__c = true;
        insert opty; 
        return opty;
        
    }
    
    
    public static OpportunityShare optyShare(Id optyId, Id userId, string oppAccess){
        OpportunityShare optyShare = new OpportunityShare();
        optyShare.OpportunityId = optyId;
        optyShare.OpportunityAccessLevel =oppAccess; 
        optyShare.UserOrGroupId = userId;
        insert optyShare;
        return optyShare;
    }
    
    public static NSSales_609_1_All_Switch_Coordinates__c create_Switch_CordinateRecord(){
        NSSales_609_1_All_Switch_Coordinates__c switchCordinateRec = new NSSales_609_1_All_Switch_Coordinates__c();
        switchCordinateRec.NSSales_Switch_Identification_Numbers__c ='100026320';
        switchCordinateRec.NSSales_Latitude__c ='37.27935701';
        switchCordinateRec.NSSales_Longitude__c ='-79.90954751';
        insert switchCordinateRec;
        return switchCordinateRec;
    }
    
    public static NSSales_609_1_Manager_Routing__c create_609_1_MngrRoutingRecord(User idManager){
        NSSales_609_1_Manager_Routing__c newIDManagerRoutingRec = new NSSales_609_1_Manager_Routing__c();
        newIDManagerRoutingRec.NSSales_State_Name__c = 'DE';
        newIDManagerRoutingRec.NSSales_County_Name__c = 'Kent';
        newIDManagerRoutingRec.NSSales_City_Name__c = 'Ada';
        newIDManagerRoutingRec.NSSales_Territory_Name__c = 'Norfolk';
        newIDManagerRoutingRec.NSSales_ID_Manager_Name__c = idManager.id;
        insert newIDManagerRoutingRec;
        return newIDManagerRoutingRec;
    }
    
    
    public static NSSales_609_1FSSalesManager__c create_609_1_FSMngrRoutingRecord(User fsManager){
        NSSales_609_1FSSalesManager__c fsmanager1 = new NSSales_609_1FSSalesManager__c();
        fsmanager1.NSSales_609_1_OperatingDivision__c = 'DEARBORN';
        fsmanager1.NSSales_609_1_Sales_Prefix__c = 'B';
        fsmanager1.NSSales_609_1_Suffix__c = '';
        fsmanager1.NSSales_609_1_LMP__c = 486.88;
        fsmanager1.NSSales_609_1_HMP__c = 518.30;
        fsmanager1.NSSales_609_1_Field_Sales_Manager__c = fsManager.id;
        insert fsmanager1;
        return fsmanager1;
    }
    
    public static Map<String,User> getUserDetails(Opportunity opty){
        List<id> approversId = new List<id>();
        Map<String,User> userMap = new Map<String,User>();
        approversId.add(opty.NSSales_609_1_IDManagerApprovalOwner__c);
        approversId.add(opty.NSSales_609_1_FSManagerApprovalOwner__c);
        List<User> userRecList = [select id, name, email from User where id in :approversId];
        for(User userDetail : userRecList){
            if(opty.NSSales_609_1_IDManagerApprovalOwner__c == userDetail.id)
            {
               userMap.put('ID', userDetail); 
            }
            if(opty.NSSales_609_1_FSManagerApprovalOwner__c == userDetail.id)
            {
                userMap.put('FS', userDetail);  
            }
        }
        return userMap;
    }
      
    @istest
    public static Opportunity push_609_1_For_Approval(){
        
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        User idManager;
        User fsManager;
        
        //Creating Sales manager test User  
        System.runAs( admin ){ 
            Profile agent1 = UserTestFactory.createProfile(NS_StaticVariablesUtility.NSSalesIDProfile);
            idManager = UserTestFactory.createUserSales(22,agent1.Id);
            Profile agent2 = UserTestFactory.createProfile(NS_StaticVariablesUtility.SalesManager);
            fsManager = UserTestFactory.createUserSales(24,agent2.Id);
        }
        
        system.test.StartTest();
        //Opportunity Creation
        Opportunity Opty = create_609_1_Opty();
        optyShare(Opty.Id,fsManager.Id,NS_StaticVariablesUtility.editAccess);
        optyShare(Opty.Id,idManager.Id,NS_StaticVariablesUtility.editAccess);
        NSSales_609_1_All_Switch_Coordinates__c switchCordinateRec = create_Switch_CordinateRecord();
        opty.NSSales_609_1_SwitchIdentificationNumber__c = switchCordinateRec.NSSales_Switch_Identification_Numbers__c;
        opty.NSSales609_1_InitaitedDate__c =system.today();
        update opty;
        /* To cover fetchstate, fetchCounty and fetchCity */
        NSSales_609_1_Manager_Routing__c newIDManagerRoutingRec = create_609_1_MngrRoutingRecord(idManager);
        
        NSSales_609_1_ApprovalProcessController.fetchState();
        NSSales_609_1_ApprovalProcessController.fetchCounty('Kent');
        NSSales_609_1_ApprovalProcessController.fetchCity('Kent','Ada');
        /*finish here for fetchstate, fetchCounty and fetchCity*/
        
        /*To cover checkMilepostRange */ 
        
        NSSales_609_1FSSalesManager__c fsmanager1 = create_609_1_FSMngrRoutingRecord(fsManager);
        NSSales_609_1FSSalesManager__c fsmanager2 = new NSSales_609_1FSSalesManager__c();
        fsmanager2.NSSales_609_1_OperatingDivision__c = 'GEORGIA';
        fsmanager2.NSSales_609_1_Sales_Prefix__c = '';
        fsmanager2.NSSales_609_1_Suffix__c = 'H';
        fsmanager2.NSSales_609_1_LMP__c = 240.36;
        fsmanager2.NSSales_609_1_HMP__c = 423.86;
        insert fsmanager2;
        
        NSSales_609_1_ApprovalProcessController.checkMilepostRange('DEARBORN','B','','487.88');
        NSSales_609_1_ApprovalProcessController.checkMilepostRange('GEORGIA','','H','245.00');
        /* finish here for checkMilepostRange*/ 
        /*To cover changeOptyStageOn_609_1_LocationSelect */ 
        opty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NSSales_609_1').getRecordTypeId();
        update opty;
        
        NSSales_609_1_ApprovalProcessController.selectFieldSalesManager('GEORGIA',null,'H','245.00');
        NSSales_609_1_ApprovalProcessController.changeOptyStageOn_609_1_LocationSelect(opty.Id,'DE','Kent','Ada','DEARBORN','B',null,'487.66');
        
        // update opty;/*finish here for changeOptyStageOn_609_1_LocationSelect*/
        /* To cover ApprovalProcess */
        NSSales_609_1_ApprovalProcessController.initiate_609_1_ApprovalProcess(opty.Id);
        List<ProcessInstanceWorkitem> p = [select id, ProcessInstanceId from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :opty.Id];
        system.assertNotEquals(null, p[0].id);
        
        NSSales_609_1_ApprovalProcessController.fetchProcessItemDetails(p[0].id);
        NSSales_609_1_ApprovalProcessController.fetchOpportunityId(p[0].id);
        NSSales_609_1_ApprovalProcessController.fetchObjectId(p[0].id);
        NSSales_609_1_ApprovalProcessController.fetchprocessInstanceId(p[0].id);
        NSSales_609_1_ApprovalProcessController.setProcessInstanceWorkitemId(opty.Id); 
        NSSales_609_1_ApprovalProcessController.setProcessInstanceWorkitemId(p[0].id);
        system.test.StopTest();
        return opty;
    }
    
    @istest
    public static void test_609_Approve(){
       
        Opportunity fetchOptyRec = [select ID,NSSales_609_1_IDManagerApprovalOwner__c,NSSales_609_1_FSManagerApprovalOwner__c
                                    from Opportunity
                                    where id = :push_609_1_For_Approval().id];
        User idUser =  getUserDetails(fetchOptyRec).get('ID');
        User fsUser =  getUserDetails(fetchOptyRec).get('FS');
          system.assertnotEquals(null, fetchOptyRec.id);
        System.runAs(idUser){
            NSSales_609_1_ApprovalProcessController.popluteApprovalDecisionOnApprove(fetchOptyRec.id); 
        }
        System.runAs(fsUser){
            NSSales_609_1_ApprovalProcessController.popluteApprovalDecisionOnApprove(fetchOptyRec.id);
        }
        NSSales_609_1_ApprovalProcessController.fetchStageName(fetchOptyRec.id);
                
    }
    
    @istest
    public static void test_609_As_Reject(){
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(15,sysprof.Id);
        Opportunity fetchOptyRec = [select ID,NSSales_609_1_FSManagerApprovalOwner__c, NSSales_609_1_IDManagerApprovalOwner__c
                                    from Opportunity
                                    where id = :push_609_1_For_Approval().id];
         system.assertnotEquals(null, fetchOptyRec.id);
        User idUser =  getUserDetails(fetchOptyRec).get('ID');
        User fsUser =  getUserDetails(fetchOptyRec).get('FS');
        System.runAs(fsUser){
            NSSales_609_1_ApprovalProcessController.updateOpportunityOnReject(fetchOptyRec.id,'3');
        }
        System.runAs(admin){
            NSSales_609_1_ApprovalProcessController.callRecallProcess(fetchOptyRec.Id, 'recalled', 'Removed');
        }
    }
    
    @istest
    public static void test_609_Recall(){

        
        Opportunity fetchOptyRec = [select ID,NSSales_609_1_FSManagerApprovalOwner__c, NSSales_609_1_IDManagerApprovalOwner__c
                                    from Opportunity
                                    where id = :push_609_1_For_Approval().id];
        User idUser =  getUserDetails(fetchOptyRec).get('ID');
        User fsUser =  getUserDetails(fetchOptyRec).get('FS');
        List<ProcessInstanceWorkitem> p = [select id, ProcessInstanceId from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :fetchOptyRec.Id];     
         system.assertNotEquals(null, p[0].id);
        System.runAs(fsUser){
            NSSales_609_1_ApprovalProcessController.updateOpportunityOnReject(fetchOptyRec.id,'2');
        }
        System.runAs(idUser){
            NSSales_609_1_ApprovalProcessController.checkApprover(fetchOptyRec.id);  
            NSSales_609_1_ApprovalProcessController.checkRecallAccess(fetchOptyRec.id);
            NSSales_609_1_ApprovalProcessController.callRecallProcess(fetchOptyRec.Id, 'recalled', 'Removed');
            NSSales_609_1_ApprovalProcessController.checkRecall(fetchOptyRec.Id);
            NSSales_609_1_ApprovalProcessController.updateOptyStage(fetchOptyRec.Id);
            NSSales_609_1_ApprovalProcessController.fetchApprovalStatus(p[0].ProcessInstanceId);
            NSSales_609_1_ApprovalProcessController.callApprovalProcess(p[0].id,'Rejecting request for Opportunity', 'Reject');
            
        }
    } 
}