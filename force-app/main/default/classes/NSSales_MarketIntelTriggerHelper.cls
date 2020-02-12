/**@author  Accenture
* @Created Date Oct,2019
* @version  1.0
* @description This class conatins methods which are invoked by NSSales_MarketIntelTrigger
*/ 

public class NSSales_MarketIntelTriggerHelper {
    
    private static final String CLASS_NAME = 'NSSales_MarketIntelTriggerHelper';
    private static final String METHOD_NAME1 = 'createNewMIAssocAccRec_DelPrevMIAccAssocRec';
   
    public static void createNewMIAssocAccRec_DelPrevMIAccAssocRec(Map<Id,Market_Intelligence__c> newMIMap, Map<Id,Market_Intelligence__c> oldMIMap){
        Set<Id> accIdSet = new Set<Id>();
        List<NS_Market_Intel_Account__c>  newMIAssocAccList= new List<NS_Market_Intel_Account__c>();
        List<NS_Market_Intel_Account__c>  miAssocAccListToBeDeleted= new List<NS_Market_Intel_Account__c>();
        
        for(Market_Intelligence__c miRec : oldMIMap.values()){
            if(miRec.Account__c != null){
                accIdSet.add(miRec.Account__c);
            }
        }
        Map<String,NS_Market_Intel_Account__c> accMIDetaisMap = new Map<String,NS_Market_Intel_Account__c>();
        for(NS_Market_Intel_Account__c miAssocAccRec : [SELECT name,NSSales_Account__c,NSSales_Market_Intel__c from NS_Market_Intel_Account__c where NSSales_Account__c IN :accIdSet]){
            accMIDetaisMap.put(miAssocAccRec.NSSales_Account__c+'-'+miAssocAccRec.NSSales_Market_Intel__c, miAssocAccRec);
        }
        
        for(Market_Intelligence__c changedMIRec : newMIMap.values()){
            if(oldMIMap.get(changedMIRec.id).Account__c != changedMIRec.Account__c && changedMIRec.Account__c != null){
                
                NS_Market_Intel_Account__c newMIAssocAccRec = new NS_Market_Intel_Account__c();
                newMIAssocAccRec.NSSales_Account__c = changedMIRec.Account__c;
                newMIAssocAccRec.NSSales_Market_Intel__c = changedMIRec.id;
                newMIAssocAccList.add(newMIAssocAccRec);
                
                if(oldMIMap.get(changedMIRec.id).Account__c!= null)
                {
                    NS_Market_Intel_Account__c assocMIAccRec = accMIDetaisMap.get(oldMIMap.get(changedMIRec.id).Account__c +'-'+changedMIRec.id);
                    miAssocAccListToBeDeleted.add(assocMIAccRec);
                }
            }
        }

        try{
            if(!newMIAssocAccList.isEmpty()){
                Database.insert(newMIAssocAccList,false);
            }
            
            if(!miAssocAccListToBeDeleted.isEmpty()){
                Database.Delete(miAssocAccListToBeDeleted,false);
            }
            
        }
        catch(Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME1);
        } 
        
    }
}