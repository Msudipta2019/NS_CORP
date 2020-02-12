public class NSSalesCampaignMemberHelper { 
    
    private static final String CLASS_NAME = 'NSSalesCampaignMemberHelper';
    private static final String METHOD_NAME1='insertCreateRecord';
    private static final String METHOD_NAME2='deleteCreateRecord';
    private static final String METHOD_NAME3='updateCreateRecord';
    
    
    
    public static void insertCreateRecord(List<CampaignMember> campmemberList){
        
        Try{
            
            List<Campaign_Member_Log__c> cmlList = new List<Campaign_Member_Log__c>();
            
            for(CampaignMember cmp : campmemberList){
                system.debug('cmp' +cmp.FirstName +cmp.LastName);
                
                Campaign_Member_Log__c cml = new Campaign_Member_Log__c();
                
               /* Datetime now = Datetime.now();
                Integer offset = UserInfo.getTimezone().getOffset(now);
                Datetime local = now.addSeconds(offset/1000);*/
                Date todaysDate = Date.today();
              
                cml.Name = cmp.FirstName+''+cmp.LastName;
                cml.NSSales_Status__c = cmp.Status;
                cml.NSSales_Object__c = 'CampaignMember';
                cml.NSSales_Action__c = 'Campaign Member Added';
               // cml.NSSales_Audit_Date__c = local;
                cml.NSSales_Audit_Date__c = todaysDate;
                cml.NSSales_Campaign__c = cmp.CampaignId;
                ///edited by Moumita
                if(cmp.LeadId != NULL)
                    cml.NSSales_Type__c = 'Lead';
                if(cmp.ContactId != NULL)
                    cml.NSSales_Type__c = 'Contact';
                cml.NSSales_First_Name__c = cmp.FirstName;
                cml.NSSales_Last_Name__c = cmp.LastName;
                cml.NSSales_Company__c = cmp.CompanyOrAccount;
                ///end of edit by Moumita
                cmlList.add(cml);
            }
            insert cmlList;
        }
        catch(Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME1);
        } 
    }
    
    public static void deleteCreateRecord(List<CampaignMember> campmemberList){
        List<Campaign_Member_Log__c> cmlList = new List<Campaign_Member_Log__c>();
        Try{
            for(CampaignMember cmp : campmemberList){
                
                Campaign_Member_Log__c cml = new Campaign_Member_Log__c();
                
                /*Datetime now = Datetime.now();
                Integer offset = UserInfo.getTimezone().getOffset(now);
                Datetime local = now.addSeconds(offset/1000);*/
                Date todaysDate = Date.today();
                
                cml.Name = cmp.FirstName+''+cmp.LastName;
                cml.NSSales_Status__c = cmp.Status;
                cml.NSSales_Object__c = 'CampaignMember';
                cml.NSSales_Action__c = 'Campaign Member Removed';
              //  cml.NSSales_Audit_Date__c = local;
                cml.NSSales_Audit_Date__c = todaysDate;
                cml.NSSales_Campaign__c = cmp.CampaignId;
                //Edited by Moumita
                cml.NSSales_First_Name__c = cmp.FirstName;
                cml.NSSales_Last_Name__c = cmp.LastName;
                cml.NSSales_Company__c = cmp.CompanyOrAccount;
                if(cmp.LeadId != NULL)
                    cml.NSSales_Type__c = 'Lead';
                if(cmp.ContactId != NULL)
                    cml.NSSales_Type__c = 'Contact';
                //End of edit by Moumita
                cmlList.add(cml);
            }
            insert cmlList;
        }
        catch(Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME2);
        } 
    }
    
    public static void updateCreateRecord(Map<Id,CampaignMember> newMap, Map<Id,CampaignMember> oldMap){
        
        
        List<Campaign_Member_Log__c> cmlList = new List<Campaign_Member_Log__c>();
        
        Try{
            
            for(CampaignMember cmp :newMap.Values()){
                if(oldMap.get(cmp.Id).Status != cmp.Status) {
                    
                    Campaign_Member_Log__c cml1 = new Campaign_Member_Log__c();
                    
                  /*  Datetime now = Datetime.now();
                    Integer offset = UserInfo.getTimezone().getOffset(now);
                    Datetime local = now.addSeconds(offset/1000);*/
                    Date todaysDate = Date.today();
                    cml1.Name = cmp.FirstName+''+cmp.LastName;
                    cml1.NSSales_Status__c = cmp.Status;
                    cml1.NSSales_Object__c = 'CampaignMember';
                    cml1.NSSales_Action__c = 'Status Updated';
                  //  cml1.NSSales_Audit_Date__c = local;
                    cml1.NSSales_Audit_Date__c = todaysDate;
                    cml1.NSSales_Campaign__c = cmp.CampaignId;
                    cml1.NSSales_New_Value__c = cmp.Status;
                    cml1.NSSales_Old_Value__c = oldMap.get(cmp.Id).Status;
                    //Edited by Moumita
                    cml1.NSSales_First_Name__c = cmp.FirstName;
                    cml1.NSSales_Last_Name__c = cmp.LastName;
                    cml1.NSSales_Company__c = cmp.CompanyOrAccount;
                    if(cmp.LeadId != NULL)
                        cml1.NSSales_Type__c = 'Lead';
                    if(cmp.ContactId != NULL)
                        cml1.NSSales_Type__c = 'Contact';
                    //End of edit by Moumita
                    cmlList.add(cml1);
                }
                
                /*    Member Name can't be edited : Handled by Validation Rule
*   if(oldMap.get(cmp.Id).FirstName != cmp.FirstName && oldMap.get(cmp.Id).LastName != cmp.LastName) {

Campaign_Member_Log__c cml2 = new Campaign_Member_Log__c();

cml2.Name = cmp.FirstName+''+cmp.LastName;
cml2.NSSales_Status__c = cmp.Status;
cml2.NSSales_Object__c = 'CampaignMember';
cml2.NSSales_Action__c = 'Name Change';
cml2.NSSales_Audit_Date__c = System.now();
cml2.NSSales_Campaign__c = cmp.CampaignId;
cml2.NSSales_New_Value__c = cmp.FirstName+''+cmp.LastName;
cml2.NSSales_Old_Value__c = oldMap.get(cmp.Id).FirstName +''+oldMap.get(cmp.Id).LastName;
//Edited by Moumita
cml2.NSSales_First_Name__c = cmp.FirstName;
cml2.NSSales_Last_Name__c = cmp.LastName;
cml2.NSSales_Company__c = cmp.CompanyOrAccount;
if(cmp.LeadId != NULL)
cml2.NSSales_Type__c = 'Lead';
if(cmp.ContactId != NULL)
cml2.NSSales_Type__c = 'Contact';
//End of edit by Moumita
cmlList.add(cml2);
}
*/  
            }
            insert cmlList;
        }
        catch(Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME3);
        } 
    }
}