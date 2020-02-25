/**@author  Accenture
* @Created Date 2020-01-10
* @version  1.0
* @description This class is used by Case trigger to update Case owner, status and status reason for Interaction type:'AccessNS/TRAX – System Defect'
***************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
***************************************************************************

----------------------------------------------------------------------------
*/ 


public class NS_CaseUpdateforSystemDefect	 {
    
    /*Class Name*/ 
    private static final String CLASS_NAME='NS_CaseUpdateforSystemDefect';
    /*Method Name*/ 
    private static final String METHOD_NAME='caseUpdateforSystemDefect';
    public static void caseUpdateforSystemDefect(List<Case> newCases){
        
        
        try{
            string st='AccessNS/TRAX - System Defect';
            id groupDetail = [SELECT ID FROM Group where Type='Queue' And Name ='E - Commerce IT' limit 1].id;
            
            for(Case cc2 : newCases){
               
                system.debug('Sudipta UAT test'+cc2.NS_Type__c+''+cc2.NS_CaseStatusCheck__c);
                if(cc2.NS_Type__c==st && cc2.NS_CaseStatusCheck__c==false && cc2.NS_RACFUserID__c!=NULL )
                {
                    
                    if(cc2.OwnerId!=groupDetail && groupDetail!= null)
                    {
                        cc2.OwnerId=groupDetail;
                    }
                    cc2.status='NS_AwaitingResponse';
                    cc2.NS_CaseStatusCheck__c=true;

                    cc2.NS_StatusReason__c='Awaiting Response – IT';
                    
                }
            }
        }
        catch(Exception exp) {
            //inserting a record in Exception object
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME,METHOD_NAME); 
        } 
        
    }
}