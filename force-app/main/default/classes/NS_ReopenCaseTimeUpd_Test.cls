/**@author  Accenture
* @Created Date 2019-12-23
* @version  1.0
* @description This is test class for NS_ReopenCaseTimeUpd.
***************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
***************************************************************************

----------------------------------------------------------------------------
*/ 


@isTest(SeeAllData=false)
public class NS_ReopenCaseTimeUpd_Test {
    
     public static testmethod void positiveCasereopen()
    {
     Account masterAccount= AccountTestFactory.createAccountRecord('BacthTest01');
     list<case> cinsert= new list<case>();
        
         Case cs1 = new Case();
         cs1 = CaseTestFactory.createCaseRecord('Cash Hold','Accounting/Waybilling',masterAccount.Id);
         cinsert.add(cs1);   
         insert cinsert; 
       
    
        cs1.NS_ExternalCaseNotes__c='Test';
        cs1.NS_CustomerNotifiedDateTime__c=system.today();
        cs1.NS_DatePaymentReceived__c=system.today();      
        cs1.NS_Last_Activity_Time__c=system.today()-2;
        cs1.NS_Counter_Activity__c=2;
   
        cs1.Status='NS_Closed';
        NS_StaticVariablesUtility.bSkipCaseTrigger =false;
        update cs1;
        
        cs1.Status='NS_Working';
        
        NS_StaticVariablesUtility.bSkipCaseTrigger =false;
        update cs1;     
        system.assertEquals(cs1.Status,'NS_Working');    

    }
}