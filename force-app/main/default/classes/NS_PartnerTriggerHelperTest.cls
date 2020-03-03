@isTest
public class NS_PartnerTriggerHelperTest {
 
    @testSetup
    private static void setup(){
        
        opportunity Oppo = new opportunity();
        Oppo.AccountId=AccountTestFactory.getThreePLAccountRecord('TestAcc').id;
        Oppo.Name='Tast Ops';
        
        Oppo.NS_Origin_Station__c='Test';	
        Oppo.StageName = 'Qualification/Analysis';                
        Oppo.CloseDate = System.Today();
        Oppo.NS_Estimated_Volume__c=50;
        Oppo.NS_Destination_Station__c='Test123';
        Oppo.NSSales_Commodity_Group__c='Test123';
        Oppo.Projected_Start_Date__c=System.Today();
        Oppo.NS_Contract_Start_Date__c=System.Today();
        Oppo.NS_Destination_State__c='Test';
        Oppo.Frequency__c='Weekly';
        Oppo.NSSales_Spot_Contract__c='Spot';
        Oppo.NSSales_Need_by_Date__c=System.Today();
        Oppo.NS_Origin_City__c='Kolkata';
        Oppo.NSSales_Route__c='Test';
        Oppo.NS_Destination_City__c='Kolkata';
        Oppo.NS_Originating_Department__c='Coal';
        Oppo.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('General Opportunity').getRecordTypeId();
        
        
        insert Oppo;
        
        Account Acc2X =AccountTestFactory.getThreePLAccountRecord('TestAcc2X');
        
        
        NS_Partner__c Ptnr2 = new NS_Partner__c();
        Ptnr2.NS_Related_Opportunity__c= Oppo.Id;
        Ptnr2.NS_Partner_Account_Type__c ='Beneficial Owner';
        Ptnr2.NS_Partner_Account__c =Acc2X.Id;
        insert Ptnr2; 
    }
    
    
    
    private static testmethod void testUpdate(){
        opportunity newOps =[Select id from Opportunity limit 01];
        test.startTest();
        Account Acc2X =[select id from account limit 01];
        id AccID2X = Acc2X.id;
        
        NS_Partner__c Ptnr1 = new NS_Partner__c();
        Ptnr1.NS_Related_Opportunity__c= newOps.Id;
        Ptnr1.NS_Partner_Account_Type__c ='*3PL';
        Ptnr1.NS_Partner_Account__c =AccID2X;
        insert Ptnr1;     
        
        NS_Partner__c Ptnr2 = new NS_Partner__c();
        Ptnr2.NS_Related_Opportunity__c= newOps.Id;
        Ptnr2.NS_Partner_Account_Type__c ='Beneficial Owner';
        Ptnr2.NS_Partner_Account__c =AccID2X;
        insert Ptnr2; 
        
        
        NS_Partner__c Ptnr3 = new NS_Partner__c();
        Ptnr3.NS_Related_Opportunity__c= newOps.Id;
        Ptnr3.NS_Partner_Account_Type__c ='Drayage';
        Ptnr3.NS_Partner_Account__c =AccID2X;
        insert Ptnr3;  
        
        NS_Partner__c Ptnr4 = new NS_Partner__c();
        Ptnr4.NS_Related_Opportunity__c= newOps.Id;
        Ptnr4.NS_Partner_Account_Type__c ='ID Allies';
        Ptnr4.NS_Partner_Account__c =AccID2X;
        insert Ptnr4; 
        
        
        NS_Partner__c Ptnr5 = new NS_Partner__c();
        Ptnr5.NS_Related_Opportunity__c= newOps.Id;
        Ptnr5.NS_Partner_Account_Type__c ='Other';
        Ptnr5.NS_Partner_Account__c =AccID2X;
        insert Ptnr5;
        
        NS_Partner__c Ptnr6 = new NS_Partner__c();
        Ptnr6.NS_Related_Opportunity__c= newOps.Id;
        Ptnr6.NS_Partner_Account_Type__c ='	Payer';
        Ptnr6.NS_Partner_Account__c =AccID2X;
        insert Ptnr6;
        
        NS_Partner__c Ptnr7 = new NS_Partner__c();
        Ptnr7.NS_Related_Opportunity__c= newOps.Id;
        Ptnr7.NS_Partner_Account_Type__c ='Port';
        Ptnr7.NS_Partner_Account__c =AccID2X;
        insert Ptnr7;
        
        NS_Partner__c Ptnr8 = new NS_Partner__c();
        Ptnr8.NS_Related_Opportunity__c= newOps.Id;
        Ptnr8.NS_Partner_Account_Type__c ='Receiver';
        Ptnr8.NS_Partner_Account__c =AccID2X;
        insert Ptnr8;
        
        
        
        
        delete Ptnr4;
        delete Ptnr3;
        delete Ptnr2;
        delete Ptnr1;
        delete Ptnr5;

        test.stopTest();
        
    }
    
    private static testmethod void testUpdate02(){
        
        opportunity newOps =[Select id from Opportunity limit 01];
        test.startTest();
        Account Acc2X =[select id from account limit 01];
        id AccID2X = Acc2X.id;
        
        NS_Partner__c Ptnr1 = new NS_Partner__c();
        Ptnr1.NS_Related_Opportunity__c= newOps.Id;
        Ptnr1.NS_Partner_Account_Type__c ='*3PL';
        Ptnr1.NS_Partner_Account__c =AccID2X;
        insert Ptnr1;     
        
        NS_Partner__c Ptnr2 = new NS_Partner__c();
        Ptnr2.NS_Related_Opportunity__c= newOps.Id;
        Ptnr2.NS_Partner_Account_Type__c ='Beneficial Owner';
        Ptnr2.NS_Partner_Account__c =AccID2X;
        insert Ptnr2; 
        
        
        NS_Partner__c Ptnr3 = new NS_Partner__c();
        Ptnr3.NS_Related_Opportunity__c= newOps.Id;
        Ptnr3.NS_Partner_Account_Type__c ='Drayage';
        Ptnr3.NS_Partner_Account__c =AccID2X;
        insert Ptnr3;  
        
        NS_Partner__c Ptnr4 = new NS_Partner__c();
        Ptnr4.NS_Related_Opportunity__c= newOps.Id;
        Ptnr4.NS_Partner_Account_Type__c ='ID Allies';
        Ptnr4.NS_Partner_Account__c =AccID2X;
        insert Ptnr4; 
        
        Ptnr1.NS_Partner_Account_Type__c = 'RR';
        update Ptnr1;   
        
        Ptnr2.NS_Partner_Account_Type__c = 'Shipper';
        update Ptnr2;
        
        Ptnr3.NS_Partner_Account_Type__c = 'Shipper & Receiver';
        update Ptnr3;      
        
        Ptnr4.NS_Partner_Account_Type__c = 'TBT';
        update Ptnr4;
        
        
        
        test.stopTest();        
        
    }
    
}