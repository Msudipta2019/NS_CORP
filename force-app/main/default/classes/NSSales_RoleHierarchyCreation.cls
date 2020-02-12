global class NSSales_RoleHierarchyCreation implements Database.Batchable<sObject>,Database.Stateful {
    
    Map<String,Id> roleNameAndId = new  Map<String,Id>();
    Exception[] errors = new Exception[0];
    
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        List<userrole> allUserRole = [Select id,Name from userrole];
        for(userrole ur : allUserRole){
            roleNameAndId.put(ur.Name,ur.Id);
        }
        system.debug('BX SRV RLHC BTCH '+roleNameAndId);
        //return Database.getQueryLocator('Select Name,Username,ProfileId,Profile.Name,UserRoleId,ManagerId,NSSales_Role_Level__c,NS_UserRoleOverride__c,Department_Description__c,NSSales_RoleName__c from User where IsActive = true and id in( \'0051I000001y2kQQAQ\')  order by NSSales_Role_Level__c');
        return Database.getQueryLocator('Select Name,Username,ProfileId,Profile.Name,UserRoleId,ManagerId,NSSales_Role_Level__c,NS_UserRoleOverride__c,Department_Description__c,NSSales_RoleName__c from User where NS_UserRoleOverride__c=false and Department_Description__c!=null and IsActive = true AND FirstName!=\'Automated\' AND LastName!=\'System\'  AND LastName!=\'Platform Integration User\'and managerid!=null and Profile.Name in (\'NS Sales Manager\',\'NS Industrial Development Manager\',\'NS Sales Read Only\')  order by NSSales_Role_Level__c'+(Test.isRunningTest()?' LIMIT 200':'')); 
        
        
    }
    
    global void execute(Database.BatchableContext BC, List<User> scope){
        try{ 
            String currentRoleprefix;
            for(User singleUser:scope){
                
                system.debug('BX SRV '+singleUser.NSSales_Role_Level__c +' RLHC '+singleUser.NSSales_RoleName__c);
                if(singleUser.Profile.Name=='NS Sales Manager'){
                    currentRoleprefix='Sales ';
                }
                else if(singleUser.Profile.Name=='NS Industrial Development Manager'){
                    currentRoleprefix='ID ';
                }
                else if(singleUser.Profile.Name=='NS Sales Read Only'){
                    currentRoleprefix='Sales ReadOnly ';
                }
                system.debug('RAW '+roleNameAndId.Keyset().Size());
                system.debug('UMP '+singleUser.NSSales_RoleName__c);
                if(!roleNameAndId.keyset().contains(singleUser.NSSales_RoleName__c)){
                    System.debug('KIWI '+singleUser.NSSales_Role_Level__c);
                    createRole(singleUser.NSSales_RoleName__c,currentRoleprefix , (Integer)singleUser.NSSales_Role_Level__c, roleNameAndId);
                    
                }
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
            mail.setSubject('['+OrgName+']***Role Hierarchy Creation Batch Ran on ' +system.now()+ ' and status is ' + batchJobStatus.Status+ '***');
            
        }else{
            mail.setSubject('***Role Hierarchy Creation Batch Ran on ' +system.now()+ ' and status is ' + batchJobStatus.Status+ '***');
            
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
            + errors +'</p> <br><br>'
            + 'Thanks,<br>'
            + 'Connect NS Salesforce Support Team!'
            + '</font></body></html>';
        
        mail.setHtmlBody(HTMLTextBody); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        ///////  NSSales_RoleHierarchyAssignment ///////////
        
        if(!(errors.size()>0&&batchJobStatus.NumberOfErrors>0)){
            if(!Test.isRunningTest()){
                
                NSSales_RoleHierarchyAssignment nRHA = new NSSales_RoleHierarchyAssignment();
                database.executeBatch(nRHA);
            }
        }
    }
    
    private static void createRole(String roleName, String dept,Integer lvl,Map<String,Id> roleNameAndId){
        id usrParentRoleId;
        String usrParentRoleName;
        system.debug('RR Start Name '+roleName);
        system.debug('RR Start LVL '+lvl);
        if(lvl==2){
            usrParentRoleName=dept+'Leadership' ;
        }
        else if(lvl>2){
            usrParentRoleName=roleName.split('Level')[0] + 'Level '+(Integer)(lvl-1);
            
        }
        system.debug('RR PRNT '+usrParentRoleName);
        system.debug('ISI '+roleNameAndId.get('ID Business Development Level 3'));
        if(roleNameAndId.keySet().contains(usrParentRoleName)){
            system.debug('INSIDER '+roleNameAndId.get(usrParentRoleName));
            SYSTEM.debug('INS Roller Name '+roleName);
            SYSTEM.debug('INS Roller Prnt '+roleNameAndId.get(usrParentRoleName));
            insertRole(roleName, roleNameAndId.get(usrParentRoleName), roleNameAndId);
        }
        else{
            if(lvl>2){
                SYSTEM.debug('DGMO LOOP '+roleName);
                
                createRole(usrParentRoleName, dept, lvl-1, roleNameAndId);
                system.debug('KGB '+usrParentRoleName);
                system.debug('RGB '+roleNameAndId.get(usrParentRoleName));
                insertRole(roleName, roleNameAndId.get(usrParentRoleName), roleNameAndId);
            }
            
        }
        
        
    }
    
    private static void insertRole(String roleName,Id parentId,Map<String,Id> roleNameAndId){
        system.debug('RRL '+roleName+' $$ '+parentId);
        UserRole rr = new UserRole();
        rr.Name=roleName;
        rr.ParentRoleId=parentId;
        upsert rr;
        
        system.debug('ROLE GONE '+rr);
        roleNameAndId.put(rr.Name, rr.Id);
        system.debug('MOSAD '+roleNameAndId.get(rr.Name));
    }
}