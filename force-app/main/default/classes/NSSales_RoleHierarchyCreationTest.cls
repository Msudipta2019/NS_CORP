@isTest(SeeAllData=false)
private class NSSales_RoleHierarchyCreationTest {
    static testmethod void testRoleHierarchy(){
        Test.startTest();
        
        User user1=UserTestFactory.createUser(06, UserTestFactory.createProfile('NS Sales Manager').Id);
        user1.NSSales_Role_Level__c= 2;
        user1.Department_Description__c  = 'Business Development';
        user1.NSSales_RoleName__c= 'Sales Business Development Level 2';
        update user1;
        
        User user2=UserTestFactory.createUser(16, UserTestFactory.createProfile('NS Sales Manager').Id);
        user2.NSSales_Role_Level__c= 10;
        user2.Department_Description__c  = 'Business Development';
        user2.NSSales_RoleName__c= 'Sales Business Development Level 10';
        update user2;
        
        User user3=UserTestFactory.createUser(36, UserTestFactory.createProfile('NS Industrial Development Manager').Id);
        user3.NSSales_Role_Level__c= 2;
        user3.Department_Description__c  = 'Business Development';
        user3.NSSales_RoleName__c= 'ID Business Development Level 2';
        update user3;
        
        User user4=UserTestFactory.createUser(46, UserTestFactory.createProfile('NS Industrial Development Manager').Id);
        user4.NSSales_Role_Level__c= 10;
        user4.Department_Description__c  = 'Business Development';
        user4.NSSales_RoleName__c= 'ID Business Development Level 10';
        update user4;
        
        User user5=UserTestFactory.createUser(56, UserTestFactory.createProfile('NS Sales Read Only').Id);
        user5.NSSales_Role_Level__c= 2;
        user5.Department_Description__c  = 'Business Development';
        user5.NSSales_RoleName__c= 'Sales ReadOnly Business Development Level 2';
        update user5;
        
        User user6=UserTestFactory.createUser(66, UserTestFactory.createProfile('NS Sales Read Only').Id);
        user6.NSSales_Role_Level__c= 10;
        user6.Department_Description__c  = 'Business Development';
        user6.NSSales_RoleName__c= 'Sales ReadOnly Business Development Level 10';
        update user6;
        
        NSSales_RoleHierarchyCreation BC=new  NSSales_RoleHierarchyCreation();
        DataBase.executeBatch(BC);
        Test.stopTest();
        
    }

}