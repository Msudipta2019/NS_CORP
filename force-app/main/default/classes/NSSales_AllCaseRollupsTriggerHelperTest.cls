@isTest(SeeAllData=false)
public class NSSales_AllCaseRollupsTriggerHelperTest {
    @isTest
    public static void updateCaseRollupRecordTest(){
        Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
        User admin = UserTestFactory.createUser(14,sysprof.Id);
        System.runAs(admin){
            system.test.StartTest();
          
            Account ultimateParentAcc1 = AccountTestFactory.getOnlineAccountRecord('Ultimate Parent Account 1'); 
            Database.insert(ultimateParentAcc1,false);
            system.assertNotEquals(null, ultimateParentAcc1.id); 
            
            //sus

            
            Account testChildAcc1 = AccountTestFactory.getOnlineAccountRecord('Test Child Account 1');
            testChildAcc1.ParentId=ultimateParentAcc1.id;
            Database.insert(testChildAcc1,false);
            system.assertNotEquals(null, testChildAcc1.id); 
            system.assertEquals(ultimateParentAcc1.id, testChildAcc1.ParentId);   
            
            Account testChildAcc2= AccountTestFactory.getOnlineAccountRecord('Test Child Account 2');
            testChildAcc2.ParentId=testChildAcc1.Id;
            Database.insert(testChildAcc2,false);   
            Case case1 = CaseTestFactory.createCaseRecord('Embargo','Local Service',testChildAcc2.Id);
            case1.NS_CustomerNotifiedDateTime__c=system.now();

            insert case1;
            //system.debug('try test'+case1);
            system.assertNotEquals(null, case1.id);           
            
            NSSales_AllCaseRollups__c rollUpRec = new NSSales_AllCaseRollups__c(); 
            rollUpRec.NSSales_Case__c=case1.id;
            rollUpRec.NSSales_Account__c= null;
            insert rollUpRec;
            rollUpRec.NSSales_Account__c= testChildAcc2.Id;
            update rollUpRec;

            
            rollUpRec=[SELECT NSSales_Case__c, NSSales_Account__c,NSSales_UltimateParentAccount__c 
                    FROM NSSales_AllCaseRollups__c where NSSales_Case__c= :case1.id LIMIT 1];
            system.assertEquals(ultimateParentAcc1.Id,rollUpRec.NSSales_UltimateParentAccount__c);             
        }
        system.test.stopTest();
    }
}