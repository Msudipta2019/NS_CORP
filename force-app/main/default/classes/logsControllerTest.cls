/**************************************************************************
Description  : Test Class for NSSales_opportunitySiteTriggerHelper class
Developer    : Accenture Solutions
Date         : 21-09-2019
****************************************************************************/
@isTest

public class logsControllerTest {
    
    static testMethod void logsControllerTestMethode()
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
        
        logsController.getLogs(internalcammem.id);
        
         Contact newCon= new Contact();
          newCon.FirstName='Test';
          newCon.LastName='Nscrop45';
          newCon.Email='Janpl@nscrop.com';
          newCon.Phone='4568092';
          newCon.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('General Contact').getRecordTypeId();
          insert newCon;
          
          
          CampaignMember camrcd= new CampaignMember();
          camrcd.CampaignId=newcamp.id;
          camrcd.ContactId=newCon.id;
          camrcd.Status='Sent';
          //insert camrcd;
          Database.SaveResult result=Database.insert(camrcd);
         system.assertEquals(True, result.isSuccess());
        
       logsController.getCampaignMemberLogs(camrcd.id);  
      
    }

}