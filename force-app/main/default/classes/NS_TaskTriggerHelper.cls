/**@author  Accenture
* @Created Date 2018-02-19
* @version  1.0
* @description This class conatins method to filter out inactive contacts from Tasks.
***************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
***************************************************************************
09/25/2019          Sudipta Mukherjee  RESRESPTIMEPTIME:First Call/Email creation date stamp on Case for Reporting Purpose.
10/16/2019			Gidon Payenson 	   Merged to P3 (MERP3) 
12/23/2019          Sudipta Mukherjee  IM02722496- New Calculated Field - "Hours Since Last Activity"
----------------------------------------------------------------------------
*/ 
public with sharing class NS_TaskTriggerHelper {
    /** @author  Accenture
*  @description To filter out the inactive contacts from Task
*  @param List of task
*  @return None
*  @throws None
*/ 
    /*Class Name*/ 
    private static final String CLASS_NAME='NS_TaskTriggerHelper';
    /*Method Name*/ 
    private static final String METHOD_NAME='filterInactiveContacts';
    private static final String PREVENT_DELETE_COMPLETED_TASK='preventDeleteCompletedTask';
    private static final String UPDATE_STATUS='updateStatus';
    private static final String UPDATE_CASE='updateCase';
    private static final String UPDATE_TASK_STATUS_ON_CASE='updateTaskStatusOnCase';
    private static final String METHOD_TASK_RESTRICTION='updateTaskRestriction';
    private static final String METHOD_TASK_RESTRICTION_ONDELETE='deleteTaskRestriction';
    private static final String METHOD_TASK_ReportDetails='countdaysForTask'; //MERP3
    private static final String METHOD_LastActivityTrackeronCase='LastActivityTrackeronCase';
    
    /*Filtering Task with Active Contact*/
    public static void filterInactiveContacts(List<Task> taskList){
        NS_TriggerSettings__c setting = NS_TriggerSettings__c.getValues(NS_StaticVariablesUtility.tskTrigger);
        if(setting.NS_IsActive__c){
            Integer count =limits.getLimitQueryRows();
            Set<Id> contactIds = new Set<Id>();        
            Map<Id, Task> taskIdMap = new Map<Id, Task>();  
            Id taskRecordTypeId =  Schema.SObjectType.Task.getRecordTypeInfosByName().
                get(NS_StaticVariablesUtility.taskRT).getRecordTypeId();
            /*Filtering Tasks for Record Type "NS Task" and storing Task Ids matching Contact Ids*/ 
            try{
                for(Task tsk : taskList){           
                    if(tsk.RecordTypeId.equals(taskRecordTypeId)){
                        if(tsk.WhoId != null && tsk.WhoId.getSObjectType()== Contact.SObjectType && !contactIds.contains(tsk.WhoId)){
                            contactIds.add(tsk.WhoId);
                            taskIdMap.put(tsk.WhoId,tsk);
                        }
                        
                    }
                }
                /*Display Error message if Task WhoId equals Inactive Contact Ids*/ 
                for(Contact con: [Select Id,Name,NS_ContactStatus__c from Contact where Id in :contactIds LIMIT:count] ){
                    
                    if(con.NS_ContactStatus__c!= null && NS_StaticVariablesUtility.conInactiveStatus.equalsIgnoreCase(con.NS_ContactStatus__c))
                    {
                        taskIdMap.get(con.Id).addError(con.Name+NS_StaticVariablesUtility.Space+ Label.NS_TaskErrorMessage);
                    }
                }
            }
            catch (Exception exp) {
                //inserting a record in Exception object
                NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME,METHOD_NAME); 
            }
        }
    } 
    /* Updating cases associated to a new task/updated task */
    public static void updateCase(List<Task> updatedTask){
        NS_TriggerSettings__c setting = NS_TriggerSettings__c.getValues(NS_StaticVariablesUtility.tskTrigger);
        if(setting.NS_IsActive__c){
            try{
                Integer count =limits.getLimitQueryRows();
                Set<Id> caseIds = new Set<Id>();
                List<Case>  csList = new List<Case>();
                for(Task ts:updatedTask){
                    if(Case.SObjectType.getDescribe().getKeyPrefix().equalsIgnoreCase(String.valueOf(ts.WhatId).substring(0,3))){
                        caseIds.add(ts.WhatId);
                    }
                }
                csList = [select Id,NS_Unread_Email__c from Case where Id IN :caseIds LIMIT:count];
                if(!csList.isEmpty()){
                    For(Case cse:csList){
                        If(cse.NS_Unread_Email__c==true){
                            cse.NS_Unread_Email__c=false;
                        }
                    }
                    Database.update(csList,false);
                }
            }
            catch (Exception exp) {
                //inserting a record in Exception object
                NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME,UPDATE_CASE); 
            }
        }
    }
    /*Logical Marker to identify cases with Open Task*/
    public static void updateStatus(List<Task> updatedTask){
        NS_TriggerSettings__c setting = NS_TriggerSettings__c.getValues(NS_StaticVariablesUtility.tskTrigger);
        if(setting.NS_IsActive__c){
            Set<Id> casewithClosedTasks = new Set<Id>();
            Set<Id> casewithOpenTasks=new  Set<Id> ();
            Integer count =limits.getLimitQueryRows();
            try{
                for(Task ts:updatedTask){
                    if(Case.SObjectType.getDescribe().getKeyPrefix().equalsIgnoreCase(String.valueOf(ts.WhatId).substring(0,3))){
                        if(!ts.IsClosed){  
                            casewithOpenTasks.add(ts.WhatId);
                        }else{
                            casewithClosedTasks.add(ts.WhatId);
                        }
                    }
                }
                for(Task tsk:[Select Id, isClosed, WhatID from Task where WhatId in:casewithClosedTasks LIMIT:count]){
                    if(!tsk.IsClosed){
                        casewithOpenTasks.add(tsk.WhatId);
                    }
                }
                For(Id cseId:casewithClosedTasks){
                    if(casewithOpenTasks.contains(cseId)){
                        casewithClosedTasks.remove(cseId);
                        
                    }
                }
                List<case> listToUpdate= new List<Case>();
                For(Case cse:[Select NS_Open_Tasks__c from Case Where Id IN:casewithOpenTasks OR Id IN:casewithClosedTasks LIMIT:count]){
                    if(casewithOpenTasks.contains(cse.Id)){
                        cse.NS_Open_Tasks__c=true;
                        listToUpdate.add(cse);
                    }
                    else{
                        cse.NS_Open_Tasks__c=false;
                        listToUpdate.add(cse);
                    }
                }
                Database.update(listToUpdate,false);
            }
            catch (Exception exp) {
                //inserting a record in Exception object
                NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME,UPDATE_STATUS); 
            }
        }
    }
    /*Prevent deletion of past activity from OSS rep*/
    public static void preventDeleteCompletedTask(List<Task> toBeDeletedTask) {
        NS_TriggerSettings__c setting = NS_TriggerSettings__c.getValues(NS_StaticVariablesUtility.tskTrigger);
        if(setting.NS_IsActive__c){
            try{            
                String profileName=[Select Name from Profile where Id=:userinfo.getProfileId() limit 1].Name;            
                for(Task currTask : toBeDeletedTask) {                
                    if(profileName.equalsIgnoreCase(NS_StaticVariablesUtility.UserRep) && currTask.IsClosed){
                        currTask.addError(System.Label.TaskDeleteMessage);
                    }
                }
                system.debug('calling updateTaskStatusOnDelete');
                updateTaskStatusOnDelete(toBeDeletedTask);
            }
            catch(Exception exp){
                NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, PREVENT_DELETE_COMPLETED_TASK);
            }
        }
    }  
    
    /*Update Logical Marker on deletion of Task*/
    public static void updateTaskStatusOnDelete(List<Task> deletedTask){
        Set<Id> casewithOpenTasks=new  Set<Id> ();
        Integer count =limits.getLimitQueryRows();
        try{
            for(Task ts:deletedTask){
                if(Case.SObjectType.getDescribe().getKeyPrefix().equalsIgnoreCase(String.valueOf(ts.WhatId).substring(0,3))){
                    if(!ts.IsClosed){
                        casewithOpenTasks.add(ts.WhatId);
                    }
                }
            }
            for(Task tsk:[Select Id, isClosed, WhatID from Task where WhatId in:casewithOpenTasks and Id Not IN:deletedTask and IsClosed=false limit:count]){
                If(casewithOpenTasks.contains(tsk.WhatId)){
                    casewithOpenTasks.remove(tsk.WhatId);
                }  
            }
            List<case> listToUpdate= new List<Case>();
            For(Case cse: [Select id,NS_Open_Tasks__c from Case Where Id IN:casewithOpenTasks limit:count]){
            	cse.NS_Open_Tasks__c=false;
                listToUpdate.add(cse);
            }
            if(!listToUpdate.isEmpty()){
                Database.SaveResult[] srList = Database.update(listToUpdate,false);
                NS_Utility.databaseSvResult(srList,UPDATE_TASK_STATUS_ON_CASE,CLASS_NAME);
            }
        }
        catch(Exception exp) {
            //inserting a record in Exception object
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME,UPDATE_TASK_STATUS_ON_CASE); 
        }   
    }
    
    
       /*Restrict User from Editing any Task if the Task owner profile will not match with the Loged in User
     * Added by Sudipta on 07-08-2019
     * As per the Sales P1 Defect number D-1490*/ 
     
    public static void updateTaskRestriction(List<Task> updOldTask,List<Task> updNewTask){            
        
        set<ID> taskowner= new set<ID>();
         try{
        
        for(task tks :updOldTask )
        {
            //SRV for D-1749
            if(tks.Escalation_Task__c){
                return ;
            }
           taskowner.add(tks.OwnerId);
            
        }
        // Checking the loged in User's profile id.
        id profileNameTaskCreater=[Select id from Profile where Id=:userinfo.getProfileId() limit 1].id;    
        // A map to hold all the details of the Task owner profile.
        map<id,user> userMap=new map<id,user>([select id,ProfileId from user where Id in:taskowner]);
       for(task tks :updNewTask)
        {
           for(task tks1:updOldTask) 
           {
            user ownerProfile=userMap.get(tks1.OwnerId);
              //checking if Task Owner's profile id is matching with the loged in User's profile id or not 
            if(ownerProfile.ProfileId!=profileNameTaskCreater)
            {
                tks.addError(Label.NSSales_errorOnEditTaskProfileBased);
            }
            
           }
         }
         }
         catch(Exception exp) {
            //inserting a record in Exception object
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME,METHOD_TASK_RESTRICTION); 
        } 
    }
    
    
    
    /*Restrict User from Deleting any Task if loged in user will not match with the Task Owner or Creater
* Added by Sudipta on 07-08-2019
* As per the Sales P1 Defect number D-1490*/ 
    
    public static void deleteTaskRestriction(List<Task> updOldTask){            
        
        set<ID> taskowner= new set<ID>();
        try{
            
            for(task tks :updOldTask )
            {
                
                taskowner.add(tks.OwnerId);
                
            }
            
            //id profileIdNSSales= [select id from profile where name='NS Sales Manager'].id; 
            //id profileIdNSSalesReadOnly= [select id from profile where name='NS Sales Read Only'].id;
            //id profileIdNSSalesID= [select id from profile where name='NS Industrial Development Manager'].id;   
            
             /* SET<ID> profileids= NEW SET<ID>();
          for(profile pp: [select id,name from profile where name in(
'NS Industrial Development Manager',
'NS Sales Manager',
'NS Sales Read Only',
'NS Integration User',
'NS Marketing Manager',
'OSS Manager',
'OSS Rep',
'OSS Support',
'Automotive Leadership',
'Automotive Manager',
'EP Leadership',
'EP Manager',
'NS Marketing Leadership',
'NS Read Only',
'UTS Leadership',
'UTS Manager')] )
            {
                profileids.add(pp.id);
            }  */
            
            
           
            
            // Checking the loged in User's profile id and User's id.
            id logedinUserId= userinfo.getUserId();
            id logedinUserProfileId=[Select id from Profile where Id=:userinfo.getProfileId() limit 1].id; 
            // A map to hold all the details of the Task owner profile.
           // map<id,user> userMap=new map<id,user>([select id,ProfileId from user where Id in:taskowner]);
            
            for(task tks1:updOldTask) 
            {
              //SRV for D-1749
             if(tks1.Escalation_Task__c){
                return ;
            }
                
                //checking if Task Owner/Creator is matching with the loged in User only for sales User 
                if
                   // tks1.OwnerId != logedinUserId && tks1.CreatedById !=logedinUserId && (logedinUserProfileId==profileIdNSSales||logedinUserProfileId==profileIdNSSalesReadOnly||logedinUserProfileId==profileIdNSSalesID))
                   (tks1.OwnerId != logedinUserId && tks1.CreatedById !=logedinUserId)
                {
                   
                    tks1.addError(Label.NSSales_errorOnDeleteTask);
                }
                
                
            }
        }
        catch(Exception exp) {
            //inserting a record in Exception object
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME,METHOD_TASK_RESTRICTION_ONDELETE); 
        } 
    }
    
    //RESPTIME   //MERP3 
/** @author  Sudipta Mukherjee
*  @description: First Call/Email creation date stamp on Case for Reporting Purpose.
*  @param List of task
*  @return None
*  @throws None 
*/
    public static void countdaysForTask(List<Task> newTask)
   {     
       try {
        //Set of case Ids to store all cases for the tasks
        set<id> setCaseid= new set<id>();
        Date dtCaseResponseStartDate;   //tracks the case creation date, when to start the population of response tmes
        If (Label.Case_Response_Time_Start_Date!=NULL ) {
           dtCaseResponseStartDate = Date.parse( Label.Case_Response_Time_Start_Date); //get from a label
        }
        else {
              dtCaseResponseStartDate = Date.parse('10/30/2019'); //hardcode if no label available
        }  
		//iterate through tasks;
        for(task tt: newTask){
            //get related to ID         
            string ttid=tt.WhatId; 
            //if the related to id is case and Task Subtype is Call or Email
            if(ttid!=null && ttid.startsWith('500') && (tt.TaskSubtype==('Call')|| tt.TaskSubtype==('Email') ))
            {                               
                setCaseid.add(tt.WhatId); 
            }
        }    
            
        if(setCaseid!=null)
            {
                 Map<Id, Case> caseMap = new Map<Id, Case>([Select Id, createddate,NS_Time_To_Response__c from 
 		                                              Case where Id =: setCaseid And CreatedDate >:dtCaseResponseStartDate ]);                      
    	   		for(task ts : newTask){
            		If(ts.whatId.getsObjectType() == Case.sObjectType)  //gp - do we need this?
            		{
                		Case c = caseMap.get(ts.whatId);
                 		if(c != null) //case found
                 		{
                     		if(c.NS_Time_To_Response__c == null && !(ts.NS_Flag__c)) //response time already exists
                     		{
                    			c.NS_Time_To_Response__c=((ts.CreatedDate.getTime())/1000/60/60)-
                                    								((c.CreatedDate.getTime())/1000/60/60);
                      		}
                 		}
            		}
        	   } //end for
                
               if(!caseMap.isEmpty()) update caseMap.values();
    		} //end if case tasks found
     } 
   
     catch(Exception exp) {
            //inserting a record in Exception object
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME,METHOD_TASK_ReportDetails); 
        } 
    
   }//end function

    
    //IM02722496- New Calculated Field - "Hours Since Last Activity" -Sudipta	
 public static void LastActivityTrackeronCase(List<Task> newTask)	
   {  	
     try {	
         system.debug('LastActivityTrackeronCase');	
       //to store the all case ids related to log a call task or Outbound email  	
       set<id> setCaseids= new set<id>();	
   	
        //iterate through tasks;	
        for(task tt: newTask){	
       	
            //get related to ID         	
            string ttid=tt.WhatId; 	
            //if the related to id is case and Task Subtype is Call or Email	
            if(ttid.startsWith('500') && (tt.TaskSubtype==('Call')|| tt.TaskSubtype==('Email') ))	
            {               	
                             	
                setCaseids.add(tt.WhatId); 	
            }	
        }    	
               if(setCaseids!=null)	
            {	
                	
                 Map<Id, Case> caseMap = new Map<Id, Case>([Select Id, createddate,status,NS_Last_Activity_Time__c,NS_Time_To_Response__c,NS_Counter_Activity__c from 	
                                                      Case where Id =: setCaseids and Status NOT IN ('NS_Closed','NS_Cancelled')]);                      	
                for(task ts1 : newTask){	
                    //if task what id is Case	
                    If(ts1.whatId.getsObjectType() == Case.sObjectType)	
                    {	
                        	
                        Case c = caseMap.get(ts1.whatId);	
                    
                        //to store the total hours between created task time and case creation time/last activity time	
                        long dateicc;	
                        //In case there is no last activity has been performed.	
                        if(c.NS_Last_Activity_Time__c==NULL)	
                        {	
                            //calculate hours between task and related case creation time	
                           dateicc= ((ts1.CreatedDate.getTime())/1000/60/60)-((c.CreatedDate.getTime())/1000/60/60);	
                        }else	
                        {	
                            //calcualte the hours between the task creation time and last activity date on related case	
                        dateicc=((ts1.CreatedDate.getTime())/1000/60/60)-((c.NS_Last_Activity_Time__c.getTime())/1000/60/60);	
                        }	
                       	
                        //set the time to reset the 24 hours counter	
                        long oneday=24;	
                        //to check how many time it crossed 24 hours between two activites	
                        long addcounter;	
                        if(dateicc>=oneday)	
                        {	
                        addcounter=dateicc/oneday;	
                        }	
                       // system.debug('SUDI+ccc4'+dateicc+addcounter);	
                        	
                        //Update the 24 hours counter field if time is more than 24 hours and case is not closed	
                        if(c!=null && dateicc>=24) //  && (c.Status!='NS_Closed' && c.Status!='NS_Cancelled')	
                        {               
                         //    system.debug('SUDI Check point 301'+c.NS_Counter_Activity__c);	
                            if(c.NS_Counter_Activity__c==NULL)	
                            {	
                            //add the total numer of times if activity took more than 24 hours    	
                            c.NS_Counter_Activity__c= addcounter;	
                               // system.debug('SUDI Check point 401'+c.NS_Counter_Activity__c);
                            }	
                            else	
                            {	
                                
                            c.NS_Counter_Activity__c=c.NS_Counter_Activity__c+addcounter;	
                                	
                            }	
                           	
                        }	
                        // if case is not closed or cancelled, update the last activity tracker field	
                        	
                        if(c != null) //case found   && (c.Status!='NS_Closed' && c.Status!='NS_Cancelled')	
                        {	
                            	
                            if(!(ts1.NS_Flag__c))	
                            {	
                                	
                                c.NS_Last_Activity_Time__c=System.Now();                              	
                            }	
                        }	
                    }	
               } //end for	
                	
               if(!caseMap.isEmpty()) update caseMap.values();	
            } //end if case tasks found	
         	
         } 	
   	
     catch(Exception exp) {	
            //inserting a record in Exception object	
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME,METHOD_LastActivityTrackeronCase); 	
        } 	
       	
   }    
}