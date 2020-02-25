public class NSSales_ID_Opportunity_StateSelection {
 @AuraEnabled
    public static Opportunity fetchStageName(Id optyRecordId){
        return [SELECT StageName FROM Opportunity where Id = :optyRecordId];
    }
    @AuraEnabled
    public static String[] fetchState(){
        //return [SELECT NSSales_State_Name__c FROM NSSales_609_1_Manager_Routing__c ORDER BY NSSales_State_Name__c];
        String stateList = label.NSSales_IDManagerRouting_State;
        List<String> stateAdd = stateList.split(',');
        //system.debug('stateAdd' +stateAdd);
        return stateAdd;        
    }
    @AuraEnabled
    public static NSSales_609_1_Manager_Routing__c[] fetchCounty(String state){
        return [SELECT NSSales_County_Name__c FROM NSSales_609_1_Manager_Routing__c where NSSales_State_Name__c = :state
                ORDER BY NSSales_County_Name__c];        
    }
      @AuraEnabled
    public static NSSales_609_1_Manager_Routing__c[] fetchCity(String county,String state){
        return [SELECT NSSales_City_Name__c FROM NSSales_609_1_Manager_Routing__c where NSSales_County_Name__c = :county 
                and NSSales_State_Name__c = :state
                ORDER BY NSSales_City_Name__c];    
    }
     @AuraEnabled
    public static void changeOptyStageOn_609_1_LocationSelect(String optyRecordId, String selectedState, String selectedCounty, String selectedCity, String operatingDivision, String prefix, String suffix, String milepost){
        
        Opportunity optyRec = [Select NSSales_609_1_Submitter__c,NSSales_609_1_SubmitterEmail__c, 
                               NSSales_609_1_IDManagerApprovalOwner__c,NSSales_609_1_IDManagerApprovalOwnerEmai__c,
                               NSSales_609_1_FSManagerApprovalOwner__c, NSSales_609_1_FSMngrApprvlOwnerEmail__c, StageName, NSSales_SendFor609_1_Approval__c,
                               NSSales_609_1_State__c, NSSales_609_1_County__c, NSSales_609_1_City__c
                               from Opportunity 
                               where id = :optyRecordId];
        
        String routingLocation = selectedState+':'+selectedCounty+':'+selectedCity;
        NSSales_609_1_Manager_Routing__c routingRec = [SELECT id,NSSales_ID_Manager_Name__c, NSSales_ID_Manager_Email_ID__c,
                                                       NSSales_State_Name__c, NSSales_County_Name__c, NSSales_City_Name__c
                                                       FROM NSSales_609_1_Manager_Routing__c
                                                       WHERE NSSales_LocationIdentifier__c = :routingLocation LIMIT 1];
       
        optyRec.NSSales_609_1_State__c = selectedState;
        optyRec.NSSales_609_1_County__c = selectedCounty;
        optyRec.NSSales_609_1_City__c = selectedCity;
        optyRec.NSSales_609_1_OperatingDivision__c = operatingDivision;
        optyRec.NSSales_609_1_Prefix__c = prefix;
        optyRec.NSSales_609_1_Suffix__c = suffix;
        optyRec.NSSales_609_1_Milepost__c = decimal.valueOf(milepost);
        NSSales_609_1FSSalesManager__c fsRoutingRec = selectFieldSalesManager(operatingDivision, prefix, suffix, milepost);  
        optyRec.NSSales_SAM__c = fsRoutingRec.NSSales_609_1_Field_Sales_Manager__c;
       
        
        update optyRec;
        
    }
      @AuraEnabled
      public static String getMilepost(Id OpprecordId)
      {
          String val;
       for(Opportunity op: [Select NSSales_609_1_Milepost__c from Opportunity where id=:OpprecordId])
       {
           if(op.NSSales_609_1_Milepost__c != NULL)
           {
               val = String.valueOf(op.NSSales_609_1_Milepost__c);//.valueOf(op.NSSales_609_1_Milepost__c);
           }
           else
           {
               val = null;
           }
       }
           return val;
      }
     @AuraEnabled
    public static Boolean checkMilepostRange(String operatingDivision, String prefix, String suffix, String milepost){
        Boolean isValidMilepost = false;
        String uniqueKey =  operatingDivision +':'+ (prefix != '' ? prefix : 'NA') +':'+ (suffix != '' ? suffix : 'NA'); 
        system.debug('uniqueKey-->'+uniqueKey);
        List<NSSales_609_1FSSalesManager__c> fsRoutingRecList = [SELECT NSSales_609_1_LMP__c, NSSales_609_1_HMP__c 
                                                                 From NSSales_609_1FSSalesManager__c
                                                                 WHERE NSSales_609_1_UniqueIdentifier__c = : uniqueKey];
        system.debug('fsRoutingRecList-->'+fsRoutingRecList);
        if(fsRoutingRecList.size()>0){
            for(NSSales_609_1FSSalesManager__c fsRoutingRec : fsRoutingRecList){
                if((decimal.valueOf(milepost) >= fsRoutingRec.NSSales_609_1_LMP__c 
                     && decimal.valueOf(milepost) <= fsRoutingRec.NSSales_609_1_HMP__c)){
                         isValidMilepost = true;
                     }
            }
        }
        system.debug('isValidMilepost-->'+isValidMilepost);
       return isValidMilepost;
    }      
    @AuraEnabled
    public static opportunity getValues(id oppoId){
           Opportunity optyRecall = [Select NSSales_609_1_Suffix__c,NSSales_609_1_Prefix__c,NSSales_609_1_OperatingDivision__c, 
                               NSSales_609_1_IDManagerApprovalOwner__c,NSSales_609_1_IDManagerApprovalOwnerEmai__c,
                               NSSales_609_1_FSManagerApprovalOwner__c, NSSales_609_1_FSMngrApprvlOwnerEmail__c, StageName, NSSales_SendFor609_1_Approval__c,
                               NSSales_609_1_State__c, NSSales_609_1_County__c, NSSales_609_1_City__c,NSSales_609_1_Milepost__c
                               from Opportunity 
                               where id = :oppoId];
        return optyRecall;
    }
    


 @AuraEnabled
    public static NSSales_609_1FSSalesManager__c selectFieldSalesManager(String operatingDivision, String prefix, String suffix, String milepost){
        
        /* Opportunity optyRec = [Select NSSales_609_1_OperatingDivision__c, NSSales_609_1_Prefix__c, NSSales_609_1_Suffix__c,
NSSales_609_1_Milepost__c,  NSSales_609_1_FSManagerApprovalOwner__c, NSSales_609_1_FSMngrApprvlOwnerEmail__c                             
from Opportunity 
where id = :optyRecordId];*/
        NSSales_609_1FSSalesManager__c fsRoutingRec = new NSSales_609_1FSSalesManager__c();
        
        if(prefix!= null){
            fsRoutingRec = [Select  NSSales_609_1_Field_Sales_Manager__c, NSSales_609_1_FSM_Email__c                              
                            from NSSales_609_1FSSalesManager__c 
                            where NSSales_609_1_OperatingDivision__c = :operatingDivision
                            and NSSales_609_1_Sales_Prefix__c = :prefix 
                            and NSSales_609_1_LMP__c <= : decimal.valueOf(milepost)
                            and NSSales_609_1_HMP__c >= : decimal.valueOf(milepost) limit 1
                           ];               
        }
        else if(suffix!= null){
            fsRoutingRec = [Select  NSSales_609_1_Field_Sales_Manager__c, NSSales_609_1_FSM_Email__c                              
                            from NSSales_609_1FSSalesManager__c 
                            where NSSales_609_1_OperatingDivision__c = :operatingDivision
                            and NSSales_609_1_Suffix__c = :suffix
                            and NSSales_609_1_LMP__c <= : decimal.valueOf(milepost)
                            and NSSales_609_1_HMP__c >= : decimal.valueOf(milepost) limit 1];
            
        }
        return fsRoutingRec;
    }
}