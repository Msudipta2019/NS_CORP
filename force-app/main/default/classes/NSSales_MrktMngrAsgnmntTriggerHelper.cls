/**@author  Accenture
* @Created Date Oct,2019
* @version  1.0
* @description This class conatins methods which are invoked by NSSales_MarketingManagerAssignmentTrigger
*/ 

public class NSSales_MrktMngrAsgnmntTriggerHelper {
    
    private static final String CLASS_NAME = 'NSSales_MrktMngrAsgnmntTriggerHelper';
    private static final String METHOD_NAME1 = 'createLogOnMktMngrAsgnmntRecInsert';
    private static final String METHOD_NAME2 = 'createLogOnMktMngrAsgnmntRecRemove';
    private static final String METHOD_NAME3 = 'createLogOnMktMngrAsgnmntRecUpdate';
    private static final String METHOD_NAME4 = 'sendEmailToManagersOnRecCreate';
    private static final String METHOD_NAME5 = 'sendEmailToManagersOnRecDelete';
    private static final String METHOD_NAME6 = 'sendEmailToManagersOnRecUpdate';
    private static final String METHOD_NAME7 = 'autoUpdatePACinMMA';
    private static final String METHOD_NAME8 = 'updateaccountClassification';
    private static final String METHOD_NAME9 = 'deleteAndUpdateDupAccountClassification';   
    /*This method creates a new Market Manager Assignment Log record everytime a Market Manager Assignment gets created*/
    public static void createLogOnMktMngrAsgnmntRecInsert(List<NSSales_Marketing_Manager_Assignment__c> newMarketManagers){
        
        List<NSSales_MarketingManagerAssignmentLog__c> mktMngrLogRecList = new List<NSSales_MarketingManagerAssignmentLog__c>();
        Date todaysDate = Date.today();
        for(NSSales_Marketing_Manager_Assignment__c newMarketManager : newMarketManagers){
            
            NSSales_MarketingManagerAssignmentLog__c newLogRec= new NSSales_MarketingManagerAssignmentLog__c();
            newLogRec.NSSales_Account__c = newMarketManager.NSSales_Account__c;
            newLogRec.NSSales_MarketingManager__c = newMarketManager.NSSales_MarketingManagerNameHidden__c;
            newLogRec.NSSales_Role__c = newMarketManager.NSSales_Role__c;
            /*   if(newMarketManager.NSSales_AssociatedBusinessUnit__c != null){
newLogRec.NSSales_AssociatedBusinessUnit__c = newMarketManager.NSSales_AssociatedBusinessUnit__c;
}*/
            newLogRec.NSSales_BusinessUnit__c = newMarketManager.NSSales_BusinessUnit__c;
            newLogRec.NSSales_Action__c = 'Marketing Manager Assignment Added';
            newLogRec.NSSales_ChangeDate__c =  todaysDate;
            mktMngrLogRecList.add(newLogRec);
        }
        try{
            if(!mktMngrLogRecList.isEmpty()){
                Database.insert(mktMngrLogRecList,false);
            }
        }
        catch(Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME1);
        } 
    }
    
    /*This method creates a new Market Manager Assignment Log record everytime a Market Manager Assignment gets removed*/
    public static void createLogOnMktMngrAsgnmntRecRemove(List<NSSales_Marketing_Manager_Assignment__c> deletedMarketManagers){
        
        List<NSSales_MarketingManagerAssignmentLog__c> mktMngrLogRecList = new List<NSSales_MarketingManagerAssignmentLog__c>();
        Date todaysDate = Date.today();
        for(NSSales_Marketing_Manager_Assignment__c deletedMarketManager : deletedMarketManagers){
            
            NSSales_MarketingManagerAssignmentLog__c newLogRec= new NSSales_MarketingManagerAssignmentLog__c();
            newLogRec.NSSales_Account__c = deletedMarketManager.NSSales_Account__c;
            newLogRec.NSSales_MarketingManager__c = deletedMarketManager.NSSales_MarketingManagerNameHidden__c;
            newLogRec.NSSales_Role__c = deletedMarketManager.NSSales_Role__c;
            /* if(deletedMarketManager.NSSales_AssociatedBusinessUnit__c != null){
newLogRec.NSSales_AssociatedBusinessUnit__c = deletedMarketManager.NSSales_AssociatedBusinessUnit__c;
}*/
            newLogRec.NSSales_BusinessUnit__c = deletedMarketManager.NSSales_BusinessUnit__c;
            newLogRec.NSSales_Action__c = 'Marketing Manager Assignment Removed';
            newLogRec.NSSales_ChangeDate__c =  todaysDate;
            mktMngrLogRecList.add(newLogRec);
        }
        try{
            if(!mktMngrLogRecList.isEmpty()){
                Database.insert(mktMngrLogRecList,false);
                
            }
        }
        catch(Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME2);
        } 
    }
    
    /*This method creates a new Market Manager Assignment Log record everytime a Market Manager Assignment gets updated*/
    public static void createLogOnMktMngrAsgnmntRecUpdate(Map<Id,NSSales_Marketing_Manager_Assignment__c> newMarketManagersMap, Map<Id,NSSales_Marketing_Manager_Assignment__c> oldMarketManagersMap){
        
        List<NSSales_MarketingManagerAssignmentLog__c> mktMngrLogRecList = new List<NSSales_MarketingManagerAssignmentLog__c>();
        Date todaysDate = Date.today();
        for(NSSales_Marketing_Manager_Assignment__c changedMktMngrRec : newMarketManagersMap.values()){
            
            if(oldMarketManagersMap.get(changedMktMngrRec.id).NSSales_Role__c != changedMktMngrRec.NSSales_Role__c){
                
                NSSales_MarketingManagerAssignmentLog__c newLogRec= new NSSales_MarketingManagerAssignmentLog__c();
                newLogRec.NSSales_Account__c = changedMktMngrRec.NSSales_Account__c;
                newLogRec.NSSales_MarketingManager__c = changedMktMngrRec.NSSales_MarketingManagerNameHidden__c;
                newLogRec.NSSales_Role__c = changedMktMngrRec.NSSales_Role__c;
                /* if(changedMktMngrRec.NSSales_AssociatedBusinessUnit__c != null){
newLogRec.NSSales_AssociatedBusinessUnit__c = changedMktMngrRec.NSSales_AssociatedBusinessUnit__c;
}*/
                newLogRec.NSSales_BusinessUnit__c = changedMktMngrRec.NSSales_BusinessUnit__c;
                newLogRec.NSSales_OldValue__c = oldMarketManagersMap.get(changedMktMngrRec.id).NSSales_Role__c;
                newLogRec.NSSales_NewValue__c = changedMktMngrRec.NSSales_Role__c;
                newLogRec.NSSales_Action__c = 'Marketing Manager Role Updated';
                newLogRec.NSSales_ChangeDate__c =  todaysDate;
                mktMngrLogRecList.add(newLogRec); 
            }
            if(oldMarketManagersMap.get(changedMktMngrRec.id).NSSales_MarketingManager__c != changedMktMngrRec.NSSales_MarketingManager__c){
                NSSales_MarketingManagerAssignmentLog__c newLogRec= new NSSales_MarketingManagerAssignmentLog__c();
                newLogRec.NSSales_Account__c = changedMktMngrRec.NSSales_Account__c;
                newLogRec.NSSales_MarketingManager__c = changedMktMngrRec.NSSales_MarketingManagerNameHidden__c;
                newLogRec.NSSales_Role__c = changedMktMngrRec.NSSales_Role__c;
                /*if(changedMktMngrRec.NSSales_AssociatedBusinessUnit__c != null){
newLogRec.NSSales_AssociatedBusinessUnit__c = changedMktMngrRec.NSSales_AssociatedBusinessUnit__c;
}*/
                newLogRec.NSSales_BusinessUnit__c = changedMktMngrRec.NSSales_BusinessUnit__c;
                newLogRec.NSSales_OldValue__c = oldMarketManagersMap.get(changedMktMngrRec.id).NSSales_MarketingManagerNameHidden__c;
                newLogRec.NSSales_NewValue__c = changedMktMngrRec.NSSales_MarketingManagerNameHidden__c;
                newLogRec.NSSales_Action__c = 'Marketing Manager Updated';
                newLogRec.NSSales_ChangeDate__c =  todaysDate;
                mktMngrLogRecList.add(newLogRec); 
            }
            
        }
        try{
            if(!mktMngrLogRecList.isEmpty()){
                Database.insert(mktMngrLogRecList,false);
                
            }
        }
        catch(Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,METHOD_NAME3);
        } 
        
    }
    
    /*on addition of a marketing manager to an Account,  this method notifies the assignee about it */
    public static void sendEmailToManagersOnRecCreate(List<NSSales_Marketing_Manager_Assignment__c> mrktMngrAssgnmtList){
        try{
            String recipientName = '';
            String recipientEmail = '';
            Set<id> accIdSet = new Set<id>();
            Map<id,Account> accountDetails = new Map<id,Account>();
            
            for(NSSales_Marketing_Manager_Assignment__c mrktMngrAssgnmtRec : mrktMngrAssgnmtList) {
                accIdSet.add(mrktMngrAssgnmtRec.NSSales_Account__c);
            }
            
            for(Account acc : [SELECT id, name from Account WHERE id IN : accIdSet]){
                accountDetails.put(acc.id, acc);
            }
            
            Messaging.SingleEmailMessage [] emails = new Messaging.SingleEmailMessage[]{};
                for(NSSales_Marketing_Manager_Assignment__c mrktMngrAssgnmtRec : mrktMngrAssgnmtList){
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setSubject('You have been added to a Marketing Manager Assignment in ConnectNS');
                    if(mrktMngrAssgnmtRec.NSSales_MarketingManager__c != null )
                    {
                        recipientName = mrktMngrAssgnmtRec.NSSales_MarketingManagerNameHidden__c;
                        recipientEmail = mrktMngrAssgnmtRec.NSSales_MarketingManagerEmailHidden__c;                        
                    }
                    
                    email.setToAddresses(new List<String> {recipientEmail});
                    String body='';
                    body +='<html><body>';
                    body += 'Hi ' +recipientName+ ',<br/><br/>You have been added to the following Account: ';
                    body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+mrktMngrAssgnmtRec.NSSales_Account__c+'">'+accountDetails.get(mrktMngrAssgnmtRec.NSSales_Account__c).name+'</a>,';
                    //  body += ' as a Marketing Manager ';//Changes for D-1824
                    body += ' with the role <b>'+mrktMngrAssgnmtRec.NSSales_Role__c +'</b>.';
                    email.setHtmlBody(body);
                    emails.add(email);
                }
            system.debug('Size' +emails.size());
            Messaging.sendEmail(emails);
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME4);
        }   
    }
    
    /*on deletion of a marketing manager to an Account,  this method notifies the assignee about it */
    public static void sendEmailToManagersOnRecDelete(List<NSSales_Marketing_Manager_Assignment__c> delmrktMngrAssgnmtList){
        try{
            String recipientName = '';
            String recipientEmail = '';
            Set<id> accIdSet = new Set<id>();
            Map<id,Account> accountDetails = new Map<id,Account>();
            
            for(NSSales_Marketing_Manager_Assignment__c mrktMngrAssgnmtRec : delmrktMngrAssgnmtList) {
                accIdSet.add(mrktMngrAssgnmtRec.NSSales_Account__c);
            }
            
            for(Account acc : [SELECT id, name from Account WHERE id IN : accIdSet]){
                accountDetails.put(acc.id, acc);
            }
            
            Messaging.SingleEmailMessage [] emails = new Messaging.SingleEmailMessage[]{};
                for(NSSales_Marketing_Manager_Assignment__c mrktMngrAssgnmtRec : delmrktMngrAssgnmtList){
                    
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setSubject('You have been removed from a Marketing Manager Assignment in ConnectNS');
                    if(mrktMngrAssgnmtRec.NSSales_MarketingManager__c != null)
                    {
                        recipientName = mrktMngrAssgnmtRec.NSSales_MarketingManagerNameHidden__c;
                        recipientEmail = mrktMngrAssgnmtRec.NSSales_MarketingManagerEmailHidden__c;                        
                    }
                    email.setToAddresses(new List<String> {recipientEmail});
                    String body='';
                    body +='<html><body>';	
                    //body += 'Hi ' +recipientName+ ',<br/><br/>Your Marketing Manager Assignment as '+ mrktMngrAssgnmtRec.NSSales_Role__c +' has been removed from the following Account: ';  //changes on D-1824
                    body += 'Hi ' +recipientName+ ',<br/><br/>Your assignment as '+ mrktMngrAssgnmtRec.NSSales_Role__c +' has been removed from the following Account: ';  //Changes for D-1824
                    body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+mrktMngrAssgnmtRec.NSSales_Account__c+'">'+accountDetails.get(mrktMngrAssgnmtRec.NSSales_Account__c).name+'</a>.';
                    email.setHtmlBody(body);
                    emails.add(email);
                }
            
            Messaging.sendEmail(emails);
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME5);
        }   
    }
    
    
    public static void sendEmailToManagersOnRecUpdate(Map<Id,NSSales_Marketing_Manager_Assignment__c> newMarketManagersMap, Map<Id,NSSales_Marketing_Manager_Assignment__c> oldMarketManagersMap){
        try{
            String recipientName = '';
            String recipientEmail = '';
            Set<id> accIdSet = new Set<id>();
            Map<id,Account> accountDetails = new Map<id,Account>();
            List<NSSales_Marketing_Manager_Assignment__c> oldManagersList = new List<NSSales_Marketing_Manager_Assignment__c>();
            List<NSSales_Marketing_Manager_Assignment__c> newManagersList = new List<NSSales_Marketing_Manager_Assignment__c>();
            
            for(NSSales_Marketing_Manager_Assignment__c mrktMngrAssgnmtRec : newMarketManagersMap.values()) {
                accIdSet.add(mrktMngrAssgnmtRec.NSSales_Account__c);
            }
            
            for(Account acc : [SELECT id, name from Account WHERE id IN : accIdSet]){
                accountDetails.put(acc.id, acc);
            }
            Messaging.SingleEmailMessage [] emails = new Messaging.SingleEmailMessage[]{};
                for(NSSales_Marketing_Manager_Assignment__c changedMktMngrRec : newMarketManagersMap.values()){
                    
                    if(oldMarketManagersMap.get(changedMktMngrRec.id).NSSales_Role__c != changedMktMngrRec.NSSales_Role__c
                       //Added to prevent mail invocation
                       && (oldMarketManagersMap.get(changedMktMngrRec.id).Primary_Account_Classification__c == changedMktMngrRec.Primary_Account_Classification__c)
                       
                      ){
                          System.debug('1');
                          Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                          email.setSubject('Your role has been updated in a Marketing Manager Assignment in ConnectNS');
                          if(changedMktMngrRec.NSSales_MarketingManager__c != null){
                              recipientName = changedMktMngrRec.NSSales_MarketingManagerNameHidden__c;
                              recipientEmail = changedMktMngrRec.NSSales_MarketingManagerEmailHidden__c;   
                          }
                          email.setToAddresses(new List<String> {recipientEmail});
                          String body='';
                          body +='<html><body>';
                          body += 'Hi ' +recipientName+ ',<br/><br/>Your role has been updated for the following Account: ';
                          body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+changedMktMngrRec.NSSales_Account__c+'">'+accountDetails.get(changedMktMngrRec.NSSales_Account__c).name+'</a>,';
                          body += ' from '+oldMarketManagersMap.get(changedMktMngrRec.id).NSSales_Role__c+' to <b>'+changedMktMngrRec.NSSales_Role__c+'</b>.';
                          email.setHtmlBody(body);
                          emails.add(email);
                      }
                    if(oldMarketManagersMap.get(changedMktMngrRec.id).NSSales_MarketingManager__c != changedMktMngrRec.NSSales_MarketingManager__c){
                        
                        oldManagersList.add(oldMarketManagersMap.get(changedMktMngrRec.id));
                        newManagersList.add(changedMktMngrRec);
                    }
                }
            Messaging.sendEmail(emails);
            
            if(!oldManagersList.isEmpty()){
                sendEmailToManagersOnRecDelete(oldManagersList);
            }
            if(!newManagersList.isEmpty()){
                sendEmailToManagersOnRecCreate(newManagersList);
            }
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME6);
        }   
        
    } 
    
    /*For R-3291 Update 12/3: Updating all the PAC Associated to that user with that account when anyone of the MMA's PAC is changed*/
    public static void autoUpdatePACinMMA(List<NSSales_Marketing_Manager_Assignment__c> marketingManagerList)
    {
        Set<id> setAccId=new Set<id>();
        Set <id> setUserId=new Set<id>();
        List<NSSales_Marketing_Manager_Assignment__c> allRelatedMarkMan = new List<NSSales_Marketing_Manager_Assignment__c>();
        Map<String,List<NSSales_Marketing_Manager_Assignment__c>> mapAllMMA = new Map<String,List<NSSales_Marketing_Manager_Assignment__c>>();
        List<NSSales_Marketing_Manager_Assignment__c> ListToFinalUpdate = new List<NSSales_Marketing_Manager_Assignment__c>();
        try
        {
            for(NSSales_Marketing_Manager_Assignment__c MarkMan : marketingManagerList){
                setAccId.add(MarkMan.NSSales_Account__c);
                setUserId.add(MarkMan.NSSales_MarketingManager__c);
            }
            allRelatedMarkMan= [select id,Name,Primary_Account_Classification__c,NSSales_Account__c,NSSales_MarketingManager__c from NSSales_Marketing_Manager_Assignment__c
                                where NSSales_Account__c in: setAccId and NSSales_MarketingManager__c in: setUserId];
            //system.debug('SRV MMP '+allRelatedMarkMan);
            for(NSSales_Marketing_Manager_Assignment__c MarkManmap :allRelatedMarkMan){
                String mapKey = MarkManmap.NSSales_MarketingManager__c + ':'+MarkManmap.NSSales_Account__c;
                if(mapAllMMA.keyset().contains(mapKey)){
                    List<NSSales_Marketing_Manager_Assignment__c> maplist =mapAllMMA.get(mapKey); 
                    maplist.add(MarkManmap);
                    mapAllMMA.Put(mapKey,maplist);
                }else{
                    
                    mapAllMMA.Put(mapKey,new List<NSSales_Marketing_Manager_Assignment__c>{MarkManmap});
                }
                
            }
            //system.debug('SRV MMP Mapu '+mapAllMMA);
            
            For(NSSales_Marketing_Manager_Assignment__c newValMan : marketingManagerList){
                String newKey =newValMan.NSSales_MarketingManager__c + ':'+newValMan.NSSales_Account__c;
                List<NSSales_Marketing_Manager_Assignment__c> ListToUpdate = mapAllMMA.Get(newKey);
                //System.debug('SRV SS '+ListToUpdate);
                For(NSSales_Marketing_Manager_Assignment__c upd :ListToUpdate){
                    if(upd.Primary_Account_Classification__c!=newValMan.Primary_Account_Classification__c)
                    {
                        upd.Primary_Account_Classification__c=newValMan.Primary_Account_Classification__c;
                        ListToFinalUpdate.add(upd);
                    }
                    
                }
            }
            system.debug('SRV FINAL ListToFinalUpdate '+ListToFinalUpdate);
            
            Update ListToFinalUpdate;
            
        }
        catch(Exception e)
        {
            NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME7);
        }
    }
    
    
    public static void updateaccountClassification(List<NSSales_Marketing_Manager_Assignment__c>mrktmanagr)   
    {                               
        List<BU__c> accClass=new List<BU__c>();
        List<id> priClass=new List<id>();
        try
        {
            
            for(NSSales_Marketing_Manager_Assignment__c mrkt:mrktmanagr)
            {
                if(mrkt.NSSales_Account__c!=null  && mrkt.Primary_Account_Classification__c!=null){
                    priClass.add(mrkt.Primary_Account_Classification__c);
                }
                
            }
            Map<id,BU__c> mapClass=new map<id,BU__c>([Select id,Name,Account__c from BU__c where id in:priClass]);
            
            for(NSSales_Marketing_Manager_Assignment__c mrktmng :mrktmanagr){
                //system.debug('SRV SS'+(mapClass.get(mrktmng.Primary_Account_Classification__c)));
                BU__c updateAcc =  mapClass.get(mrktmng.Primary_Account_Classification__c);
                updateAcc.Account__c=mrktmng.NSSales_Account__c;
                accClass.add(updateAcc);
            }
            update accClass;
        }
        catch(Exception e)
        {
            NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME8);
        }
        
    } 
    
    //Update 10/1 Delete duplicate Account Classification
    
    public static void deleteAndUpdateDupAccountClassification(List<NSSales_Marketing_Manager_Assignment__c> mrkmList){
        List<Id> mrkMAccountIds = new List<Id>();
        list<id> listToDel=new list<id>();
        list<BU__c> listTOUpdate= new list<BU__c>();
        set<id> mrktMAccClass =new set<Id>();
        List<BU__c> validBUList = new List<BU__c>();
        try{
            
            for(NSSales_Marketing_Manager_Assignment__c mm:mrkmList){
                mrkMAccountIds.add(mm.NSSales_Account__c);
                if(mm.Primary_Account_Classification__c != null){
                    mrktMAccClass.add(mm.Primary_Account_Classification__c);
                    
                }
            }
            validBUList = [Select id,Account__c,
                           NS_Account_Type_BU__c,
                           NS_Business_Group_BU__c,
                           NSSales_Group_Name1__c,
                           NS_Line_of_Business_BU__c,
                           NS_Major_Group_BU__c,
                           NS_Minor_Group_BU__c,
                           recordtypeid,
                           NS_Sub_Business_Group_BU__c from BU__c where Account__c IN:mrkMAccountIds 
                           and id not IN:mrktMAccClass LIMIT 50000];
            
            if(mrktMAccClass.size()>0){
                BU__c accC = [Select id,Name,Account__c,
                              NS_Account_Type_BU__c,
                              NS_Business_Group_BU__c,
                              NSSales_Group_Name1__c,
                              NS_Line_of_Business_BU__c,
                              NS_Major_Group_BU__c,
                              NS_Minor_Group_BU__c,
                              recordtypeid,
                              NS_Sub_Business_Group_BU__c from BU__c where id IN:mrktMAccClass limit 01];
                
                
                if(validBUList.size()>0){
                    for(BU__c bu:validBUList)
                    {
                        if(AccC.NS_Account_Type_BU__c == bu.NS_Account_Type_BU__c &&
                           AccC.NS_Business_Group_BU__c == bu.NS_Business_Group_BU__c &&
                           AccC.recordtypeid == bu.recordtypeid &&
                           AccC.NS_Line_of_Business_BU__c == bu.NS_Line_of_Business_BU__c &&
                           AccC.NS_Major_Group_BU__c == bu.NS_Major_Group_BU__c &&
                           AccC.NS_Minor_Group_BU__c == bu.NS_Minor_Group_BU__c &&
                           AccC.NS_Sub_Business_Group_BU__c == bu.NS_Sub_Business_Group_BU__c)
                        {
                            for(NSSales_Marketing_Manager_Assignment__c mm:mrkmList){ 
                                if(mm.Primary_Account_Classification__c==AccC.Id ){
                                    mm.Primary_Account_Classification__c=bu.Id;
                                    listToDel.add(AccC.Id);
                                    break;
                                }
                            }
                        }
                        else{
                            for(NSSales_Marketing_Manager_Assignment__c mm:mrkmList){ 
                                if(mm.Primary_Account_Classification__c==AccC.Id ){
                                    AccC.Account__c=mm.NSSales_Account__c;
                                    listTOUpdate.Add(AccC);
                                }
                            }
                        }
                        
                    }
                }else{
                    for(NSSales_Marketing_Manager_Assignment__c mm:mrkmList){ 
                        if(mm.Primary_Account_Classification__c==AccC.Id ){
                            AccC.Account__c=mm.NSSales_Account__c;
                            listTOUpdate.Add(AccC);
                        }
                    }
                }
                database.delete(listToDel);
                Map<id,BU__c> updateMap = new map<id,BU__c>();
                updateMap.putAll(listTOUpdate);
                database.update(updateMap.values());
                
            }
        }
        catch (Exception exp) {
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME9);
        }
        
    }
    
    public static void removeDuplicateAccountClasification(List<NSSales_Marketing_Manager_Assignment__c> mrkmList){
        
    }
}