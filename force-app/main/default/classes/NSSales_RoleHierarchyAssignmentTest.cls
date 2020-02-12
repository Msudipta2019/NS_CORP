@isTest(SeeAllData=false)
private class NSSales_RoleHierarchyAssignmentTest {
	static testmethod void testRoleAssignment(){
        Test.startTest();
        User user3= UserTestFactory.createUser(36, UserTestFactory.createProfile('NS Sales Manager').Id);
        Id RoleCeo = [SELECT Id FROM UserRole WHERE Name  = 'NS CEO'].Id;
        user3.UserRoleId=RoleCeo;
        update user3;
        NSSales_RoleHierarchyAssignment BC = new NSSales_RoleHierarchyAssignment();
        DataBase.executeBatch(BC);
        Test.stopTest();
    }

}