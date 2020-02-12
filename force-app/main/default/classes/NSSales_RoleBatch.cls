global class NSSales_RoleBatch implements Database.Batchable<sObject>,Database.Stateful {
    
    List<User> listAllUsers = new List<User>();
    List<User> newUserLists = new List<User>();
    Map<id,List<User>> mapRole = new Map<id,List<User>>();
    Map<String,Id> roleNameAndId = new  Map<String,Id>();
    list<String> csvListUser= new list<String>();
    
    Map<id,User> userMap;
    Exception[] errors = new Exception[0];
    integer saveRecordCountOnUpdate = 0;
    integer saveRecordCountOnFail = 0;
    integer batchCount = 0;
    List<User> updatedRolelevelUser = new List<User>();
    
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        System.debug('BB Check1');
        
        List<userrole> allUserRole = [Select id,Name from userrole];
        for(userrole ur : allUserRole){
            roleNameAndId.put(ur.Name,ur.Id);
        }
        
        userMap = new Map<id,User>([Select id, Username,Name,ProfileId,UserRoleId,userrole.Name,ManagerId,Manager.Name,Manager.NSSales_Role_Level__c,NSSales_Role_Level__c from User]);
        listAllUsers.addAll([Select id,Username, Name,ProfileId,UserRoleId,userrole.Name,ManagerId,Manager.Name,Manager.NSSales_Role_Level__c,NSSales_Role_Level__c from User]);
        system.debug('BB SS BTCH '+listAllUsers.size());
        for(User newUser : listAllUsers)
        {
            if(newUser.ManagerId != null){
                if((mapRole.keySet()).contains(newUser.ManagerId)){
                    
                    newUserLists=mapRole.get(newUser.ManagerId);
                    newUserLists.add(newUser);
                    mapRole.put(newUser.ManagerId,newUserLists);
                    
                }
                else
                {
                    List<User> newUserLists1 = new List<User>{newUser};
                        mapRole.put(newUser.ManagerId,newUserLists1);
                    
                    
                }
                
            }
        }
        
        //System.debug('BB SRV START BTCH' + mapRole.get('0051I000002X2dSQAS'));
        
        
        
        //return Database.getQueryLocator('Select Name,Username,ProfileId,Profile.Name,UserRoleId,userrole.Name,ManagerId,NSSales_Role_Level__c,NS_UserRoleOverride__c,Department_Description__c from User where IsActive = true and FirstName=\'Automated\' ');
        
        //return Database.getQueryLocator('Select Username,ProfileId,Profile.Name,UserRoleId,ManagerId,NSSales_Role_Level__c from User where IsActive = true and id in (\'0054F000002NFCLQA4\',\'0051I000002WtcKQAS\', \'0054F000002NEM5\', \'0054F000002NEN8\')' );
        // return Database.getQueryLocator('Select Username,ProfileId,Profile.Name,UserRoleId,ManagerId,NSSales_Role_Level__c,NS_UserRoleOverride__c from User where IsActive = true AND FirstName!=\'Automated\' AND LastName!=\'System\'  AND LastName!=\'Platform Integration User\'and managerid!=null');
        //return Database.getQueryLocator('Select Name,Username,ProfileId,Profile.Name,UserRoleId,userrole.Name,ManagerId,NSSales_Role_Level__c,NS_UserRoleOverride__c,Department_Description__c from User where IsActive = true AND FirstName!=\'Automated\' AND LastName!=\'System\'  AND LastName!=\'Platform Integration User\'and managerid!=null and Profile.Name in (\'NS Sales Manager\',\'NS Industrial Development Manager\',\'NS Sales Read Only\')  order by Username');
        String query = 'Select Name,Username,ProfileId,Profile.Name,UserRoleId,userrole.Name,ManagerId,NSSales_Role_Level__c,NS_UserRoleOverride__c,Department_Description__c from User where IsActive = true AND FirstName!=\'Automated\' AND LastName!=\'System\'  AND LastName!=\'Platform Integration User\'and managerid!=null and Profile.Name in (\'NS Sales Manager\',\'NS Industrial Development Manager\',\'NS Sales Read Only\')  order by Username'+(Test.isRunningTest()?' LIMIT 200':'');
        return Database.getQueryLocator(query);
        
        
    }
    global void execute(Database.BatchableContext bc, List<user> scope){
        try{
            system.debug('911 SOS '+scope);
            string currentRoleprefix;
            for(User singleUser:scope){
                Integer old = (Integer)singleUser.NSSales_Role_Level__c;
                //singleUser.NSSales_Role_Level__c = findtop(singleUser, userMap, 0);
                singleUser.NSSales_Role_Level__c = findtoprolelevel(singleUser, userMap, 0,roleNameAndId);
                system.debug('BB SRV SUN EXC Name '+singleUser.Username + 'Role Level : ' +singleUser.NSSales_Role_Level__c);
                if(singleUser.Profile.Name=='NS Sales Manager'){
                    currentRoleprefix='Sales ';
                }
                else if(singleUser.Profile.Name=='NS Industrial Development Manager'){
                    currentRoleprefix='ID ';
                }
                else if(singleUser.Profile.Name=='NS Sales Read Only'){
                    currentRoleprefix='Sales ReadOnly ';
                }
                singleUser.NSSales_RoleName__c = currentRoleprefix + singleUser.Department_Description__c + ' Level '+singleUser.NSSales_Role_Level__c;
                if(singleUser.NSSales_Role_Level__c == 0)
                {
                    singleUser.NSSales_RoleName__c = 'NS CEO';
                }
                if(singleUser.NSSales_Role_Level__c == 1)
                {
                    singleUser.NSSales_RoleName__c = currentRoleprefix+'Leadership';
                }
                
                updatedRolelevelUser.add(singleUser);
                saveRecordCountOnUpdate++;
                csvListUser.add(singleUser.id+','+singleuser.Name+','+singleuser.Username+','+old+','+singleuser.NSSales_Role_Level__c);
                
            }
            
            //update scope;
            Database.saveResult[] DMLResultOnUpdate = Database.update(updatedRolelevelUser, false);
            system.debug('DML Update Size' +DMLResultOnUpdate.size());
            
            for(Integer Looper=batchCount;Looper<DMLResultOnUpdate.size();Looper++){
                if(!DMLResultOnUpdate[Looper].isSuccess()){
                    system.debug(DMLResultOnUpdate[Looper].getErrors());
                    saveRecordCountOnFail++;    
                }
                batchCount++;
            } 
            system.debug('batch Count after for loop =' +batchCount);
            system.debug('911 SCP '+scope);
            
            
        } catch(exception E){
            errors.add(E);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('BB STATE'); 
        
        // Query the AsyncApexJob object to retrieve the current job's information.
        
        
        AsyncApexJob batchJobStatus = [
            SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, 
            CreatedBy.Email
            FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        string header = 'Id,Name,User Name,Old Level,New Level\n';
        string finalstr = header ;
        for(String a: csvListUser)
        {
            string recordString = a+'\n';
            finalstr = finalstr +recordString;
            
        }
        
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        string csvname= 'UserLevel_'+(system.now()).format('yyyyMMddhhmmss')+'.csv';      //UPDATE HERE
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        String emailList = label.RoleBatchEmails;
        List<String> emailAdd = emailList.split(',');
        String[] SendToAddresses = emailAdd;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {batchJobStatus.CreatedBy.Email};
            mail.setToAddresses(SendToAddresses);
        String OrgName = URL.getSalesforceBaseUrl().toExternalForm().substringBetween('--','.');
        
        id owa = [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName='No Reply' limit 01].id;
        
        mail.setOrgWideEmailAddressId(owa);
        
        if(OrgName!=null){
            mail.setSubject('['+OrgName+']***Role Level Batch Ran on ' +system.now()+ ' and status is ' + batchJobStatus.Status+ '***');
            
        }else{
            mail.setSubject('***Role Level Batch Ran on ' +system.now()+ ' and status is ' + batchJobStatus.Status+ '***');
            
        }
        string HTMLTextBody = '';
        HTMLTextBody = '<html> <body style="background-color: #d5f4e6;"> <font face = "Verdana" size = "2"> Hello, <br><br> Records processed in batches of overall ' 
            + batchJobStatus.TotalJobItems 
            +  ' jobs <br><br> Total Number of execution level errors in those batches are: ' 
            + batchJobStatus.NumberOfErrors
            + '<br><br> <p style="color:red;"> Errors that needs to be addressed at data level are  '
            + errors.size()
            + ' : ' 
            + errors +'</p> <br><br>'
            + 'Thanks,<br>'
            + 'Connect NS Salesforce Support Team!'
            + '</font></body></html>';
        
        mail.setHtmlBody(HTMLTextBody); 
        mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        ///////// calling Batch for Role creation
        if(!(errors.size()>0&&batchJobStatus.NumberOfErrors>0)){
            if(!Test.isRunningTest()){
                NSSales_RoleHierarchyCreation nRHC = new NSSales_RoleHierarchyCreation();
                database.executeBatch(nRHC);
            }
            
        }
        
        
        
    }
    
    
    Private static integer findtoprolelevel(user singleUser,Map<id,User> userMap,integer height,Map<String,Id> roleNameAndId){
        system.debug('SRV SUN Strt '+singleUser.Username +' @ '+height);
        integer MaxHeight;
        user innUser = singleUser;
        
        
        system.debug('SKS '+innUser.userroleid);
        system.debug('SKS '+roleNameAndId.get('NS CEO'));
        system.debug('SKS '+roleNameAndId.Size());
        
        Boolean topLevelRole = false;
        while ( !topLevelRole ) {
            
            if ( innUser.ManagerId!=null && innUser.userroleid!=roleNameAndId.get('NS CEO')) {
                height=height+1;
                innUser=userMap.get(innUser.ManagerId);
                system.debug('SRV SUN b4 '+height);
            }
            else if(innUser.ManagerId==null||innUser.userroleid==roleNameAndId.get('NS CEO')) {
                MaxHeight= height;
                topLevelRole = true;
                System.debug('SRV SUN MAN '+innUser.Username +' @ '+height);
            }
        }
        system.debug('SRV SUN User '+innUser.Username + 'Max Height@' +MaxHeight);
        return MaxHeight;  
        
    }
    
    
}