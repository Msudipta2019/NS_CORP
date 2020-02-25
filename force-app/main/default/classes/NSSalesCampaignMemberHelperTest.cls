/**************************************************************************
Description  : Test Class for NSSales_opportunitySiteTriggerHelper class
Developer    : Accenture Solutions
Date         : 21-09-2019
****************************************************************************/
@isTest
public class NSSalesCampaignMemberHelperTest {
    
    
      static testMethod void createCampaignMemberTestMethod()
      {
          Campaign newcamp = new Campaign();
          newcamp.Name='Test Campaign';
          newcamp.IsActive=True;
          newcamp.Type='Email';
          
          Insert newcamp;
          
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
          
          camrcd.Status='Responded';
          update camrcd;
          
          
          delete camrcd;
          
          
          
      }
}