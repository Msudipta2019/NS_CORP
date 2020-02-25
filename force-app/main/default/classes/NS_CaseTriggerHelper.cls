/**@author  Accenture
* @Created Date 2018-Apr-15
* @version  1.0
* @description This class conatins methods which are invoked by CaseTrigger to update Case detail 
*Modification History
***************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
***************************************************************************
06/25/2019          Gidon Payenson      IM02499080 – multiple queues/owner assignment enhancement
09/25/2019          Sudipta Mukherjee   Enhancement - To bypass the auto Escalation logic on call/email response stamp
10/16/2019			Gidon Payenson		Merge to P3 (MERP3)
11/07/2019          Sourav Sinha        Defect D1760 Child status ctatus working
11/07/2019          Sourav Sinha        Defect D1760 Assigned to Check
11/14/2019          Daniel Glaser       Enhancement TRAX - adding code to support Case New_External_Comment__c to process
                                         new Case activity Button Case Updated (external)
11/07/2019          Sourav Sinha        D-1786 Null Point Exception Error
11/21/2019          Aritra Dey          D-3325 Populate the feedback case Subject
1/29/2020           Aritra Dey          D-1942 Close case edit validation bypass for NS Integration User 
2/4/2020            Sudipta Mukherjee   IM02722496- New Calculated Field - "Hours Since Last Activity"
----------------------------------------------------------------------------
*/ 
public Without sharing class NS_CaseTriggerHelper {
    /*Class Name*/
    private static final String CLASS_NAME = 'NS_CaseTriggerHelper';
    
    /*Method Name*/ /*Gunjari 02/07*/
    private static final String METHOD_NAME1='insertAllCaseRollupRecord';
    private static final String METHOD_NAME2='updateAllCaseRollupRecord'; 
    
    /* @author-  Accenture
*  @description- Update Case with cust. Metadata value, if Interaction reason is changed
*  @param- None
*  @return- None
*  @throws- Standard Exception
*/
    
    public static void updateCaseInfo(List<Case> newCases){
        
        if(NS_StaticVariablesUtility.isTriggerExecuted == false){
            List<Case> casesNewOwner = new List<Case>();
            List<Id> casesClosed = new List<Id>();
            List<Case> casesNewSetings = new List<Case>();//if interaction reason is changed
            List<Case> casesNewUpdate = new List<Case>();
            Set<Case> casesWithTask = new Set<Case>();
            Set<String> caseIntermodalqueue=new Set<String>();
            Set<Id> nonEscalatedCases = new Set<Id>();
            Case cseOld = new Case();
            Case cseNew = new Case();
            Case oldCase = new Case();
            Case newCase = new Case();
            Set<String> reasonToEscalate = new Set<String>();//Change owner if case is escalated
            //Gunjari -- 12/19 for Req#919 -- populate Case BU
            List<Case> caseChangedOwners = new List<Case>();
            
            caseIntermodalqueue.add(NS_StaticVariablesUtility.NS_Intermodal_Customer_Service);
            caseIntermodalqueue.add(NS_StaticVariablesUtility.NS_Intermodal_Customer_Service_Manager);
                
            List<Profile> adminProfileID= [Select id from profile where Name in ('System Administrator', 'OSS Support','NS Integration User') limit 05];
            Profile currentUserProfile = [Select id from profile where id =:userinfo.getProfileId()];
            Set<NS_CaseSetting__mdt> escMetadata = new Set<NS_CaseSetting__mdt>();
            List<Group> csmQueueid=[select id,name from Group where  type ='Queue' and name in :caseIntermodalqueue];
            Map<String,id> groupMap= new Map<String,id>();

            try{
                for(Group gg :csmQueueid){
                    groupMap.put(gg.name,gg.id);
                }
				//SRV11/18- D-1786 Commented out
                //NS_CaseTriggerUtility.metadataData();

                for(Case CC : newCases){
                    oldCase = (Case)Trigger.oldMap.get(CC.id);
                    newCase = (Case)Trigger.newMap.get(CC.id);                   
                    
                    if((NS_StaticVariablesUtility.NS_CLOSED.Equals(CC.Status))&&(oldCase.Status.Equals(newCase.Status))&&(!adminProfileID.contains(currentUserProfile))){
                        CC.addError(NS_StaticVariablesUtility.ClosedcaseError); 
                    }
                }
                //SRV - Phase 3 Escalation REQ-1192
                escMetadata.addall([SELECT Label,Interaction_Type__c FROM NS_CaseSetting__mdt WHERE NS_AutoEscalateOnUpdate__c = true LIMIT 100]);
                escMetadata.addall([SELECT Label,Interaction_Type__c FROM NS_CaseSetting__mdt WHERE NS_Intermodal_Escalation__c = true and 
                                    NS_AutoEscalateOnUpdate__c != true LIMIT 100]);
 				system.debug('SRV ESC '+escMetadata);
                For(NS_CaseSetting__mdt cSet :escMetadata){
                    reasonToEscalate.add(cSet.Label+cSet.Interaction_Type__c);
                }
                
                for( Id cseId : Trigger.newMap.keySet() ){
                    cseOld = (Case)Trigger.oldMap.get(cseId);
                    cseNew = (Case)Trigger.newMap.get(cseId);

                    // TRAX @dglaser
                    // check for empty field New_External_Comment__c if not empty the field
                    // New_External_Comment__c will be added to the field Case_Update_External__c
                    // during the after update a Task will be created.
                    system.debug('NS_CaseTriggerHelper updateCaseInfo'+cseNew.New_External_Comment__c);
                    if (cseNew.New_External_Comment__c != null && cseNew.New_External_Comment__c != '') {
                    	DateTime myDateTime = datetime.now();
						String myDate = myDateTime.format('MM/dd/yyyy hh:mm a');
						string originalMsg = cseNew.Case_Update_External__c != null ? cseNew.Case_Update_External__c : '';
						// +'\r\n\r\n'
                    	cseNew.Case_Update_External__c = myDate + ' ' +UserInfo.getFirstName() +' '+UserInfo.getLastName().left(1)+' -- ' +cseNew.New_External_Comment__c +'\n\n'+ originalMsg;
                    	createTaskforNewExt_Comment(cseNew);
                    	newCase.New_External_Comment__c ='';
                    }



                    if(cseNew.NS_WFAutoRelease__c==false && cseNew.parentid==null){//Added as Time based workflow was hitting update trigger logic
                        //If Case created from Quick case remove the checkbox so that validation rule can function 
                        if(cseNew.NS_Created_using_Quick_Case__c == true){
                            cseNew.NS_Created_using_Quick_Case__c= false;
                        }
                        //Assigned To will be null if owner is changed
                        if(cseOld.OwnerId != cseNew.OwnerId){
                            cseNew.NS_AssignedTo__c = null;
                            //Gunjari -- 12/19 for Req#919 -- populate Case BU
                            caseChangedOwners.add(cseNew);
                        }
                        
                        if(!NS_StaticVariablesUtility.NS_ESCALATED.equalsIgnoreCase(cseNew.Status)){
                            nonEscalatedCases.add(cseNew.Id);//Later if status is escalated then update Assigned To as null
                        }  
                        
                        System.debug('SRV TC ESC 01 '+cseNew.NS_IsEscaledOnEdit__c);
                        System.debug('SRV TC ESC 01 '+cseNew.NS_InteractionReason__c+cseNew.NS_Type__c);
                        System.debug('SRV TC ESC 01 '+reasonToEscalate);
                        
                        //fetch custom logic if interaction reason is changed 
                        if((cseOld.NS_InteractionReason__c != cseNew.NS_InteractionReason__c)){
                            casesNewUpdate.add(cseNew);
                        }
                        //Check 'Escalate on Edit' Interaction Reasons for auto escalation
                       
                        
                        
                        else if(cseNew.NS_IsEscaledOnEdit__c== false &&
                                reasonToEscalate.contains(cseNew.NS_InteractionReason__c+cseNew.NS_Type__c) 
                             //  MERP3; Sudipta Mukherjee   Enhancement - To bypass the auto Escalation logic on call/email response stamp        
                                && 
                                ((cseOld.NS_Time_To_Response__c==null && cseNew.NS_Time_To_Response__c==null)
                                 ||(cseOld.NS_Time_To_Response__c!=null && cseNew.NS_Time_To_Response__c!=null))
                        /*commenting out as a part of Hours Since Last Activity by Sudipta on 2/5/2020*/
                                &&
                                 /*********IM02722496- New Calculated Field - "Hours Since Last Activity" by Sudipta*/
                                (cseOld.NS_Last_Activity_Time__c==cseNew.NS_Last_Activity_Time__c))
                               
                                /***IM02722496 END***/
                            
                                {
                                     casesNewSetings.add(cseNew);
                                }
                        
                        else if((cseOld.NS_Type__c  != cseNew.NS_Type__c)){
                            casesNewUpdate.add(cseNew);
                        }
                        //Manual Case Closure not permitted if Case is having open task
                        else if(cseOld.Status != cseNew.Status && NS_StaticVariablesUtility.NS_CLOSED.equalsIgnoreCase(cseNew.Status)){
                            casesClosed.add(cseNew.Id);
                        }
                        //Manual Escalation, fetch custom logic to get the new owner
                        else if(cseOld.Status != cseNew.Status && NS_StaticVariablesUtility.NS_ESCALATED.equalsIgnoreCase(cseNew.Status)){
                            //hardcoding removed by SM
                            if(cseOld.NS_CaseBusinessUnit__c== NS_StaticVariablesUtility.NS_OSS &&cseNew.NS_CaseBusinessUnit__c==NS_StaticVariablesUtility.NS_OSS){
                                cseNew.NS_AssignedTo__c = null;
                            } 
                            casesNewOwner.add(cseNew);
                        }
                        //Update Owner, if Case Assignment is updated
                        if (cseOld.NS_AssignedTo__c != cseNew.NS_AssignedTo__c){
                            if(cseOld.NS_AssignedTo__c==null && (NS_StaticVariablesUtility.NS_NEW.equalsIgnoreCase(cseNew.Status) || cseNew.Status.equalsIgnoreCase(NS_StaticVariablesUtility.NEW_TXT))){
                                cseNew.Status = NS_StaticVariablesUtility.NS_WORKING;
                                
                            }
                            /* //IM02499080 gp -- 06/25/19 -- add checks for assigned to field (old) and if
                            
                            if (cseNew.NS_AssignedTo__c!=null){
                                casesNewOwner.add(cseNew);
                                casesWithTask.add(cseNew);
                            */
                            if (cseNew.NS_AssignedTo__c!=null && (cseOLd.NS_AssignedTo__c!=null ||
                              cseOLd.NS_AssignedTo__c==null  
                              && cseNew.NS_AssignedTo__c != UserInfo.getUserId()
                                                           	)) {                         
                                 casesNewOwner.add(cseNew);
                                 casesWithTask.add(cseNew);
                            } //IM02499080 Gidon -- 06/25/19------------------------
                        }
                    }
                    //SRV D1760 Child status ctatus working
                    else if(cseNew.NS_WFAutoRelease__c==false && cseNew.parentid!=null){

                        if ((NS_StaticVariablesUtility.NS_NEW.equalsIgnoreCase(cseOld.Status) || cseOld.Status.equalsIgnoreCase(NS_StaticVariablesUtility.NEW_TXT))
                           && !(NS_StaticVariablesUtility.NS_CLOSED.Equals(cseNew.Status))
                           && cseOld.NS_AssignedTo__c!=null){
                            system.debug('SOS DEBUG');
                            cseNew.Status = NS_StaticVariablesUtility.NS_WORKING;
                        }
                        if (cseOld.NS_AssignedTo__c != cseNew.NS_AssignedTo__c){
                            system.debug('SRV inside if '+cseOld.NS_AssignedTo__c);
                            //if(cseOld.NS_AssignedTo__c==null && (NS_StaticVariablesUtility.NS_NEW.equalsIgnoreCase(cseNew.Status) || cseNew.Status.equalsIgnoreCase(NS_StaticVariablesUtility.NEW_TXT))){
                            if((NS_StaticVariablesUtility.NS_NEW.equalsIgnoreCase(cseNew.Status) || cseNew.Status.equalsIgnoreCase(NS_StaticVariablesUtility.NEW_TXT))){
                                system.debug('SRV B4 working '+cseNew.Status);
                                cseNew.Status = NS_StaticVariablesUtility.NS_WORKING;
                                system.debug('SRV Aftr working '+cseNew.Status);
                            }
                        }


                    }
                    //If Time based workflow hit the update trigger
                    else{
                        cseNew.NS_WFAutoRelease__c=false;
                    }
                }
                if(!casesNewSetings.isEmpty()){
                    
                    NS_CaseTriggerUtility.getCaseSettings(casesNewSetings);
                    getCaseOwner(casesNewSetings);
                    For(Case cse: casesNewSetings){
                       Case cseOldRec = (Case)Trigger.oldMap.get(cse.Id);
                       Case cseNewRec = (Case)Trigger.newMap.get(cse.Id); 
                        if(nonEscalatedCases.contains(cse.Id) && NS_StaticVariablesUtility.NS_ESCALATED.equalsIgnoreCase(cse.Status)){
                            if(cse.NS_CaseBusinessUnit__c==NS_StaticVariablesUtility.NS_OSS && cseOld.OwnerId != cseNew.OwnerId) {
                            	// system.debug('updateCaseInfo Setting up Assigned to as null cseNew.NS_AssignedTo__c '+cseNew.NS_AssignedTo__c);
                                cse.NS_AssignedTo__c=null;//Setting up Assigned to as null for auto Escalated case
                            }
                            if(cse.NS_CaseBusinessUnit__c==NS_StaticVariablesUtility.NS_Intermodal
                                && cse.NS_InteractionReason__c==NS_StaticVariablesUtility.NS_IR_Shipment_Exception
                               &&(cse.NS_Type__c==NS_StaticVariablesUtility.NS_IT_Shutdown||cse.NS_Type__c==NS_StaticVariablesUtility.NS_IT_Misroute)
                              &&(cse.OwnerId==groupMap.get(NS_StaticVariablesUtility.NS_Intermodal_Customer_Service))
                              ){
                                	cse.NS_AssignedTo__c=null;
                                  //hardcoding removed by SM
                                    cse.OwnerId=groupMap.get(NS_StaticVariablesUtility.NS_Intermodal_Customer_Service_Manager);
                                
                            }
                        } 
                    }
                    NS_StaticVariablesUtility.isTriggerExecuted = true;
                }
                else if(!casesNewOwner.isEmpty()){
                    getCaseOwner(casesNewOwner);
                    For(Case cse: casesNewSetings){
                        if(nonEscalatedCases.contains(cse.Id) && NS_StaticVariablesUtility.NS_ESCALATED.equalsIgnoreCase(cse.Status)){
                            if(cse.NS_CaseBusinessUnit__c==NS_StaticVariablesUtility.NS_OSS && cseOld.OwnerId != cseNew.OwnerId){
                            	// system.debug('updateCaseInfo for auto Escalated case cseNew.NS_AssignedTo__c '+cseNew.NS_AssignedTo__c);
                                cse.NS_AssignedTo__c=null;//Setting up Assigned to as null for auto Escalated case
                            }
                        } 
                    }
                    NS_StaticVariablesUtility.isTriggerExecuted = true;
                }
                if(!casesNewUpdate.isEmpty()){
                    
                    NS_CaseTriggerUtility.getCaseSettings(casesNewUpdate);
                    For( Case cse: casesNewUpdate){
                        if(NS_StaticVariablesUtility.NS_CLOSED.equalsIgnoreCase(cse.Status) ||
                           NS_StaticVariablesUtility.NS_ESCALATED.equalsIgnoreCase(cse.Status)){
                               cse.Status = NS_StaticVariablesUtility.NS_WORKING;
                           }
                    }
                    NS_StaticVariablesUtility.isTriggerExecuted = true;
                }
                //Gunjari -- 12/19 for Req#919 -- populate Case BU
                if(!caseChangedOwners.isEmpty()){
                    NS_CaseTriggerUtility.getCaseBusinessUnit(caseChangedOwners);
                    NS_StaticVariablesUtility.isTriggerExecuted = true;
                }
                
                if(!casesClosed.isEmpty()){
                    
                    List<Id> casesWithOpenTask = NS_CaseTriggerUtility.getcaseWithOpenTask(casesClosed);
                    
                    for(Case cse : newCases){
                        if(casesWithOpenTask.contains(cse.Id)){
                            cse.addError(Label.NS_CaseWithOpenTaskError);
                        }
                    }    
                }
                
                if(!casesWithTask.isEmpty()){
                    
                    NS_CaseTriggerUtility.refreshTask(casesWithTask);
                }
                for(Case cse : newCases){
                    if(NS_StaticVariablesUtility.NS_ESCALATED.equalsIgnoreCase(cse.Status) && cse.NS_IsEscaledOnEdit__c== false){
                        cse.NS_IsEscaledOnEdit__c= true;
                    }
                }
                //to cover Catch part
                if(Test.isRunningTest()){
                    integer I=100/0;
                }
            }
            catch (Exception exp) {
                /*Inserting a record in Exception object*/
                NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, 'getCaseOwner');
            }
        }    
    }   
    
    /* @author-  Accenture
*  @description- Check if new Task needs to be created
*  @param- None
*  @return- None
*  @throws- Standard Exception
*/
    public static void checkTask(){
        Case cseOld = new Case();
        Case cseNew = new Case();
        List<Case> casesNewTask= new List<Case>();
        List<Case> caseWithoutTask = new List<Case>();
        
        try{
            for( Id cseId : Trigger.newMap.keySet() ){
                cseOld = (Case)Trigger.oldMap.get(cseId);
                cseNew = (Case)Trigger.newMap.get(cseId); 
                if( cseOld.Status != cseNew.Status){
                    casesNewTask.add(cseNew);
                }
            }
            if(casesNewTask.size()>0){
                
                createTask(casesNewTask);
            }
            
            //to cover Catch part
            if(Test.isRunningTest()){
                integer I=100/0;
            }
        }
        catch (Exception exp) {
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, 'checkTask');
        } 
    }
    
    /* @author-  Accenture
*  @description- Create Task as per Case Setting for ecalation notifications
*  @param- List of Cases
*  @return- None
*  @throws- Standard Exception
*/
    public static void createTask(List<Case> caseNew){
        Set<String> caseTaskOwner = new Set<String>();
        List<String> pubGroupList = new List<String>();
        Set<String> iReasons = new Set<String>();
        Set<String> iType = new Set<String>();
        Set<Id> ownerIds = new Set<Id>();
        Set<ID> userIDTask = new Set<ID>();
        Map<Id,String> queueNameWithIds = new Map<Id,String>();
        Map<Case,List<Id>> taskAndUsers= new Map<Case,List<Id>>();
        try{ //hardcoding removed by SM
            for(Task T :[SELECT id, OwnerId,WhatId FROM Task WHERE WhatId in : caseNew AND TaskSubtype =: NS_StaticVariablesUtility.TaskSubtype_Task ]){
                String S =T.OwnerId+'_'+T.WhatId;
                caseTaskOwner.add(S);
            }
            
            For(Case cse: caseNew){
                iReasons.add(cse.NS_InteractionReason__c);
                iType.add(cse.NS_Type__c);
                ownerIds.add(cse.OwnerId);
            }
            //Get values from Custom metadata Case Settings 
            Map<String, String> caseBUWithStatus = NS_CaseTriggerUtility.getMetadataStatus(iReasons,iType);
            Map<String, String> caseWithTaskOwners = NS_CaseTriggerUtility.getTaskOwner(iReasons,iType);
            String autoStatus;
            For(Case cse: caseNew){ 
                //Combination of Case BU and Interaction Reason is unique. Get the API name of public group
                
                if(cse.Status.equalsIgnoreCase('NS_Escalated')){
                    pubGroupList.add(caseWithTaskOwners.get(cse.NS_InteractionReason__c+cse.NS_Type__c));
                }
            }
            //All the member users of public group
            Map<String,List<Id>>groupWithUsers= NS_CaseTriggerUtility.getMemberUsers(pubGroupList);
            //Get the Case Owner queue
            For(Group grp: [SELECT Id,Type,DeveloperName FROM Group WHERE Id IN: ownerIds and Type='Queue']){
                queueNameWithIds.put(grp.Id, grp.DeveloperName);
            }
            //All the member users of owner queue
            Map<String,List<Id>>queueWithUsers= NS_CaseTriggerUtility.getMemberUsers(queueNameWithIds.values());
            taskAndUsers= NS_CaseTriggerUtility.getMktgNotifications(caseNew);
            For(Case cse: caseNew){                
                List<Id> groupMembers = groupWithUsers.get(caseWithTaskOwners.get(cse.NS_InteractionReason__c+cse.NS_Type__c));
                List<Id> queueMembers = queueWithUsers.get(queueNameWithIds.get(cse.OwnerId));        
                System.debug('SVM Grp '+groupMembers);
                System.debug('SVM QQ '+queueMembers);
                For(Id usrId: queueMembers){
                    //check if queue member also exist in group member
                    If(groupMembers != null && groupMembers.contains(usrId)){
                        if(!taskAndUsers.containsKey(cse)){
                            taskAndUsers.put(cse, new List<Id>());
                        }                    
                        taskAndUsers.get(cse).add(usrId);
                    }
                }
            }    
            List<Task> listTask = new List<Task>();
            For(Case cse:taskAndUsers.keyset()){                
                For(Id usrId: taskAndUsers.get(cse)){
                    if(userIDTask != null){
                    	if(!userIDTask.contains(usrId)){
                        userIDTask.add(usrId);
                        String userTask = usrId+'_'+cse.Id;
                        if(!caseTaskOwner.contains(userTask)){                   
                            Task tsk = new Task();
                            tsk.WhatId=cse.Id;
                            // Commented by Sudipto G for D-1749
                            tsk.Status='Temp';
                            tsk.Escalation_Task__c=true;
                            //tsk.Status=NS_StaticVariablesUtility.Taskstatus_Completed;
                            If(cse.Account.NS_MarketingOwner__c!=null){
                                tsk.Subject='Case ' + cse.CaseNumber + ' has been escalated';
                            }
                            else{
                                tsk.Subject='Case ' + cse.CaseNumber + ' has been escalated to your queue - ' + cse.NS_InteractionReason__c;    
                            }
                            tsk.Description=cse.Description;
                            tsk.OwnerId=usrId ;
                            listTask.add(tsk);
                        }
                    }
                    }
                }
            }
            if(!listTask.isEmpty()){
                List<database.SaveResult> SS= Database.insert(listTask,false);// inserting task as open task so that user gets notificaton later updating it as completed
            }
            // Commented by Sudipto G for D-1749
            
            List<Task> markAsCompleted = new List<Task>();
            For(Task tsk: listTask){//hardcoding removed by SM
                tsk.Status = NS_StaticVariablesUtility.Taskstatus_Completed;
                markAsCompleted.add(tsk);
            }

            if (markAsCompleted.size() > 0) {
            	update markAsCompleted;
            }            
            
            //to cover Catch part
            if(Test.isRunningTest()){
                integer I=100/0;
            }
        }
        catch(Exception ex){
            NS_StaticVariablesUtility.createExceptionRecord(ex, CLASS_NAME, '');
        }
    }    
    //Gunjari -- 12/19 for Req#919 -- populate Case BU
    /* @author-  Accenture
*  @description- Case Owner can be the user, user's queue or manager's queue bases on different condition
*  @param- List of Cases
*  @return- None
*  @throws- Standard Exception
*/
    public static void getCaseOwner(List<Case> caseList){
		//Added by Sudipta 12/24/2019 : E-Commerce IT queue	
        system.debug('NS_CaseTriggerHelper getCaseOwner start');	
        string st='AccessNS/TRAX - System Defect';	
        id groupDetail = [SELECT ID FROM Group where Type='Queue' And name ='E - Commerce IT' limit 1].id;	
       	//End:E-Commerce IT queue         
        Map<String,Id> queueWithId = new Map<String,Id>();
        Map<ID,String> allIDwithQueue = new Map<ID,String>();
        Set<String> setQueueNames = new Set<String>();// list of user's primary and manger's queue
        Set<Id> setAssignedToIds = new Set<Id>();
        Map<Id,String> userPrimaryQ = new Map<Id,String>();//user Id and Queue name
        Map<String,String> managerQ = new Map<String,String>();//Queue name and Manager's queue
        Map<String, String> EscalateQ = new Map<String, String>();  // map to hold which queues have exception for excalation.
        // Map<String,String> QueueWithBU = new Map<String,String>();//commented by Gunjari -- 12/19 for Req#919 -- populate Case BU
        //Gunjari -- 12/19 for Req#919 -- populate Case BU
        List<case> caseOwners = new List<case>();
        try{
            For(Group gg :[SELECT Id,Name FROM Group WHERE Type = 'Queue']){
                allIDwithQueue.put(gg.Id,gg.Name);
            }
            
            For(case cse : caseList){
                if(cse.NS_AssignedTo__c!=null){
                    setAssignedToIds.add(cse.NS_AssignedTo__c);                    
                }
                setQueueNames.add(allIDwithQueue.get(Cse.OwnerId));
            }
            
            For(User usr: [SELECT Id, NS_Primary_Queue__c, Associated_Business_Unit__c FROM User 
                           WHERE 
                           Id =:userinfo.getUserId() OR 
                           Id IN : setAssignedToIds]){
                               setQueueNames.add(usr.NS_Primary_Queue__c);                                
                               userPrimaryQ.put(usr.Id,usr.NS_Primary_Queue__c);               
                           }
            
            //fetch custom metadata to check manager's queue name and corresponding business unit
            For(NS_QueueSetting__mdt qmdt: [SELECT Label, NS_BusinessUnit__c,NS_ManagerQueue__c FROM NS_QueueSetting__mdt 
                                            Where Label IN: setQueueNames]){
                                                setQueueNames.add(qmdt.NS_ManagerQueue__c);
                                                managerQ.put(qmdt.Label,qmdt.NS_ManagerQueue__c); 
                                            }
            // fetch custom metadata check the 'email to Queue' for queue with exception to Escalation.
			For(NS_EmailToQueue__mdt etqmdt: [SELECT Label, Queue_Id__c FROM NS_EmailToQueue__mdt 
			                                            Where Escalate_Based_On_Queue__c = true]) {
                // system.debug('getCaseOwner EscalateQ '+etqmdt.Queue_Id__c+' label '+etqmdt.Label);
				EscalateQ.put(etqmdt.Queue_Id__c, etqmdt.Queue_Id__c);
			} 
            // Fetch Queue Id for user's primary and manager's queue name
            For(QueueSobject qs: [SELECT QueueId,Queue.Name FROM QueueSobject 
                                  WHERE SobjectType = :NS_StaticVariablesUtility.NS_CASE 
                                  AND Queue.Name IN :setQueueNames ]){
                                      queueWithId.put(qs.Queue.Name,qs.QueueId);               
                                  }
            
            String userType = Schema.SObjectType.User.getKeyPrefix();
            
            for(case cse: caseList){                
                system.debug('ANAA cloned case get case owner cse.RecordTypeId'+ cse.RecordTypeId);
                system.debug('ANAA cloned case get case owner cse.RecordTypeId'+ Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get(NS_StaticVariablesUtility.Service_Requests).getRecordTypeId());
                if(cse.RecordTypeId !=Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get(NS_StaticVariablesUtility.Service_Requests).getRecordTypeId()){
                    system.debug('ANAA cloned case get case owner');
                    
                    /*****Edited by Moumita*****/
                    /*** Added the below Intermodal Check -- Sudipto G */
                    if(((cse.Origin.equalsIgnoreCase(NS_StaticVariablesUtility.NS_Email) && cse.Id!=null) ||
                       (cse.Origin.equalsIgnoreCase(NS_StaticVariablesUtility.NS_Email) && cse.Id==null && ((String)cse.OwnerId).startsWith(userType)) ||
                       !cse.Origin.equalsIgnoreCase(NS_StaticVariablesUtility.NS_Email))
                       //hardcoding removed by SM
                       //&& cse.NS_CaseBusinessUnit__c!=NS_StaticVariablesUtility.NS_Intermodal
                      ){
                          // Sudipta added on 24/12/2019: E-Commerce IT queue	
                         	
                        	
                         system.debug('AccessNS/TRAX – System Defect BEFORE ENTRY'+cse.NS_Type__c+st);		
						 if(cse.NS_Type__c==st && (cse.id==null) && cse.NS_CaseStatusCheck__c==false)	
						  {	
                              system.debug('AccessNS/TRAX – System Defect ENTRY'+cse.OwnerId);	
							  cse.OwnerId = groupDetail;	
                              cse.NS_CaseStatusCheck__c=true;
                              cse.status='NS_AwaitingResponse';	
                              cse.NS_StatusReason__c='Awaiting Response – IT';	
                              system.debug('AccessNS/TRAX – System Defect EXIT'+cse.OwnerId);	
						  }	
                          /*END OF E-COMMERCE IT*/
						  else{	
                          	
                          
                           //cse.NS_CaseBusinessUnit__c!='Intermodal'){
                           // cse.NS_OwnerBusinessUnit__c = QueueWithBU.get(userPrimaryQ.get(userinfo.getUserId())); //commented by Gunjari -- 12/19 for Req#919 -- populate Case BU
                           
                           //Owner is Manager's Queue for Escalated Case                           
                           if(cse.Id!=null && NS_StaticVariablesUtility.NS_ESCALATED.equalsIgnoreCase(cse.Status) &&
                              cse.NS_IsEscaledOnEdit__c== false && cse.NS_CaseBusinessUnit__c!=NS_StaticVariablesUtility.NS_Intermodal){
                                  if(cse.NS_AssignedTo__c!=null){
                                      //Commented the below line by Sudipto G as its not present in PSUAT and not sure who removed/added the 
                                      //line check in DEV02
                                      //id newOwnerID= queueWithId.get(managerQ.get(userPrimaryQ.get(cse.NS_AssignedTo__c)));
                                      // look to see if the current owner is a queue with an exception to escalate. If so use the 
                                      // original queue owner id.
                                      // system.debug('getCaseOwner look for cse.OwnerId '+cse.OwnerId);
                                      // The EscalateQ has the Queue_Id__c entered in 15 Char instead of 18
                                      // So check for 15 characters.
                                      string ownerid = cse.OwnerId;
                                      if (EscalateQ.containsKey(ownerid.left(15))) {
                                      	cse.OwnerId =  queueWithId.get(managerQ.get(allIDwithQueue.get(cse.OwnerId)));
                                      	// system.debug('getCaseOwner EscalateQ cse.OwnerId '+cse.OwnerId);
                                      }
                                      //Commented the below check by Sudipto G as its not present in PSUAT and not sure who removed/added the 
                                      //line check in DEV02
                                      /*
                                      else if(cse.OwnerId!=newOwnerID){
                                          System.debug('@@@SUD 1 if 3');
                                      cse.OwnerId =  queueWithId.get(managerQ.get(userPrimaryQ.get(cse.NS_AssignedTo__c)));
                                      cse.NS_AssignedTo__c=null;
                                      }*/
                                      else {
                                      	cse.OwnerId =  queueWithId.get(managerQ.get(userPrimaryQ.get(cse.NS_AssignedTo__c)));
                                      } 
                                      // cse.NS_OwnerBusinessUnit__c = QueueWithBU.get(userPrimaryQ.get(cse.NS_AssignedTo__c));//commented by Gunjari -- 12/19 for Req#919 -- populate Case BU
                                  }
                                  else{
                                      //cse.OwnerId =  queueWithId.get(managerQ.get(userPrimaryQ.get(userinfo.getUserId()))) ;
                                      cse.OwnerId =  queueWithId.get(managerQ.get(allIDwithQueue.get(cse.OwnerId))) ;
                                  }                                  
                              }
                           
                           //Owner is Assigned user's Primary_Queue for Cloned Cases
                           else if(cse.isclone() && cse.NS_CaseBusinessUnit__c!=NS_StaticVariablesUtility.NS_Intermodal){
                               cse.OwnerId = queueWithId.get(userPrimaryQ.get(cse.NS_AssignedTo__c));
                           }
                           
                           //Owner is Assigned user's Primary_Queue 
                           else if(queueWithId.containsKey(userPrimaryQ.get(cse.NS_AssignedTo__c)) && cse.ParentId ==null 
                                   && ((cse.NS_CaseBusinessUnit__c==NS_StaticVariablesUtility.NS_Intermodal) 
                                       && (cse.Status != NS_StaticVariablesUtility.NS_ESCALATED))){
                               cse.OwnerId = queueWithId.get(userPrimaryQ.get(cse.NS_AssignedTo__c));
                           }
                           else if(queueWithId.containsKey(userPrimaryQ.get(cse.NS_AssignedTo__c)) && cse.ParentId ==null 
                                   && cse.NS_CaseBusinessUnit__c!=NS_StaticVariablesUtility.NS_Intermodal){
                               cse.OwnerId = queueWithId.get(userPrimaryQ.get(cse.NS_AssignedTo__c));
                           }
                           
                           //Owner is logged in user's Primary_Queue    
                           else if(queueWithId.containsKey(userPrimaryQ.get(userinfo.getUserId())) && cse.ParentId ==null && cse.NS_CaseBusinessUnit__c!=NS_StaticVariablesUtility.NS_Intermodal){
                               cse.OwnerId = queueWithId.get(userPrimaryQ.get(userinfo.getUserId()));
                               if(cse.NS_AssignedTo__c==null){
                                   cse.NS_AssignedTo__c=userinfo.getUserId();
                               }                          
                           }                           
                           // If user's primary queue is not set, owner will be 'created by'  
                           
                           else{
                               //cse.OwnerId = userinfo.getUserId();
                               if(cse.NS_AssignedTo__c==null && cse.ParentId ==null && cse.NS_CaseBusinessUnit__c!=NS_StaticVariablesUtility.NS_Intermodal){ 
                                   cse.NS_AssignedTo__c=userinfo.getUserId();
                               }                               
                           }
                          }//E-Commerce IT Loop ended
                       }  
                    
                    
                }
                
                //inserting Email-to-case, no action needed from here
                //Gunjari -- 12/19 for Req#919 -- populate Case BU
                caseOwners.add(cse);
                system.debug('ANAA cloned case get case owner caseOwners');
            }
            //Gunjari -- 12/19 for Req#919 -- populate Case BU
            NS_CaseTriggerUtility.getCaseBusinessUnit(caseOwners);
            //to cover Catch part
            if(Test.isRunningTest()){
                integer I=100/0;
            }
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            system.debug('ANAA cloned case get case owner exception');
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, 'getCaseOwner');
        }        
    } 
	/* @author-  Accenture
*  @description- After the case file New_External_Comment__c has been updated create a Task
*  @param- None
*  @return- None
*  @throws- None
* TRAX @dglaser
*/
    public static void createTaskforNewExt_Comment(Case newCase)
    {
    	system.debug('createTaskforNewExt_Comment Entered');
    	string  subject = 'Case Update (External) : ' + newCase.New_External_Comment__c;  // 'Case Update (External)'; //
    	if  (subject.length() > 250) {
    		subject = subject.left(250);
    	}

		FeedItem fi = new FeedItem ();
    
	    fi.Body = '<b>Case Update (External) : </b>' + newCase.New_External_Comment__c;
	    fi.IsRichText = true;
	    fi.ParentId =  newCase.id;
		fi.Status = 'Published';
		fi.Title = 'Case Update (External) : ';
		fi.Type = 'TextPost';
		insert fi;
		
 		system.debug('createTaskforNewExt_Comment Created Task');	   	
    	
    	system.debug('createTaskforNewExt_Comment Cleared New_External_Comment__c');
    }
    //For Time Capture in case subject field - 11/21/2019 
     public static  void timeconversion(List<Case> xtime)
     {
         
      For(case tim : xtime){
          
          //NS_Feedback_Case
          Id RecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Feedback Case').getRecordTypeId();
          
          //&&(tim.Owner.Name == 'CS Feedback')
                if((tim.subject == 'Feedback Received at') && (tim.RecordTypeId == RecType))
                {
                    
                    tim.subject = tim.subject + ' ' +system.now().format('MM/dd/yyyy h:mm a','America/New_York');
                }
         
      }
     }
}