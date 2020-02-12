@isTest(SeeAllData=false)
private class NSSales_RoleBatchTest {
    
    static testmethod void testUserRoleBatch(){
        Test.startTest();
        
        User user3= UserTestFactory.createUser(36, UserTestFactory.createProfile('NS Sales Manager').Id);
        Id RoleCeo = [SELECT Id FROM UserRole WHERE Name  = 'NS CEO'].Id;
        user3.UserRoleId=RoleCeo;
        update user3;
        
        User user4= UserTestFactory.createUser(420, UserTestFactory.createProfile('NS Sales Manager').Id);
        
        user4.UserRoleId=RoleCeo;
        user4.ManagerId=user3.Id;
        update user4;
        
        User user1= UserTestFactory.createUser(76, UserTestFactory.createProfile('NS Sales Manager').Id);
        user1.Department_Description__c  = 'Dummy Description for user1';
        user1.ManagerId=user3.Id;
        update user1;
        User user2= UserTestFactory.createUser(34, UserTestFactory.createProfile('NS Industrial Development Manager').Id);
        user2.Department_Description__c  = 'Dummy Description for user2';
        user2.ManagerId=user3.Id;
        update user2;
        NSSales_RoleBatch BC=new NSSales_RoleBatch();
        DataBase.executeBatch(BC);
        system.assert(user2.ManagerId != null);
        Test.stopTest();
        
    }
    
}