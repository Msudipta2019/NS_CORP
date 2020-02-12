global class NSSales_RoleHierarchyAssignment implements Database.Batchable<sObject>,Database.Stateful {
    
    Map<String,Id> roleNameAndId = new  Map<String,Id>();
    list<String> csvListUser= new list<String>();
    ////Excptn
    Exception[] errors = new Exception[0];
    integer saveRecordCountOnUpdate = 0;
    integer saveRecordCountOnFail = 0;
    integer batchCount = 0;
    List<User> updatedRolelevelUser = new List<User>();
    
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        List<userrole> allUserRole = [Select id,Name from userrole];
        for(userrole ur : allUserRole){
            roleNameAndId.put(ur.Name,ur.Id);
        }
        system.debug('Bas SRV RLHC BTCH '+roleNameAndId);
        //return Database.getQueryLocator('Select Name,Username,ProfileId,Profile.Name,UserRoleId,ManagerId,NSSales_Role_Level__c,NS_UserRoleOverride__c,Department_Description__c,NSSales_RoleName__c from User where IsActive = true and id = \'0051I000001y2lFQAQ\' ');
        return Database.getQueryLocator('Select Name,Username,ProfileId,Profile.Name,UserRoleId,UserRole.Name,ManagerId,NSSales_Role_Level__c,NS_UserRoleOverride__c,Department_Description__c,NSSales_RoleName__c from User where NS_UserRoleOverride__c=false and Department_Description__c!= null and IsActive = true AND FirstName!=\'Automated\' AND LastName!=\'System\'  AND LastName!=\'Platform Integration User\'and managerid!=null and Profile.Name in (\'NS Sales Manager\',\'NS Industrial Development Manager\',\'NS Sales Read Only\')  order by NSSales_Role_Level__c'+(Test.isRunningTest()?' LIMIT 200':''));     
        
        
    }
    global void execute(Database.BatchableContext BC, List<User> scope){
        try{
        for(user singleUser :scope){
            singleUser.userroleid=roleNameAndId.get(singleUser.NSSales_RoleName__c);
            //Record Id,Name,usrname,oldroleName,Rolelevel,Profile,NewRoleName
            csvListUser.add(singleUser.id+','+singleuser.Name+','+singleuser.Username+','+Singleuser.UserRole.Name+','+singleuser.NSSales_Role_Level__c+','+Singleuser.Profile.Name+','+Singleuser.NSSales_RoleName__c);
            updatedRolelevelUser.add(singleUser);
            saveRecordCountOnUpdate++;
        }
        
        Database.saveResult[] DMLResultOnUpdate = Database.update(updatedRolelevelUser, false);
            system.debug('DML Update Size' +DMLResultOnUpdate.size());
            
            for(Integer Looper=batchCount;Looper<DMLResultOnUpdate.size();Looper++){
                if(!DMLResultOnUpdate[Looper].isSuccess()){
                    system.debug(DMLResultOnUpdate[Looper].getErrors());
                    saveRecordCountOnFail++;    
                }
                batchCount++;
            }
        }
        catch(exception E){
            errors.add(E);
        }
    }
    global void finish(Database.BatchableContext BC){
        AsyncApexJob batchJobStatus = [
            SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, 
            CreatedBy.Email
            FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        //usrname,oldroleName,Rolelvl,Profile
        string header = 'Id,Name,User Name,Old Role Name,Role Level,Profile,New Role Name\n';
        string finalstr = header ;
        for(String a: csvListUser)
        {
            string recordString = a+'\n';
            finalstr = finalstr +recordString;
            
        }
        
         Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        string csvname= 'User_'+(system.now()).format('yyyyMMddhhmmss')+'.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        String emailList = label.RoleBatchEmails;
        List<String> emailAdd = emailList.split(',');
        String[] SendToAddresses = emailAdd;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {batchJobStatus.CreatedBy.Email};
            mail.setToAddresses(SendToAddresses);
        String OrgName = URL.getSalesforceBaseUrl().toExternalForm().substringBetween('--','.');
        system.debug('XCX '+OrgName);
        
        id owa = [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName='No Reply' limit 01].id;
        
        mail.setOrgWideEmailAddressId(owa);
        
        if(OrgName!=null){
            System.debug('VCV INSIDER');
                    mail.setSubject('['+OrgName+']***Role Hierarchy Assignment Batch Ran on ' +system.now()+ ' and status is ' + batchJobStatus.Status+ '***');

        }else{
                    mail.setSubject('***Role Hierarchy Assignment Batch Ran on ' +system.now()+ ' and status is ' + batchJobStatus.Status+ '***');

        }
        
        
        string HTMLTextBody = '';
        HTMLTextBody = '<html> <body style="background-color: #d5f4e6;"> <font face = "Verdana" size = "2"> Hello, <br><br> Records processed in batches of overall ' 
            + batchJobStatus.TotalJobItems 
            +  ' jobs <br><br> Total Number of execution level errors in those batches are: ' 
            + batchJobStatus.NumberOfErrors
            //	+  '  <br><br> Total Number of Users updated in those batches are: ' 
            //    + batchJobStatus.saveRecordCountOnUpdate
            + '<br><br> <p style="color:red;"> Errors that needs to be addressed at data level are  '
            + errors.size()
            + ' : ' 
            + errors +'</p> <br>'
            +'user Records Attached <br><br>'
            + 'Thanks,<br>'
            + 'Connect NS Salesforce Support Team!'
            + '</font></body></html>';
        
        mail.setHtmlBody(HTMLTextBody); 
        mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
    
}