/**@author  Accenture
* @Created Date Oct,2019
* @version  1.0 
* @description This class contains Server side controller for Marketing Intel functionalities 
*/ 
public class NSSales_MarketIntelController {
    private static final String CLASS_NAME = 'NSSales_MarketIntelController';
    private static final String METHOD_NAME1 = 'createMarketIntelAssociatedObjectRec';
    private static final String METHOD_NAME2 = 'findObjectNameFromRecordId';
    private static final String METHOD_NAME3 = 'createMarketIntelAssociatedAccountRec';
    private static final String METHOD_NAME4 = 'createMarketIntelAssociatedContactRec';
    private static final String METHOD_NAME5 = 'createMarketIntelAssociatedOptyRec';
    private static final String METHOD_NAME6 = 'createMarketIntelAssociatedCampRec';
    
    @AuraEnabled
    public static void createMarketIntelAssociatedObjectRec(String sourceId,String marketIntelRecordId){
        try{
            String objectName = findObjectNameFromRecordId(sourceId);
            if(objectName.equalsIgnoreCase('Account'))
            {
                createMarketIntelAssociatedAccountRec(sourceId,marketIntelRecordId);
            }
            if(objectName.equalsIgnoreCase('Contact'))
            {
                createMarketIntelAssociatedContactRec(sourceId,marketIntelRecordId);
            }
            if(objectName.equalsIgnoreCase('Opportunity'))
            {
                createMarketIntelAssociatedOptyRec(sourceId,marketIntelRecordId);
            }
            if(objectName.equalsIgnoreCase('Campaign'))
            {
                createMarketIntelAssociatedCampRec(sourceId,marketIntelRecordId);
            }
        }
        catch(Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME1);
        } 
    }
    
    @AuraEnabled
    public static String findObjectNameFromRecordId(String recordId){
        String objName = '';
        try{
            String keyCode = recordId.subString(0,3);
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            for(Schema.SObjectType objectInstance : gd.values())
            {
                if(objectInstance.getDescribe().getKeyPrefix() == keyCode)
                {
                    objName = objectInstance.getDescribe().getName();
                }
            }
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            system.debug('exp-->'+exp);
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME2);
        } 
        return objName;
    }
    
    @AuraEnabled
    public static void createMarketIntelAssociatedAccountRec(String sourceId,String marketIntelRecordId){
        
        NS_Market_Intel_Account__c newRec = new NS_Market_Intel_Account__c();
        newRec.NSSales_Account__c = sourceId;
        newRec.NSSales_Market_Intel__c = marketIntelRecordId;
        try{
            Database.insert(newRec,false);
        }
        catch(Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME3);
        } 
        
    }
    
    public static void createMarketIntelAssociatedContactRec(String sourceId,String marketIntelRecordId){
        
        Market_Intel_Associated_Contact__c newRec = new Market_Intel_Associated_Contact__c();
        newRec.Contact__c = sourceId;
        newRec.Market_Intel__c = marketIntelRecordId;
        try{
            Database.insert(newRec,false);
        }
        catch(Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME3);
        } 
        
    }
    public static void createMarketIntelAssociatedOptyRec(String sourceId,String marketIntelRecordId){
        
        Market_Intel_Associated_Opportunities__c newRec = new Market_Intel_Associated_Opportunities__c();
        newRec.Opportunity__c = sourceId;
        newRec.Market_Intel__c = marketIntelRecordId;
        try{
            Database.insert(newRec,false);
        }
        catch(Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME5);
        } 
        
    }
    
     public static void createMarketIntelAssociatedCampRec(String sourceId,String marketIntelRecordId){
        
        Market_Intel_Associated_Campaign__c newRec = new Market_Intel_Associated_Campaign__c();
        newRec.Campaign__c = sourceId;
        newRec.Market_Intel__c = marketIntelRecordId;
        try{
            Database.insert(newRec,false);
        }
        catch(Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME6);
        } 
        
    }
}