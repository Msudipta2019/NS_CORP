@isTest(seeAllData=false)
public class  NSSales_609_1_MgrRoutrTriggerHelperTest {
    static testMethod void updateNSSales_609_1_MgrRoutinsert() {
        Test.startTest();
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        
        NSSales_State__c cstState= new NSSales_State__c();
        cstState.Name='testState';
        insert cstState;
        
        NSSales_609_1_Manager_Routing__c routingRec=new NSSales_609_1_Manager_Routing__c();
        routingRec.NSSales_City_Name__c ='Kolkata';
        routingRec.NSSales_State_Name__c='West Bengal';
        routingRec.NSSales_ID_Manager_Name__c=admin.id;
        routingRec.NSSales_Territory_Name__c='test';
        insert routingRec;
       
        NSSales_State__c cstState1= [select name from NSSales_State__c where name ='West Bengal'];
        system.assertNotEquals(null, cstState1.id);
        Test.stopTest();
        
    }
    
    
    static testMethod void updateNSSales_609_1_MgrRoutdelete() {
        
        Test.startTest();
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        
        NSSales_609_1_Manager_Routing__c routingRec=new NSSales_609_1_Manager_Routing__c();
        routingRec.NSSales_City_Name__c ='Kolkata';
        routingRec.NSSales_State_Name__c='West Bengal';
        routingRec.NSSales_County_Name__c='test county';
        routingRec.NSSales_ID_Manager_Name__c=admin.id;
        routingRec.NSSales_Territory_Name__c='test';
        insert routingRec;
        system.assertNotEquals(null, routingRec.id);
        
        NSSales_609_1_Manager_Routing__c delRecord=[Select id from NSSales_609_1_Manager_Routing__c 
                                                   where NSSales_State_Name__c='West Bengal'
                                                   and NSSales_City_Name__c ='Kolkata'
                                                  and NSSales_County_Name__c='test county'];
        delete delRecord;
        Test.stopTest();
    }  
    
    /*static testMethod void updateNSSales_609_1_MgrRoutedit() {   
        
        Test.startTest();
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        
        NSSales_609_1_Manager_Routing__c routingRec=new NSSales_609_1_Manager_Routing__c();
        routingRec.NSSales_City_Name__c ='Kolkata';
        routingRec.NSSales_State_Name__c='West Bengal';
        routingRec.NSSales_ID_Manager_Name__c=admin.id;
        routingRec.NSSales_Territory_Name__c='test';
        insert routingRec; 
        
        routingRec.NSSales_State_Name__c='Test State';
        update routingRec;
        
        NSSales_State__c cstState1= [select name from NSSales_State__c where name ='Test State'];
        system.assertNotEquals(null, cstState1.id);
       
        Test.stopTest();
    }*/
}