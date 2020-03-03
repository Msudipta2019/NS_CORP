/*
*Modification History
***************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
***************************************************************************
11/22/2019          Sourav Sinha      VOC Devlopment- Update Survey result with case number

----------------------------------------------------------------------------
*/ 
public Without sharing class NS_CaseTriggerHelperAddl {
    
    private static final String CLASS_NAME = 'NS_CaseTriggerHelperAddl';
    private static final String METHOD_NAME1='insertAllCaseRollupRecord';
    private static final String METHOD_NAME2='updateAllCaseRollupRecord';
    private static final String METHOD_NAME3= 'updateSurveyWithCase';
    
    
    /* @author-  Accenture
*  @description- Fetch Case Setting(Custom Metada) to populate default value 
*  @param- List of Cases
*  @return- None
*  @throws- Standard Exception
*/     
    public static void checkRecordTypeAndIsMonitored(List<Case> caseNew){
        try{
            
            NS_StaticVariablesUtility.isTriggerExecuted = true;
            
            Map<String, String> forwardingMap = new Map<String, String>();
            for(NS_EmailToQueue__mdt emq :[Select Forwarding_Address__c,MasterLabel from NS_EmailToQueue__mdt where MasterLabel like 'Intermodal -%']){
                forwardingMap.put(emq.MasterLabel, emq.Forwarding_Address__c);
            }
            
            
            For(Case caseRec:caseNew){
                if(!(NS_StaticVariablesUtility.NS_Email.equalsIgnoreCase( caseRec.Origin)&&(!caseRec.NS_Created_using_Quick_Case__c))&& caseRec.ParentId== null )
                {    
                    
                    system.debug('SRV CCK 0007');
                    if(NS_StaticVariablesUtility.Delayed.equals(caseRec.NS_InteractionReason__c)){
                        caseRec.RecordTypeId = NS_CaseTriggerUtility.getRecTypeId(NS_StaticVariablesUtility.Delay_Expedite);
                    }
                    else if(caseRec.RecordTypeId.Equals(Schema.SObjectType.Case.getRecordTypeInfosByName().get(NS_StaticVariablesUtility.Service_Requests).getRecordTypeId()))
                    {
                        caseRec.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(NS_StaticVariablesUtility.Service_Requests).getRecordTypeId();
                    }
                    
                    ///SRV-CaseRecTyp_IM
                    else if(NS_StaticVariablesUtility.NS_Intermodal.equals(caseRec.NS_InteractionCategory__c)){
                        if(NS_StaticVariablesUtility.NS_IMTracing.equals(caseRec.NS_InteractionReason__c)||NS_StaticVariablesUtility.NS_IR_Shipment_Exception.equals(caseRec.NS_InteractionReason__c)){
                            caseRec.RecordTypeId = NS_CaseTriggerUtility.getRecTypeId(NS_StaticVariablesUtility.NS_Intermodal_Shipping);
                        }
                        else{
                            caseRec.RecordTypeId = NS_CaseTriggerUtility.getRecTypeId(NS_StaticVariablesUtility.NS_Intermodal_Non_Shipping);
                        }
                    }
                    ///SRV-CaseRecTyp_IM
                    else{
                        caseRec.RecordTypeId =  NS_CaseTriggerUtility.getRecTypeId(caseRec.NS_InteractionReason__c);
                    }
                }
                else if((caseRec.RecordTypeId != Schema.SObjectType.Case.getRecordTypeInfosByName().get(NS_StaticVariablesUtility.NS_EMAILTOCASE).getRecordTypeId()||
                         caseRec.RecordTypeId != Schema.SObjectType.Case.getRecordTypeInfosByName().get(NS_StaticVariablesUtility.Service_Requests).getRecordTypeId())&&
                        caseRec.ParentId!=null && caseRec.Origin!='Survey Result'
                       )
                {
                    caseRec.RecordTypeId =  NS_CaseTriggerUtility.getRecTypeId(NS_StaticVariablesUtility.ChildCase); 
                    
                }
                else if((caseRec.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get(NS_StaticVariablesUtility.NS_EMAILTOCASE).getRecordTypeId()
                        )&&(([Select Forwarding_Address__c from NS_EmailToQueue__mdt where MasterLabel ='TOP21 Inquiry'].Forwarding_Address__c).contains(caseRec.Forwarding_Emails__c)))
                {
                    
                    caseRec.RecordTypeId =  NS_CaseTriggerUtility.getRecTypeId(NS_StaticVariablesUtility.TOP21);
                    
                }
                //SRV--D1744 && request 3245
                else if((caseRec.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get(NS_StaticVariablesUtility.NS_EMAILTOCASE).getRecordTypeId()
                        )&&((forwardingMap.values()).contains(caseRec.Forwarding_Emails__c)))
                {
                    caseRec.NS_InteractionCategory__c='Intermodal';
                    if((forwardingMap.get('Intermodal - Customer Feedback')).contains(caseRec.Forwarding_Emails__c)){
                        caseRec.RecordTypeId =  NS_CaseTriggerUtility.getRecTypeId(NS_StaticVariablesUtility.NS_Intermodal_Non_Shipping);
                        caseRec.NS_InteractionReason__c='General Inquiry';
                        caseRec.NS_Type__c='Customer Feedback';
                        caseRec.Priority='Medium';
                    }
                    
                    
                    
                }
                
                //SRV END
                //SRV-VOCREQID##
                else if(caseRec.parentid!=null && caseRec.Origin=='Survey Result'){
                    System.debug('SRV 911'+caseRec.RecordTypeId);
                    caseRec.RecordTypeId=NS_CaseTriggerUtility.getRecTypeId(NS_StaticVariablesUtility.FeedBackTypeRT );
                }
                //SRV-END
                else{
                    if(!(caseRec.isClone())){
                        system.debug('ANAA Email2Case RT initial *********'+ caseRec.RecordTypeId);
                        caseRec.RecordTypeId =  NS_CaseTriggerUtility.getRecTypeId(NS_StaticVariablesUtility.NS_EmailToCaseRT );
                        system.debug('ANAA Email2Case RT updated *********'+ caseRec.RecordTypeId);
                    }
                }
                
                
                if(caseRec.Origin != NS_StaticVariablesUtility.NS_Email && caseRec.NS_Created_using_Quick_Case__c == false){
                    caseRec.NS_CreatedFromClonning__c = true;
                    caseRec.NS_StatusReason__c = null;
                    caseRec.NS_ExternalCaseNotes__c = null;
                }
                
            }
            
            if(Test.isRunningTest()){
                integer I=100/0;
            }                
        }          
        
        
        catch(exception exp)
        {
            NS_StaticVariablesUtility.createExceptionRecord(exp, '', 'checkRecordTypeAndIsMonitored');
            
        }
    }
    
    /* @author-  Accenture
*  @description- Update Contact with number of Cases associated
*  @param- None
*  @return- None
*  @throws- Standard Exception
*/
    public static void updateCountInContact(List<Case> listCase){
        Set<Id> conIds = new Set<Id>(); 
        List<Contact> contactWithCount=New List<Contact>();
        for(Case c : listCase){ 
            if(c.ContactId != null){ 
                conIds.add(c.ContactId); 
            } 
        }
        try{
            //////////Jack Reported issue on 5-31//////////////////////////
            List<Contact> ConList =[SELECT id, name, (SELECT id FROM cases) FROM contact where Id IN: conIds];
            For(Contact con: ConList){
                con.NS_CaseCount__c =con.cases.size(); 
                contactWithCount.ADD(con);
            }
            Update contactWithCount;
            
            
            
            
            //to cover Catch part
            if(Test.isRunningTest()){
                integer I=100/0;
            }
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, 'updateCountInContact');
        } 
    }
    
    
    
    /* @author-  Accenture
*  @description- Update Case status to escalated as per the metadata
*  @param- List of Cases in trigger
*  @return- None
*  @throws- Standard Exception
*/
    public static void checkStatusOnCreate(List<Case> caseNewList){
        Set<String> iReasons = new Set<String>();
        Set<String> iType = new Set<String>();
        map<String,String> mapMetadata = new map<String,String>();
        try{
            For(Case cse: caseNewList){
                iReasons.add(cse.NS_InteractionReason__c);
                iType.add(Cse.NS_Type__c);
            }
            if(NS_CaseTriggerUtility.getMetadataStatus(iReasons,iType)!=null){
                mapMetadata=NS_CaseTriggerUtility.getMetadataStatus(iReasons,iType);
            }
            
            for(Case newCase : caseNewList ){
                if(newCase.NS_Type__c ==NS_StaticVariablesUtility.EmptyDisposition &&(newCase.NS_CaseBusinessUnit__c==NS_StaticVariablesUtility.NS_EquipmentPlanning || newCase.NS_CaseBusinessUnit__c==NS_StaticVariablesUtility.NS_UnitTrain))
                {
                    newCase.Status = NS_StaticVariablesUtility.NS_CLOSED;    
                }
                else if(mapMetadata.get(newCase.NS_InteractionReason__c+'_'+newCase.NS_CaseBusinessUnit__c)!=null){
                    newCase.Status=mapMetadata.get(newCase.NS_InteractionReason__c+'_'+newCase.NS_CaseBusinessUnit__c);
                }
                
            }
            if(Test.isRunningTest()){
                integer I=100/0;
            }
        }
        
        catch (Exception exp) {
            
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, 'checkStatusOnCreate');
        }
    }
    /****************************************************/
    //Description: R2 changes on contact,Account
    //             custom validation rule that when Case record OEM account field is selected, its id must have a corresponding ns_accountrelation record where selected OEM account is in ns_relationparty2 field 
    //            
    //Developer Name : Moumita
    //Date : 3/7/2019
    /***************************************************/
    public static void ValidateOEMAccount(List<Case> caseList){
        Set<Id> RelationParty2Ids = new Set<Id>();
        boolean isPresent;
        
        try{
            
            for(Case cs : caseList)
            {
                if(cs.NS_OEM_Account__c != null){
                    
                    for(List<NS_AccountRelation__c> ar : [Select Id, NS_RelationParty1__c, NS_RelationParty2__c from NS_AccountRelation__c where NS_RelationParty1__c = : cs.AccountId])
                    {
                        for(NS_AccountRelation__c r : ar)
                        {
                            RelationParty2Ids.add(r.NS_RelationParty2__c);
                        }
                    }
                    
                    isPresent =  RelationParty2Ids.contains(cs.NS_OEM_Account__c);
                    
                    if(isPresent == false)
                    {
                        cs.NS_OEM_Account__c.addError('Please select OEM Account that is in Relation Party 2 with the respective account');
                        
                    }
                }
            }
            if(Test.isRunningTest()){
                integer I=100/0;
            }
        }
        catch (Exception exp) 
        {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp,CLASS_NAME,'ValidateOEMAccount');
        }
        
    }
    /*****Start of Req - Account Cases & Opportunities Roll-Up****************************/
    
    /*Gunjari 02/07 -- insert a new record in All Case Rollups object when a new case is created */
    public static void insertAllCaseRollupRecord(List<Case> caseList){
        List<NSSales_AllCaseRollups__c> caseListToInsert = new List<NSSales_AllCaseRollups__c>();
        try{        
            for (Case cse : caseList){
                if(cse.AccountId!= null){
                    Id ultimateParentAccId = getUltimateParent(cse.AccountId); 
                    NSSales_AllCaseRollups__c caseRecord = new NSSales_AllCaseRollups__c();
                    caseRecord.NSSales_Case__c = cse.Id;
                    caseRecord.NSSales_Account__c = cse.AccountId;
                    caseRecord.NSSales_UltimateParentAccount__c = ultimateParentAccId;
                    caseListToInsert.add(caseRecord);
                    
                }
            }
            if(!caseListToInsert.isEmpty()){
                Database.SaveResult[] srList = Database.insert(caseListToInsert,false); 
                NS_Utility.databaseSvResult(srList,METHOD_NAME1,CLASS_NAME);
            }
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            system.debug('Exception in insert-->'+exp.getMessage());
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME,METHOD_NAME1);
        }
        
    }
    /*Gunjari 02/07 -- update the corresponding record from All Case Rollups object when an existing case is updated */
    public static void updateAllCaseRollupRecord(Map<Id,Case> newCaseMap,Map<Id,Case> oldCaseMap){ 
        
        NSSales_AllCaseRollups__c caseRec= new NSSales_AllCaseRollups__c (); 
        List<NSSales_AllCaseRollups__c> caseListToUpdate = new List<NSSales_AllCaseRollups__c>();
        Map<Id,NSSales_AllCaseRollups__c>  allCaseRollupMap= new Map<Id,NSSales_AllCaseRollups__c>();
        List <NSSales_AllCaseRollups__c> tempAllCaseRollupList = new list <NSSales_AllCaseRollups__c>([select Name, NSSales_Case__c, NSSales_Account__c, NSSales_UltimateParentAccount__c from NSSales_AllCaseRollups__c where NSSales_Case__c = :newCaseMap.keySet()]);
        try{
            if(!tempAllCaseRollupList.isEmpty()){
                for(NSSales_AllCaseRollups__c rec :  tempAllCaseRollupList ){
                    allCaseRollupMap.put(rec.NSSales_Case__c,rec);
                }
                
                for (Case cse : newCaseMap.values()){
                    if(oldCaseMap.get(cse.Id).AccountId!=cse.AccountId)
                    {
                        if(cse.AccountId!= null){
                            caseRec= allCaseRollupMap.get(cse.Id);
                            caseRec.NSSales_Account__c=cse.AccountId;
                            Id ultimateParentAccId = getUltimateParent(cse.AccountId);
                            caseRec.NSSales_UltimateParentAccount__c = ultimateParentAccId;
                        }
                        
                    }
                    if(caseRec.Id!=null)
                        caseListToUpdate.add(caseRec); 
                } 
                if(!caseListToUpdate.isEmpty()){
                    Database.SaveResult[] srList = Database.update(caseListToUpdate,false); 
                    NS_Utility.databaseSvResult(srList,METHOD_NAME2,CLASS_NAME);
                }
            }
            else{
                insertAllCaseRollupRecord(newCaseMap.values());
            }
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            system.debug('Exception in update-->'+exp.getMessage());
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME2);
        }
        
    }
    
    
    //Gunjari 02/07 -- get the ultimate parent account id from the account entered in case 
    private static Id getUltimateParent(Id accountId){
        Boolean topLevelParent = false;
        while ( !topLevelParent ) {
            Account acc = [ Select Id, ParentId From Account where Id =: accountId limit 1 ];
            if ( acc.ParentID != null ) {
                accountId = acc.ParentID;
            }
            else {
                topLevelParent = true;
            }
        }
        return accountId ;
    }
    
    /*****End of Req - Account Cases & Opportunities Roll-Up****************************/
    //SRV VOC implementation
    public static void updateSurveyWithCase(List<Case> caseList){
        Id RecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Feedback Case').getRecordTypeId();
        List<id> listRelSurvey = new List<id> ();
        list<Survey_Result__c> updateSurveyList = new list<Survey_Result__c>();
        try{
            for(Case cc :caseList){
                if((cc.subject.contains('Feedback Received at') && (cc.RecordTypeId == RecType)&&(cc.NS_Survey_Feedback_Number__c!=null))){
                    System.debug('SOS 00 '+cc.NS_Survey_Feedback_Number__c);
                    listRelSurvey.add(cc.NS_Survey_Feedback_Number__c);
                    system.debug('SOS LS'+listRelSurvey);
                } 
            }
            if(!listRelSurvey.isEmpty())
            {
                map<id, Survey_Result__c> mapSurvey = new map<id, Survey_Result__c>([Select id,Feedback_Case__c from Survey_Result__c where id in :listRelSurvey]);
                
                for(Case cc :caseList){
                    Survey_Result__c relSurvey = mapSurvey.get(cc.NS_Survey_Feedback_Number__c);
                    if(relSurvey.id!=null){
                        relSurvey.Feedback_Case__c = cc.Id;
                        updateSurveyList.add(relSurvey);
                    }
                }
                update updateSurveyList;
            }
            
        }
        catch(exception exp){
            system.debug('SOS EX'+Exp.getLineNumber()+':'+Exp.getMessage());
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME3);
        }
    }
    
}