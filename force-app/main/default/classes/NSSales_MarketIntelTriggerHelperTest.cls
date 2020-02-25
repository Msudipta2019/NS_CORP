/************************************
Description  : Test class for NSSales_MrktMngrAsgnmntTriggerHelper class
Developer    : Accenture
Date         : 25 Nov'19
**************************************/
@isTest(SeeAllData=false)
public class NSSales_MarketIntelTriggerHelperTest {
    
    public static testmethod void createNewMIAssocAccRecTest(){
        
        system.test.StartTest();
        
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id); 
        
        system.runAs(admin){
            
            Account testAccount1 = AccountTestFactory.getOnlineAccountRecord('Test Account');
            Database.insert(testAccount1,false);
            system.assertNotEquals(null, testAccount1.id); 
            
            Market_Intelligence__c testMIRec = new Market_Intelligence__c();
            testMIRec.Name = 'test Market Intel';
            testMIRec.Type__c = 'Economic';
            testMIRec.Source__c ='Account';
            testMIRec.Account__c =testAccount1.id;
            testMIRec.Mode__c = 'Ocean';
            testMIRec.Geography__c = 'US-West';
            Database.insert(testMIRec,false);
            system.assertNotEquals(null, testMIRec.id); 
            
            Account testAccount2 = AccountTestFactory.getOnlineAccountRecord('Test Account1');
            Database.insert(testAccount2,false);
            system.assertNotEquals(null, testAccount2.id); 
            testMIRec.Account__c = testAccount2.id;
            Database.update(testMIRec,false);
            system.test.StopTest();
            
        }
        
    }
    
}