/*
Description  : This class is a Test Class for Opportunity Trigger Helper.
Developer    : Accenture Solutions
Date         : 02-07-2019
*/

@isTest
public class NS_Sales_OpportunityTriggerHelperTest {
    
    
    
    Public static String approvedStatus = 'Approved';
    Public static String StageNameInternalReview = 'Internal Review';
    Public Static  String StageQA = 'Qualification/Analysis';
    
    /*static User testUser;
    static Opportunity opty;
    static BU__c accClsfctn = new BU__c();
    static BU__c accClsfctn1 = new BU__c();
    static Account testAcc; 
    
    @testsetup
    static void setup(){
        
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        testUser = UserTestFactory.createUser(14,sysprof.Id);
        opty = NSSales_OpportunityFactory.createOpportunityForHelper();  
        accClsfctn.RecordTypeId = Schema.SObjectType.BU__c.getRecordTypeInfosByName().get('Automotive').getRecordTypeId();
        accClsfctn.Account__c = Opty.AccountId;
        insert accClsfctn; 
        
        testAcc = AccountTestFactory.getOnlineAccountRecord('Test Child Account');
        insert testAcc;
        
    }

    */
    /*  TO be uncommented---Failing*/
 
    static testMethod void updateCounterForFinalApprovalTest() {
        //Creating Admin User  
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        User atest;    
        
        //Creating Sales manager test User  
        System.runAs( admin ){ 
            Profile agent = UserTestFactory.createProfile(NS_StaticVariablesUtility.SalesManager);
            atest = UserTestFactory.createUserSales(22,agent.Id);
            
        }
        
        system.test.StartTest();
        //System.runAs(atest){
        //Opportunity Creation
        
        Opportunity Opty = NSSales_OpportunityFactory.createOpportunityForHelper();    
        
        //Account classification Creation            
        BU__c accclassi= new BU__c();
        accclassi.RecordTypeId=Schema.SObjectType.BU__c.getRecordTypeInfosByName().get('Automotive').getRecordTypeId();
        accclassi.Account__c=Opty.AccountId;
        insert accclassi;       
        // Associate Account Classification with Opportunity         
        Opty.NSSales_Account_Classification__c =  accclassi.id;
        
        update Opty;
        //Sending Opportunity to Internal Review Stage  
        
        Opty.NS_SalesNPO_Approvers__c = atest.id;
        Opty.StageName=StageNameInternalReview;
        //Opty.NSSales_OPS_Planning_East__c = TRUE;
        Opty.NSSales_OPS_Planning_North__c = TRUE;
        //Opty.NSSales_OPS_Planning_West__c = TRUE;
        Opty.NSSales_OPS_Planning_South__c = TRUE;
        Opty.NSSales_Unit_Train__c = TRUE;
        Opty.NSSales_Network_Capacity__c = TRUE;
        Opty.NSSales_Network_Optimization__c = TRUE;
        Opty.NSSales_Auto_Intermodal__c = TRUE;
        Opty.NSSales_Interline_Services__c = TRUE;  
        opty.NSSales_OPS_Planning_Central__c=true;
        opty.NSSales_Industrial_Products_Unit__c=true;
        opty.NSSales_Power__c=true;
        opty.NSSales_OPS_Planning_NOC__c=true;
        opty.NSSales_OPS_Planning_Central_Status__c='Approved';
        opty.NSSales_Industrial_Products_Unit_Status__c='Approved';
        opty.NSSales_OPS_Planning_NOC_Status__c='Approved';
        Opty.NSSales_Power_Approval_Status__c = approvedStatus;
        //Opty.NSSales_OPS_Planning_East_Status__c = approvedStatus;
        Opty.NSSales_OPS_Planning_North_Status__c = approvedStatus;
        //Opty.NSSales_OPS_Planning_West_Status__c = approvedStatus;
        Opty.NSSales_OPS_Planning_South_Status__c = approvedStatus;
        Opty.NSSales_Unit_Train_Status__c = approvedStatus;
        Opty.NSSales_Network_Capacity_Status__c = approvedStatus;
        Opty.NSSales_Network_Optimization_Status__c = approvedStatus;
        Opty.NSSales_Auto_Intermodal_Status__c = approvedStatus;
        //Opty.NSSales_Industrial_Products_Unit_Status__c = approvedStatus;
        Opty.NSSales_Interline_Services_Status__c = approvedStatus;
        opty.NSSales_SendFor609_1_Approval__c=5;
        
        update opty;       
        Opportunity exam=[select StageName from Opportunity LIMIT 1];  
        System.debug('exam'+exam);
        system.assertEquals('Approved',opty.NSSales_Network_Optimization_Status__c);
        
        // Update Opportunity stage name on: Qualification/Analysis
        Opty.StageName=StageQA;
        update opty;
        System.test.StopTest();
    }
    
    
    /*Gunjari 09/07 -- test class for insertAllOpportunityRollupRecordTest*/  
    @isTest
    public static void insertAllOpportunityRollupRecordTest(){
        system.test.StartTest();
        Account ultimateParentAcc = AccountTestFactory.getOnlineAccountRecord('Ultimate Parent Account'); 
        Database.insert(ultimateParentAcc,false);
        system.assertNotEquals(null, ultimateParentAcc.id);    
        Account testChildAcc = AccountTestFactory.getOnlineAccountRecord('Test Child Account');
        testChildAcc.ParentId=ultimateParentAcc.Id;
        Database.insert(testChildAcc,false);
        system.assertNotEquals(null, testChildAcc.id); 
        system.assertEquals(ultimateParentAcc.Id, testChildAcc.ParentId);
        Opportunity opty = NSSales_OpportunityFactory.createOpportunityForHelper();
        opty.AccountId=testChildAcc.id;
        Database.update(opty,false);
        system.assertNotEquals(null,opty.id); 
        system.assertEquals(testChildAcc.id, opty.AccountId);
        NSSales_AllOpportunityRollups__c optyRollupRec = [SELECT NSSales_Opportunity__c, NSSales_Account__c,NSSales_UltimateParentAccount__c 
                                                          FROM NSSales_AllOpportunityRollups__c where NSSales_Opportunity__c= :opty.id];
        
        system.assertEquals(opty.id,optyRollupRec.NSSales_Opportunity__c);
        system.assertEquals(opty.AccountId,optyRollupRec.NSSales_Account__c);
        system.assertEquals(ultimateParentAcc.id,optyRollupRec.NSSales_UltimateParentAccount__c);
        system.test.stopTest();     
        
    }
    
    /*Gunjari 09/07 -- test class for updateAllOpportunityRollupRecordTest*/  
   /* @isTest
    
    public static void updateAllOpportunityRollupRecordTest(){
        
        system.test.StartTest();
        Account ultimateParentAcc1 = AccountTestFactory.getOnlineAccountRecord('Ultimate Parent Account 1'); 
        Database.insert(ultimateParentAcc1,false);
        system.assertNotEquals(null, ultimateParentAcc1.id);    
        Account testChildAcc1 = AccountTestFactory.getOnlineAccountRecord('Test Child Account 1');
        testChildAcc1.ParentId=ultimateParentAcc1.Id;
        Database.insert(testChildAcc1,false);
        system.assertNotEquals(null, testChildAcc1.id); 
        system.assertEquals(ultimateParentAcc1.Id, testChildAcc1.ParentId);
        Account ultimateParentAcc2= AccountTestFactory.getOnlineAccountRecord('Ultimate Parent Account 2'); 
        Database.insert(ultimateParentAcc2,false);
        system.assertNotEquals(null, ultimateParentAcc2.id);    
        Account testChildAcc2= AccountTestFactory.getOnlineAccountRecord('Test Child Account 2');
        testChildAcc2.ParentId=ultimateParentAcc2.Id;
        Database.insert(testChildAcc2,false);
        system.assertNotEquals(null, testChildAcc2.id); 
        system.assertEquals(ultimateParentAcc2.Id, testChildAcc2.ParentId);
        Opportunity opty = NSSales_OpportunityFactory.createOpportunityForHelper();
        opty.AccountId=testChildAcc1.id;
        Database.update(opty,false);
        system.assertNotEquals(null,opty.id); 
        system.assertEquals(testChildAcc1.id, opty.AccountId);
        NSSales_AllOpportunityRollups__c optyRollupRec = [SELECT NSSales_Opportunity__c, NSSales_Account__c,NSSales_UltimateParentAccount__c 
                                                          FROM NSSales_AllOpportunityRollups__c where NSSales_Opportunity__c= :opty.id];
        system.assertEquals(opty.id,optyRollupRec.NSSales_Opportunity__c);
        system.assertEquals(opty.AccountId,optyRollupRec.NSSales_Account__c);  
        system.assertEquals(ultimateParentAcc1.id,optyRollupRec.NSSales_UltimateParentAccount__c);
        opty.AccountId= testChildAcc2.id;
        Database.update(opty,false);
        optyRollupRec = [SELECT NSSales_Opportunity__c, NSSales_Account__c,NSSales_UltimateParentAccount__c 
                         FROM NSSales_AllOpportunityRollups__c where NSSales_Opportunity__c= :opty.id];
        system.assertEquals(opty.id,optyRollupRec.NSSales_Opportunity__c);
        system.assertEquals(opty.AccountId,optyRollupRec.NSSales_Account__c);
        system.assertEquals(ultimateParentAcc2.id,optyRollupRec.NSSales_UltimateParentAccount__c);  
        system.test.stopTest();     
    }
   */ 
    /*Gunjari 08/27 -- test class for sendEmailToCampaignMembersOnOptyOnCreate and sendEmailToCampaignMembersOnOptyOnUpdate*/  
    @isTest
    public static void sendEmailToCampaignMembersOnOptyTest(){
        system.test.StartTest();
        //Creating two new users
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User testUser1 = UserTestFactory.createUser(14,sysprof.Id);
        system.assertNotEquals(null,testUser1.id); 
        User testUser2 = UserTestFactory.createUser(15,sysprof.Id);
        system.assertNotEquals(null,testUser2.id);  
        
        //creating one new campaign
        Campaign newCampaign = new Campaign();
        newCampaign.name = 'Test Campaign';
        insert newCampaign;
        system.assertNotEquals(null,newCampaign.id);  
        
        //creating 2 Internal Campaign Member records
        Internal_Campaign_Members__c internalCampMember1 = new Internal_Campaign_Members__c();
        internalCampMember1.NSSales_Campaign__c = newCampaign.id;
        internalCampMember1.NSSales_Internal_User__c = testUser1.id;
        internalCampMember1.NSSales_Role__c ='test role';
        insert internalCampMember1;
        system.assertNotEquals(null,internalCampMember1.id); 
        system.assertEquals(newCampaign.id,internalCampMember1.NSSales_Campaign__c); 
        
        Internal_Campaign_Members__c internalCampMember2 = new Internal_Campaign_Members__c();
        internalCampMember2.NSSales_Campaign__c = newCampaign.id;
        internalCampMember2.NSSales_Internal_User__c = testUser2.id;
        internalCampMember2.NSSales_Role__c ='test role';  
        insert internalCampMember2;
        system.assertNotEquals(null,internalCampMember2.id); 
        system.assertEquals(newCampaign.id,internalCampMember2.NSSales_Campaign__c); 
        
        //creating a new opportunity
        Opportunity opty = NSSales_OpportunityFactory.createOpportunityForHelper();  
        system.assertNotEquals(null,opty.id);
        opty.CampaignId = newCampaign.id;
        update opty;
        system.assertEquals(newCampaign.id,opty.CampaignId); 
        system.test.stopTest();
    }
    
    @isTest
    public static void all609_1_Test(){
        system.test.StartTest();
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User testUser = UserTestFactory.createUser(14,sysprof.Id);
        system.assertNotEquals(null,testUser.id); 
        System.runAs(testUser){ 
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
            system.assertNotEquals(null,opty.id); 
            NSSales_609_1_All_Switch_Coordinates__c switchCordinateRec = new NSSales_609_1_All_Switch_Coordinates__c();
            switchCordinateRec.NSSales_Switch_Identification_Numbers__c ='100026320';
            switchCordinateRec.NSSales_Latitude__c ='37.27935701';
            switchCordinateRec.NSSales_Longitude__c ='-79.90954751';
            insert switchCordinateRec;
            opty.NSSales_609_1_SwitchIdentificationNumber__c = switchCordinateRec.NSSales_Switch_Identification_Numbers__c;
            opty.NSSales609_1_InitaitedDate__c =system.today();
            update opty;
            system.test.stopTest();
        }
    }

    
    public static void oppStageChangeUpdateTest(){
        system.test.StartTest();
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User testUser = UserTestFactory.createUser(14,sysprof.Id);
        Opportunity opty = NSSales_OpportunityFactory.createOpportunityForHelper();  
        BU__c accClsfctn = new BU__c();
        accClsfctn.RecordTypeId = Schema.SObjectType.BU__c.getRecordTypeInfosByName().get('Automotive').getRecordTypeId();
        accClsfctn.Account__c = Opty.AccountId;
        insert accClsfctn; 
        BU__c accClsfctn1 = new BU__c();
        Account testAcc = AccountTestFactory.getOnlineAccountRecord('Test Child Account');
        insert testAcc;
        accClsfctn1.RecordTypeId = Schema.SObjectType.BU__c.getRecordTypeInfosByName().get('Automotive').getRecordTypeId();
        accClsfctn1.Account__c = testAcc.id;
        Opty.NSSales_Account_Classification__c =  accClsfctn.id;
        opty.StageName ='Internal Review';
        opty.NS_SalesNPO_Approvers__c = testUser.id;
        opty.Opportunity_Owner_NPO_Updates__c = '';
        update opty;
        opty.StageName = 'Proposal';
        update opty;
        opty.Opportunity_Owner_NPO_Updates__c = 'test update';
        update opty;
        
        opty.StageName = 'Negotiation';
        opty.Opportunity_Owner_NPO_Updates__c = '';
        update opty;
        /*
opty.Opportunity_Owner_NPO_Updates__c = 'test further Update';
update opty;

        opty.StageName = 'Closed Won';
        opty.Won_Reason__c = 'Alternative Product';
        update opty;
*/
        system.test.stopTest();
    }
             
}