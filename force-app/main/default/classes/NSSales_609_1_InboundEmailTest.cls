@istest
public class NSSales_609_1_InboundEmailTest {
	@isTest
    public static void check_609_1_Recall(){
           //Creating Admin User  
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        User idManager;
        User fsManager;
        User owner;
        
        //Creating Sales manager test User  
        System.runAs( admin ){ 
            Profile agent1 = UserTestFactory.createProfile(NS_StaticVariablesUtility.NSSalesIDProfile);
            idManager = UserTestFactory.createUserSales(22,agent1.Id);
            Profile agent2 = UserTestFactory.createProfile(NS_StaticVariablesUtility.SalesManager);
            fsManager = UserTestFactory.createUserSales(24,agent2.Id);
            Profile agent3 = UserTestFactory.createProfile(NS_StaticVariablesUtility.SalesManager);
            owner = UserTestFactory.createUserSales(78,agent3.Id);
        }
       
        system.test.StartTest();
        
        //Opportunity Creation
        Opportunity Opty = create_609_1_Opty();
        optyShare(Opty.Id,fsManager.Id,NS_StaticVariablesUtility.editAccess);
        optyShare(Opty.Id,idManager.Id,NS_StaticVariablesUtility.editAccess);
        optyShare(Opty.Id,owner.Id,NS_StaticVariablesUtility.editAccess);
        NSSales_609_1_All_Switch_Coordinates__c switchCordinateRec = create_Switch_CordinateRecord();
        opty.NSSales_609_1_SwitchIdentificationNumber__c = switchCordinateRec.NSSales_Switch_Identification_Numbers__c;
        opty.NSSales609_1_InitaitedDate__c =system.today();
        opty.OwnerId = owner.Id;
        update opty;
        NSSales_609_1_Manager_Routing__c newIDManagerRoutingRec = create_609_1_MngrRoutingRecord(idManager);
        NSSales_609_1FSSalesManager__c fsmanager1 = create_609_1_FSMngrRoutingRecord(fsManager);
        /*To cover changeOptyStageOn_609_1_LocationSelect */ 
        opty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NSSales_609_1').getRecordTypeId();
        update opty;
        NSSales_609_1_ApprovalProcessController.changeOptyStageOn_609_1_LocationSelect(opty.Id,'DE','Kent','Ada','DEARBORN','B',null,'487.66');
        /*finish here for changeOptyStageOn_609_1_LocationSelect*/
       /* To cover ApprovalProcess */
        System.runAs( admin ){ 
        NSSales_609_1_ApprovalProcessController.initiate_609_1_ApprovalProcess(opty.Id);
        }
        
        System.runAs(owner){ 
        NSSales_609_1_ApprovalProcessController.checkRecall(opty.Id);
        NSSales_609_1_ApprovalProcessController.checkRecallAccess(opty.Id);
        NSSales_609_1_ApprovalProcessController.callRecallProcess(opty.Id, 'recalled', 'Removed');
        NSSales_609_1_ApprovalProcessController.updateOptyStage(opty.Id);
        }
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'Email Service Invoked';
        email.plainTextBody = opty.Id+',Removed,Recalled';
        email.HtmlBody = opty.Id+',Removed,Recalled';
        email.toAddresses = new List<String>{System.Label.NS_609_1_Email_service};   
            
        Messaging.InboundEmail.Header hditem= new Messaging.InboundEmail.Header();   
        hditem.name='Date'; 
        hditem.value='< image Tue, 27 Jan 2020 14:08:37 -0700 >';
        email.headers=new Messaging.inboundEmail.Header[]{hditem}; 
        envelope.fromAddress = 'test@connectns.com'; 
        NSSales_609_1_InboundEmail emailServiceHandler = new NSSales_609_1_InboundEmail();
        system.debug(email.headers);
        Messaging.InboundEmailResult result =  emailServiceHandler.handleInboundEmail(email, envelope);
        
        system.assert(opty.StageName == 'Qualification/Analysis', 'Failed to recall');
        
        system.test.StopTest();
    }
    
    /*Method to create 609.1 Opportunity*/
    public static Opportunity create_609_1_Opty(){
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
}