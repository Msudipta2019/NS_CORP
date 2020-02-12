@isTest(SeeAllData=false)
private class NS_OppWorkBenchRequestTest {
    
    static testmethod void testOpportunityWBInsert(){
        String StageNameInternalReview = 'Internal Review';
        NS_TriggerSettings__c customSet1 = new NS_TriggerSettings__c();
        customSet1.Name=NS_StaticVariablesUtility.assocTrigger;
        customSet1.NS_IsActive__c=true;
        Database.insert(customSet1,false);
        System.debug('CustomSet: '+customSet1.id);
        NS_Integration_Endpoints__c ie = new NS_Integration_Endpoints__c();
        ie.Name = 'CustomerContactChange_Teams';
        ie.Endpoint_URL__c = 'https://www.google.com';
        insert ie;
        
        Account newAcc = new Account(Name='Test',RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerService' AND 
                                                                 SobjectType ='Account' Limit 1].id);
        insert newAcc;
         BU__c asso = new BU__c();
         asso.Account__c=newAcc.id;
         //asso.NS_Account_Type_BU__c='Direct Customer';
         asso.RecordTypeId=Schema.SObjectType.BU__c.getRecordTypeInfosByName().get('Industrial Products').getRecordTypeId();              
         insert asso;     
        User atest;
        Profile agent = UserTestFactory.createProfile(NS_StaticVariablesUtility.SalesManager);
        atest = UserTestFactory.createUserSales(22,agent.Id);
        Opportunity opp = new Opportunity();
         opp.Name = 'Test';
         opp.AccountId = newAcc.Id;
         opp.NS_Originating_Department__c = 'Industrial Products';
         opp.StageName = 'Qualification/Analysis';
         opp.NS_Origin_Carrier__c = 'NS';
         opp.NS_Origin_City__c = 'Norfolk';
         opp.Origin_State__c = 'VA';
         opp.NS_Destination_Carrier__c = 'NS';
        opp.NS_Destination_City__c = 'Atlanta';
         opp.NS_Destination_State__c = 'NA';
         opp.CloseDate = System.Today();
        
         opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('General Opportunity').getRecordTypeId();
        insert opp;
       // Opp.NS_SalesNPO_Approvers__c = atest.id;
        Opp.StageName=StageNameInternalReview;
        Opp.NS_Origin_Station__c='Test';                 
        Opp.NS_Estimated_Volume__c=100;
        Opp.NS_Destination_Station__c='Test123';
        Opp.NSSales_Commodity_Group__c='Test123';
        Opp.Projected_Start_Date__c=System.Today();
        Opp.NS_Contract_Start_Date__c=System.Today();
        Opp.NS_Destination_State__c='Test';
        Opp.Frequency__c='Weekly';
        Opp.NSSales_Spot_Contract__c='Spot';
        Opp.NSSales_Need_by_Date__c=System.Today();
        Opp.NS_Origin_City__c='Kolkata';
        Opp.NSSales_Route__c='Test';
        Opp.NS_Destination_City__c='Kolkata';
        Opp.Consignee__c=newAcc.id;                
        Opp.NSSales_Shipper__c=newAcc.id;
        Opp.NSSales_Account_Classification__c=asso.id;
        //opp.NS_WB_RequestID__c ='123456789012';
        update opp;
        Opp.NS_SalesNPO_Approvers__c = atest.id;
        //Opp.NSSales_OPS_Planning_North__c = true;
        Opp.NSSales_NPO_Final_Approval__c = true;
        opp.StageName ='Proposal';
        update opp;
       Test.startTest();
        System.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
        Test.stopTest();
    }

}