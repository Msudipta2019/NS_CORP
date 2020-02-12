global class NS_DaylightSave implements Database.Batchable<sObject> { 
    private static final String CLASS_NAME = 'UserTriggerHelper';
    private static final String METHOD_NAME1 = 'updateTimeDeltaOnCreate';
    private static final String METHOD_NAME2 = 'updateTimeDeltaOnUpdate'; 
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, TimeZoneSidKey,FirstName,profile.name FROM User limit 1300'; 
        
        System.debug('Query1' +query);
        System.debug('Database.getQueryLocator(query)' +Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext BC, List<User> scope) {
        System.debug('Scope User :' +scope);
        List<User> newUserList = new List<User>();
        for(User newUser : scope){
            if(newUser.TimeZoneSidKey.contains('America') && newUser.profile.name != null){
                
                
                TimeZone tz = Timezone.getTimeZone(newUser.TimeZoneSidKey);
                DateTime dt = Datetime.now();
                Long dt1Long = dt.getTime();
                Long dt2Long = dt.addSeconds((tz.getOffset(dt)/1000)).getTime();
                Long milliseconds = dt1Long-dt2Long;
                Decimal seconds = milliseconds / 1000;
                Decimal minutes = seconds / 60;
                Decimal hours = minutes / 60;
                newUser.NSSales_TimeDelta__c = hours;
                newUserList.add(newUser);
                
            }
        }
        update  newUserList;  
        System.debug(newUserList);
        
        /*  try{
if(!newUserList.isEmpty()){
Database.update(newUserList,false);
}
}
catch(Exception exp) 
{

NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME1); 


}*/
        
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
}