/**@author  Accenture
* @Created Date Oct,2019
* @version  1.0 
* @description This is the test class for NSSales_MarketIntelController
*/
@isTest
public class NSSales_MarketIntelControllerTest {
    
    @istest
    private static void createMarketIntelAssociatedObjectRecTest(){
     
        system.test.StartTest();
        Account testAccount = null;
        Contact testContact = null;
        Opportunity testOpty = null;
        Campaign testCampaign = null;
        Market_Intelligence__c testMIRec = null;
        
        //Creating an admin user
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        
        //Creating a Sales Manager user
        Profile testUserProfile=UserTestFactory.createProfile('NS Sales Manager');
        User testUser= UserTestFactory.createUser(87, testUserProfile.Id);
        
        system.runAs(admin){
            //Creating an Account
            testAccount = AccountTestFactory.getOnlineAccountRecord('Test Account');
            Database.insert(testAccount,false);
            
            //Creating a Contact
            testContact = ContactTestFactory.createContactRecord(testAccount.id,NS_StaticVariablesUtility.CONST_BLANK);
            
            //Creating an Opportunity
            testOpty = NSSales_OpportunityFactory.createOpportunityForHelper();
            
            //Creating a Campaign
            testCampaign = new Campaign();
            testCampaign.name = 'Test Campaign';
            Database.insert(testCampaign,false);
        }
        
        system.assertNotEquals(null, testAccount.id); 
        system.assertNotEquals(null, testContact.id); 
        system.assertNotEquals(null, testOpty.id); 
        system.assertNotEquals(null, testCampaign.id); 
        
        system.runAs(testUser){  
            //Creating a Market Intel Record
            testMIRec = new Market_Intelligence__c();
            testMIRec.Name = 'test Market Intel';
           	testMIRec.Type__c = 'Economic';
            testMIRec.Source__c ='Conference';
            testMIRec.Mode__c = 'Ocean';
            testMIRec.Geography__c = 'US-West';
            Database.insert(testMIRec,false);
        }
        
        system.assertNotEquals(null, testMIRec.id);
        
        //Checking if a Market Intel Associated Account Record has been created when a MI record is created from Account
        NSSales_MarketIntelController.createMarketIntelAssociatedObjectRec(testAccount.id,testMIRec.id);
        NS_Market_Intel_Account__c miAssocAccountRec = [Select id from NS_Market_Intel_Account__c where NSSales_Account__c = :testAccount.id and NSSales_Market_Intel__c = :testMIRec.id];
        system.assertNotEquals(null, miAssocAccountRec.id);
        
        
        //Checking if a Market Intel Associated Contact Record has been created when a MI record is created from Contact
        NSSales_MarketIntelController.createMarketIntelAssociatedObjectRec(testContact.id,testMIRec.id);
        Market_Intel_Associated_Contact__c miAssocContactRec = [Select id from Market_Intel_Associated_Contact__c where Contact__c = :testContact.id and Market_Intel__c = :testMIRec.id];
        system.assertNotEquals(null, miAssocContactRec.id);
        
        //Checking if a Market Intel Associated Opportunity Record has been created when a MI record is created from Opportunity
        NSSales_MarketIntelController.createMarketIntelAssociatedObjectRec(testOpty.id,testMIRec.id);
        Market_Intel_Associated_Opportunities__c miAssocOptyRec = [Select id from Market_Intel_Associated_Opportunities__c where Opportunity__c = :testOpty.id and Market_Intel__c = :testMIRec.id];
        system.assertNotEquals(null, miAssocOptyRec.id);
        
        
       //Checking if a Market Intel Associated Campaign Record has been created when a MI record is created from Campaign
        NSSales_MarketIntelController.createMarketIntelAssociatedObjectRec(testCampaign.id,testMIRec.id);
        Market_Intel_Associated_Campaign__c miAssocCampRec = [Select id from Market_Intel_Associated_Campaign__c where Campaign__c = :testCampaign.id and Market_Intel__c = :testMIRec.id];
        system.assertNotEquals(null, miAssocCampRec.id);
        system.test.StopTest();
    }
    
    @isTest
    private static void testMethodException(){
        String objectName = NSSales_MarketIntelController.findObjectNameFromRecordId('10');
        System.assertEquals(objectName,'');
    }
    
}