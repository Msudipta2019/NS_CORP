public class NS_AccountClassificationTriggerHelper {
    
    public static void insertRecordTypeField(List<BU__C> listBu){
        for(Bu__C bu: listBu){
            bu.Record_Type_Duplication_Check__c=bu.RecordTypeId;
        }
    }
    
    
    public static void vrForDuplicatePACRecordv2(List<BU__C> buList)
    {
        List<String> allAccClass=new List<String>();
        for(BU__C b1 : [select id,Account__c,NS_Account_Type_BU__c,NS_Major_Group_BU__c,NS_Minor_Group_BU__c,NS_Record_Type_Name__c,NS_Business_Group_BU__c,NS_Line_of_Business_BU__c from BU__C])
        {
            String b1Str=b1.Account__c+':'+b1.NS_Account_Type_BU__c+':'+b1.NS_Major_Group_BU__c+':'+b1.NS_Minor_Group_BU__c+':'+b1.NS_Business_Group_BU__c+':'+b1.NS_Line_of_Business_BU__c;
            allAccClass.add(b1Str);
        }
        
        for(BU__C b2 : buList)
        {
            String b2Str = b2.Account__c+':'+b2.NS_Account_Type_BU__c+':'+b2.NS_Major_Group_BU__c+':'+b2.NS_Minor_Group_BU__c+':'+b2.NS_Business_Group_BU__c+':'+b2.NS_Line_of_Business_BU__c;
            if(b2.Account__c != null)
            {
                if(allAccClass.contains(b2Str))
                {
                    b2.addError('This is a duplicate Account Classification. Please use an existing Account Classification.');
                }
            }
        }
        system.debug(allAccClass);
    }
}