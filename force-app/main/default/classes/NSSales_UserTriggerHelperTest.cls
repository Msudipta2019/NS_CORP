@isTest(seeAllData=false)
public class NSSales_UserTriggerHelperTest {
    static testMethod void updateDateTime() {
        
        
        
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(37,sysprof.Id);
        User user1= UserTestFactory.createUser(76, UserTestFactory.createProfile('NS Marketing Manager').Id);
        
        admin.TimeZoneSidKey='America/New_York';
        admin.NSSales_TimeDelta__c=5;
        update admin;
        
        List<User> alist1=[Select id,TimeZoneSidKey from User where id=: admin.Id];
        System.debug('alist1'+alist1.size());
        system.assertNotEquals(null, admin.id);
        Test.startTest(); 
        
        Account ex= AccountTestFactory.createAccountRecord('test account');
        Opportunity opTest = new Opportunity();
        opTest.AccountId=ex.id;
        opTest.NS_Originating_Department__c='Automotive';
        opTest.NSSales_Implementation_Date__c=system.today();
        opTest.StageName='Closed: Implementation Pending';
        
        //opTest.NS_Expiration_Notification_Timeframe__c = 1;
        
        BU__c userPAC= new BU__c(Account__c=opTest.AccountId);
      
        NSSales_Marketing_Manager_Assignment__c nmm = 
            new NSSales_Marketing_Manager_Assignment__c(NSSales_Account__c = ex.Id ,
                                                        Primary_Account_Classification__c = userPAC.Id,
                                                        NSSales_MarketingManager__c = user1.id);
        
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.plainTextBody = 'teset';
        //email.toAddresses = 'test@test.com';
        
        
        NSSales_UserTriggerHelper abc=new NSSales_UserTriggerHelper();
        NSSales_UserTriggerHelper.sendEmail('teset','test@test.com','Test Lead');
        
        Test.stopTest();
        
        
    } 
    @isTest
    private  static void updatetimedelta(){
        
        Map<id,user> oldmap = new Map<id,user>();
        Map<id,user> newmap = new Map<id,user>();            
        
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        
        
        admin.TimeZoneSidKey='Asia/Kolkata';
        update admin;
        oldmap.put(admin.id , admin);
        Test.startTest(); 
        admin.TimeZoneSidKey='America/New_York';
        update admin;
        newmap.put(admin.id, admin);
        
        NSSales_UserTriggerHelper.updateTimeDeltaOnUpdate(newmap,oldmap);
        Test.stopTest();
        
        system.assertEquals('America/New_York',admin.TimeZoneSidKey);
        
    }
    @isTest
    private  static void updatemanopp(){
        Map<id,user> oldmap = new Map<id,user>();
        Map<id,user> newmap = new Map<id,user>();            
        
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        User username = UserTestFactory.createAutoLeadUser(15,sysprof.Id);
          Id RoleId = [SELECT Id FROM UserRole WHERE DeveloperName = 'Automotive_Leadership'].Id;       
        
        admin.IsActive=true;
        //admin.UserRoleId=admin.id;
        admin.ManagerId=username.id;
        admin.UserRoleId=RoleId;
        update admin;
        
        oldmap.put(admin.id , admin);
        Test.startTest(); 
        admin.IsActive=false;
      // admin.UserRoleId=admin.id;
      	admin.ManagerId=username.id;
        admin.UserRoleId=RoleId;
        update admin;
        newmap.put(admin.id, admin);
        
        NSSales_UserTriggerHelper.updateoppmanager(newmap,oldmap);
        Test.stopTest();          
        system.assertEquals(false,admin.IsActive);       

}
}