@isTest (SeeAllData=false)
public class NSSales_NPOCommentControllerTest {
    
   
    @isTest
    public static void npo_Opty_Comment_Test(){
        
        system.test.StartTest();
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        User atest;    
        
        //Creating Sales manager test User  
        System.runAs( admin ){ 
            Profile agent = UserTestFactory.createProfile(NS_StaticVariablesUtility.SalesManager);
            atest = UserTestFactory.createUserSales(22,agent.Id);
            
            Account acc = new Account(
                RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerBusiness' AND 
                                SobjectType ='Account' Limit 1].id,
                Name='AccountForOppotunity');
            insert acc;
            system.assertNotEquals(null,acc.id); 
            Opportunity opty = new Opportunity();
            opty.Name = 'Test';
            opty.AccountId = acc.Id;
            opty.NS_Originating_Department__c = 'Automotive';
            opty.StageName = 'Qualification/Analysis';                
            opty.CloseDate = System.Today();
            opty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NS_General_Opportunity').getRecordTypeId();
            opty.NSSales_609_1_SwitchRemovalRequest__c = true;
            insert opty; 
            opty.NS_SalesNPO_Approvers__c=atest.id;
            opty.NSSales_Network_Capacity__c=true;
            update opty;    
            List<NSSales_NPO_Approval__c> npoApprovalRec= [select id,NSSales_Approval_Type__c,NSSales_Status__c from NSSales_NPO_Approval__c where NSSales_Related_Opportunity__c =: opty.Id];
            NSSales_NPOCommentController.getVisibility(npoApprovalRec[0].Id);//npoObjReq
            List<ProcessInstanceWorkitem> pI = [select id, ProcessInstanceId from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :npoApprovalRec[0].Id];
            NSSales_NPOCommentController.getVisibility(pI[0].Id);
            String npoObjReq = NSSales_NPOCommentController.findObjectNameFromRecordId(npoApprovalRec[0].Id);//passed with one exception
            System.debug('npoObjReq'+npoObjReq);
            String piObjId = NSSales_NPOCommentController.fetchObjectId(pI[0].Id);
            System.debug('piObjId'+piObjId);
            NSSales_NPO_Approval_Comments__c approvalComment=new NSSales_NPO_Approval_Comments__c();
            approvalComment.NSSales_Comments__c='approved';
            approvalComment.NSSales_ProcessInstanceWorkItemId__c = pI[0].Id;
            approvalComment.NSSales_ProcessInstanceID__c=(pI[0].ProcessInstanceId);
            insert approvalComment;
            List<NSSales_NPO_Approval_Comments__c> piDetails21 =NSSales_NPOCommentController.fetchCommentsProcessItemDetailsNpo(pI[0].Id);
            System.assertNotEquals(null, approvalComment.id);
            List<ProcessInstanceStep>  ProcessInstanceStepList = [SELECT id,ProcessInstanceId FROM ProcessInstanceStep where ProcessInstanceId = :pI[0].ProcessInstanceId];    
           NSSales_NPOCommentController.getVisibility(ProcessInstanceStepList[0].Id);//npoObjReq
            String  fetchObjectIdfromProcess =NSSales_NPOCommentController.fetchObjectIdfromProcessInstance(ProcessInstanceStepList[0].ID);
            NSSales_NPO_Approval_Comments__c approvalComment1=new NSSales_NPO_Approval_Comments__c();
            approvalComment1.NSSales_Comments__c='approved';
            approvalComment1.NSSales_ProcessInstanceStepID__c=(ProcessInstanceStepList[0].id);
            insert approvalComment1;
            List<NSSales_NPO_Approval_Comments__c> piDetails30= NSSales_NPOCommentController.fetchCommentProcessInstanceStepNpo(ProcessInstanceStepList[0].ID);
            System.assertNotEquals(null, approvalComment1.id);
            system.test.StopTest();
        }
    } 
    
    @isTest
    public static void opty_609_1_Comment_Test(){
        system.test.StartTest();
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
            Account acc = new Account(
                RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerBusiness' AND 
                                SobjectType ='Account' Limit 1].id,
                Name='AccountForOppotunity');
            insert acc;
            system.assertNotEquals(null,acc.id); 
            Opportunity opty = new Opportunity();
            opty.Name = 'Test';
            opty.AccountId = acc.Id;
            opty.NS_Originating_Department__c = 'Automotive';
            opty.StageName = 'Qualification/Analysis';                
            opty.CloseDate = System.Today();
            opty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NS_General_Opportunity').getRecordTypeId();
            opty.NSSales_609_1_SwitchRemovalRequest__c = true;
            insert opty;
            opty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NSSales_609_1').getRecordTypeId();
            update opty;
            opty.NSSales609_1_InitaitedDate__c=date.parse('06/07/2012');
            NSSales_609_1_All_Switch_Coordinates__c switchCordinateRec = create_Switch_CordinateRecord();
            opty.NSSales_609_1_SwitchIdentificationNumber__c = switchCordinateRec.NSSales_Switch_Identification_Numbers__c;
            update opty;
            create_609_1_MngrRoutingRecord(idManager);
            create_609_1_FSMngrRoutingRecord(fsManager);
            NSSales_609_1_ApprovalProcessController.changeOptyStageOn_609_1_LocationSelect(opty.Id,'DE','Kent','Ada','DEARBORN','B',null,'487.66');
            NSSales_609_1_ApprovalProcessController.initiate_609_1_ApprovalProcess(opty.Id);
            List<ProcessInstanceWorkitem> pI = [select id, ProcessInstanceId from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :opty.id];
            System.debug('pI'+pI);
              System.debug('pI[0].Id'+pI[0].Id);
            NSSales_NPOCommentController.getVisibility(pI[0].Id);
           NSSales_NPOCommentController.fetchCommentsProcessItemDetailsOpp(pI[0].ID);
            List<ProcessInstanceStep>  processInstanceStepList = [SELECT id,ProcessInstanceId FROM ProcessInstanceStep where ProcessInstanceId = :pI[0].ProcessInstanceId]; 
           NSSales_NPOCommentController.fetchCommentProcessInstanceStepOpp(processInstanceStepList[0].id);
            NSSales_NPOCommentController.getVisibility(processInstanceStepList[0].Id);
            System.debug('ProcessInstanceStepList'+processInstanceStepList);
        } 
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
}