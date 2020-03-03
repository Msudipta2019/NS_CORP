@isTest(SeeAllData=false)
public class NSSales_LightningTreeApexControllerTest {
    
  
        @isTest static void runAccountHierarchyTest(){
       /* Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        User atest;
        system.runAs(admin){ 
            Profile agent = UserTestFactory.createProfile(NS_StaticVariablesUtility.SalesManager);
            atest = UserTestFactory.createUserSales(22,agent.Id);
        }*/
        system.test.StartTest();
        Account ultimateParent = AccountTestFactory.getOnlineAccountRecord('Ultimate Parent 1'); 
        Database.insert(ultimateParent,false);
        Account testChildCorp1 = AccountTestFactory.getOnlineAccountRecord('Test Child Corporate 1');
        testChildCorp1.ParentId=ultimateParent.Id;
        Database.insert(testChildCorp1,false);
        system.assertEquals(ultimateParent.Id, testChildCorp1.ParentId);
        Account testChildCorp2 = AccountTestFactory.getOnlineAccountRecord('Test Child Corporate 2');
        testChildCorp2.ParentId=ultimateParent.Id;
        Database.insert(testChildCorp2,false);   
        system.assertEquals(ultimateParent.Id, testChildCorp2.ParentId);
        Account testGrandChildCorp1 = AccountTestFactory.getOnlineAccountRecord('Test Grand Child Corporate 1');
        testGrandChildCorp1.ParentId = testChildCorp1.Id;
        Database.insert(testGrandChildCorp1,false);
        system.assertEquals(testChildCorp1.Id, testGrandChildCorp1.ParentId); 
        Account testGrandChildCorp2 = AccountTestFactory.getOnlineAccountRecord('Test Grand Child Corporate 2');
        testGrandChildCorp2.ParentId = testChildCorp1.Id;
        Database.insert(testGrandChildCorp2,false);
        system.assertEquals(testChildCorp1.Id, testGrandChildCorp2.ParentId);   
        Account testGrandChildBus1 = AccountTestFactory.getOnlineBusinessAccountRecord('Test Grand Child Business 1');
        testGrandChildBus1.ParentId = testChildCorp2.Id;
        Database.insert(testGrandChildBus1,false);
        system.assertEquals(testChildCorp2.Id, testGrandChildBus1.ParentId);
        Account testGrandChildBus2 = AccountTestFactory.getOnlineBusinessAccountRecord('Test Grand Child Business 2');
        testGrandChildBus2.ParentId = testChildCorp2.Id;
        Database.insert(testGrandChildBus2,false);
        system.assertEquals(testChildCorp2.Id, testGrandChildBus2.ParentId);
      //  system.runAs(atest){
        NSSales_LightningTreeApexController.getAccountHierarchy(ultimateParent.id,false); 
     //   }
     system.test.stopTest();  
     
    }
    
    
    
    
    @isTest static void runExpandHierarchyTest(){
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        User atest;
        system.runAs(admin){ 
            Profile agent = UserTestFactory.createProfile(NS_StaticVariablesUtility.SalesManager);
            atest = UserTestFactory.createUserSales(22,agent.Id);
        }
        system.test.StartTest();
        Account ultimateParent = AccountTestFactory.getOnlineAccountRecord('Ultimate Parent 1'); 
        Database.insert(ultimateParent,false);
        Account testChildCorp1 = AccountTestFactory.getOnlineAccountRecord('Test Child Corporate 1');
        testChildCorp1.ParentId=ultimateParent.Id;
        Database.insert(testChildCorp1,false);
        system.assertEquals(ultimateParent.Id, testChildCorp1.ParentId);
        Account testChildCorp2 = AccountTestFactory.getOnlineAccountRecord('Test Child Corporate 2');
        testChildCorp2.ParentId=ultimateParent.Id;
        Database.insert(testChildCorp2,false);   
        system.assertEquals(ultimateParent.Id, testChildCorp2.ParentId);
        Account testGrandChildCorp1 = AccountTestFactory.getOnlineAccountRecord('Test Grand Child Corporate 1');
        testGrandChildCorp1.ParentId = testChildCorp1.Id;
        Database.insert(testGrandChildCorp1,false);
        system.assertEquals(testChildCorp1.Id, testGrandChildCorp1.ParentId); 
        Account testGrandChildCorp2 = AccountTestFactory.getOnlineAccountRecord('Test Grand Child Corporate 2');
        testGrandChildCorp2.ParentId = testChildCorp1.Id;
        Database.insert(testGrandChildCorp2,false);
        system.assertEquals(testChildCorp1.Id, testGrandChildCorp2.ParentId);   
        Account testGrandChildBus1 = AccountTestFactory.getOnlineBusinessAccountRecord('Test Grand Child Business 1');
        testGrandChildBus1.ParentId = testChildCorp2.Id;
        Database.insert(testGrandChildBus1,false);
        system.assertEquals(testChildCorp2.Id, testGrandChildBus1.ParentId);
        Account testGrandChildBus2 = AccountTestFactory.getOnlineBusinessAccountRecord('Test Grand Child Business 2');
        testGrandChildBus2.ParentId = testChildCorp2.Id;
        Database.insert(testGrandChildBus2,false);
        system.assertEquals(testChildCorp2.Id, testGrandChildBus2.ParentId);
     //   system.runAs(atest){
             NSSales_LightningTreeApexController.expandAllItems(testChildCorp1.id,false);
     //   }   
     system.test.stopTest();    
    }
    
}