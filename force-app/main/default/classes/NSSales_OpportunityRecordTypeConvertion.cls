public class NSSales_OpportunityRecordTypeConvertion {
   
    @AuraEnabled
    public static void opportunityConvert(Id oppId)
    {
        Opportunity opp = [Select Id,RecordTypeId, StageName from Opportunity where Id=:oppId];
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('General Opportunity').getRecordTypeId();
        opp.StageName = 'Qualification/Analysis';
        opp.NSSales_Converted_RecordType__c = true;
        update opp;
    }
    
    @AuraEnabled
    public static Opportunity showIDOptyInfo(Id oppId){
        
        return ([Select Id,
                 NSSales_Owner_Name__c,
                 NSSales_Annual_System_Revenue__c,
                 Date_of_State_Lead__c,
                 NSSales_Date_Reported__c,
                 NS_Facility_Type__c,
                 NSSales_High_Priority__c,
                 NSSales_Incentive_Capital__c,
                 Incentive_Per_Car__c,
                 NS_Industry_Investment__c,
                 Initial_Contact_Date__c,
                 NSSales_Marketing_Involved__c,
                 Maximum_Building_Size_sq_ft__c,
                 Maximum_Daily_Truck_Volume__c,
                 Maximum_Investment__c,
                 Maximum_Jobs__c,
                 Maximum_Power_Requirements_MW__c,
                 Maximum_Site_Size_Acres__c,
                 Maximum_Weekly_Rail_Volume__c,
                 Building_Clear_Height_ft__c,
                 Minimum_Building_Size_Sq_Ft__c,
                 Minimum_Daily_Truck_Volume__c,
                 Minimum_Investment__c,
                 Minimum_Jobs__c,
                 Minimum_Power_Requirement_MW__c,
                 Minimum_Site_Size_Acres__c,
                 Minimum_Weekly_Rail_Volume__c,
                 NSSales_New_Employees__c,
                 NSSales_New_Exp__c,
                 NS_Private__c,
                 Project_Name__c,
                 NSSales_SAM_User_Name__c,
                 Site_Selection_Company__c,
                 NSSales_System_Cars__c,
                 NSSales_Traffic_Beginning__c,
                 Type_of_Project__c FROM Opportunity Where Id=:oppId]);
    }
}