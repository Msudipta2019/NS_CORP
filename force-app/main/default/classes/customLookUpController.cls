public class customLookUpController {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        string profileck = '';
        set <string> profilenames = new set<string>();
        String sQuery =  '';
        List < sObject > returnList = new List < sObject > ();
        if (ObjectName == 'User') {
            // profileNames.add('NS Sales Manager');  this is for Manual Customer
            profileNames.add('NS Industrial Development Manager');
            sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey and profile.name in :profileNames order by createdDate DESC limit 10';
        } else {
        	// Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        	sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 10';
        }            
        List < sObject > lstOfRecords = Database.query(sQuery);
        system.debug('fetchLookUpValues ' + lstOfRecords.size());
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}