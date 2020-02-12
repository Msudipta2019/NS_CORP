/**@author  Accenture
* @Created Date 2019-12-23
* @version  1.0
* @description This is test class for NS_CaseUpdateforSystemDefect.
***************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
***************************************************************************

----------------------------------------------------------------------------
*/ 

@isTest(SeeAllData=false)
public class NS_CaseUpdateforSystemDefectTest {
    
    
     public static testmethod void positiveCasetest()
    {
     Account masterAccount= AccountTestFactory.createAccountRecord('BacthTest500');

        
         Case cs1 = new Case();
         cs1 = CaseTestFactory.createCaseRecord('Cash Hold','Accounting/Waybilling',masterAccount.Id);
        
   
         insert cs1; 
        system.debug('Sudipta:Case Status Check200'+cs1.Status+''+cs1.NS_Type__c+''+cs1.NS_CaseStatusCheck__c);
        cs1.NS_InteractionCategory__c='Business Functions';
        cs1.NS_InteractionReason__c='Technical Support';
        cs1.NS_Type__c='AccessNS/TRAX - System Defect';
        cs1.NS_RACFUserID__c='NS123';
        //cs1.NS_CaseStatusCheck__c=false;
        NS_StaticVariablesUtility.bSkipCaseTrigger =false;
        update cs1;   
  
         string cs3=([select status from case where id=:cs1.id].status);
         //system.debug('Sudipta:Case Status Check'+cs1.Status+''+cs1.NS_Type__c+''+cs3);
         system.assertEquals(cs3,'NS_AwaitingResponse');
        //system.assertNotEquals(cs1.id,null);

    }
    

}