@isTest
public class NSSales_OpptyAddress_Test {

    @isTest static void oppAddress()
    {
     Opportunity od = new Opportunity();   
     od.NSSales_609_1_OperatingDivision__c = 'DEARBORN';
     od.NSSales_609_1_Prefix__c = 'GJ';
     od.NSSales_State__c = 'ND';
     od.NSSales_Street__c = '7, Lok Kalyan Marg';
     od.NSSales_City__c = 'New Delhi';
     od.NSSales_609_1_Milepost__c = 100.00;
     System.debug(od.Id);
     NSSales_Oppty_Address.getaddress(od.Id);
     //stem.assertEquals(od!=null);          
    }   
    
}