/**@author  ConnectNS (GP)
* NS_BatchforResponseTimeInsert 
* @Created Date 2019-11-01
* @version  1.0
* @description This is a batchable and schedulable class that insets the first response time into the account
* based on thge first Call or email task cretaed by the user. Note - the NS_Flag has to be FALSE
*
*Modification History 
*************************************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
*************************************************************************************************

-------------------------------------------------------------------------------------------------

*/
global class NS_BatchforResponseTimeInsert implements Database.Batchable<sObject>,Schedulable{
  //method that is executed upon scheduling
  global void execute(SchedulableContext sc){
      NS_BatchForResponseTimeInsert batchForResponseTimeInsert = new  NS_BatchForResponseTimeInsert();
      Database.executeBatch(batchForResponseTimeInsert,200);
  }
    //start function that returns a list based on the query 
    global Database.QueryLocator start(Database.BatchableContext BC){
        Date dtCaseResponseStartDate;   //tracks the case creation date, when to start the population of response tmes
        If (Label.Batch_Case_Response_Time_Start_Date!=NULL ) { //uses label for customization. 
           dtCaseResponseStartDate = Date.parse( Label.Batch_Case_Response_Time_Start_Date); //get from a label
        }
 //       else {
 //             dtCaseResponseStartDate = Date.parse('09/01/2018'); //hardcode if no label available
 //       }  
        //compiles query
        string query = 'Select id, createddate, NS_Time_To_Response__c, CaseNumber,' +
              '(select id, createddate,  tasksubtype  from tasks where NS_Flag__c = False AND (TaskSubtype=\'Call\' OR TaskSubtype=\'Email\')' + 
               'order by createddate Limit 1)' + 
              'from case where NS_Time_To_Response__c = null AND createddate > :dtCaseResponseStartDate'; 
        return Database.getQueryLocator(query);
    }
    //business logic for batch
    global void execute(Database.BatchableContext BC,List<sObject> lstCases){
       processCaseResponseTimes (lstCases);
    }
    //any after batch functionality
    global void finish(Database.BatchableContext BC) {

    }
    
 /**@author  ConnectNS
* @Created Date 2019-11-01
* @description processes cases to calculate first response times. 
* Only for cases where response time is NULL.
*/    
	private void processCaseResponseTimes(List<case>lstCasesToProcess){
       
        List <case> lstCasesToUpdate = new List<case>();
        for (Case c: lstCasesToProcess) {
            If (c.Tasks != NULL) { //case does not have tasks
                if (c.tasks.size() > 0){ //if tasks are not null, but length is 0
                    //calculate time in hours
                     c.NS_Time_To_Response__c=(c.Tasks[0].CreatedDate.getTime() - c.CreatedDate.getTime())/1000/60/60;
                    lstCasesToUpdate.add(c); //add to the list to be updated
            	}
        	}
        }
        // update using database functions to enable updating cases that do not cretaew validation errors.
   		NS_StaticVariablesUtility.bSkipTrigger = True; //to skip the case trigger
        Database.SaveResult[] SR = Database.update(lstCasesToUpdate, false);
        NS_StaticVariablesUtility.bSkipTrigger = false; //reset the trigger skipping variable
    }
}