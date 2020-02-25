/**************************************************************************
Description  : Test Class for NSSales_opportunitySiteTriggerHelper class
Developer    : Accenture Solutions
Date         : 21-09-2019
****************************************************************************/
@isTest
public class NSSales_insertIntCmpMemberLogTest {
      static testMethod void createInternalMemberTestMethod()
      {
           Campaign newcamp = new Campaign();
          newcamp.Name='Test Campaign';
          newcamp.IsActive=True;
          newcamp.Type='Email';
          
          Insert newcamp;
          
          
          
          Internal_Campaign_Members__c internalcammem= new  Internal_Campaign_Members__c();
          internalcammem.NSSales_Campaign__c=newcamp.id;
          internalcammem.NSSales_Internal_User__c=userinfo.getUserId();
          internalcammem.NSSales_Phone__c='7845126';
          internalcammem.NSSales_Role__c='Teams';
          
          insert internalcammem;
          
          
          internalcammem.NSSales_Role__c='NS CROP';
          internalcammem.NSSales_Phone__c='7788556';
          update internalcammem;
          
          Delete internalcammem;
          
          
          Internal_Campaign_Members__c internalcammem02= new  Internal_Campaign_Members__c();
          internalcammem02.NSSales_Campaign__c=newcamp.id;
          internalcammem02.NSSales_Non_Connect_NS_User__c='Sudipta Mukherjee';
          internalcammem02.NSSale_Non_Connect_NS_User_Phone_Number__c='7845126';
          internalcammem02.NSSales_Non_Connect_NS_User_Role__c='Teams';
          internalcammem02.NSSale_Non_Connect_NS_User_Email_Address__c='abc@nscrop.com';
                    
        
          Database.SaveResult result = Database.insert(internalcammem02, false);
         
           system.assertEquals(True, result.isSuccess());
          
          
          internalcammem02.NSSales_Non_Connect_NS_User_Role__c='NS CROP';
          internalcammem02.NSSale_Non_Connect_NS_User_Phone_Number__c='7784556';
          internalcammem02.NSSale_Non_Connect_NS_User_Email_Address__c='sudipta@nscrop.com';
          update internalcammem02;
          
          
          delete internalcammem02;

     
          
      }
    
    
    
}