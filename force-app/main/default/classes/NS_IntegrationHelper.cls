/*
Description  : This class is created to handle all integration related business logic
Developer    : Accenture Solutions
Date         : 20-06-2018

-----------------------------------------------------------------------
Developer name        Date          Description        
-----------------------------------------------------------------------
@Bharadwaj Urma    20-06-2018     Added Method to make ANI and VDN maintenance callouts
@Arjun Ghosh       14-12-2018     Added method to ensure Deletion & re-insertion of contact records in Tyes on 
@Daniel Glaser     25-09-2019     Added Field Location to send update to Tyes.
@Daniel Glaser     09-10-2019     Tyes update fix for Service contacts create
                                   change of Account related to contacts
@Daniel Glaser     10-14-2019     Tyes update fix for Service contacts create, update, change state and delete
@Daniel Glaser     10-25-2019     Tyes update fix for NON Service contacts create, update, change state and delete
@Nanda		       10-15-2019     Added Method to send contact update request to Tyes for 3PL and Offline Account.
*/

public class NS_IntegrationHelper {
    
    Static Final String userFederationId = [Select FederationIdentifier from user where ID = :UserInfo.getUserId()].FederationIdentifier;
    Static Final Id serviceAccId = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerService'].Id;
    
    Static Final Id OnlineCustomerBusiness = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerBusiness'].Id;
    Static Final Id OnlineCustomerCorporate = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerCorporate'].Id;
    Static Final Id OnLineServiceAccount = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerService'].Id;
    Static Final Id GeneralContact = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_GeneralContact'].Id;
    Static Final Id OfflineCustomer = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OfflineCustomer'].Id;
    Static Final Id NS3PLCustomer = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_3PL'].Id;
    Static Final Id FieldLocation = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_FieldLocation'].Id;  // @Daniel Glaser 
    Static Final Id AniOnlyCustomer = [SELECT Id FROM RecordType WHERE DeveloperName ='ANI_ONLY'].Id;
    Static Final String CLASS_NAME = 'NS_IntegrationHelper';
    Static Final String METHOD_NAME1 = 'onANIInsert';
    Static Final String METHOD_NAME2 = 'onANIUpdate'; 
    Static Final String METHOD_NAME3 = 'onCustomerVDNUpdate'; 
    Static Final String METHOD_NAME4 = 'invokeManageOnlineCustomerContact';
    Static Final String METHOD_NAME5 = 'invoke_VDNMaintenanceOnInsert';
    Static Final String METHOD_NAME6 = 'invoke_VDNMaintenanceOnUpdate';
    Static Final String METHOD_NAME7 = 'onCustomerContactInsert';
    Static Final String METHOD_NAME8 = 'onCustomerContactUpdate';
    Static Final String METHOD_NAME9 = 'invoke_VDNMaintenanceOnDelete';
    public Static Final String AC_ID='AccountId';
    public static boolean isValidForSync(Contact con){
        boolean check = false;
        if(con.RecordTypeId == GeneralContact)
            check = true;
        return check;
    }
    /*
When ANI/Phone is available during Insert of Contact, sync it to TYES
*/
    public static void onANIInsert(Map<Id, Contact> newMap){        
        String VDNExten = '';
        String PhoneANI;
        Set<Id> vdnIdForValidAccount = new Set<Id>();
        List<Contact> validContactForANIUpdate = new List<Contact>();
        
        Set<Id> rtIds = new Set<Id>();
        rtIds.add(OnLineServiceAccount);
        rtIds.add(OfflineCustomer);
        rtIds.add(OnlineCustomerBusiness);
        rtIds.add(OnlineCustomerCorporate);
        rtIds.add(NS3PLCustomer);
        rtIds.add(FieldLocation);  // @Daniel Glaser 
        System.debug('NS_IntegrationHelper onANIInsert entered');
        //prepared all phone field to be synced to TYES.
        List<String> fieldNameList = new List<String>();
        fieldNameList.add('Phone');
        fieldNameList.add('MobilePhone');
        fieldNameList.add('OtherPhone');
        fieldNameList.add('HomePhone');
        
        for(Contact conLoopRec : newMap.values()){
            if(conLoopRec.AccountId != null){
                System.debug('NS_IntegrationHelper onANIInsert conLoopRec.AccountId '+conLoopRec.AccountId);
                validContactForANIUpdate.add(conLoopRec);
                vdnIdForValidAccount.add(conLoopRec.AccountId);
            }
        }
        if(!validContactForANIUpdate.isEmpty()){     
            Map<Id, Account> vdnMapforValidAcc = new Map<Id, Account>([Select id, Recordtypeid, phone, NS_PrimaryVDN__r.Id, NS_PrimaryVDN__c, NS_PrimaryVDN__r.NS_VDNCode__c 
                                                                       from Account where Id IN : vdnIdForValidAccount]);
           // NS_VDN__c vdnforOfflineAcc = [Select Id, NS_VDNCode__c from NS_VDN__c where Id = : System.Label.NS_OfflinePrimaryVDN];  // @Nanda
          //  NS_VDN__c vdnfor3PLAcc = [Select Id, NS_VDNCode__c from NS_VDN__c where Id = : System.Label.NS_3PLPrimaryVDN];          // @Nanda
            NS_VDN__c vdnforUnknownVDN = [Select Id, NS_VDNCode__c from NS_VDN__c where Id = : System.Label.NS_UnknownPrimaryVDN];  // @dglaser  
            
            List<NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper> offlineAccAniMaintenanceList = new List<NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper>();
            SObject tmpConRec;
            for(Contact validAccLoopRec : validContactForANIUpdate){
                System.debug('NS_IntegrationHelper onANIInsert validAccLoopRec loop '+validAccLoopRec.AccountId);
                //Account check is needed for record type check and to get VDN for Sync action.
                if(vdnMapforValidAcc.containsKey(validAccLoopRec.AccountId)  && rtIds.contains(vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId) ){
                    System.debug('NS_IntegrationHelper onANIInsert for offline customer, get offline VDN code');
                    String rti =  vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId;
                    //system.debug('NS_IntegrationHelper onANIInsert rti '+rti+' vdn '+vdnforOfflineAcc.NS_VDNCode__c);
                    //for offline customer, get offline VDN code.
                   /* if(vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == OfflineCustomer &&  vdnforOfflineAcc.NS_VDNCode__c != null){
                        VDNExten = vdnforOfflineAcc.NS_VDNCode__c;
                    }
                    //  system.debug('NS_IntegrationHelper onANIInsert current VDN exten '+VDNExten);
                    //for 3PL, get 3PL vdn code.
                    if(vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == NS3PLCustomer && vdnfor3PLAcc.NS_VDNCode__c != null){
                        System.debug('NS_IntegrationHelper onANIInsert 3PL, get 3PL vdn '+vdnfor3PLAcc.NS_VDNCode__c);
                        VDNExten = vdnfor3PLAcc.NS_VDNCode__c;
                    } */
                    //for other(NON service), get associated VDN code.
                    if((vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == OnlineCustomerBusiness || 
                        vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == OnlineCustomerCorporate||
                        vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == FieldLocation ||     //@Daniel Glaser
                        vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == NS3PLCustomer ||     // @Nanda
                        vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == OfflineCustomer ||   // @Nanda
                        (vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == OnLineServiceAccount  &&
                         validAccLoopRec.RecordTypeId == AniOnlyCustomer) &&   
                        vdnMapforValidAcc.get(validAccLoopRec.AccountId).NS_PrimaryVDN__r.NS_VDNCode__c != null)) {
                            VDNExten = vdnMapforValidAcc.get(validAccLoopRec.AccountId).NS_PrimaryVDN__r.NS_VDNCode__c;
                            //  system.debug('NS_IntegrationHelper onANIInsert for other(NON service),  VDN code: '+VDNExten);
                            // If there is no VDN assign the Unkwown VDN number  @dglaser
                            if (VDNExten == null) {
                                VDNExten = vdnforUnknownVDN.NS_VDNCode__c;   // @dglaser
                            }
                        }
                    if(VDNExten != null && VDNExten != ''){
                        System.debug('NS_IntegrationHelper onANIInsert SObject for dynamic field access');
                        //Using SObject for dynamic field access.
                        tmpConRec = (SObject)validAccLoopRec;
                        for(String fieldName : fieldNameList){
                            if(tmpConRec.get(fieldName) != null && tmpConRec.get(fieldName) != NS_StaticVariablesUtility.Blank){
                                //Prepare wrapper with Contact data.
                                NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper aniMaintWrapperForCon = new NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper();
                                aniMaintWrapperForCon.ActionInd = NS_StaticVariablesUtility.InsertActionInd;
                                aniMaintWrapperForCon.Phone_ANI = (String)tmpConRec.get(fieldName);
                                aniMaintWrapperForCon.Old_Phone_ANI = '';
                                aniMaintWrapperForCon.VDNExten = VDNExten;
                                if(aniMaintWrapperForCon.Phone_ANI.Length() == 10 || aniMaintWrapperForCon.Phone_ANI.Length() == 0 ){            // @Nanda
                                offlineAccAniMaintenanceList.add(aniMaintWrapperForCon);
                            }
                        }
                        }
                        //  system.debug('NS_IntegrationHelper onANIInsert process list '+offlineAccAniMaintenanceList.size());
                        if(vdnMapforValidAcc.get(validAccLoopRec.AccountId).phone != null){
                            //Prepare wrapper with account data as well. This takes care of offline customer not synced on Insert.
                            NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper aniMaintWrapperForAcc = new NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper();
                            aniMaintWrapperForAcc.ActionInd = NS_StaticVariablesUtility.InsertActionInd;
                            aniMaintWrapperForAcc.Phone_ANI = vdnMapforValidAcc.get(validAccLoopRec.AccountId).phone;
                            aniMaintWrapperForAcc.Old_Phone_ANI = '';
                            aniMaintWrapperForAcc.VDNExten = VDNExten;
                            //  system.debug('NS_IntegrationHelper onANIInsert Prepare wrapper with account data as well. This takes care of offline customer not synced on Insert phone '+aniMaintWrapperForAcc.Phone_ANI);
                            offlineAccAniMaintenanceList.add(aniMaintWrapperForAcc);    
                        }
                    }
                }           
            }
            //  system.debug('NS_IntegrationHelper onANIInsert offlineAccAniMaintenanceList chk ');
            if(!offlineAccAniMaintenanceList.isEmpty()){
                try{
                    System.debug('NS_IntegrationHelper onANIInsert call NS_WebServiceHandler_ANIMaintenance.prepareOfflineAccAniUpdateBody');
                    NS_WebServiceHandler_ANIMaintenance.prepareOfflineAccAniUpdateBody(userFederationId,NS_StaticVariablesUtility.InsertActionInd,offlineAccAniMaintenanceList);
                }catch(Exception e){
                    NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME1);
                }
            }
        }
        System.debug('NS_IntegrationHelper onANIInsert exited');
    }
    
    /*
When ANI/Phone is available during Update of Contact, sync it to TYES
*/
    public static void onANIUpdate(Map<Id, Contact> newMap, Map<Id, Contact> oldMap){        
        system.debug('onAniUpdate');
        String VDNExten='';
        String PhoneANI;
        String oldPhoneANI;
        List<Contact> validContactForANIUpdate = new List<Contact>();
        map<string,Contact> validOldContacts = new map<string,Contact>();
        Set<Id> vdnIdForValidAccount = new Set<Id>();
        Set<Id> vdnIdForOldValidAccount = new Set<Id>();
        Set<Id> rtIds = new Set<Id>();
        rtIds.add(OnlineCustomerBusiness);
        rtIds.add(OnlineCustomerCorporate);
        rtIds.add(OnLineServiceAccount);
        rtIds.add(FieldLocation);  // @Daniel Glaser
        System.debug('NS_IntegrationHelper onANIUpdate entered');
        List<String> fieldNameList = new List<String>();
        fieldNameList.add('Phone');
        fieldNameList.add('MobilePhone');
        fieldNameList.add('OtherPhone');
        fieldNameList.add('HomePhone');       
        string Statusfield = 'NS_ContactStatus__c';
        String FieldAccountId = 'AccountId';
        boolean ProcessChangeAccount = false;
        boolean checkOldRecType = false;
        
        
        for(Contact conLoopRec : newMap.values()){
            //if(isValidForSync(conLoopRec)){
            if(conLoopRec.AccountId != null){
                validContactForANIUpdate.add(conLoopRec);
                vdnIdForValidAccount.add(conLoopRec.AccountId);
            }
            //}
        }
        // get the account id for Old map values @dglaser
        for (Contact conLoopRec : oldMap.values()) {
            if(conLoopRec.AccountId != null){
                system.debug('NS_IntegrationHelper onANIUpdate get the account id for Old map values '+conLoopRec.AccountId);
                vdnIdForOldValidAccount.add(conLoopRec.AccountId);  
                validOldContacts.put(conLoopRec.id, conLoopRec);
            }
        }
        if(!validContactForANIUpdate.isEmpty()){
            Map<Id, Account> vdnMapforValidAcc = new Map<Id, Account>([Select id, Recordtypeid, NS_PrimaryVDN__r.Id, NS_PrimaryVDN__c, NS_PrimaryVDN__r.NS_VDNCode__c 
                                                                       from Account where Id IN : vdnIdForValidAccount]);
            // get the old contact account information @dglaser                                                           
            Map<Id, Account> vdnMapforOldValidAcc = new Map<Id, Account>([Select id, Recordtypeid, NS_PrimaryVDN__r.Id, NS_PrimaryVDN__c, NS_PrimaryVDN__r.NS_VDNCode__c 
                                                                       from Account where Id IN : vdnIdForOldValidAccount]); // @dglaser


           // NS_VDN__c vdnforOfflineAcc = [Select Id, NS_VDNCode__c from NS_VDN__c where Id = : System.Label.NS_OfflinePrimaryVDN];
           // NS_VDN__c vdnfor3PLAcc = [Select Id, NS_VDNCode__c from NS_VDN__c where Id = : System.Label.NS_3PLPrimaryVDN];
            NS_VDN__c vdnforUnknownVDN = [Select Id, NS_VDNCode__c from NS_VDN__c where Id = : System.Label.NS_UnknownPrimaryVDN];   // @dglaser
            
            List<NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper> offlineAccAniMaintenanceList = new List<NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper>();
            SObject newConRec;
            SObject oldConRec;
            String actionInd = NS_StaticVariablesUtility.UpdateActionInd;
            for(Contact validAccLoopRec : validContactForANIUpdate){
                newConRec = (SObject)validAccLoopRec;
                oldConRec = (SObject)oldMap.get(validAccLoopRec.Id);
                
                if(vdnMapforValidAcc.containsKey(validAccLoopRec.AccountId)  && rtIds.contains(vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId )){
                   /* if(vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == OfflineCustomer &&  vdnforOfflineAcc.NS_VDNCode__c != null){
                        VDNExten = vdnforOfflineAcc.NS_VDNCode__c;
                    }
                    if(vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == NS3PLCustomer && vdnfor3PLAcc.NS_VDNCode__c != null){
                        VDNExten = vdnfor3PLAcc.NS_VDNCode__c;
                    }*/
                    
                    if((vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == OnlineCustomerBusiness || 
                        vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == OnlineCustomerCorporate ||
                        vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == FieldLocation ||  // @Daniel Glaser 
                        ((vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == OnLineServiceAccount   &&
                         validAccLoopRec.RecordTypeId == AniOnlyCustomer))&& 
                        vdnMapforValidAcc.get(validAccLoopRec.AccountId).NS_PrimaryVDN__r.NS_VDNCode__c != null)){
                            VDNExten = vdnMapforValidAcc.get(validAccLoopRec.AccountId).NS_PrimaryVDN__r.NS_VDNCode__c;
                            // If there is no VDN assign the Unkwown VDN number   @dglaser
                            if (VDNExten == null) {
                                VDNExten = vdnforUnknownVDN.NS_VDNCode__c;   // @dglaser
                            }
                            //  system.debug('NS_IntegrationHelper onANIUpdate  ck VDN code: '+VDNExten);

                    }
                    
                    // Verify there is a old map, then check to see if the New Account id is different then the Old  @dglaser
                    // If different it means that the Account on the Contact has changed. Based on which was changed 
                    // determines if old contact has to be sent to tyes or the New Contact
                    if (oldConRec.get(FieldAccountId) != newConRec.get(FieldAccountId) ) { 
                        contact oldcontact = validOldContacts.get(validAccLoopRec.id);
                        //  system.debug('NS_IntegrationHelper onANIUpdate check if old map contains the accountid '+oldcontact.AccountId);
                        if (vdnMapforOldValidAcc.containsKey(oldcontact.AccountId)) {
                            System.debug('NS_IntegrationHelper onANIUpdate check if old map contains the accountid '+validAccLoopRec.AccountId);
                            // check to see if the old rectype is NON service and the New is Service
                            // This ensures the change of contact accounts will delete the old ANI entry in TYES
                            string oldacctid = oldMap.get(validAccLoopRec.Id).id;
                            System.debug('NS_IntegrationHelper onANIUpdate check if old map contains the accountid '+validAccLoopRec.AccountId+' old '+oldacctid);
                           if ((vdnMapforOldValidAcc.get(oldcontact.AccountId).RecordTypeId !=OnLineServiceAccount ) &&     
                               vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == OnLineServiceAccount){                   
                                
                                checkOldRecType = true;
                                // have to retrieve th VDN from the old account
                                // VDNExten = oldConRec.NS_PrimaryVDN__r.NS_VDNCode__c;
                                VDNExten = vdnMapforOldValidAcc.get(oldcontact.AccountId).NS_PrimaryVDN__r.NS_VDNCode__c;
                                // If there is no VDN assign the Unkwown VDN number   @dglaser
                                if (VDNExten == null) {
                                    VDNExten = vdnforUnknownVDN.NS_VDNCode__c;   // @dglaser
                                }
                                ProcessChangeAccount = true;
                               //  system.debug('NS_IntegrationHelper onANIUpdate OLD Account VDN code: '+VDNExten);
                            }
                        }
                    }

                    // if There is an VDN process the Contact
                    if(VDNExten != null && VDNExten != ''){
                        boolean ProcessNonServInActive = false;   // @dglaser  process NON service account contact if contact set to Inactive
                        boolean ProcessNonServToActive = false;   // @dglaser  Process NON service account contact if contact is set to active
                        //  if not a service account process contact set to inactive contact for actionInd for 'D' delete   @dglaser
                        if ((vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId != OnLineServiceAccount))  
                        {
                            if (oldConRec.get(Statusfield) == 'Active' && (oldConRec.get(Statusfield) != validAccLoopRec.NS_ContactStatus__c)) {
                                // set flag that ContactStatus was changed to inActive
                                // this will clear all the phone numbers assocated with the contact in TYES as ANI phone numbers  @dglaser
                                ProcessNonServInActive = true;
                                System.debug('NS_IntegrationHelper onANIUpdate  ProcessNonServInActive: ');
                            // Check to see if the Contact moved from Inactive to Active.   @dglaser
                            } else if (oldConRec.get(Statusfield) == 'Inactive' && (oldConRec.get(Statusfield) != validAccLoopRec.NS_ContactStatus__c)) {
                                // set flag to process all filled in phone numbers as insert  @dglaser
                                ProcessNonServToActive = true;
                                System.debug('NS_IntegrationHelper onANIUpdate  ProcessNonServToActive: ');
                            // If the contacts account is changed then process all the phone numbers as an update
                            // with NEW VDN number   @dglaser
                            } else if (oldConRec.get(FieldAccountId) != newConRec.get(FieldAccountId) ) {
                                System.debug('NS_IntegrationHelper onANIUpdate  Contact Account changed');
                                ProcessChangeAccount = true;
                            }
                        }
                        for(String fieldName : fieldNameList){
                            NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper aniMaintWrapper = new NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper();
                            if(newConRec.get(fieldName) != oldConRec.get(fieldName)){ 
                                if(newConRec.get(fieldName) == null || newConRec.get(fieldName) == NS_StaticVariablesUtility.Blank){
                                    actionInd = NS_StaticVariablesUtility.DeleteActionInd;
                                    aniMaintWrapper.Phone_ANI = '';                        
                                }else if(oldConRec.get(fieldName) == null || oldConRec.get(fieldName) == NS_StaticVariablesUtility.Blank){
                                    actionInd = NS_StaticVariablesUtility.InsertActionInd;
                                    aniMaintWrapper.Phone_ANI = newConRec.get(fieldName) != null ? (String)newConRec.get(fieldName) : '';                        
                                }else{
                                    aniMaintWrapper.Phone_ANI = newConRec.get(fieldName) != null ? (String)newConRec.get(fieldName) : '';
                                }
                                //  system.debug('NS_IntegrationHelper onANIUpdate Action Indicator '+actionInd);
                                aniMaintWrapper.ActionInd = actionInd;
                                aniMaintWrapper.Old_Phone_ANI = oldConRec.get(fieldName) != null ? (String)oldConRec.get(fieldName) : '';
                                aniMaintWrapper.VDNExten = VDNExten;
                                if(aniMaintWrapper.Phone_ANI.Length()== 10 || aniMaintWrapper.Phone_ANI.Length()== 0 ){     // @Nanda
                                offlineAccAniMaintenanceList.add(aniMaintWrapper);                                                                  
                                }                                                                                                                  
                            } else if (ProcessNonServInActive || ProcessNonServToActive || ProcessChangeAccount) {
                                // process NON Service Accounts where the contact has been set to INACTIVE  @dglaser
                                if (oldConRec.get(fieldName) != null && oldConRec.get(fieldName) != '')  {
                                    if (ProcessNonServToActive) {
                                        aniMaintWrapper.ActionInd = NS_StaticVariablesUtility.InsertActionInd;
                                        aniMaintWrapper.Phone_ANI = newConRec.get(fieldName) != null ? (String)newConRec.get(fieldName) : '';
                                    } else if (ProcessNonServInActive) {
                                        aniMaintWrapper.ActionInd = NS_StaticVariablesUtility.DeleteActionInd;
                                        aniMaintWrapper.Phone_ANI = '';
                                        aniMaintWrapper.Old_Phone_ANI = oldConRec.get(fieldName) != null ? (String)oldConRec.get(fieldName) : '';
                                    } else if (ProcessChangeAccount) {
                                        // Process each phonenumber to change the VDN number to the account of the 
                                        // updated contact.
                                        // If the old account was non-service  @dglaser
                                        if (checkOldRecType) {
                                            aniMaintWrapper.ActionInd = NS_StaticVariablesUtility.DeleteActionInd;
                                            aniMaintWrapper.Phone_ANI = '';
                                            system.debug('NS_IntegrationHelper onANIUpdate delete old account phones');
                                        } else {    
                                            aniMaintWrapper.ActionInd = NS_StaticVariablesUtility.UpdateActionInd;
                                        
                                            aniMaintWrapper.Phone_ANI = newConRec.get(fieldName) != null ? (String)newConRec.get(fieldName) : '';
                                        }
                                        aniMaintWrapper.Old_Phone_ANI = oldConRec.get(fieldName) != null ? (String)oldConRec.get(fieldName) : '';
                                    }
                                    system.debug('NS_IntegrationHelper onANIUpdate Action Indicator '+aniMaintWrapper.ActionInd+ ' old phone '+aniMaintWrapper.Old_Phone_ANI);
                                    aniMaintWrapper.VDNExten = VDNExten;
                                     if(aniMaintWrapper.Phone_ANI.Length()== 10 || aniMaintWrapper.Phone_ANI.Length()== 0){           // @Nanda
                                    offlineAccAniMaintenanceList.add(aniMaintWrapper);
                                }
                            }
                        }
                        }
                    }
                }
            }
        
            if(!offlineAccAniMaintenanceList.isEmpty()){
                try{
                    System.debug('NS_IntegrationHelper onANIUpdate call NS_WebServiceHandler_ANIMaintenance.prepareOfflineAccAniUpdateBody');
                    NS_WebServiceHandler_ANIMaintenance.prepareOfflineAccAniUpdateBody(userFederationId,NS_StaticVariablesUtility.UpdateActionInd,offlineAccAniMaintenanceList);
                }catch(Exception e){
                    NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME1);
                }
            }    
        }
        //  system.debug('NS_IntegrationHelper onANIUpdate exited');
    }
    
    /* 
This method is used to send contact update request to TYES for 3PL and Offline Account. 
Date : 10-15-2019
    */
     public static void contactupdate_3pl_Offline(Map<Id, Contact> newMap, Map<Id, Contact> oldMap){   
         system.debug('contactupdate_3pl_Offline');
        String VDNExten='';
        String PhoneANI;
        String oldPhoneANI;
        List<Contact> validContactForANIUpdate = new List<Contact>();
        map<string,Contact> validOldContacts = new map<string,Contact>();
        Set<Id> vdnIdForValidAccount = new Set<Id>();
        Set<Id> vdnIdForOldValidAccount = new Set<Id>();
        Set<Id> rtIds = new Set<Id>();
        rtIds.add(OfflineCustomer);
        rtIds.add(NS3PLCustomer);
        System.debug('NS_IntegrationHelper onANIUpdate entered');
        List<String> fieldNameList = new List<String>();
        fieldNameList.add('Phone');
        fieldNameList.add('MobilePhone');
        fieldNameList.add('OtherPhone');
        fieldNameList.add('HomePhone');       
        string Statusfield = 'NS_ContactStatus__c';
        String FieldAccountId = 'AccountId';
        boolean ProcessChangeAccount = false;
        boolean checkOldRecType = false;
        
        
        for(Contact conLoopRec : newMap.values()){
            //if(isValidForSync(conLoopRec)){
            if(conLoopRec.AccountId != null){
                validContactForANIUpdate.add(conLoopRec);
                vdnIdForValidAccount.add(conLoopRec.AccountId);
            }
            //}
        }
        // get the account id for Old map values @dglaser
        for (Contact conLoopRec : oldMap.values()) {
            if(conLoopRec.AccountId != null){
                system.debug('NS_IntegrationHelper onANIUpdate get the account id for Old map values '+conLoopRec.AccountId);
                vdnIdForOldValidAccount.add(conLoopRec.AccountId);  
                validOldContacts.put(conLoopRec.id, conLoopRec);
            }
        }
        if(!validContactForANIUpdate.isEmpty()){
            Map<Id, Account> vdnMapforValidAcc = new Map<Id, Account>([Select id, Recordtypeid, NS_PrimaryVDN__r.Id, NS_PrimaryVDN__c, NS_PrimaryVDN__r.NS_VDNCode__c 
                                                                       from Account where Id IN : vdnIdForValidAccount]);
            // get the old contact account information @dglaser                                                           
            Map<Id, Account> vdnMapforOldValidAcc = new Map<Id, Account>([Select id, Recordtypeid, NS_PrimaryVDN__r.Id, NS_PrimaryVDN__c, NS_PrimaryVDN__r.NS_VDNCode__c 
                                                                       from Account where Id IN : vdnIdForOldValidAccount]); 

            NS_VDN__c vdnforUnknownVDN = [Select Id, NS_VDNCode__c from NS_VDN__c where Id = : System.Label.NS_UnknownPrimaryVDN];  
            
            List<NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper> offlineAccAniMaintenanceList = new List<NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper>();
            SObject newConRec;
            SObject oldConRec;
            String actionInd = NS_StaticVariablesUtility.UpdateActionInd;
            for(Contact validAccLoopRec : validContactForANIUpdate){
                newConRec = (SObject)validAccLoopRec;
                oldConRec = (SObject)oldMap.get(validAccLoopRec.Id);
                
                if(vdnMapforValidAcc.containsKey(validAccLoopRec.AccountId)  && rtIds.contains(vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId )){
                   
                     if ((vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == OfflineCustomer || (vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == NS3PLCustomer )) &&        // @Nanda
                        (validAccLoopRec.RecordTypeId == AniOnlyCustomer || validAccLoopRec.RecordTypeId == GeneralContact ) &&                                                                           
                            vdnMapforValidAcc.get(validAccLoopRec.AccountId).NS_PrimaryVDN__r.NS_VDNCode__c != null){                                                                                     
                            VDNExten = vdnMapforValidAcc.get(validAccLoopRec.AccountId).NS_PrimaryVDN__r.NS_VDNCode__c;
                            // If there is no VDN assign the Unkwown VDN number   
                            if (VDNExten == null) {
                                VDNExten = vdnforUnknownVDN.NS_VDNCode__c;   
                            }

                    }
                    
                    // Verify there is a old map, then check to see if the New Account id is different then the Old  @dglaser
                    // If different it means that the Account on the Contact has changed. Based on which was changed 
                    // determines if old contact has to be sent to tyes or the New Contact
                    if (oldConRec.get(FieldAccountId) != newConRec.get(FieldAccountId) ) { 
                        contact oldcontact = validOldContacts.get(validAccLoopRec.id);
                        
                        if (vdnMapforOldValidAcc.containsKey(oldcontact.AccountId)) {
                            System.debug('NS_IntegrationHelper onANIUpdate check if old map contains the accountid '+validAccLoopRec.AccountId);
                            // This ensures the change of contact accounts will delete the old ANI entry in TYES
                            string oldacctid = oldMap.get(validAccLoopRec.Id).id;
                            System.debug('NS_IntegrationHelper onANIUpdate check if old map contains the accountid '+validAccLoopRec.AccountId+' old '+oldacctid);
                           if (((vdnMapforOldValidAcc.get(oldcontact.AccountId).RecordTypeId !=NS3PLCustomer ) &&     // @Nanda 
                               vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId == NS3PLCustomer) || (vdnMapforOldValidAcc.get(oldcontact.AccountId).RecordTypeId !=OfflineCustomer ) &&     // @Nanda
                               vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId ==OfflineCustomer ) {     // @Nanda                 
                                
                                checkOldRecType = true;
                                // have to retrieve th VDN from the old account
                                // VDNExten = oldConRec.NS_PrimaryVDN__r.NS_VDNCode__c;
                                VDNExten = vdnMapforOldValidAcc.get(oldcontact.AccountId).NS_PrimaryVDN__r.NS_VDNCode__c;
                                // If there is no VDN assign the Unkwown VDN number   
                                if (VDNExten == null) {
                                    VDNExten = vdnforUnknownVDN.NS_VDNCode__c;   
                                }
                                ProcessChangeAccount = true;
                            }
                        }
                    }

                    // if There is an VDN process the Contact
                    if(VDNExten != null && VDNExten != ''){
                        boolean ProcessNonServInActive = false;   //  process NON service account contact if contact set to Inactive
                        boolean ProcessNonServToActive = false;   //  Process NON service account contact if contact is set to active
                        //  if not a service account process contact set to inactive contact for actionInd for 'D' delete   @dglaser
                        if ((vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId != OfflineCustomer) || (vdnMapforValidAcc.get(validAccLoopRec.AccountId).RecordTypeId !=NS3PLCustomer))  // @Nanda
                        {
                            if (oldConRec.get(Statusfield) == 'Active' && (oldConRec.get(Statusfield) != validAccLoopRec.NS_ContactStatus__c)) {
                                // set flag that ContactStatus was changed to inActive
                                // this will clear all the phone numbers assocated with the contact in TYES as ANI phone numbers  
                                ProcessNonServInActive = true;
                                System.debug('NS_IntegrationHelper onANIUpdate  ProcessNonServInActive: ');
                            // Check to see if the Contact moved from Inactive to Active.   
                            } else if (oldConRec.get(Statusfield) == 'Inactive' && (oldConRec.get(Statusfield) != validAccLoopRec.NS_ContactStatus__c)) {
                                // set flag to process all filled in phone numbers as insert  
                                ProcessNonServToActive = true;
                                System.debug('NS_IntegrationHelper onANIUpdate  ProcessNonServToActive: ');
                            // If the contacts account is changed then process all the phone numbers as an update
                            // with NEW VDN number   @dglaser
                            } else if (oldConRec.get(FieldAccountId) != newConRec.get(FieldAccountId) ) {
                                System.debug('NS_IntegrationHelper onANIUpdate  Contact Account changed');
                                ProcessChangeAccount = true;
                            }
                        }
                        for(String fieldName : fieldNameList){
                            NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper aniMaintWrapper = new NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper();
                            if(newConRec.get(fieldName) != oldConRec.get(fieldName)){ 
                                if((newConRec.get(fieldName) != oldConRec.get(fieldName)) && oldConRec.get(fieldName) !=null ){
                                    actionInd = NS_StaticVariablesUtility.UpdateActionInd;
                                    aniMaintWrapper.Phone_ANI = newConRec.get(fieldName) != null ? (String)newConRec.get(fieldName) : '';
                                }
                                if(newConRec.get(fieldName) == null || newConRec.get(fieldName) == NS_StaticVariablesUtility.Blank){
                                    actionInd = NS_StaticVariablesUtility.DeleteActionInd;
                                    aniMaintWrapper.Phone_ANI = '';                        
                                }else
                                    if(oldConRec.get(fieldName) == null || oldConRec.get(fieldName) == NS_StaticVariablesUtility.Blank){
                                    actionInd = NS_StaticVariablesUtility.InsertActionInd;
                                    aniMaintWrapper.Phone_ANI = newConRec.get(fieldName) != null ? (String)newConRec.get(fieldName) : '';                        
                                }else{
                                    aniMaintWrapper.Phone_ANI = newConRec.get(fieldName) != null ? (String)newConRec.get(fieldName) : '';
                                }
                                
                                aniMaintWrapper.ActionInd = actionInd;
                                aniMaintWrapper.Old_Phone_ANI = oldConRec.get(fieldName) != null ? (String)oldConRec.get(fieldName) : '';
                                aniMaintWrapper.VDNExten = VDNExten;
                                if(aniMaintWrapper.Phone_ANI.Length()== 10 || aniMaintWrapper.Phone_ANI.Length() == 0){     // @Nanda
                                offlineAccAniMaintenanceList.add(aniMaintWrapper);                                                                  
                                }                                                                                                                  
                            } else if (ProcessNonServInActive || ProcessNonServToActive || ProcessChangeAccount) {
                                // process NON Service Accounts where the contact has been set to INACTIVE  
                                if (oldConRec.get(fieldName) != null && oldConRec.get(fieldName) != '') {
                                    if (ProcessNonServToActive) {
                                        aniMaintWrapper.ActionInd = NS_StaticVariablesUtility.InsertActionInd;
                                        aniMaintWrapper.Phone_ANI = newConRec.get(fieldName) != null ? (String)newConRec.get(fieldName) : '';
                                    } else if (ProcessNonServInActive) {
                                        aniMaintWrapper.ActionInd = NS_StaticVariablesUtility.DeleteActionInd;
                                        aniMaintWrapper.Phone_ANI = '';
                                        aniMaintWrapper.Old_Phone_ANI = oldConRec.get(fieldName) != null ? (String)oldConRec.get(fieldName) : '';
                                    } else if (ProcessChangeAccount) {
                                        // Process each phonenumber to change the VDN number to the account of the 
                                        // updated contact.
                                        // If the old account was non-service  
                                        if (checkOldRecType) {
                                            aniMaintWrapper.ActionInd = NS_StaticVariablesUtility.DeleteActionInd;
                                            aniMaintWrapper.Phone_ANI = '';
                                            system.debug('NS_IntegrationHelper onANIUpdate delete old account phones');
                                        } else {    
                                            aniMaintWrapper.ActionInd = NS_StaticVariablesUtility.UpdateActionInd;
                                        
                                            aniMaintWrapper.Phone_ANI = newConRec.get(fieldName) != null ? (String)newConRec.get(fieldName) : '';
                                        }
                                        aniMaintWrapper.Old_Phone_ANI = oldConRec.get(fieldName) != null ? (String)oldConRec.get(fieldName) : '';
                                    }
                                    system.debug('NS_IntegrationHelper onANIUpdate Action Indicator '+aniMaintWrapper.ActionInd+ ' old phone '+aniMaintWrapper.Old_Phone_ANI);
                                    aniMaintWrapper.VDNExten = VDNExten;
                                     if(aniMaintWrapper.Phone_ANI.Length()== 10 || aniMaintWrapper.Phone_ANI.Length()==0){       // @Nanda 
                                    offlineAccAniMaintenanceList.add(aniMaintWrapper);
                                }
                            }
                        }
                        }
                    }
                }
            }
        
            if(!offlineAccAniMaintenanceList.isEmpty()){
                try{
                    System.debug('NS_IntegrationHelper onANIUpdate call NS_WebServiceHandler_ANIMaintenance.prepareOfflineAccAniUpdateBody');
                    NS_WebServiceHandler_ANIMaintenance.prepareOfflineAccAniUpdateBody(userFederationId,NS_StaticVariablesUtility.UpdateActionInd,offlineAccAniMaintenanceList);
                }catch(Exception e){
                    NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME1);
                }
            }    
        }
        //  system.debug('NS_IntegrationHelper onANIUpdate exited');
    }
    
    /*
When ANI/Phone is available during Insert of Account, sync it to TYES
*/
    public static void onANIInsert(Map<Id,Account> newMap){    
        String VDNExten = '';
        String PhoneANI;
        Set<Id> vdnIdForValidAccount = new Set<Id>();
        List<Id> validRecordTypes = new List<Id>();
        List<Account> validAccountForANIUpdate = new List<Account>();
        validRecordTypes.add(OnlineCustomerBusiness);
        validRecordTypes.add(OnlineCustomerCorporate);
        validRecordTypes.add(OnLineServiceAccount);
        validRecordTypes.add(NS3PLCustomer);
        validRecordTypes.add(OfflineCustomer);
        validRecordTypes.add(FieldLocation);  // @Daniel Glaser 
        //  system.debug('NS_IntegrationHelper onANIInsert entered');
        for(Account accLoopRec : newMap.values()){
            if(validRecordTypes.contains(accLoopRec.RecordTypeId)){
                if(accLoopRec.phone != null){
                    validAccountForANIUpdate.add(accLoopRec);
                    vdnIdForValidAccount.add(accLoopRec.NS_PrimaryVDN__c);
                }
            }
        }        
        
        Map<Id, NS_VDN__c> vdnMapforValidAcc = new Map<Id, NS_VDN__c>([Select Id, NS_VDNCode__c from NS_VDN__c where Id IN :vdnIdForValidAccount]);
       // NS_VDN__c vdnfor3PLAcc = [Select Id, NS_VDNCode__c from NS_VDN__c where Id = : System.Label.NS_3PLPrimaryVDN];
        NS_VDN__c vdnforUnknownVDN = [Select Id, NS_VDNCode__c from NS_VDN__c where Id = : System.Label.NS_UnknownPrimaryVDN];    // @dglaser
        List<NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper> offlineAccAniMaintenanceList = new List<NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper>();
        
        if(!validAccountForANIUpdate.isEmpty()){
            for(Account validAccLoopRec : validAccountForANIUpdate){
                
                /*if(validAccLoopRec.RecordTypeId == NS3PLCustomer) {
                    VDNExten = vdnfor3PLAcc != null ? vdnfor3PLAcc.NS_VDNCode__c : '';
                }*/
                VDNExten = vdnMapforValidAcc.containsKey(validAccLoopRec.NS_PrimaryVDN__c) ? vdnMapforValidAcc.get(validAccLoopRec.NS_PrimaryVDN__c).NS_VDNCode__c : '';
                //  system.debug('NS_IntegrationHelper onANIInsert VDN code: '+VDNExten);
                // If there is no VDN assign the Unkwown VDN number    @dglaser
                if (VDNExten == null) {
                    VDNExten = vdnforUnknownVDN.NS_VDNCode__c;   // @dglaser
                }

                PhoneANI = validAccLoopRec.phone != null ? validAccLoopRec.phone : '';
                
                if(VDNExten != null && VDNExten != ''){
                    NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper aniMaintWrapper = new NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper();
                    aniMaintWrapper.ActionInd = NS_StaticVariablesUtility.InsertActionInd;
                    aniMaintWrapper.Phone_ANI = PhoneANI;
                    aniMaintWrapper.Old_Phone_ANI = '';
                    aniMaintWrapper.VDNExten = VDNExten;
                    offlineAccAniMaintenanceList.add(aniMaintWrapper);
                }
                
            }    
            try{
                if(!offlineAccAniMaintenanceList.isEmpty()){
                    System.debug('NS_IntegrationHelper onANIInsert call NS_WebServiceHandler_ANIMaintenance.prepareOfflineAccAniUpdateBody');
                    NS_WebServiceHandler_ANIMaintenance.prepareOfflineAccAniUpdateBody(userFederationId,NS_StaticVariablesUtility.InsertActionInd,offlineAccAniMaintenanceList);
                }
                
            }catch(Exception e){
                NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME1);
            }
        }
        System.debug('NS_IntegrationHelper onANIInsert exited');   
    }
    
    /*
When ANI/Phone is changed during update of Account, sync it to TYES
*/
    public static void onANIUpdate(Map<Id, Account> newMap, Map<Id, Account> oldMap){
        String VDNExten='';
        String PhoneANI;
        String actionInd = NS_StaticVariablesUtility.UpdateActionInd;
        
        List<Account> validAccountForANIUpdate = new List<Account>();
        Set<Id> vdnIdForValidAccount = new Set<Id>();
        List<Id> validRecordTypes = new List<Id>();
        System.debug('NS_IntegrationHelper onANIUpdate entered');
        validRecordTypes.add(OfflineCustomer);
        validRecordTypes.add(OnlineCustomerBusiness);
        validRecordTypes.add(OnlineCustomerCorporate);        
        validRecordTypes.add(NS3PLCustomer);
        validRecordTypes.add(OnLineServiceAccount); //added: as discussed with Haibing
        validRecordTypes.add(FieldLocation);  // @Daniel Glaser
        
        for(Account accLoopRec : newMap.values()){
            if(validRecordTypes.contains(accLoopRec.RecordTypeId)){
                if(accLoopRec.NS_PrimaryVDN__c != null){
                    if(accLoopRec.phone != oldMap.get(accLoopRec.Id).phone || accLoopRec.NS_OfflineContactWorkPhone__c != oldMap.get(accLoopRec.Id).NS_OfflineContactWorkPhone__c){
                        validAccountForANIUpdate.add(accLoopRec);
                        vdnIdForValidAccount.add(accLoopRec.NS_PrimaryVDN__c);
                    }
                }
            }
        }
        
        Map<Id, NS_VDN__c> vdnMapforValidAcc = new Map<Id, NS_VDN__c>([Select Id, NS_VDNCode__c from NS_VDN__c where Id IN :vdnIdForValidAccount]);
        List<NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper> offlineAccAniMaintenanceList = new List<NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper>();
        
        if(!validAccountForANIUpdate.isEmpty()){
            for(Account validAccLoopRec : validAccountForANIUpdate){
                VDNExten = vdnMapforValidAcc.containsKey(validAccLoopRec.NS_PrimaryVDN__c) ? vdnMapforValidAcc.get(validAccLoopRec.NS_PrimaryVDN__c).NS_VDNCode__c : '';
                if(VDNExten != null && VDNExten != ''){
                    if(validAccLoopRec.phone != oldMap.get(validAccLoopRec.Id).phone ){                    
                        if(oldMap.get(validAccLoopRec.Id).phone == '' || oldMap.get(validAccLoopRec.Id).phone == null){
                            actionInd = NS_StaticVariablesUtility.InsertActionInd;
                        }
                        if(validAccLoopRec.phone == '' || validAccLoopRec.phone == null){
                            actionInd = NS_StaticVariablesUtility.DeleteActionInd;
                        }
                        NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper aniMaintWrapper = new NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper();
                        aniMaintWrapper.ActionInd = actionInd;
                        aniMaintWrapper.Phone_ANI = validAccLoopRec.phone != null ? validAccLoopRec.phone : '';
                        aniMaintWrapper.Old_Phone_ANI = oldMap.get(validAccLoopRec.Id).phone != null ? oldMap.get(validAccLoopRec.Id).phone : '';
                        aniMaintWrapper.VDNExten = VDNExten;
                        offlineAccAniMaintenanceList.add(aniMaintWrapper);
                    }
                    
                    if(validAccLoopRec.NS_OfflineContactWorkPhone__c != oldMap.get(validAccLoopRec.Id).NS_OfflineContactWorkPhone__c){
                        if(oldMap.get(validAccLoopRec.Id).NS_OfflineContactWorkPhone__c == '' || oldMap.get(validAccLoopRec.Id).NS_OfflineContactWorkPhone__c == null){
                            actionInd = NS_StaticVariablesUtility.InsertActionInd;
                        }
                        if(validAccLoopRec.NS_OfflineContactWorkPhone__c == '' || validAccLoopRec.NS_OfflineContactWorkPhone__c == null){
                            actionInd = NS_StaticVariablesUtility.DeleteActionInd;
                        }
                        NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper aniMaintWrapper = new NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper();
                        aniMaintWrapper.ActionInd = actionInd;
                        aniMaintWrapper.Phone_ANI = validAccLoopRec.NS_OfflineContactWorkPhone__c != null ? validAccLoopRec.NS_OfflineContactWorkPhone__c : '';
                        aniMaintWrapper.Old_Phone_ANI = oldMap.get(validAccLoopRec.Id).NS_OfflineContactWorkPhone__c != null ? oldMap.get(validAccLoopRec.Id).NS_OfflineContactWorkPhone__c : '';
                        aniMaintWrapper.VDNExten = VDNExten;
                        
                        if(aniMaintWrapper.Phone_ANI.Length() == 10 || aniMaintWrapper.Phone_ANI.Length() == 0){                            // @Nanda
                        offlineAccAniMaintenanceList.add(aniMaintWrapper);                       
                    }
                    }
                }
                try{
                    if(!offlineAccAniMaintenanceList.isEmpty()){
                        System.debug('NS_IntegrationHelper onANIUpdate call NS_WebServiceHandler_ANIMaintenance.prepareOfflineAccAniUpdateBody');
                        NS_WebServiceHandler_ANIMaintenance.prepareOfflineAccAniUpdateBody(userFederationId,actionInd,offlineAccAniMaintenanceList);
                    }
                }catch(Exception e){
                    NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME2);
                }
            }
        }
        System.debug('NS_IntegrationHelper onANIUpdate exited');
    }    
    
    /*
When VDN lookup is changed during update of service Account, sync it to TYES
*/
    public static void onCustomerVDNUpdate(Map<Id, Account> newMap, Map<Id, Account> oldMap){
        String cCode;
        String VDNExten = '';
        String sCode;
        boolean ifAniSyncNeeded = false;
        Map<Id,Account> validAccountForANIUpdate = new Map<Id,Account>();
        Set<Id> vdnIdForValidAccount = new Set<Id>();
        Set<Id> operatingStationIdForValidAccount = new Set<Id>();
        List<NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper> offlineAccAniMaintenanceList = new List<NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper>();
        
        //Prepare fields to be sysnced on contact update.
        List<String> fieldNameList = new List<String>();
        fieldNameList.add('Phone');
        fieldNameList.add('MobilePhone');
        fieldNameList.add('OtherPhone');
        fieldNameList.add('HomePhone');
        System.debug('NS_IntegrationHelper onCustomerVDNUpdate entered');
        for(Account accLoopRec : newMap.values()){
            if(accLoopRec.RecordTypeId == serviceAccId || accLoopRec.RecordTypeId == OnlineCustomerCorporate || accLoopRec.RecordTypeId == OnlineCustomerBusiness || accLoopRec.RecordTypeId == OfflineCustomer ||  accLoopRec.RecordTypeId == FieldLocation|| accLoopRec.RecordTypeId == NS3PLCustomer){   // @Daniel Glaser
                   if(oldMap.get(accLoopRec.Id).NS_PrimaryVDN__c != accLoopRec.NS_PrimaryVDN__c){
                        System.debug('NS_IntegrationHelper onCustomerVDNUpdate NS_PrimaryVDN__c '+accLoopRec.NS_PrimaryVDN__c);                     
                       validAccountForANIUpdate.put(accLoopRec.Id,accLoopRec);
                       vdnIdForValidAccount.add(accLoopRec.NS_PrimaryVDN__c);
                       operatingStationIdForValidAccount.add(accLoopRec.NS_OperatingStation__c);
                   }
               }
        }
        
        Map<Id, NS_VDN__c> vdnMapforValidAcc = new Map<Id, NS_VDN__c>([Select Id, NS_VDNCode__c from NS_VDN__c where Id IN :vdnIdForValidAccount]);
        Map<Id, NS_ServiceStations__c> operatingStationMapforValidAcc = new Map<Id, NS_ServiceStations__c>([Select Id, Name from NS_ServiceStations__c where Id IN :operatingStationIdForValidAccount]);
        Map<Id, Contact> contactToAccMap = new Map<Id, Contact>([Select Id, RecordTypeId, AccountId, Account.RecordTypeId, Account.Phone, Account.NS_PrimaryVDN__c, Phone, MobilePhone, OtherPhone, HomePhone from Contact where AccountId IN :validAccountForANIUpdate.keySet()]);
        //  system.debug('NS_IntegrationHelper onCustomerVDNUpdate contacts to Account map '+contactToAccMap.size());
        for(Account validAccLoopRec : validAccountForANIUpdate.values()){
            //If service account, call "SetCustomerVDN" action of TYES for VDN sync.
            if(validAccLoopRec.RecordTypeId == serviceAccId){
                VDNExten = vdnMapforValidAcc.containsKey(validAccLoopRec.NS_PrimaryVDN__c) ? vdnMapforValidAcc.get(validAccLoopRec.NS_PrimaryVDN__c).NS_VDNCode__c : NS_StaticVariablesUtility.Blank ;
                sCode = operatingStationMapforValidAcc.containsKey(validAccLoopRec.NS_OperatingStation__c) ? operatingStationMapforValidAcc.get(validAccLoopRec.NS_OperatingStation__c).Name.split('-')[0] : NS_StaticVariablesUtility.Blank ;
                cCode = validAccLoopRec.NS_ClassCode__c != null ? validAccLoopRec.NS_ClassCode__c : NS_StaticVariablesUtility.Blank ;
                
                if(validAccLoopRec.NS_PrimaryVDN__c == null && validAccLoopRec.phone != null){
                    NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper aniMaintWrapperForAcc = new NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper();
                    aniMaintWrapperForAcc.ActionInd = NS_StaticVariablesUtility.DeleteActionInd;
                    aniMaintWrapperForAcc.Phone_ANI = NS_StaticVariablesUtility.Blank;
                    aniMaintWrapperForAcc.Old_Phone_ANI = validAccLoopRec.phone;
                    aniMaintWrapperForAcc.VDNExten = vdnMapforValidAcc.containsKey(validAccLoopRec.NS_PrimaryVDN__c) ? vdnMapforValidAcc.get(validAccLoopRec.NS_PrimaryVDN__c).NS_VDNCode__c : NS_StaticVariablesUtility.Blank ;
                    offlineAccAniMaintenanceList.add(aniMaintWrapperForAcc);
                }
                if(validAccLoopRec.NS_PrimaryVDN__c != null && validAccLoopRec.phone != null){
                    NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper aniMaintWrapperForAcc = new NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper();
                    aniMaintWrapperForAcc.ActionInd = NS_StaticVariablesUtility.InsertActionInd;
                    aniMaintWrapperForAcc.Phone_ANI = validAccLoopRec.phone;
                    aniMaintWrapperForAcc.Old_Phone_ANI = NS_StaticVariablesUtility.Blank;
                    aniMaintWrapperForAcc.VDNExten = vdnMapforValidAcc.containsKey(validAccLoopRec.NS_PrimaryVDN__c) ? vdnMapforValidAcc.get(validAccLoopRec.NS_PrimaryVDN__c).NS_VDNCode__c : NS_StaticVariablesUtility.Blank ;
                    offlineAccAniMaintenanceList.add(aniMaintWrapperForAcc);
                }
                // this will be bulkified. 
                try{
                    System.debug('NS_IntegrationHelper onCustomerVDNUpdate call NS_WebServiceHandler_ANIMaintenance.invoke_SetCustomerVDN');
                    NS_WebServiceHandler_ANIMaintenance.invoke_SetCustomerVDN(userFederationId,cCode,sCode,VDNExten);
                }catch(Exception e){
                    NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME3);
                }
            }
            //if Non Service account, check if phone number exist, if yes, send phone number using offlineANIMaintenance call to TYES.
            if((validAccLoopRec.RecordTypeId == OnlineCustomerCorporate || validAccLoopRec.RecordTypeId == OnlineCustomerBusiness ||  validAccLoopRec.RecordTypeId == FieldLocation ||validAccLoopRec.RecordTypeId ==NS3PLCustomer ||validAccLoopRec.RecordTypeId ==OfflineCustomer) &&   // @Daniel Glaser
               validAccLoopRec.phone != null){
                   NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper aniMaintWrapperForAcc = new NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper();
                   if(validAccLoopRec.NS_PrimaryVDN__c != null){
                       aniMaintWrapperForAcc.ActionInd = NS_StaticVariablesUtility.InsertActionInd;
                       aniMaintWrapperForAcc.Phone_ANI = validAccLoopRec.phone;
                       aniMaintWrapperForAcc.Old_Phone_ANI = NS_StaticVariablesUtility.Blank;
                       aniMaintWrapperForAcc.VDNExten = vdnMapforValidAcc.containsKey(validAccLoopRec.NS_PrimaryVDN__c) ? vdnMapforValidAcc.get(validAccLoopRec.NS_PrimaryVDN__c).NS_VDNCode__c : NS_StaticVariablesUtility.Blank ;
                   }else{
                       aniMaintWrapperForAcc.ActionInd = NS_StaticVariablesUtility.DeleteActionInd;
                       aniMaintWrapperForAcc.Phone_ANI = NS_StaticVariablesUtility.Blank;
                       aniMaintWrapperForAcc.Old_Phone_ANI = oldMap.get(validAccLoopRec.Id).phone;
                       aniMaintWrapperForAcc.VDNExten = vdnMapforValidAcc.containsKey(validAccLoopRec.NS_PrimaryVDN__c) ? vdnMapforValidAcc.get(oldMap.get(validAccLoopRec.Id).NS_PrimaryVDN__c).NS_VDNCode__c : NS_StaticVariablesUtility.Blank ;
                   }
                   if(aniMaintWrapperForAcc.Phone_ANI.Length() == 10 || aniMaintWrapperForAcc.Phone_ANI.Length() == 10){                            // @ Nanda 
                   offlineAccAniMaintenanceList.add(aniMaintWrapperForAcc);                     //   @ Nanda 
               }
               }
        }
        //for Non Service account, check if phone number exist on Contact, if yes, send phone number using offlineANIMaintenance call to TYES.
        SObject tmpConRec;
        String actionInd;
        for(Contact con : contactToAccMap.values()){
            if(con.Account.NS_PrimaryVDN__c != null){ 
                actionInd = NS_StaticVariablesUtility.InsertActionInd;
            }else{
                actionInd = NS_StaticVariablesUtility.DeleteActionInd;
            }            
            //  system.debug('NS_IntegrationHelper onCustomerVDNUpdate walk through contacts id '+con.id+ ' actionInd '+actionInd);
            if(con.Account.RecordTypeId == OnlineCustomerCorporate || con.Account.RecordTypeId == OnlineCustomerBusiness  || con.Account.RecordTypeId == OfflineCustomer || con.Account.RecordTypeId == FieldLocation || con.Account.RecordTypeId ==NS3PLCustomer ||con.Account.RecordTypeId == OfflineCustomer){   // @Daniel Glaser
               //  system.debug('NS_IntegrationHelper onCustomerVDNUpdate online '); 
                tmpConRec = (SObject)con;
                for(String fieldName : fieldNameList){
                    if(tmpConRec.get(fieldName) != null && tmpConRec.get(fieldName) != NS_StaticVariablesUtility.Blank){
                        System.debug('NS_IntegrationHelper onCustomerVDNUpdate fieldname update '+fieldname);
                        NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper aniMaintWrapperForCon = new NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper();
                        aniMaintWrapperForCon.ActionInd = actionInd;
                        if(actionInd == NS_StaticVariablesUtility.InsertActionInd){
                            aniMaintWrapperForCon.Phone_ANI = (String)tmpConRec.get(fieldName);
                            aniMaintWrapperForCon.Old_Phone_ANI = NS_StaticVariablesUtility.Blank;
                            aniMaintWrapperForCon.VDNExten = vdnMapforValidAcc.containsKey(con.Account.NS_PrimaryVDN__c) ? vdnMapforValidAcc.get(con.Account.NS_PrimaryVDN__c).NS_VDNCode__c : NS_StaticVariablesUtility.Blank ;
                        }
                        if(actionInd == NS_StaticVariablesUtility.DeleteActionInd){
                            aniMaintWrapperForCon.Phone_ANI = NS_StaticVariablesUtility.Blank;
                            aniMaintWrapperForCon.Old_Phone_ANI = (String)tmpConRec.get(fieldName);
                            aniMaintWrapperForCon.VDNExten = vdnMapforValidAcc.containsKey(con.Account.NS_PrimaryVDN__c) ? vdnMapforValidAcc.get(con.Account.NS_PrimaryVDN__c).NS_VDNCode__c : NS_StaticVariablesUtility.Blank ;
                        }
                        if(aniMaintWrapperForCon.Phone_ANI.Length() == 10 || aniMaintWrapperForCon.Phone_ANI.Length() == 10){                 // @Nanda 
                        offlineAccAniMaintenanceList.add(aniMaintWrapperForCon);            
                    }
                    }
                }
            }
            else if(con.Account.RecordTypeId == serviceAccId && con.RecordTypeId == AniOnlyCustomer) {
                System.debug('NS_IntegrationHelper onCustomerVDNUpdate service');  
                if(con.Phone != null && con.Phone != NS_StaticVariablesUtility.Blank){
                    NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper aniMaintWrapperForCon = new NS_StaticVariablesUtility.OfflineAccAniMaintenanceWrapper();
                    aniMaintWrapperForCon.ActionInd = actionInd;
                    if(actionInd == NS_StaticVariablesUtility.InsertActionInd){
                        aniMaintWrapperForCon.Phone_ANI = con.Phone;
                        aniMaintWrapperForCon.Old_Phone_ANI = NS_StaticVariablesUtility.Blank;
                        aniMaintWrapperForCon.VDNExten = vdnMapforValidAcc.containsKey(con.Account.NS_PrimaryVDN__c) ? vdnMapforValidAcc.get(con.Account.NS_PrimaryVDN__c).NS_VDNCode__c : NS_StaticVariablesUtility.Blank ;
                    }
                    if(actionInd == NS_StaticVariablesUtility.DeleteActionInd){
                        aniMaintWrapperForCon.Phone_ANI = NS_StaticVariablesUtility.Blank;
                        aniMaintWrapperForCon.Old_Phone_ANI = con.Phone;
                        aniMaintWrapperForCon.VDNExten = vdnMapforValidAcc.containsKey(con.Account.NS_PrimaryVDN__c) ? vdnMapforValidAcc.get(con.Account.NS_PrimaryVDN__c).NS_VDNCode__c : NS_StaticVariablesUtility.Blank ;
                    }
                    if(aniMaintWrapperForCon.Phone_ANI.Length() == 10 || aniMaintWrapperForCon.Phone_ANI.Length() == 0){          // @Nanda
                    offlineAccAniMaintenanceList.add(aniMaintWrapperForCon);     
                }
                }
            }
        }
        // if contact found for Non Service, sync it to TYES.
        if(!offlineAccAniMaintenanceList.isEmpty()){
            try{
                System.debug('NS_IntegrationHelper onCustomerVDNUpdate call NS_WebServiceHandler_ANIMaintenance.prepareOfflineAccAniUpdateBody');
                NS_WebServiceHandler_ANIMaintenance.prepareOfflineAccAniUpdateBody(userFederationId,NS_StaticVariablesUtility.InsertActionInd,offlineAccAniMaintenanceList);
            }catch(Exception e){
                NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME3);
            }
        }
        System.debug('NS_IntegrationHelper onCustomerVDNUpdate exited');
    }
    
    /*
Description  - This method is used to sync contact to TYES when updated. The contact should belong to a service account.
*/
    public static void invokeManageOnlineCustomerContactOnUpdate(Map<Id, Contact> newMap, Map<Id, Contact> oldMap){
        Set<Id> AccountIdSet = new Set<Id>();
        Set<Id> ContactIdSet = new Set<Id>();
        List<NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper> CustomerContactWrapperList;
        CustomerContactWrapperList = new List<NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper>();
        
        List<String> allValidFields = NS_StaticVariablesUtility.getValidFieldsForContactMaintenance();
        
        Set<Id> rtIds = new Set<Id>();
        rtIds.add(OnLineServiceAccount);
        
        SObject newConSobjectTemp;
        SObject oldConSobjectTemp;
        System.debug('NS_IntegrationHelper invokeManageOnlineCustomerContactOnUpdate entered');
        for(Contact newContact : newMap.values()){
            if(newContact.AccountId != null){
                AccountIdSet.add(newContact.AccountId);
            }
        }
        
        Map<Id,Account> AccountMap = new Map<Id, Account>([Select Id,RecordTypeId,NS_ClassCode__c,NS_ControllingStation__c,NS_OperatingStation__c, NS_OperatingStation__r.name, NS_OperatingStation__r.NS_OperatingStationCode__c
                                                           from Account 
                                                           where Id IN :AccountIdSet and RecordTypeId IN :rtIds]);
        
        for(NS_PrimaryContact__c pc : [Select Id,NS_ContactName__c from NS_PrimaryContact__c 
                                       where NS_ContactName__c IN :newMap.keySet()])
                                       {
                                           ContactIdSet.add(pc.NS_ContactName__c);
                                       }
        
        for(Contact newContactTemp : newMap.values()){
            System.debug('NS_IntegrationHelper invokeManageOnlineCustomerContactOnUpdate newContactTemp');
            if(isValidForSync(newContactTemp)){
                System.debug('NS_IntegrationHelper invokeManageOnlineCustomerContactOnUpdate isValidForSync');
                if(AccountMap.containsKey(newContactTemp.AccountId)){
                    System.debug('NS_IntegrationHelper invokeManageOnlineCustomerContactOnUpdate AccountMap');
                    Contact oldContactTemp = oldMap.get(newContactTemp.Id);
                    oldConSobjectTemp = (SObject)oldContactTemp;
                    newConSobjectTemp = (SObject)newContactTemp;
                    for(String validfield : allValidFields){
                        // @Daniel Glaser get the old and new contact information to check status
                        Contact oldContact = oldMap.get(newContactTemp.Id);
                        Contact newContact = newMap.get(newContactTemp.Id);
                        System.debug('NS_IntegrationHelper invokeManageOnlineCustomerContactOnUpdate validfield '+validfield );
                        System.debug('NS_IntegrationHelper invokeManageOnlineCustomerContactOnUpdate status '+newContact.NS_ContactStatus__c);
                        // @Daniel Glaser add checking for a change to status only when status is moved to Active from Inactive
                        //   This allows status activate to be sent  to TYES
                        if (oldConSobjectTemp.get(validfield) != newConSobjectTemp.get(validfield) || 
                            (oldContact.NS_ContactStatus__c == 'Inactive' && (oldContact.NS_ContactStatus__c != newContact.NS_ContactStatus__c))) {
                            //  system.debug('>>>>> Valid contact'+newConSobjectTemp);
                            // Contact oldContact = oldMap.get(newContactTemp.Id);  @DG
                            // Contact newContact = newMap.get(newContactTemp.Id);  @DG
                            Account contactsAccount = AccountMap.get(newContactTemp.AccountId);
                            
                            NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper mocw = new NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper();
                            mocw.Action_Ind = NS_StaticVariablesUtility.UpdateActionInd;
                            mocw.ClassCode = contactsAccount.NS_ClassCode__c == null ? NS_StaticVariablesUtility.Blank : contactsAccount.NS_ClassCode__c;
                            mocw.Comment = newContact.Description == null ? NS_StaticVariablesUtility.Blank : newContact.Description;
                            mocw.Commodity = newContact.NS_Commodity__c == null ? NS_StaticVariablesUtility.Blank : newContact.NS_Commodity__c;
                            mocw.New_Cell_Phone = newContact.MobilePhone == null ? NS_StaticVariablesUtility.Blank : newContact.MobilePhone;
                            mocw.New_Email = newContact.Email == null ? NS_StaticVariablesUtility.Blank : newContact.Email;
                            mocw.New_Fax = newContact.Fax == null ? NS_StaticVariablesUtility.Blank : newContact.Fax;
                            mocw.New_First_Name = newContact.FirstName == null ? NS_StaticVariablesUtility.Blank : newContact.FirstName;
                            mocw.New_Last_Name = newContact.LastName == null ? NS_StaticVariablesUtility.Blank : newContact.LastName;
                            mocw.New_Phone_1 = newContact.Phone == null ? NS_StaticVariablesUtility.Blank : newContact.Phone;
                            mocw.New_Phone_1_Ext = newContact.NS_Work_Phone_Ext__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(newContact.NS_Work_Phone_Ext__c);
                            mocw.New_Phone_2 = newContact.OtherPhone == null ? NS_StaticVariablesUtility.Blank : newContact.OtherPhone;
                            mocw.New_Phone_2_Ext = newContact.NS_OtherPhoneExt__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(newContact.NS_OtherPhoneExt__c);
                            mocw.New_Phone_3 = newContact.HomePhone == null ? NS_StaticVariablesUtility.Blank : newContact.HomePhone;
                            mocw.New_Phone_3_Ext = newContact.NS_OtherPhone2Ext__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(newContact.NS_OtherPhone2Ext__c);
                            mocw.Old_Cell_Phone = oldContact.MobilePhone == null ? NS_StaticVariablesUtility.Blank : oldContact.MobilePhone;
                            mocw.Old_Email = oldContact.Email == null ? NS_StaticVariablesUtility.Blank : oldContact.Email;
                            mocw.Old_Fax = oldContact.Fax == null ? NS_StaticVariablesUtility.Blank : oldContact.Fax;
                            mocw.Old_First_Name = oldContact.FirstName == null ? NS_StaticVariablesUtility.Blank : oldContact.FirstName;
                            mocw.Old_Last_Name = oldContact.LastName == null ? NS_StaticVariablesUtility.Blank : oldContact.LastName;
                            mocw.Old_Phone_1 = oldContact.Phone == null ? NS_StaticVariablesUtility.Blank : oldContact.Phone;
                            mocw.Old_Phone_1_Ext = oldContact.NS_Work_Phone_Ext__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(oldContact.NS_Work_Phone_Ext__c);
                            mocw.Old_Phone_2 = oldContact.OtherPhone == null ? NS_StaticVariablesUtility.Blank : oldContact.OtherPhone;
                            mocw.Old_Phone_2_Ext = oldContact.NS_OtherPhoneExt__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(oldContact.NS_OtherPhoneExt__c);
                            mocw.Old_Phone_3 = oldContact.HomePhone == null ? NS_StaticVariablesUtility.Blank : oldContact.HomePhone;
                            mocw.Old_Phone_3_Ext = oldContact.NS_OtherPhone2Ext__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(oldContact.NS_OtherPhone2Ext__c);
                            mocw.Primary_Indicator = ContactIdSet.contains(newContact.Id) ? NS_StaticVariablesUtility.TRUE_STR : NS_StaticVariablesUtility.FALSE_STR;
                            mocw.Role = newContact.NS_OSSContactRole__c == null ? NS_StaticVariablesUtility.Blank : newContact.NS_OSSContactRole__c;
                            mocw.StationCode = contactsAccount.NS_OperatingStation__c != null ? contactsAccount.NS_OperatingStation__r.NS_OperatingStationCode__c : NS_StaticVariablesUtility.Blank ;
                            // @Daniel Glaser 
                            //  mocw.StationCode = contactsAccount.NS_OperatingStation__c != null ? contactsAccount.NS_OperatingStation__r.name.split('-')[0] : NS_StaticVariablesUtility.Blank ;
                            //  system.debug('Station Code:'+mocw.StationCode);
                            //  system.debug('contactsAccount.NS_OperatingStation__r'+contactsAccount.NS_OperatingStation__r);
                            CustomerContactWrapperList.add(mocw);
                            
                            try {
                                System.debug('NS_IntegrationHelper invokeManageOnlineCustomerContactOnUpdate call NS_WebServiceHandler_ANIMaintenance.prepareManageOnlineCustomerContactRequest');
                                NS_WebServiceHandler_ANIMaintenance.prepareManageOnlineCustomerContactRequest(CustomerContactWrapperList);
                            }
                            catch(Exception e){
                                NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME4);
                            }
                            
                            break;
                        }
                    }
                }
            }
        }
        System.debug('NS_IntegrationHelper invokeManageOnlineCustomerContactOnUpdate exited');
    }
    
    /*
Description  - This method is used to sync contact to TYES when updated. The contact should belong to a Service,3PL and Offline Account.
*/ 
    public static void invokeManageOnlineCustomerContactOnInsert(Map<Id, Contact> newMap){
        Set<Id> AccountIdSet = new Set<Id>();
        List<NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper> CustomerContactWrapperList;
        CustomerContactWrapperList = new List<NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper>();
        
        Id onLineServiceAccount = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerService'].Id;
        Id OnLineCorporateAccount = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerCorporate'].Id;
        Id OnLineBusinessAccount = [SELECT Id FROM RecordType WHERE DeveloperName ='NS_OnlineCustomerBusiness'].Id;
        
        Set<Id> rtIds = new Set<Id>();
        rtIds.add(OnLineServiceAccount);
        rtIds.add(NS3PLCustomer);                         // @Nanda
        rtIds.add(OfflineCustomer);                       // @Nanda
        System.debug('NS_IntegrationHelper invokeManageOnlineCustomerContactOnInsert entered');
        for(Contact newContact : newMap.values()){
            AccountIdSet.add(newContact.AccountId);
        }
        
        Map<Id,Account> AccountMap = new Map<Id, Account>([Select Id,RecordTypeId,NS_ClassCode__c,NS_ControllingStation__c,NS_OperatingStation__c,NS_OperatingStation__r.name,NS_OperatingStation__r.NS_OperatingStationCode__c 
                                                           from Account 
                                                           where Id IN :AccountIdSet and RecordTypeId IN :rtIds]);
        
        for(Contact newContact : newMap.values()){   
            if(isValidForSync(newContact)){
                if(AccountMap.containsKey(newContact.AccountId)){                
                    Account contactsAccount = AccountMap.get(newContact.AccountId);                
                    NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper mocw = new NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper();
                    mocw.Action_Ind = NS_StaticVariablesUtility.InsertActionInd;
                    mocw.ClassCode = contactsAccount.NS_ClassCode__c == null ? NS_StaticVariablesUtility.Blank : contactsAccount.NS_ClassCode__c;
                    mocw.Comment = newContact.Description == null ? NS_StaticVariablesUtility.Blank : newContact.Description;
                    mocw.Commodity = newContact.NS_Commodity__c == null ? NS_StaticVariablesUtility.Blank : newContact.NS_Commodity__c;
                    mocw.New_Cell_Phone = newContact.MobilePhone == null ? NS_StaticVariablesUtility.Blank : newContact.MobilePhone;
                    mocw.New_Email = newContact.Email == null ? NS_StaticVariablesUtility.Blank : newContact.Email;
                    mocw.New_Fax = newContact.Fax == null ? NS_StaticVariablesUtility.Blank : newContact.Fax;
                    mocw.New_First_Name = newContact.FirstName == null ? NS_StaticVariablesUtility.Blank : newContact.FirstName;
                    mocw.New_Last_Name = newContact.LastName == null ? NS_StaticVariablesUtility.Blank : newContact.LastName;
                    mocw.New_Phone_1 = newContact.Phone == null ? NS_StaticVariablesUtility.Blank : newContact.Phone;
                    mocw.New_Phone_1_Ext = newContact.NS_Work_Phone_Ext__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(newContact.NS_Work_Phone_Ext__c);
                    mocw.New_Phone_2 = newContact.OtherPhone == null ? NS_StaticVariablesUtility.Blank : newContact.OtherPhone;
                    mocw.New_Phone_2_Ext = newContact.NS_OtherPhoneExt__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(newContact.NS_OtherPhoneExt__c);
                    mocw.New_Phone_3 = newContact.HomePhone == null ? NS_StaticVariablesUtility.Blank : newContact.HomePhone;
                    mocw.New_Phone_3_Ext = newContact.NS_OtherPhone2Ext__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(newContact.NS_OtherPhone2Ext__c);
                    mocw.Primary_Indicator = NS_StaticVariablesUtility.FALSE_STR;
                    mocw.Role = newContact.NS_OSSContactRole__c == null ? NS_StaticVariablesUtility.Blank : newContact.NS_OSSContactRole__c;
                    // The following line was commented because the next line is the correct method for setting the Station Code
                    // mocw.StationCode = contactsAccount.NS_OperatingStation__c != null ? contactsAccount.NS_OperatingStation__r.name.split('-')[0] : NS_StaticVariablesUtility.Blank ;
                    mocw.StationCode = ContactsAccount.NS_OperatingStation__c != null ? ContactsAccount.NS_OperatingStation__r.NS_OperatingStationCode__c : NS_StaticVariablesUtility.Blank ;
                    
                    CustomerContactWrapperList.add(mocw);
                    
                    try{
                        System.debug('NS_IntegrationHelper invokeManageOnlineCustomerContactOnInsert call NS_WebServiceHandler_ANIMaintenance.prepareManageOnlineCustomerContactRequest');
                        NS_WebServiceHandler_ANIMaintenance.prepareManageOnlineCustomerContactRequest(CustomerContactWrapperList);
                    }
                    catch(Exception e){
                        NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME4);
                    }
                    
                    break;
                }
            }
        }
        System.debug('NS_IntegrationHelper invokeManageOnlineCustomerContactOnInsert exited');
    }
    
    public static void invoke_VDNMaintenanceOnInsert(Map<Id,NS_VDN__c> vdnNewMap){
        String Description;
        String NewVDNExten;
        String OldVDNExten;
        System.debug('NS_IntegrationHelper invoke_VDNMaintenanceOnInsert entered');
        for(NS_VDN__c newVdnRec : vdnNewMap.values()){
            Description = newVdnRec.NS_VDNDescription__c;
            NewVDNExten = newVdnRec.NS_VDNCode__c;
            OldVDNExten = ' ';
            
            try{
                System.debug('NS_IntegrationHelper invoke_VDNMaintenanceOnInsert call NS_WebServiceHandler_ANIMaintenance.invoke_VDN_Maintenance');
                NS_WebServiceHandler_ANIMaintenance.invoke_VDN_Maintenance(userFederationId,NS_StaticVariablesUtility.InsertActionInd,Description,NewVDNExten,OldVDNExten);
            }catch(Exception e){
                NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME5);
            }
        }
        System.debug('NS_IntegrationHelper invoke_VDNMaintenanceOnInsert exited');
    }
    
    public static void invoke_VDNMaintenanceOnUpdate(Map<Id,NS_VDN__c> vdnNewMap, Map<Id,NS_VDN__c> vdnOldMap){
        
        NS_VDN__c oldVdnRec;
        String Description;
        String NewVDNExten;
        String OldVDNExten;
        System.debug('NS_IntegrationHelper invoke_VDNMaintenanceOnUpdate entered');
        for(NS_VDN__c newVdnRec : vdnNewMap.values()){
            
            oldVdnRec = vdnOldMap.get(newVdnRec.Id);
            Description = newVdnRec.NS_VDNDescription__c;
            NewVDNExten = newVdnRec.NS_VDNCode__c;
            OldVDNExten = oldVdnRec.NS_VDNCode__c;
            
            if(!(newVdnRec.NS_VDNCode__c.equals(oldVdnRec.NS_VDNCode__c)) || !(newVdnRec.NS_VDNDescription__c.equals(oldVdnRec.NS_VDNDescription__c))){
                try{
                    System.debug('NS_IntegrationHelper invoke_VDNMaintenanceOnUpdate call NS_WebServiceHandler_ANIMaintenance.invoke_VDN_Maintenance');
                    NS_WebServiceHandler_ANIMaintenance.invoke_VDN_Maintenance(userFederationId,NS_StaticVariablesUtility.UpdateActionInd,Description,NewVDNExten,OldVDNExten);
                }catch(Exception e){
                    NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME6);
                }
            }
        }
        System.debug('NS_IntegrationHelper invoke_VDNMaintenanceOnUpdate exited');
    }
    
    /* New enhancement
* On Delete
* 14-08-2018
*/
    public static void invoke_VDNMaintenanceOnDelete(Map<Id,NS_VDN__c> vdnNewMap, Map<Id,NS_VDN__c> vdnOldMap){
        
        NS_VDN__c oldVdnRec;
        String Description;
        String NewVDNExten;
        String OldVDNExten;
        System.debug('NS_IntegrationHelper invoke_VDNMaintenanceOnDelete entered');
        for(NS_VDN__c newVdnRec : vdnOldMap.values()){
            
            oldVdnRec = vdnOldMap.get(newVdnRec.Id);
            Description = oldVdnRec.NS_VDNDescription__c;
            NewVDNExten = '';
            OldVDNExten = oldVdnRec.NS_VDNCode__c;
            try{
                System.debug('NS_IntegrationHelper invoke_VDNMaintenanceOnDelete call NS_WebServiceHandler_ANIMaintenance.invoke_VDN_Maintenance');
                NS_WebServiceHandler_ANIMaintenance.invoke_VDN_Maintenance(userFederationId,NS_StaticVariablesUtility.DeleteActionInd,Description,NewVDNExten,OldVDNExten);
            }catch(Exception e){
                NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME9);
            }
            
        }
        System.debug('NS_IntegrationHelper invoke_VDNMaintenanceOnDelete exited');
    }
    public static void onCustomerContactInsert(Map<Id, NS_PrimaryContact__c> newMap){
        Set<Id> accountIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        Set<Id> rtIds = new Set<Id>();
        Map<Id,String> primContToRoleMap = new Map<Id,String>();
        
        rtIds.add(OnLineServiceAccount);
        rtIds.add(OnlineCustomerBusiness);
        rtIds.add(OnlineCustomerCorporate);
        
        List<NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper> CustomerContactWrapperList =  new List<NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper>();
        System.debug('NS_IntegrationHelper invoke_VDNMaintenanceOnDelete entered');
        for(NS_PrimaryContact__c newPC : newMap.values()){
            contactIds.add(newPC.NS_ContactName__c);
        }
        if(!contactIds.isEmpty()){
            for(Contact primaryConDetail : [Select Id, NS_Commodity__c, Email, Title, Fax,  Phone,NS_Work_Phone_Ext__c, MobilePhone, FirstName, LastName, HomePhone, OtherPhone, NS_OtherPhone2Ext__c,NS_OtherPhoneExt__c,
                                            NS_OSSContactRole__c,AccountId,Account.NS_ClassCode__c,Account.NS_ControllingStation__c
                                            from Contact where ID IN :contactIds AND Account.RecordTypeId IN :rtIds]){
                                                NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper mocw = new NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper();
                                                mocw.Action_Ind = NS_StaticVariablesUtility.InsertActionInd;
                                                mocw.ClassCode = primaryConDetail.Account.NS_ClassCode__c == null ? NS_StaticVariablesUtility.Blank : primaryConDetail.Account.NS_ClassCode__c;
                                                mocw.Comment = primaryConDetail.Title ==  null ? NS_StaticVariablesUtility.Blank : primaryConDetail.Title;
                                                mocw.Commodity = primaryConDetail.NS_Commodity__c ==  null ? NS_StaticVariablesUtility.Blank : primaryConDetail.NS_Commodity__c;
                                                mocw.New_Cell_Phone = primaryConDetail.MobilePhone == null ? NS_StaticVariablesUtility.Blank : primaryConDetail.MobilePhone;
                                                mocw.New_Email = primaryConDetail.Email == null ? NS_StaticVariablesUtility.Blank : primaryConDetail.Email;
                                                mocw.New_Fax = primaryConDetail.Fax == null ? NS_StaticVariablesUtility.Blank : primaryConDetail.Fax;
                                                mocw.New_First_Name = primaryConDetail.FirstName ==  null ? NS_StaticVariablesUtility.Blank : primaryConDetail.FirstName;
                                                mocw.New_Last_Name = primaryConDetail.LastName ==  null ? NS_StaticVariablesUtility.Blank : primaryConDetail.LastName;
                                                mocw.New_Phone_1 = primaryConDetail.Phone == null ? NS_StaticVariablesUtility.Blank : primaryConDetail.Phone;
                                                mocw.New_Phone_1_Ext = primaryConDetail.NS_Work_Phone_Ext__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(primaryConDetail.NS_Work_Phone_Ext__c);
                                                mocw.New_Phone_2 = primaryConDetail.OtherPhone == null ? NS_StaticVariablesUtility.Blank : primaryConDetail.OtherPhone;
                                                mocw.New_Phone_2_Ext = primaryConDetail.NS_OtherPhoneExt__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(primaryConDetail.NS_OtherPhoneExt__c);
                                                mocw.New_Phone_3 = primaryConDetail.HomePhone == null ? NS_StaticVariablesUtility.Blank : primaryConDetail.HomePhone;
                                                mocw.New_Phone_3_Ext = primaryConDetail.NS_OtherPhone2Ext__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(primaryConDetail.NS_OtherPhone2Ext__c);
                                                mocw.Primary_Indicator = NS_StaticVariablesUtility.TRUE_STR;
                                                mocw.Role = primaryConDetail.NS_OSSContactRole__c == null ? NS_StaticVariablesUtility.Blank : primaryConDetail.NS_OSSContactRole__c;
                                                // mocw.StationCode = primaryConDetail.Account.NS_ControllingStation__c != null ? primaryConDetail.Account.NS_ControllingStation__c.split('-')[0] : ''; // @DG use next line
                                                mocw.StationCode = primaryConDetail.Account.NS_OperatingStation__c != null ? primaryConDetail.Account.NS_OperatingStation__r.NS_OperatingStationCode__c : NS_StaticVariablesUtility.Blank ;
                                                CustomerContactWrapperList.add(mocw);
                                            }
            if(!CustomerContactWrapperList.isEmpty()){
                try{
                    System.debug('NS_IntegrationHelper invoke_VDNMaintenanceOnDelete call NS_WebServiceHandler_ANIMaintenance.prepareManageOnlineCustomerContactRequest');
                    NS_WebServiceHandler_ANIMaintenance.prepareManageOnlineCustomerContactRequest(CustomerContactWrapperList);
                }catch(Exception e){
                    NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME7);
                }
            }
        }
        System.debug('NS_IntegrationHelper invoke_VDNMaintenanceOnDelete exited');
    }
    
    public static void onCustomerContactUpdate(Map<Id, NS_PrimaryContact__c> newMap, Map<Id, NS_PrimaryContact__c> oldMap){
        Set<Id> accountIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        Set<Id> rtIds = new Set<Id>();
        Set<Id> oldContactIds = new Set<Id>();
        Map<Id,String> primContToRoleMap = new Map<Id,String>();
        List<NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper> CustomerContactWrapperList =  new List<NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper>();
        
        rtIds.add(OnLineServiceAccount);
        rtIds.add(OnlineCustomerCorporate);
        rtIds.add(OnlineCustomerBusiness);
        System.debug('NS_IntegrationHelper onCustomerContactUpdate entered');
        for(NS_PrimaryContact__c newPC : newMap.values()){
            
            if(newPC.NS_ContactName__c != null && newPC.NS_ContactName__c != oldMap.get(newPC.Id).NS_ContactName__c){
                contactIds.add(newPC.NS_ContactName__c);
                oldContactIds.add(oldMap.get(newPC.Id).NS_ContactName__c);
            }
        }
        
        if(!oldContactIds.isEmpty() && !contactIds.isEmpty()){
            
            Map<Id, Contact> oldConIdsToRecMap = new Map<Id, Contact>([Select Id, NS_Commodity__c, Email, Fax,  Phone,NS_Work_Phone_Ext__c, MobilePhone, HomePhone, FirstName, LastName, OtherPhone, NS_OtherPhone2Ext__c, NS_OtherPhoneExt__c,
                                                                       NS_OSSContactRole__c,AccountId,Account.NS_ClassCode__c,Account.NS_ControllingStation__c,Account.RecordTypeId 
                                                                       from Contact where ID IN :oldContactIds AND Account.RecordTypeId IN :rtIds]);
            
            Map<Id, Contact> newConIdsToRecMap = new Map<Id, Contact>( [Select Id, NS_Commodity__c, NS_OSSContactRole__c, Description, Email, Fax, Phone,NS_Work_Phone_Ext__c, MobilePhone, HomePhone, FirstName, LastName, OtherPhone, NS_OtherPhone2Ext__c,NS_OtherPhoneExt__c,
                                                                        AccountId,Account.NS_ClassCode__c,Account.NS_ControllingStation__c,Account.RecordTypeId 
                                                                        from Contact where ID IN :contactIds AND Account.RecordTypeId IN :rtIds]);
            
            for(NS_PrimaryContact__c primaryConDetail : newMap.values()){
                
                Contact oldContact = oldConIdsToRecMap.get(oldMap.get(primaryConDetail.Id).NS_ContactName__c);
                Contact newContact = newConIdsToRecMap.get(primaryConDetail.NS_ContactName__c);
                
                NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper mocw = new NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper();
                mocw.Action_Ind = NS_StaticVariablesUtility.UpdateActionInd;
                mocw.ClassCode = newContact.Account.NS_ClassCode__c ==  null ? NS_StaticVariablesUtility.Blank : newContact.Account.NS_ClassCode__c;
                mocw.Comment = newContact.Description ==  null ? NS_StaticVariablesUtility.Blank : newContact.Description;
                mocw.Commodity = newContact.NS_Commodity__c ==  null ? NS_StaticVariablesUtility.Blank : newContact.NS_Commodity__c;
                mocw.New_Cell_Phone = newContact.MobilePhone == null ? NS_StaticVariablesUtility.Blank : newContact.MobilePhone;
                mocw.New_Email = newContact.Email == null ? NS_StaticVariablesUtility.Blank : newContact.Email;
                mocw.New_Fax = newContact.Fax == null ? NS_StaticVariablesUtility.Blank : newContact.Fax;
                mocw.New_First_Name = newContact.FirstName ==  null ? NS_StaticVariablesUtility.Blank : newContact.FirstName;
                mocw.New_Last_Name = newContact.LastName ==  null ? NS_StaticVariablesUtility.Blank : newContact.LastName;
                mocw.New_Phone_1 = newContact.Phone == null ? NS_StaticVariablesUtility.Blank : newContact.Phone;
                mocw.New_Phone_1_Ext = newContact.NS_Work_Phone_Ext__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(newContact.NS_Work_Phone_Ext__c);
                mocw.New_Phone_2 = newContact.OtherPhone == null ? NS_StaticVariablesUtility.Blank : newContact.OtherPhone;
                mocw.New_Phone_2_Ext = newContact.NS_OtherPhoneExt__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(newContact.NS_OtherPhoneExt__c);
                mocw.New_Phone_3 = newContact.HomePhone == null ? NS_StaticVariablesUtility.Blank : newContact.HomePhone;
                mocw.New_Phone_3_Ext = newContact.NS_OtherPhone2Ext__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(newContact.NS_OtherPhone2Ext__c);
                mocw.Old_Cell_Phone = oldContact.MobilePhone == null ? NS_StaticVariablesUtility.Blank : oldContact.MobilePhone;
                mocw.Old_Email = oldContact.Email == null ? NS_StaticVariablesUtility.Blank : oldContact.Email;
                mocw.Old_Fax = oldContact.Fax == null ? NS_StaticVariablesUtility.Blank : oldContact.Fax;
                mocw.Old_First_Name = oldContact.FirstName ==  null ? NS_StaticVariablesUtility.Blank : oldContact.FirstName;
                mocw.Old_Last_Name = oldContact.LastName ==  null ? NS_StaticVariablesUtility.Blank : oldContact.LastName;
                mocw.Old_Phone_1 = oldContact.Phone == null ? NS_StaticVariablesUtility.Blank : oldContact.Phone;
                mocw.Old_Phone_1_Ext = oldContact.NS_Work_Phone_Ext__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(oldContact.NS_Work_Phone_Ext__c);
                mocw.Old_Phone_2 = oldContact.OtherPhone == null ? NS_StaticVariablesUtility.Blank : oldContact.OtherPhone;
                mocw.Old_Phone_2_Ext = oldContact.NS_OtherPhoneExt__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(oldContact.NS_OtherPhoneExt__c);
                mocw.Old_Phone_3 = oldContact.HomePhone == null ? NS_StaticVariablesUtility.Blank : oldContact.HomePhone;
                mocw.Old_Phone_3_Ext = oldContact.NS_OtherPhone2Ext__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(oldContact.NS_OtherPhone2Ext__c);
                mocw.Primary_Indicator = NS_StaticVariablesUtility.TRUE_STR;
                mocw.Role = newContact.NS_OSSContactRole__c == null ? NS_StaticVariablesUtility.Blank : newContact.NS_OSSContactRole__c;
                // mocw.StationCode = newContact.Account.NS_ControllingStation__c != null ? newContact.Account.NS_ControllingStation__c.split('-')[0] : '';
                mocw.StationCode = newContact.Account.NS_OperatingStation__c != null ? newContact.Account.NS_OperatingStation__r.NS_OperatingStationCode__c : NS_StaticVariablesUtility.Blank ;
                CustomerContactWrapperList.add(mocw);
            }
        }
        
        if(!CustomerContactWrapperList.isEmpty()){
            try{
                System.debug('NS_IntegrationHelper onCustomerContactUpdate call NS_WebServiceHandler_ANIMaintenance.prepareManageOnlineCustomerContactRequest');
                NS_WebServiceHandler_ANIMaintenance.prepareManageOnlineCustomerContactRequest(CustomerContactWrapperList);
            }catch(Exception e){
                NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME8);
            }
            
        }
        System.debug('NS_IntegrationHelper onCustomerContactUpdate exited');
    }
    
    /* ================================================
* @Method Name : invoke_ContactUpdate
* @author id: arjun.c.ghosh@accenture.com
* @Purpose: This method is used to send request to reflect in Tyes for change of Account in a Contact
* @Parameters: String Account Name
* @return: Account
* @Release: Phase-1 Enhancement Request
* @created date: 21-12-2018
==================================================*/ 
    public static void invoke_ContactUpdate(Map<Id, Contact> newMap, Map<Id, Contact> oldMap){  
        try{
            Set<Id> oldAccountIdSet = new Set<Id>();
            Set<Id> AccountIdSet = new Set<Id>();
            Set<Id> ContactIdSet = new Set<Id>();
            List<NS_StaticVariablesUtility.ManageOnlineCustomerContactDeleteWrapper> CustomerContactWrapperList;
            CustomerContactWrapperList = new List<NS_StaticVariablesUtility.ManageOnlineCustomerContactDeleteWrapper>();      
            List<NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper> CustomerContactWrapperListforInsert;
            CustomerContactWrapperListforInsert = new List<NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper>();        
            Set<Id> rtIds = new Set<Id>();
            rtIds.add(OnLineServiceAccount); 
            SObject newConSobjectTemp;
            SObject oldConSobjectTemp;
            System.debug('NS_IntegrationHelper invoke_ContactUpdate entered');        
            for(Contact newContact : newMap.values()){
                if(newContact.AccountId != null){
                    AccountIdSet.add(newContact.AccountId);
                }
            }
            for(Contact oldContact : oldMap.values()){
                if(oldContact.AccountId != null){
                    oldAccountIdSet.add(oldContact.AccountId);
                }
            }
            Map<Id,Account> AccountMap = new Map<Id, Account>([Select Id,RecordTypeId,NS_ClassCode__c,NS_ControllingStation__c,NS_OperatingStation__c, NS_OperatingStation__r.name, NS_OperatingStation__r.NS_OperatingStationCode__c
                                                               from Account 
                                                               where Id IN :AccountIdSet and RecordTypeId IN :rtIds]);
            
            Map<Id,Account> oldAccountMap = new Map<Id, Account>([Select Id,RecordTypeId,NS_ClassCode__c,NS_ControllingStation__c,NS_OperatingStation__c, NS_OperatingStation__r.name, NS_OperatingStation__r.NS_OperatingStationCode__c
                                                                  from Account 
                                                                  where Id IN :oldAccountIdSet ]);
            
            for(NS_PrimaryContact__c pc : [Select Id,NS_ContactName__c from NS_PrimaryContact__c 
                                           where NS_ContactName__c IN :newMap.keySet()]){
                                               ContactIdSet.add(pc.NS_ContactName__c);
                                           }
            
            for(Contact newContactTemp : newMap.values()){
                if(isValidForSync(newContactTemp)){
                    
                    Contact oldContactTemp = oldMap.get(newContactTemp.Id);
                    Contact oldContact = oldMap.get(newContactTemp.Id);
                    Contact newContact = newMap.get(newContactTemp.Id);

                      //  system.debug('NS_IntegrationHelper invoke_ContactUpdate AccountMap.containsKey new id '+newContactTemp.AccountId);
                      if(AccountMap.containsKey(newContactTemp.AccountId) || oldAccountMap.containsKey(oldContact.AccountId)){
                        // Contact oldContactTemp = oldMap.get(newContactTemp.Id);
                        oldConSobjectTemp = (SObject)oldContactTemp;
                        newConSobjectTemp = (SObject)newContactTemp;
                        system.debug('NS_IntegrationHelper invoke_ContactUpdate check old and new account id ');
                        if(oldConSobjectTemp.get(AC_ID) != newConSobjectTemp.get(AC_ID)){
                            system.debug('NS_IntegrationHelper invoke_ContactUpdate Different old and new account id ');
                            // Have to add code to see if the account is Service. If not skip call in the insert 
                            // or delete contact tyes.  @Daniel Glaser
                            if (AccountMap.containsKey(newContactTemp.AccountId)) {
                                account newaccount = AccountMap.get(newContactTemp.AccountId);
                                system.debug('NS_IntegrationHelper invoke_ContactUpdate new account '+newaccount.id+' type '+newaccount.RecordTypeId);
                                if (newaccount.RecordTypeId == OnLineServiceAccount) { //  @Daniel Glaser
                                    system.debug('NS_IntegrationHelper invoke_ContactUpdate call insertDeletedContactOnTyes');
                                    insertDeletedContactOnTyes(newMap, AccountIdSet, AccountMap, newContact, 
                                                           CustomerContactWrapperListforInsert);
                                }

                            }
                            account oldaccount = oldAccountMap.get(oldContact.AccountId);
                                                     
                            system.debug('NS_IntegrationHelper invoke_ContactUpdate old account '+oldaccount.id+' type '+oldaccount.RecordTypeId);
                            if (oldaccount.RecordTypeId == OnLineServiceAccount) {  //  @Daniel Glaser  the account type has to be Service before to call  DeleteContact
                                system.debug('NS_IntegrationHelper invoke_ContactUpdate call deleteContactonTyes');
                                deleteContactonTyes(newContactTemp, AccountMap, oldAccountMap, oldContactTemp,
                                                ContactIdSet, oldContact, newContact, CustomerContactWrapperList);
                            }                    
                        }
                        else{
                            System.debug('NS_IntegrationHelper invoke_ContactUpdate contact status old  '+oldContactTemp.NS_ContactStatus__c+ ' new NS_ContactStatus__c' +newContactTemp.NS_ContactStatus__c);
                            // @DG this code has to be cleaned up
                            invokeManageOnlineCustomerContactOnUpdate(newMap,oldMap);
                        }
                    }
                }
            }
        }catch(Exception exp){
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, 'invoke_ContactUpdate');
        }
        System.debug('NS_IntegrationHelper invoke_ContactUpdate exited');
    }
  
    /* ================================================
* @Method Name : deleteContactonTyes
* @author id: arjun.c.ghosh@accenture.com
* @Purpose:
* @Parameters: String Account Name
* @return: Account
* @Release: Phase-1 Enhancement Request
* @created date: 21-12-2018
==================================================*/     
    public static void deleteContactonTyes(Contact newContactTemp, Map<Id,Account> AccountMap ,Map<Id,Account> oldAccountMap, 
                                           Contact oldContactTemp, Set<Id> ContactIdSet, Contact oldContact, Contact newContact, 
                                           List<NS_StaticVariablesUtility.ManageOnlineCustomerContactDeleteWrapper> CustomerContactWrapperList) {
                    System.debug('NS_IntegrationHelper deleteContactonTyes entered');
           Account contactsAccount = AccountMap.get(newContactTemp.AccountId);
           Account oldContactsAccount=oldAccountMap.get(oldContactTemp.AccountId);
           NS_StaticVariablesUtility.ManageOnlineCustomerContactDeleteWrapper mocw = new NS_StaticVariablesUtility.ManageOnlineCustomerContactDeleteWrapper();
           mocw.Action_Ind = NS_StaticVariablesUtility.DeleteActionInd;
           mocw.ClassCode =oldContactsAccount.NS_ClassCode__c == null ? NS_StaticVariablesUtility.Blank : oldContactsAccount.NS_ClassCode__c;
           mocw.Comment = NS_StaticVariablesUtility.Blank; mocw.Commodity = NS_StaticVariablesUtility.Blank;
           mocw.nCellPhone = NS_StaticVariablesUtility.Blank; mocw.nEmail = NS_StaticVariablesUtility.Blank; 
           mocw.nFax = NS_StaticVariablesUtility.Blank; mocw.nFname = NS_StaticVariablesUtility.Blank; 
           mocw.nLname = NS_StaticVariablesUtility.Blank; mocw.nPhone1 = NS_StaticVariablesUtility.Blank; 
           mocw.nPhone1Ext = NS_StaticVariablesUtility.Blank; mocw.nPhone2 = NS_StaticVariablesUtility.Blank; 
           mocw.nPhone2Ext = NS_StaticVariablesUtility.Blank; mocw.nPhone3 = NS_StaticVariablesUtility.Blank; 
           mocw.nPhone3Ext = NS_StaticVariablesUtility.Blank; mocw.oPhone3Ext =  NS_StaticVariablesUtility.Blank;
           mocw.oCellPhone = oldContact.MobilePhone == null ? NS_StaticVariablesUtility.Blank : oldContact.MobilePhone; 
           mocw.oEmail = oldContact.Email == null ? NS_StaticVariablesUtility.Blank : oldContact.Email;
           mocw.oFax = oldContact.Fax == null ? NS_StaticVariablesUtility.Blank : oldContact.Fax; 
           mocw.oFname =String.isBlank(oldContact.FirstName) ? NS_StaticVariablesUtility.Blank:oldContact.FirstName;
           mocw.oLname = String.isBlank(oldContact.LastName) ? NS_StaticVariablesUtility.Blank:oldContact.LastName;
           mocw.oPhone1 =  oldContact.Phone == null ? NS_StaticVariablesUtility.Blank : oldContact.Phone;
           mocw.oPhone1Ext = NS_StaticVariablesUtility.Blank; mocw.oPhone2 = NS_StaticVariablesUtility.Blank; 
           mocw.oPhone2Ext = NS_StaticVariablesUtility.Blank; mocw.oPhone3 = NS_StaticVariablesUtility.Blank;                                                                                          
           mocw.Primary_Indicator = ContactIdSet.contains(newContact.Id) ? NS_StaticVariablesUtility.TRUE_STR : NS_StaticVariablesUtility.FALSE_STR;
           mocw.Role =  NS_StaticVariablesUtility.Blank ;
           //mocw.StationCode = oldContactsAccount.NS_OperatingStation__c != null ? oldContactsAccount.NS_OperatingStation__r.name.split('-')[0] : NS_StaticVariablesUtility.Blank ;
             mocw.StationCode = oldContactsAccount.NS_OperatingStation__c != null ? oldContactsAccount.NS_OperatingStation__r.NS_OperatingStationCode__c : NS_StaticVariablesUtility.Blank ;
           CustomerContactWrapperList.add(mocw);                                               
           try{
                System.debug('NS_IntegrationHelper deleteContactonTyes call NS_WebServiceHandler_ANIMaintenance.prepareManageOnlineCustomerContactDeleteRequest');
               NS_WebServiceHandler_ANIMaintenance.prepareManageOnlineCustomerContactDeleteRequest(CustomerContactWrapperList);
           }catch(Exception e){
               NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME4);
           }
           System.debug('NS_IntegrationHelper deleteContactonTyes exited');
       }
   
 /* ================================================
* @Method Name : invoke_ContactUpdate
* @author id: arjun.c.ghosh@accenture.com
* @Purpose: This method is used to reflect in Tyes for change of Account in a Contact,
*              insert the deleted record in Tyes with new related Account
* @Parameters: String Account Name
* @return: Account
* @Release: Phase-1 Enhancement Request
* @created date: 21-12-2018
==================================================*/   
    public static void insertDeletedContactOnTyes(Map<Id, Contact> newMap,Set<Id> AccountIdSet,
                                                  Map<Id,Account> AccountMap, Contact newCon,
                                                  List<NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper> CustomerContactWrapperList) {
        System.debug('NS_IntegrationHelper insertDeletedContactOnTyes entered');
          Account conAcc = AccountMap.get(newCon.AccountId);                
          NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper mocw = new NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper();
          mocw.Action_Ind = NS_StaticVariablesUtility.InsertActionInd;
          mocw.ClassCode = conAcc.NS_ClassCode__c == null ? NS_StaticVariablesUtility.Blank : conAcc.NS_ClassCode__c;
          mocw.Comment = newCon.Description == null ? NS_StaticVariablesUtility.Blank : newCon.Description;
          mocw.Commodity = newCon.NS_Commodity__c == null ? NS_StaticVariablesUtility.Blank : newCon.NS_Commodity__c;
          mocw.New_Cell_Phone = (newCon.MobilePhone == null ) ? NS_StaticVariablesUtility.Blank : newCon.MobilePhone;
          mocw.New_Email = newCon.Email == null ? NS_StaticVariablesUtility.Blank : newCon.Email;
          mocw.New_Fax = newCon.Fax == null ? NS_StaticVariablesUtility.Blank : newCon.Fax;
          mocw.New_First_Name = newCon.FirstName == null ? NS_StaticVariablesUtility.Blank : newCon.FirstName;
          mocw.New_Last_Name = newCon.LastName == null ? NS_StaticVariablesUtility.Blank : newCon.LastName;
          mocw.New_Phone_1 = newCon.Phone == null ? NS_StaticVariablesUtility.Blank : newCon.Phone;
          mocw.New_Phone_1_Ext = newCon.NS_Work_Phone_Ext__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(newCon.NS_Work_Phone_Ext__c);
          mocw.New_Phone_2 = (newCon.OtherPhone == null ) ? NS_StaticVariablesUtility.Blank : newCon.OtherPhone;
          mocw.New_Phone_2_Ext = newCon.NS_OtherPhoneExt__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(newCon.NS_OtherPhoneExt__c);
          mocw.New_Phone_3 = (newCon.HomePhone == null ) ? NS_StaticVariablesUtility.Blank : newCon.HomePhone;
          mocw.New_Phone_3_Ext = newCon.NS_OtherPhone2Ext__c == null ? NS_StaticVariablesUtility.Blank : String.valueOf(newCon.NS_OtherPhone2Ext__c);
          mocw.Primary_Indicator = NS_StaticVariablesUtility.FALSE_STR;
          mocw.Role = newCon.NS_OSSContactRole__c == null ? NS_StaticVariablesUtility.Blank : newCon.NS_OSSContactRole__c;
          //mocw.StationCode = conAcc.NS_OperatingStation__c != null ? conAcc.NS_OperatingStation__r.name.split('-')[0] : NS_StaticVariablesUtility.Blank ;
          mocw.StationCode = conAcc.NS_OperatingStation__c != null ? conAcc.NS_OperatingStation__r.NS_OperatingStationCode__c : NS_StaticVariablesUtility.Blank ;
          CustomerContactWrapperList.add(mocw);
          try{
                System.debug('NS_IntegrationHelper insertDeletedContactOnTyes call NS_WebServiceHandler_ANIMaintenance.prepareManageOnlineCustomerContactRequest');
              NS_WebServiceHandler_ANIMaintenance.prepareManageOnlineCustomerContactRequest(CustomerContactWrapperList);
          }
          catch(Exception e){
              NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME4);
          }
          System.debug('NS_IntegrationHelper insertDeletedContactOnTyes exited');
      }
 /* ================================================
* @Method Name : invoke_ContactDel
* @author id: arjun.c.ghosh@accenture.com
* @Purpose:  This method is used to send request to delete the existing Contact record in Tyes in case of it getting deleted in SFDC
* @Parameters: String Account Name
* @return: Account
* @Release: Phase-1 Enhancement Request
* @created date: 21-12-2018
==================================================*/     
    public static void invoke_ContactDel( Map<Id, Contact> oldMap){      
        Set<Id> oldAccountIdSet = new Set<Id>();
        Set<Id> ContactIdSet = new Set<Id>();
        List<NS_StaticVariablesUtility.ManageOnlineCustomerContactDeleteWrapper> CustomerContactWrapperList;        
        CustomerContactWrapperList = new List<NS_StaticVariablesUtility.ManageOnlineCustomerContactDeleteWrapper>();              
        List<NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper> CustomerContactWrapperListforInsert;        
        CustomerContactWrapperListforInsert = new List<NS_StaticVariablesUtility.ManageOnlineCustomerContactWrapper>();        
        Set<Id> rtIds = new Set<Id>();
        rtIds.add(OnLineServiceAccount);
        rtIds.add(OfflineCustomer);
        rtIds.add(OnlineCustomerBusiness);
        rtIds.add(OnlineCustomerCorporate);
        rtIds.add(NS3PLCustomer);
        rtIds.add(FieldLocation);               
        SObject oldConSobjectTemp;
 
        System.debug('NS_IntegrationHelper invoke_ContactDel entered');               
        for(Contact oldContact : oldMap.values()){
            if(oldContact.AccountId != null){
                oldAccountIdSet.add(oldContact.AccountId);
            }
        }      
        // only process Service accounts. Contact ard not is TYES for NON service accounts, 
        // so they can't be deleted @Daniel Glaser
        Map<Id,Account> oldAccountMap = new Map<Id, Account>([Select Id,RecordTypeId,NS_ClassCode__c,NS_ControllingStation__c,NS_OperatingStation__c, NS_OperatingStation__r.NS_OperatingStationCode__c
                                                              from Account 
                                                              where Id IN :oldAccountIdSet and RecordTypeId in : rtIds]);
        if (!oldAccountMap.isEmpty()) { 
            for(NS_PrimaryContact__c pc : [Select Id,NS_ContactName__c from NS_PrimaryContact__c 
                                           where NS_ContactName__c IN :oldMap.keySet()]){
                                               ContactIdSet.add(pc.NS_ContactName__c);
                                           }
            for(Contact oldContactsTemp : oldMap.values()){
                if(isValidForSync(oldContactsTemp)){
                    Contact oldContactTemp = oldMap.get(oldContactsTemp.Id);
                    oldConSobjectTemp = (SObject)oldContactTemp;
                    Contact oldContact = oldMap.get(oldConSobjectTemp.Id);             
                    deleteContact( oldAccountMap, oldContactTemp,
                                  ContactIdSet, oldContact, CustomerContactWrapperList);
                }
            }
        }
        System.debug('NS_IntegrationHelper invoke_ContactDel exited');
    }
/* ================================================
* @Method Name : invoke_ContactDel
* @author id: arjun.c.ghosh@accenture.com
* @Purpose:  This method is used to send request to delete the existing Contact record in Tyes in case of it getting deleted in SFDC
* @Parameters: String Account Name
* @return: Account
* @Release: Phase-1 Enhancement Request
* @created date: 21-12-2018
==================================================*/     
   public static void deleteContact(Map<Id,Account> oldAccountMap, 
                                     Contact oldContactTemp, Set<Id> ContactIdSet, Contact oldContact,
                                     List<NS_StaticVariablesUtility.ManageOnlineCustomerContactDeleteWrapper> CustomerContactWrapperList) {            
        System.debug('NS_IntegrationHelper deleteContact entered');
         Account oldContactsAccount=oldAccountMap.get(oldContactTemp.AccountId);
         NS_StaticVariablesUtility.ManageOnlineCustomerContactDeleteWrapper mocw = new NS_StaticVariablesUtility.ManageOnlineCustomerContactDeleteWrapper();
         mocw.Action_Ind = NS_StaticVariablesUtility.DeleteActionInd;
         mocw.ClassCode =oldContactsAccount.NS_ClassCode__c == null ? NS_StaticVariablesUtility.Blank : oldContactsAccount.NS_ClassCode__c;
         mocw.Comment = NS_StaticVariablesUtility.Blank; mocw.Commodity = NS_StaticVariablesUtility.Blank;
         mocw.nCellPhone = NS_StaticVariablesUtility.Blank; mocw.nEmail = NS_StaticVariablesUtility.Blank; 
         mocw.nFax = NS_StaticVariablesUtility.Blank; mocw.nFname = NS_StaticVariablesUtility.Blank; 
         mocw.nLname = NS_StaticVariablesUtility.Blank; mocw.nPhone1 = NS_StaticVariablesUtility.Blank; 
         mocw.nPhone1Ext = NS_StaticVariablesUtility.Blank; mocw.nPhone2 = NS_StaticVariablesUtility.Blank; 
         mocw.nPhone2Ext = NS_StaticVariablesUtility.Blank; mocw.nPhone3 = NS_StaticVariablesUtility.Blank; 
         mocw.nPhone3Ext = NS_StaticVariablesUtility.Blank; mocw.oPhone3Ext =  NS_StaticVariablesUtility.Blank;
         mocw.oCellPhone = oldContact.MobilePhone == null ? NS_StaticVariablesUtility.Blank : oldContact.MobilePhone; 
         mocw.oEmail = oldContact.Email == null ? NS_StaticVariablesUtility.Blank : oldContact.Email;
         mocw.oFax = oldContact.Fax == null ? NS_StaticVariablesUtility.Blank : oldContact.Fax; 
         mocw.oFname =String.isBlank(oldContact.FirstName) ? NS_StaticVariablesUtility.Blank:oldContact.FirstName;
         mocw.oLname = String.isBlank(oldContact.LastName) ? NS_StaticVariablesUtility.Blank:oldContact.LastName;
         mocw.oPhone1 =  oldContact.Phone == null ? NS_StaticVariablesUtility.Blank : oldContact.Phone;
         mocw.oPhone1Ext = oldContact.NS_Work_Phone_Ext__c == null ? NS_StaticVariablesUtility.Blank : oldContact.NS_Work_Phone_Ext__c;
         mocw.oPhone2 = NS_StaticVariablesUtility.Blank; 
         mocw.oPhone2Ext = NS_StaticVariablesUtility.Blank; mocw.oPhone3 = NS_StaticVariablesUtility.Blank;                                                                                          
         mocw.Primary_Indicator = ContactIdSet.contains(oldContact.Id) ? NS_StaticVariablesUtility.TRUE_STR : NS_StaticVariablesUtility.FALSE_STR;
         mocw.Role =  NS_StaticVariablesUtility.Blank ;
        // mocw.StationCode = oldContactsAccount.NS_OperatingStation__c != null ? oldContactsAccount.NS_OperatingStation__r.name.split('-')[0] : NS_StaticVariablesUtility.Blank ;
        mocw.StationCode = oldContactsAccount.NS_OperatingStation__c != null ? oldContactsAccount.NS_OperatingStation__r.NS_OperatingStationCode__c : NS_StaticVariablesUtility.Blank ;
         CustomerContactWrapperList.add(mocw);                                               
         try{
            System.debug('NS_IntegrationHelper deleteContact call NS_WebServiceHandler_ANIMaintenance.prepareManageOnlineCustomerContactDeleteRequest');
             NS_WebServiceHandler_ANIMaintenance.prepareManageOnlineCustomerContactDeleteRequest(CustomerContactWrapperList);
         }catch(Exception e){
             NS_StaticVariablesUtility.createExceptionRecord(e, CLASS_NAME, METHOD_NAME4);
         }
         System.debug('NS_IntegrationHelper deleteContact exited');
     }

public static void deleteTyesContact(Map<Id, Contact> newMap, Map<Id, Contact> oldMap){
    System.debug('NS_IntegrationHelper deleteTyesContact entered');
        System.debug('NS_IntegrationHelper deleteTyesContact newMap @@@@@@@@@@@@---'+newMap);
        system.debug('NS_IntegrationHelper deleteTyesContact oldMap @@@@@@@@@@@@---'+oldMap);
        for(Contact conobj : newMap.values()){
            System.debug('NS_IntegrationHelper deleteTyesContact status '+conobj.NS_ContactStatus__c);
            if(conobj.NS_ContactStatus__c == 'Inactive' || test.isRunningTest()){
                NS_IntegrationHelper.invoke_ContactDel(oldMap);
            }
        }
        System.debug('NS_IntegrationHelper deleteTyesContact exited');
    }
}