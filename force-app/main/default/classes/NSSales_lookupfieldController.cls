public with Sharing class NSSales_lookupfieldController {    
    @AuraEnabled
    public static List<sObject> GetRecentRecords(String ObjectName, List<String> ReturnFields, Integer MaxResults) {
        
        List<Id> recentIds = new List<Id>();
        for(RecentlyViewed recent : [SELECT Id FROM RecentlyViewed WHERE Type = :ObjectName ORDER BY LastViewedDate DESC LIMIT :MaxResults]) {
            recentIds.add(recent.Id);
        }
        
        String sQUERY = 'SELECT Id, ';
        
        if (ReturnFields != null && ReturnFields.Size() > 0) {
            sQuery += String.join(ReturnFields, ',');
        } else {
            sQuery += 'Name';   
        }
        
        sQuery += ' FROM ' + ObjectName + ' WHERE Id IN :recentIds';
        
        system.debug('SOQL from GetRecentRecords --> ' +sQuery);
        List<sObject> searchResult = Database.query(sQuery);
        
        return searchResult;
    }
    
    @AuraEnabled
    public static List<sObject> SearchRecords(String Accid, String ObjectName, List<String> ReturnFields, List<String> QueryFields, String SearchText, String SortColumn, String SortOrder, Integer MaxResults) {
        
        if (AccId == null || AccId == '')
        {
            AccId = 'DUMMYVALUE';
        }
        
        //always put a limit on the results
        if (MaxResults == null || MaxResults == 0) {
            MaxResults = 1000;
        }
        
        SearchText = '%' + SearchText + '%';
        
        List <sObject > returnList = new List < sObject > ();
        
        String sQuery =  'SELECT Id, ';
        
        if (ReturnFields != null && ReturnFields.Size() > 0) {
            sQuery += String.join(ReturnFields, ',');
        } else {
            sQuery += 'Name';   
        }
        
        sQuery += ' FROM ' + ObjectName + ' WHERE ';
        
        if (QueryFields == null || QueryFields.isEmpty()) {
            sQuery += ' Name LIKE :SearchText ';
        } else {
            string likeField = '';
            Integer i = 1;
            for(string field : QueryFields) {
                if(i == 1)
                {
                    likeField += ' OR ' + '(' + field + ' LIKE :SearchText ';   
                }
                else
                {
                    likeField += ' OR ' + field + ' LIKE :SearchText ';    
                }
                i = i + 1;
            }
            sQuery += likeField.removeStart(' OR ');
        }
        
        if(string.isNotBlank(SortColumn) && string.isNotBlank(SortOrder)) {
            sQuery += ') AND Account__c = :Accid ORDER BY ' + SortColumn + ' ' + SortOrder;
        }
        
        sQuery += ' LIMIT ' + MaxResults;
        
        //System.debug('Accid --> '+Accid);
        system.debug('SOQL from SearchRecords --> ' +sQuery);
        
        List <sObject> searchResult = Database.query(sQuery);
        
        return searchResult;
    }
    
    @AuraEnabled
    public static List<sObject> GetRecord(String ObjectName, List<String> ReturnFields, String AccId, String Id) {
        
        if (AccId == null || AccId == '')
        {
            AccId = 'DUMMYVALUE';
        }
        
        String sQUERY = 'SELECT Id, ';
        
        if (ReturnFields != null && ReturnFields.Size() > 0) {
            sQuery += String.join(ReturnFields, ',');
        } else {
            sQuery += 'Name';   
        }
        
        //sQuery += ' FROM ' + ObjectName + ' WHERE Id = :Id';
        sQuery += ' FROM ' + ObjectName + ' WHERE Account__c = :AccId';
        
        system.debug('SOQL from GetRecord --> ' +sQuery);
        List<sObject> searchResult = Database.query(sQuery);
        
        return searchResult;
    }
    
    @AuraEnabled
    public static string findObjectIcon(String ObjectName) {    
        String u;
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();
        
        for(Schema.DescribeTabSetResult describeTabSetResult : Schema.describeTabs()) {
            for(Schema.DescribeTabResult describeTabResult : describeTabSetResult.getTabs()) {
                if(describeTabResult.getSobjectName() == ObjectName) { 
                    if( describeTabResult.isCustom() == true ) {
                        for (Schema.DescribeIconResult describeIcon : describeTabResult.getIcons()) {
                            if (describeIcon.getContentType() == 'image/svg+xml'){
                                return 'custom:' + describeIcon.getUrl().substringBetween('custom/','.svg').substringBefore('_');
                            }
                        }
                    } else {
                        return 'standard:' + ObjectName.toLowerCase();
                    }
                }
            }
        }
        
        return 'standard:default';
    }
    
    @AuraEnabled
    public static objectDetails getObjectDetails(String ObjectName) {    
        
        objectDetails details = new objectDetails();
        
        Schema.DescribeSObjectResult describeSobjectsResult = Schema.describeSObjects(new List<String>{ObjectName})[0];
        
        details.label = describeSobjectsResult.getLabel();
        details.pluralLabel = describeSobjectsResult.getLabelPlural();
        
        details.iconName = findObjectIcon(ObjectName);
        
        return details;
    }
    
    public class objectDetails {
        @AuraEnabled
        public string iconName;
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string pluralLabel;
    }
}