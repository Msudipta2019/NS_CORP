/**@author  Accenture
* @Created Date Jan,2020
* @version  1.0
* @description This class conatins methods which are invoked by NSSales_609_1_Manager_Routing_Trigger
*/ 

public class NSSales_609_1_MgrRoutingTriggerHelper {
    
    private static final String CLASS_NAME = 'NSSales_609_1_MgrRoutingTriggerHelper';
    private static final String METHOD_NAME1 = 'insertStates';
    private static final String METHOD_NAME2 = 'deleteStates';
    private static final String METHOD_NAME3 = 'editStates';
    
    public static void insertStates(List<NSSales_609_1_Manager_Routing__c> managerRoutingList){
        
        try{
            Set<String> stateNames = new Set<String>();
            for(NSSales_State__c stateRec : [Select name from NSSales_State__c limit 500]){
                stateNames.add(stateRec.name);
            }
            
            List<NSSales_State__c> listToInsert = new List<NSSales_State__c>();
            
            for(NSSales_609_1_Manager_Routing__c newRec : managerRoutingList){
                if(!stateNames.contains(newRec.NSSales_State_Name__c)){
                    NSSales_State__c newStateRec = new NSSales_State__c();
                    newStateRec.name = newRec.NSSales_State_Name__c;
                    listToInsert.add(newStateRec);
                }
            }
            if(!listToInsert.isEmpty()){
                Database.insert(listToInsert, false);
            }
        }
        catch(Exception exp){
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME1);
        }
        
    }
    
    public static void deleteStates(List<NSSales_609_1_Manager_Routing__c> routingListToBeDeleted){
        try{
            Set<String> statesInDeletedList = new Set<String>();
            //  Set<String> locIndentifierInToBeDelList = new Set<String>();
            Map<String,NSSales_State__c> statesFromCustSettings = new Map<String,NSSales_State__c>();
            List<NSSales_State__c> stateListToBeDel = new List<NSSales_State__c>();
            for(NSSales_State__c stateRec : [Select name from NSSales_State__c limit 500]){
                statesFromCustSettings.put(stateRec.name,stateRec);
            }
            for(NSSales_609_1_Manager_Routing__c routingRec : routingListToBeDeleted){
                if(routingRec.NSSales_State_Name__c != null){
                    statesInDeletedList.add(routingRec.NSSales_State_Name__c);
                    //  locIndentifierInToBeDelList.add(routingRec.NSSales_LocationIdentifier__c);
                }
            }
            system.debug('statesInDeletedList-->'+statesInDeletedList);
            List<NSSales_609_1_Manager_Routing__c> mngrRoutingList = [SELECT id, NSSales_State_Name__c
                                                                      //, NSSales_LocationIdentifier__c
                                                                      FROM NSSales_609_1_Manager_Routing__c
                                                                      WHERE NSSales_State_Name__c IN : statesInDeletedList
                                                                      //  AND NSSales_LocationIdentifier__c NOT IN : locIndentifierInToBeDelList
                                                                     ];
            system.debug('mngrRoutingList-->'+mngrRoutingList);
            if(mngrRoutingList.size()==0){
                for(NSSales_609_1_Manager_Routing__c routingRecToDel : routingListToBeDeleted){
                    if(statesFromCustSettings.containsKey(routingRecToDel.NSSales_State_Name__c)){
                        stateListToBeDel.add(statesFromCustSettings.get(routingRecToDel.NSSales_State_Name__c));
                    }
                }
            }
            system.debug('stateListToBeDel-->'+stateListToBeDel);
            if(!stateListToBeDel.isEmpty()){
                Database.delete(stateListToBeDel, false);
            }
        }
        catch(Exception exp){
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME2);
        }
    }
    
   /* public static void editStates(Map<id,NSSales_609_1_Manager_Routing__c> oldRoutingMap,Map<id,NSSales_609_1_Manager_Routing__c> newRoutingMap){
        try{
            Set<String> oldStateValues = new Set<String>();
            Set<String> newStateValues = new Set<String>();
            Set<String> locIndentifierInNewStateVal = new Set<String>();
            List<NSSales_State__c> stateListToBeAdded = new List<NSSales_State__c>();
            List<NSSales_State__c> stateListToBeDeleted = new List<NSSales_State__c>();
            
            Map<String,NSSales_State__c> statesFromCustSettings = new Map<String,NSSales_State__c>();
            for(NSSales_State__c stateRec : [Select name from NSSales_State__c limit 500]){
                statesFromCustSettings.put(stateRec.name,stateRec);
            }
            for(NSSales_609_1_Manager_Routing__c routingRec : oldRoutingMap.values()){
                if(routingRec.NSSales_State_Name__c != null){
                    oldStateValues.add(routingRec.NSSales_State_Name__c);
                }
            }
            system.debug('oldStateValues-->'+oldStateValues);
            for(NSSales_609_1_Manager_Routing__c routingRec : newRoutingMap.values()){
                if(routingRec.NSSales_State_Name__c != null){
                    newStateValues.add(routingRec.NSSales_State_Name__c);
                    if(routingRec.NSSales_LocationIdentifier__c != null){
                        locIndentifierInNewStateVal.add(routingRec.NSSales_LocationIdentifier__c);
                    }
                }
            }
            system.debug('newStateValues-->'+newStateValues);
            List<NSSales_609_1_Manager_Routing__c> mngrRoutingListWithOldState = [SELECT id, NSSales_State_Name__c
                                                                                  FROM NSSales_609_1_Manager_Routing__c
                                                                                  WHERE NSSales_State_Name__c IN : oldStateValues];
            
            system.debug('mngrRoutingListWithOldState-->'+mngrRoutingListWithOldState);
            List<NSSales_609_1_Manager_Routing__c> mngrRoutingListWithNewState = [SELECT id, NSSales_State_Name__c
                                                                                  FROM NSSales_609_1_Manager_Routing__c
                                                                                  WHERE NSSales_State_Name__c IN : newStateValues
                                                                                  AND NSSales_LocationIdentifier__c NOT IN : locIndentifierInNewStateVal
                                                                                 ];
            system.debug('mngrRoutingListWithNewState-->'+mngrRoutingListWithNewState);
            
            if(mngrRoutingListWithOldState.size()==0){
                for(NSSales_609_1_Manager_Routing__c routingRec : newRoutingMap.Values()){
                    if(oldRoutingMap.get(routingRec.id).NSSales_State_Name__c != routingRec.NSSales_State_Name__c
                       && oldRoutingMap.get(routingRec.id).NSSales_State_Name__c != null){
                           if(statesFromCustSettings.containsKey(oldRoutingMap.get(routingRec.id).NSSales_State_Name__c)){
                               stateListToBeDeleted.add(statesFromCustSettings.get(oldRoutingMap.get(routingRec.id).NSSales_State_Name__c));
                           }
                       }
                }
            }
            if(mngrRoutingListWithNewState.size()==0){
                for(NSSales_609_1_Manager_Routing__c routingRec : newRoutingMap.Values()){
                    if(oldRoutingMap.get(routingRec.id).NSSales_State_Name__c != routingRec.NSSales_State_Name__c
                       && routingRec.NSSales_State_Name__c != null){
                           if(!statesFromCustSettings.containsKey(routingRec.NSSales_State_Name__c)){
                               NSSales_State__c newStateRec = new NSSales_State__c();
                               newStateRec.name = routingRec.NSSales_State_Name__c;
                               stateListToBeAdded.add(newStateRec);
                           }
                       }
                }
            }
            system.debug('stateListToBeDeleted-->'+stateListToBeDeleted);
            system.debug('stateListToBeAdded-->'+stateListToBeAdded);
            if(!stateListToBeDeleted.isEmpty()){
                Database.delete(stateListToBeDeleted, false);
            }
            if(!stateListToBeAdded.isEmpty()){
                Database.insert(stateListToBeAdded, false);
            }
        }
        catch(Exception exp){
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME3);
        }
    }*/
}