/*
Description  : This class covers the unit testing for NS_BatchforResponseTimeInsert. Coverage 100%
Developer    : Accenture Solutions (GP)
Date         : 11/04/2019
Modidications:
-----------------------------------------------------------------------
Developer name        Date          Description 
-----------------------------------------------------------------------
*/
//set up test data
@isTest 
public class NS_BatchforResponseTimeInsertTest {

    @testSetup 
    static void createTestData() {
         //Set up sys admin profile and user
         Profile sysprof = UserTestFactory.createProfile(NS_StaticVariablesUtility.SystemAdministratorProfile);
         User admin = UserTestFactory.createUser(14,sysprof.Id);
         system.runAs(admin) { //run below as the setup admin user
              //Cretae Account
              Account acc = AccountTestFactory.createAccountRecord('test Account');//Create account
              acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name ='Corporate' AND SobjectType ='Account' Limit 1].id;
              acc.NS_Account_Tier__c = 'Tier2';
              acc.NS_Major_Commodity__c = 'AgFP';
              update acc;
              //Create Contact
              Contact con = ContactTestFactory.createContactRecord(acc.id, 'customerAccount') ;  //create contact     
              con.email = 'test.testing@sometest.com';  //set contact email
              update con;
              //Create Queue
              Group g1 = new Group(Name='NS_AgFp_Core', type='Queue'); //insert queue
              insert g1; 
 			  //Cretae Case
              Case c = CaseTestFactory.createCase('Concerned Citizen', 'Concerned Citizen', acc.id, con.id);
              c.OwnerId = g1.id; //assign queue as owner
              insert c;
              //Create Task. assign properties for the batch to pick it up
              Task tsk = TaskTestFactory.createTaskRecord(NS_StaticVariablesUtility.NAME);
              tsk.NS_Flag__c = false;
              tsk.TaskSubtype = 'call';
              tsk.WhatId = c.id;
              tsk.WhoId = con.id;
              insert tsk;
              
 
      }      
    }
/*   
Description  : Test the batch logic
Developer    : Accenture Solutions (GP)
Date         : 11/04/2019
Modidications:
-----------------------------------------------------------------------
Developer name        Date          Description 
-----------------------------------------------------------------------
*/
@istest 
    private static  void BatchforResponseTimeInsertTest(){ 
        test.startTest();
        Case c = [select id, NS_Time_To_Response__c from case Limit 1];
        c.NS_Time_To_Response__c = NULL;
        update c;
         
        NS_BatchForResponseTimeInsert batchClass = new  NS_BatchForResponseTimeInsert();
        Database.executeBatch(batchClass,200);
      	//for batch tests the .stopTest needs to be placed BEFORE assertions !!!!
        test.stopTest(); 
        c = [select id, NS_Time_To_Response__c from case Limit 1];
        system.assertEquals(0, c.NS_Time_To_Response__c, 'Time To Response shoul be 0');
      
    }

    
/*   
Description  : Test the batch scheduler
Developer    : Accenture Solutions (GP)
Date         : 11/04/2019
Modidications:
-----------------------------------------------------------------------
Developer name        Date          Description 
-----------------------------------------------------------------------
*/    
   @istest
   private static  void testschedule() {
		Test.StartTest();
		NS_BatchForResponseTimeInsert testsche = new  NS_BatchForResponseTimeInsert();
		String sch = '0 0 01 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}

}