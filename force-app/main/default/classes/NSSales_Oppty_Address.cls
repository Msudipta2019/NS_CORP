public class NSSales_Oppty_Address {
    @AuraEnabled
    public static Opportunity getaddress(Id optyRecordId)
    {
        system.debug('TEST555'+optyRecordId);
        return ([select NSSales_609_1_OperatingDivision__c,NSSales_609_1_Prefix__c,NSSales_State__c,NSSales_Street__c,NSSales_City__c,NSSales_609_1_Milepost__c from Opportunity where id=:optyRecordId limit 1]); 
    }
    @AuraEnabled
    public static void optymapaddress(string optyRecordId,string  streetDetails,string  cityDetails,string  stateDetails)
    {
        
        Opportunity optyRec=[select NSSales_State__c,NSSales_Street__c,NSSales_City__c from Opportunity where id=:optyRecordId]; 
        
        optyRec.NSSales_State__c = stateDetails;
        optyRec.NSSales_Street__c = streetDetails;
        optyRec.NSSales_City__c = cityDetails;        
            
        update optyRec;
    }
    
    
}