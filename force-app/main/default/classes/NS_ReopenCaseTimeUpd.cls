/**@author  Accenture
* @Created Date 2019-12-23
* @version  1.0
* @description This class conatins method to populate the Reopen case date field.
***************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
***************************************************************************

----------------------------------------------------------------------------
*/ 

public class NS_ReopenCaseTimeUpd {
    /*Class Name*/ 
    private static final String CLASS_NAME='NS_ReopenCaseTimeUpd';
    /*Method Name*/ 
    private static final String METHOD_NAME='reopenCaseLogic';
    
    public static void reopenCaseLogic(list<case> oldcase,list<case> newcase)
    {
        Try{
            //map to hold the case old values with id before update
            Map<id,case> oldcaseMap= new Map<id,case>();
            
            for(case cs3:oldcase)
            {
                oldcaseMap.put(cs3.id,cs3);                
            }
            //list of cases
            List<case> updcase = new List<case>();
            
            for(case cs4:newcase)
            {
                system.debug('NEWMAP'+cs4.status +'OLDMAP'+oldcaseMap.get(cs4.id).status);
                //Check if case is reopened
                if(cs4.status!=oldcaseMap.get(cs4.id).status && (oldcaseMap.get(cs4.id).status=='NS_Closed' || oldcaseMap.get(cs4.id).status=='NS_Cancelled'))
                {
                     long dateicc;
                    
                    if(cs4.NS_Last_Activity_Time__c!=NULL)
                        {
                            //To calcualte the hours between reopen time and last activity on case
                            //system.debug('I AM IN dateicc');
                           //dateicc= ((system.now().getTime())/1000/60/60)-((cs4.NS_Last_Activity_Time__c.getTime())/1000/60/60);
                           dateicc= ((system.now().getTime())/1000/60/60)-((cs4.ClosedDate.getTime())/1000/60/60);
                        }
                    else
                    {
                         dateicc= ((system.now().getTime())/1000/60/60)-((cs4.ClosedDate.getTime())/1000/60/60);
                    }
                   // system.debug('ANY SUDI:'+dateicc);
                    //set the value for 24 hours 
                     long oneday=24;
                     long addcounter;
                    
                    if(dateicc!=null && dateicc>=oneday)
                    {//to count how many times it crosses 24 hours
                     addcounter=dateicc/oneday;
                    }
                    
                    if(cs4!=null && dateicc!=null && dateicc>=oneday){
                       if(cs4.NS_Counter_Activity__c==NULL)
                            {
                            //to set the counter    
                            cs4.NS_Counter_Activity__c= addcounter;
                            }
                            else
                            {
                             if(cs4.status!=oldcaseMap.get(cs4.id).status && (oldcaseMap.get(cs4.id).status=='NS_Closed' || oldcaseMap.get(cs4.id).status=='NS_Cancelled'))
                             {
                             cs4.NS_Counter_Activity__c=addcounter;
                             }
                            cs4.NS_Counter_Activity__c=cs4.NS_Counter_Activity__c+addcounter;
                            }
                    }
                    //system.debug('SUDI: I AM HERE TO UPDATE ACTIVITY TIME');
                    //update the Last activity field once case is reopend.
                    cs4.NS_Last_Activity_Time__c=system.now();
                    
                    
                }
                //logic to calculate the hours between case closure and create time if no activity has occured for 24 hours.
                else if(cs4.status!=oldcaseMap.get(cs4.id).status && (cs4.status=='NS_Closed' || cs4.status=='NS_Cancelled'))
                {
                    long dateicc;
                    if(cs4.NS_Last_Activity_Time__c==NULL)
                    {
                    dateicc= ((system.now().getTime())/1000/60/60)-((cs4.CreatedDate.getTime())/1000/60/60);
                    }
                    else
                    {
                    dateicc= ((system.now().getTime())/1000/60/60)-((cs4.NS_Last_Activity_Time__c.getTime())/1000/60/60);  
                    }
                        
                    
                     long oneday=24;
                     long addcounter;
                    
                    if(dateicc!=null && dateicc>=oneday)
                    {//to count how many times it crosses 24 hours
                     addcounter=dateicc/oneday;
                    }
                    
                    if(cs4!=null && dateicc!=null && dateicc>=oneday){
                       if(cs4.NS_Counter_Activity__c==NULL)
                            {
                            //to set the counter    
                            cs4.NS_Counter_Activity__c= addcounter;
                            }
                            else
                            {
                            cs4.NS_Counter_Activity__c=cs4.NS_Counter_Activity__c+addcounter;
                            }
                    }
                }
            }
            
            
        }
        
        
        catch(Exception exp) {
            //inserting a record in Exception object
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME,METHOD_NAME); 
        } 
    }
    
}