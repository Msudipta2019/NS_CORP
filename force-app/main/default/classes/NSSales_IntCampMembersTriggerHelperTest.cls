/*
Description  : This class is a Test Class for Internal Campaign Members Trigger Helper.
Developer    : Accenture Solutions
Date         : 08-27-2019
*/
@isTest
public class NSSales_IntCampMembersTriggerHelperTest {
    
    /*Gunjari 08/27 -- test class for sendNotificationToMembersOnCreate*/
    @isTest
    public static void sendNotificationToMembersTest(){
        system.test.StartTest();
        //Creating one new user
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User testUser = UserTestFactory.createUser(14,sysprof.Id);
        system.assertNotEquals(null,testUser.id); 

        //creating one new campaign
        Campaign newCampaign = new Campaign();
        newCampaign.name = 'Test Campaign';
        insert newCampaign;
        system.assertNotEquals(null,newCampaign.id);
        
        //creating one Internal Campaign Member records
        Internal_Campaign_Members__c internalCampMember = new Internal_Campaign_Members__c();
        internalCampMember.NSSales_Campaign__c = newCampaign.id;
        internalCampMember.NSSales_Internal_User__c = testUser.id;
        internalCampMember.NSSales_Role__c ='test role';
        insert internalCampMember;
        system.assertNotEquals(null,internalCampMember.id); 
        system.assertEquals(newCampaign.id,internalCampMember.NSSales_Campaign__c); 
        system.test.stopTest();      
    }
}