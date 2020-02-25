@isTest
public class NS_VOC_SurveyResultTriggerHelperTest 
{
    @isTest static void testCreateSurvey() 
    {
        Account a=AccountTestFactory.createAccountRecord('Test Account');
        System.debug(' Check'+a.id);
        
        Contact c=ContactTestFactory.createContactRecord(a.Id,'Random');
        System.debug('test  '+c.NS_CustomerAccnt__c);
        System.debug('test1  '+c.id);
        
        Case cas=CaseTestFactory.createCase('Setback', 'Foreign Road', a.Id, c.Id);
        insert cas;
        System.debug('Test_Case' +cas.NS_InteractionReason__c);
        System.debug('Test_Case' +cas.NS_InteractionCategory__c);
        System.debug('Test_Case' +cas.AccountId);
        System.debug('Test_Case' +cas.id);
        
        
        Survey_Result__c svr = new Survey_Result__c();
        svr.NS_resolve__c='Strongly Disagree';
        svr.NS_ParentCaseNumber__c=cas.id;
        svr.NS_resolveIssue__c='Yes';
        insert svr;
        
        System.assert(svr.id!=null);
    }    
}