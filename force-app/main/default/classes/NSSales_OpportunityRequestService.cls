@RestResource(urlMapping='/Opportunity/v1/*')
global class NSSales_OpportunityRequestService {
    
    Static Final String GENOPTYRECTYPE = 'General Opportunity';
    Static Final String Stage = 'Qualification/Analysis';
    @HttpPost
    global static String doPost() {
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
        String response ='';
        Id UltimateAccId;
        //Id UltimateChildAccId;
        
        List<NSSales_Opportunity_Lanes__c> listOptyLane = new List<NSSales_Opportunity_Lanes__c>();
        List<NSSales_Opportunity_Lanes__c> listChildOptyLane = new List<NSSales_Opportunity_Lanes__c>();
        List<Opportunity> OptyList = new List<Opportunity>();
        Map<String,Id> userNameList=new Map<String,Id>();
        Map<String,ID> laneMap = new Map<String,ID>();
        List<String> laneImcNumWithAcc = new List<String>();
        List<String> laneImcNum = new List<String>();
        List<Account> accList = new List<Account>();
        List<Account> acctList = new List<Account>();
        List<Account> childAcctList = new List<Account>();
        Boolean emailNotify = false;
        // try{
        for(User usr : [Select Id,FederationIdentifier,Name from User]){
            userNameList.put(usr.FederationIdentifier, usr.Id);       
        }
        NSSales_OpportunityRequestWrapper rw = (NSSales_OpportunityRequestWrapper)JSON.deserialize(requestString,NSSales_OpportunityRequestWrapper.class);
        // Opportunity Insert- Account logic
        if(rw.custMdmId!= null){
            System.debug('custMdmId' +rw.custMdmId);
            accList = [Select id,NS_Ultimate_Parent__c,RecordType.DeveloperName from Account where NS_MDM_EID__c=:rw.custMdmId 
                       AND (RecordType.DeveloperName ='NS_OnlineCustomerCorporate' OR RecordType.DeveloperName='NS_OnlineCustomerBusiness') limit 1];
            UltimateAccId = accList[0].Id;
        }
        /*  else if(rw.custGoodspell !=''){
accList = [Select id,NS_Ultimate_Parent__c,RecordType.DeveloperName,NS_Function_Type__c from Account
where NS_Goodspell__c =:rw.custGoodspell AND RecordType.DeveloperName='NS_OnlineCustomerBusiness'
AND ParentId.RecordType.DeveloperName ='NS_OnlineCustomerCorporate' limit 1];
} */
        else if(rw.custNum !=null){
            System.debug('custNum' +rw.custNum);
            //if an account with same primary 6 and has mkt mgr assignement exists, use this acct
            
            List<NSSales_Marketing_Manager_Assignment__c> mktList = [Select id,NSSales_Account__c from NSSales_Marketing_Manager_Assignment__c where
                                                                     NSSales_Account__r.NS_CustomerPrimary__c =:rw.custNum limit 1];
            System.debug('List'+mktList);
            if(!mktList.isEmpty()){
                System.debug('mktList');
            UltimateAccId = mktList[0].NSSales_Account__c;
                System.debug(UltimateAccId);
            }
            //use account record with functional type as “IM domestic” or “IM international”, 
            //if Corp account record is found, use Corp, otherwise use Business
            //after creation, set an new identifier field on the Opty record to true for later notification to users
            
            if(mktList.isEmpty()){
                System.debug('acctList');
                acctList = [Select id,RecordType.DeveloperName,NS_Function_Type__c from Account where NS_CustomerPrimary__c=:rw.custNum 
                            AND NS_Function_Type__c includes('IM Domestic;IM International','IM Domestic','IM International')
                            ORDER BY RecordType.DeveloperName DESC limit 1]; 
              if(!acctList.isEmpty()){ 
                UltimateAccId = acctList[0].Id;
                emailNotify = true;
              }
                // If none of the above is found, use account with same primary 6 
            //and has oppty records associated to it
            //after creation, set an new identifier field on the Opty record to true for later notification to users
                else if(acctList.isEmpty()){
                System.debug('opptyList');
                List<Opportunity> opptyList = [Select id,AccountId from Opportunity where Account.NS_CustomerPrimary__c =:rw.custNum limit 1];
                    if(!opptyList.isEmpty()){
                UltimateAccId = opptyList[0].AccountId;
                emailNotify = true;
                    }
                    else if(opptyList.isEmpty()){
                        List<Account> accountList=[Select id,name from Account where NS_CustomerPrimary__c =:rw.custNum limit 1];
                    if(!accountList.isEmpty()){ 
                    UltimateAccId = accountList[0].Id;
                    emailNotify = true;
                    }
                    }
                }
            }
            System.debug('UltimateAccId1' +UltimateAccId);
            // If none of the above is found, use account with same primary 6 
            //and has oppty records associated to it
            //after creation, set an new identifier field on the Opty record to true for later notification to users
            
          /*  else if(acctList.isEmpty()){
                System.debug('opptyList');
                List<Opportunity> opptyList = [Select id,AccountId from Opportunity where Account.NS_CustomerPrimary__c =:rw.custNum limit 1];
                UltimateAccId = opptyList[0].AccountId;
                emailNotify = true;
                
            } */
        }
        System.debug('UltimateAccId2' +UltimateAccId);
        // If Opportunity with same Source System ID and Source System already exist.   
        List<Opportunity> opptyList= [Select id,name,NS_WB_RequestID__c,NSSales_Source_System__c from Opportunity 
                                      where NS_WB_RequestID__c =:rw.soucreSysId AND NSSales_Source_System__c=:rw.soucreSys];
        if(opptyList.size() > 0){
            response = 'Opportunity already exists in the system'; 
        }
        else if(UltimateAccId == null){
            JSONGenerator gen = JSON.createGenerator(true);
               gen.writeStartObject();
               gen.writeStringField('resultCode', '-1');
               gen.writeStringField('resultDescription', 'No Account Found');
               gen.writeEndObject();
               String jsonData1 = gen.getAsString();
               response = response + jsonData1;
        }
        else{
            Opportunity opp = new Opportunity();
            opp.Name = 'Test';
            opp.AccountId = UltimateAccId;
            opp.NS_Originating_Department__c = rw.soucreSys;
            opp.StageName = Stage;
            opp.NS_WB_RequestID__c = rw.soucreSysId;
            opp.NS_WB_RequestNum__c = rw.sourceSysNum;
            opp.NSSales_Source_System__c = rw.soucreSys;
            if(rw.closeDate == ''){
                opp.CloseDate = System.Today()+30;
            }
            else{
                opp.CloseDate = Date.valueOf(rw.closeDate);
            }
            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GENOPTYRECTYPE).getRecordTypeId();
            if(opp.CreatedById != null){
                opp.CreatedById = userNameList.get(rw.createdByRacf);
            }
            if(emailNotify == true){
                opp.NSSales_OpptyAcct_Notification__c = true;
            }
            insert opp;
            System.debug('Parent Opp' +opp.id);
            if(opp.id != null){
               // response = response + '{"resultCode" : "0","resultDescription" : "Created","OpptyId" :'+opp.id +'}'; 
               JSONGenerator gen = JSON.createGenerator(true);
               gen.writeStartObject();
               gen.writeStringField('resultCode', '0');
               gen.writeStringField('resultDescription', 'Created');
               gen.writeStringField('Parent Opportunity', opp.id);
               gen.writeEndObject();
               String jsonData1 = gen.getAsString();
               response = response + jsonData1;
             }
            else{
               // response = response + '{"resultCode" : "-1","resultDescription" : "No Account Found"}';
               JSONGenerator gen = JSON.createGenerator(true);
               gen.writeStartObject();
               gen.writeStringField('resultCode', '-1');
               gen.writeStringField('resultDescription', 'No Account Found');
               gen.writeEndObject();
               String jsonData1 = gen.getAsString();
               response = response + jsonData1;
            } 
            
            
            //To Create Opty Lanes Record
            for(NSSales_OpportunityRequestWrapper.lanes objt : rw.lanes){
                
                NSSales_Opportunity_Lanes__c optylanes = new NSSales_Opportunity_Lanes__c();
                    
                    optylanes.NSSales_LaneId__c = objt.laneId;
                    optylanes.NSSales_OnRamp__c = objt.onRamp;
                    optylanes.NSSales_OffRamp__c = objt.offRamp;
                    optylanes.NSSales_Shipper__c = objt.shipper;
                    optylanes.NSSales_Receiver__c = objt.receiver;
                    optylanes.NSSales_OriginRoad__c = objt.originRoad;
                    optylanes.NSSales_OriginCity__c = objt.originCity;
                    optylanes.NSSales_OriginState__c = objt.originState;
                    optylanes.NSSales_OriginHandlingLine__c = objt.originHandlingLine;
                    optylanes.NSSales_DestinRoad__c = objt.destinRoad;
                    optylanes.NSSales_DestinCity__c = objt.destinCity;
                    optylanes.NSSales_DestinState__c = objt.destinState;
                    optylanes.NSSales_STCC__c = objt.stcc;
                    optylanes.NSSales_Route__c = objt.route;
                    optylanes.NSSales_EstVolume__c = objt.estVolume;
                    optylanes.NSSales_EstVolumeUnits__c = objt.estVolumeUnits;
                    optylanes.NSSales_EstVolumePeriod__c = objt.estVolumePeriod;
                    optylanes.NSSales_EstRate__c = objt.estRate;
                    optylanes.NSSales_CompetitionType__c = objt.competitionType;
                    optylanes.NSSales_CarOwnership__c = objt.carOwnership;
                    optylanes.NSSales_CarType__c = objt.carType;
                    optylanes.NSSales_MinWeight__c = objt.minWeight;
                    optylanes.NSSales_MinWeightUnits__c = objt.minWeightUnits;
                    optylanes.NSSales_MinCars__c = objt.minCars;
                    optylanes.NSSales_MinCarsPeriod__c = objt.minCarsPeriod;
                    optylanes.NSSales_Lading__c = objt.lading;
                    optylanes.NSSales_Basis__c = objt.basis;
                    optylanes.NSSales_Rate__c = objt.activeRate;
                    optylanes.NSSales_Recommended_Rate__c = objt.reccRate;
                if(objt.offerRate !=null){
                    optylanes.NSSales_Round_1_Rate__c = objt.offerRate;
                    optylanes.NSSales_Round_1_Rate_Update__c = System.today();
                }
                if(objt.finalRate !=null){
                    optylanes.NSSales_Final_Rate__c = objt.finalRate;
                    optylanes.NSSales_Final_Rate_Update__c = System.today();
                } 
                    optylanes.NSSales_Final_Rate__c = objt.finalRate;
                    optylanes.NSSales_PrivateRate__c = objt.privateRate;
                    optylanes.NSSales_RateSource__c = objt.rateSource;
                    optylanes.NSSales_Lane_Status__c = objt.laneStatus;
                    optylanes.NSSales_Opportunity__c = opp.Id;
                
                listOptyLane.add(optylanes);
            }
            
            if(!listOptyLane.isEmpty()){
                insert listOptyLane;
            }
            
            //To Create Child Opportunity Record
            for(NSSales_OpportunityRequestWrapper.lanes objtOpp : rw.lanes){
                
                if(objtOpp.imcNum !=null){
                    String UltimateChildAccId = '';
                    //if an account with same primary 6 and has mkt mgr assignement exists, use this acct      
                    List<NSSales_Marketing_Manager_Assignment__c> mktChildList = [Select id,NSSales_Account__c from NSSales_Marketing_Manager_Assignment__c where
                                                                                  NSSales_Account__r.NS_CustomerPrimary__c =:objtOpp.imcNum limit 1];
                    if(!mktChildList.isEmpty()){
                    UltimateChildAccId = mktChildList[0].NSSales_Account__c;
                    }
                    //use account record with functional type as “IM domestic” or “IM international”, 
                    //if Corp account record is found, use Corp, otherwise use Business
                    //after creation, set an new identifier field on the Opty record to true for later notification to users
                    
                    if(mktChildList.isEmpty()){
                        System.debug('mktChildList');
                        childAcctList = [Select id,RecordType.DeveloperName,NS_Function_Type__c from Account where NS_CustomerPrimary__c=:objtOpp.imcNum 
                                         AND NS_Function_Type__c includes('IM Domestic;IM International','IM Domestic','IM International')
                                         ORDER BY RecordType.DeveloperName DESC limit 1]; 
                         if(!childAcctList.isEmpty()){
                             System.debug('childAcctList');
                        UltimateChildAccId = childAcctList[0].Id; 
                         }
                        else if(childAcctList.isEmpty()){
                            System.debug('childOpptyList');
                        List<Opportunity> childOpptyList = [Select id,AccountId from Opportunity where Account.NS_CustomerPrimary__c =:objtOpp.imcNum limit 1];
                            if(!childOpptyList.isEmpty()){
                            UltimateChildAccId = childOpptyList[0].AccountId;
                            System.debug(UltimateChildAccId);
                            }
                         else if(childOpptyList.isEmpty()){
                             List<Account> childAccountList =[Select id,name from Account where NS_CustomerPrimary__c =:objtOpp.imcNum limit 1];
                             if(!childAccountList.isEmpty()){
                             UltimateChildAccId = childAccountList[0].Id;
                            System.debug(UltimateChildAccId);
                             }
                            }  
                    }
                    }
                    
                    // If none of the above is found, use account with same primary 6 
                    //and has oppty records associated to it
                    //after creation, set an new identifier field on the Opty record to true for later notification to users
                    
                   /* else if(childAcctList.isEmpty()){
                        List<Opportunity> childOpptyList = [Select id,AccountId from Opportunity where Account.NS_CustomerPrimary__c =:rw.custNum limit 1];
                        UltimateChildAccId = childOpptyList[0].AccountId;
                    }*/
                    System.debug('UltimateChildAccId'+UltimateChildAccId);
                    if(UltimateChildAccId ==''){
                        System.debug('Null'+objtOpp.imcNum);
                        laneImcNum.add(objtOpp.imcNum);
                    }
                    else{
                        laneImcNumWithAcc.add(objtOpp.laneId);
                       
                        Opportunity oppty = new Opportunity();
                        oppty.Name = 'Test';
                        oppty.AccountId = UltimateChildAccId;
                        oppty.NS_Originating_Department__c = rw.soucreSys;
                        oppty.StageName = Stage;
                        oppty.NS_WB_RequestID__c = rw.soucreSysId;
                        oppty.NS_WB_RequestNum__c = rw.sourceSysNum;
                        oppty.NSSales_Source_System__c = rw.soucreSys;
                        oppty.NSSales_Parent_Opportunity__c  =opp.Id;
                        oppty.NSSales_Lane_ID__c =objtOpp.laneId;
                        if(rw.closeDate == ''){
                            oppty.CloseDate = System.Today()+30;
                        }
                        else{
                            oppty.CloseDate = Date.valueOf(rw.closeDate);
                        }
                        oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GENOPTYRECTYPE).getRecordTypeId();
                        System.debug('Oppty'+oppty);
                        OptyList.add(oppty);
                    }
                }
                
            }
            System.debug('OptyList'+OptyList);
            if(!OptyList.isEmpty()){
                    insert OptyList;
                }
            List<Opportunity> childOppList = [Select id,NSSales_Lane_ID__c from Opportunity where Id IN: OptyList];
            
            for(Opportunity childOpp : childOppList){
                laneMap.put(childOpp.NSSales_Lane_ID__c,childOpp.Id);
                
            }
            
            //To assosiate Opty Lane record with Child Opportunity
            
            for(NSSales_OpportunityRequestWrapper.lanes objtLaneOpp : rw.lanes){
                
                if(objtLaneOpp.imcNum !=''){
                    
                    NSSales_Opportunity_Lanes__c optylanes = new NSSales_Opportunity_Lanes__c();
                        
                        optylanes.NSSales_LaneId__c = objtLaneOpp.laneId;
                        optylanes.NSSales_OnRamp__c = objtLaneOpp.onRamp;
                        optylanes.NSSales_OffRamp__c = objtLaneOpp.offRamp;
                        optylanes.NSSales_Shipper__c = objtLaneOpp.shipper;
                        optylanes.NSSales_Receiver__c = objtLaneOpp.receiver;
                        optylanes.NSSales_OriginRoad__c = objtLaneOpp.originRoad;
                        optylanes.NSSales_OriginCity__c = objtLaneOpp.originCity;
                        optylanes.NSSales_OriginState__c = objtLaneOpp.originState;
                        optylanes.NSSales_OriginHandlingLine__c = objtLaneOpp.originHandlingLine;
                        optylanes.NSSales_DestinRoad__c = objtLaneOpp.destinRoad;
                        optylanes.NSSales_DestinCity__c = objtLaneOpp.destinCity;
                        optylanes.NSSales_DestinState__c = objtLaneOpp.destinState;
                        optylanes.NSSales_STCC__c = objtLaneOpp.stcc;
                        optylanes.NSSales_Route__c = objtLaneOpp.route;
                        optylanes.NSSales_EstVolume__c = objtLaneOpp.estVolume;
                        optylanes.NSSales_EstVolumeUnits__c = objtLaneOpp.estVolumeUnits;
                        optylanes.NSSales_EstVolumePeriod__c = objtLaneOpp.estVolumePeriod;
                        optylanes.NSSales_EstRate__c = objtLaneOpp.estRate;
                        optylanes.NSSales_CompetitionType__c = objtLaneOpp.competitionType;
                        optylanes.NSSales_CarOwnership__c = objtLaneOpp.carOwnership;
                        optylanes.NSSales_CarType__c = objtLaneOpp.carType;
                        optylanes.NSSales_MinWeight__c = objtLaneOpp.minWeight;
                        optylanes.NSSales_MinWeightUnits__c = objtLaneOpp.minWeightUnits;
                        optylanes.NSSales_MinCars__c = objtLaneOpp.minCars;
                        optylanes.NSSales_MinCarsPeriod__c = objtLaneOpp.minCarsPeriod;
                        optylanes.NSSales_Lading__c = objtLaneOpp.lading;
                        optylanes.NSSales_Basis__c = objtLaneOpp.basis;
                        optylanes.NSSales_Rate__c = objtLaneOpp.activeRate;
                        optylanes.NSSales_Recommended_Rate__c =objtLaneOpp.reccRate;
                   if(objtLaneOpp.offerRate !=null){
                        optylanes.NSSales_Round_1_Rate__c = objtLaneOpp.offerRate;
                        optylanes.NSSales_Round_1_Rate_Update__c = System.today();
                    }
                    if(objtLaneOpp.finalRate !=null){
                        optylanes.NSSales_Final_Rate__c = objtLaneOpp.finalRate;
                        optylanes.NSSales_Final_Rate_Update__c = System.today();
                    } 
                        optylanes.NSSales_PrivateRate__c = objtLaneOpp.privateRate;
                        optylanes.NSSales_RateSource__c = objtLaneOpp.rateSource;
                        optylanes.NSSales_Lane_Status__c = objtLaneOpp.laneStatus;
                        optylanes.NSSales_Opportunity__c = laneMap.get(objtLaneOpp.laneId);
                    
                    listChildOptyLane.add(optylanes);
                    
                }
                
            }
            if(!listChildOptyLane.isEmpty()){
                insert listChildOptyLane;
            }
            
            if(!laneImcNumWithAcc.isEmpty()){ 
                System.debug(laneImcNumWithAcc);
                System.debug(laneMap);
                    //response = response+ '{"imcNum" : "Error - No Account Found with IMCNUM"'+imc+'}';
                    JSONGenerator gen = JSON.createGenerator(true);
                    gen.writeStartObject();     
                    gen.writeFieldName('Lanes Created');
                    gen.writeStartArray();
                    for(String imc :laneImcNumWithAcc){
                        System.debug(imc);
                        gen.writeStartObject();
                        gen.writeStringField('resultCode', '0');
                        gen.writeStringField('resultDescription', 'Created');
                        gen.writeStringField('Child Opportunity', laneMap.get(imc));
                        gen.writeEndObject();
                }
                gen.writeEndArray();
                gen.writeEndObject();
                String jsonData2 = gen.getAsString();
                response = response + jsonData2;
            }
            
            if(!laneImcNum.isEmpty()){ 
                
                    //response = response+ '{"imcNum" : "Error - No Account Found with IMCNUM"'+imc+'}';
                    JSONGenerator gen = JSON.createGenerator(true);
                    gen.writeStartObject();     
                    gen.writeFieldName('Lanes Not Created');
                    gen.writeStartArray();
                    for(String imc :laneImcNum){
                        gen.writeStartObject();
                        gen.writeStringField('imcNum', 'Error - No Account Found with IMCNUM'+imc);
                        gen.writeEndObject();
                }
                gen.writeEndArray();
                gen.writeEndObject();
                String jsonData3 = gen.getAsString();
                response = response + jsonData3;
            }
            
        }
        // }catch(Exception e) {
        //     response = 'Failure'+e.getMessage();
        //}
        System.debug('Response' +response);
        String jsonString = response.replace('\n', '');
        
        
        return jsonString;                                 
    }
    
    @HttpPut
    global static String updateLane() {
        
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
        String response;
        
        Map<String,Object> wrapperMap = new Map<String,Object>();
        List<NSSales_Opportunity_Lanes__c> listLane = new List<NSSales_Opportunity_Lanes__c>();
        
        NSSales_OpportunityRequestWrapper rw = (NSSales_OpportunityRequestWrapper)JSON.deserialize(requestString,NSSales_OpportunityRequestWrapper.class);
        try{
            for(NSSales_OpportunityRequestWrapper.lanes objt : rw.lanes){
                wrapperMap.put(objt.laneId,objt);
            }            
            
            List<NSSales_Opportunity_Lanes__c> listOptyLane = [Select id,NSSales_LaneId__c from NSSales_Opportunity_Lanes__c where NSSales_LaneId__c IN: wrapperMap.keySet()];
            
            for(NSSales_Opportunity_Lanes__c oppLane: listOptyLane){
                //wrapperMap.get(oppLane.NSSales_LaneId__c).onRamp 
                for(NSSales_OpportunityRequestWrapper.lanes objt : rw.lanes){                    
                    if(oppLane.NSSales_LaneId__c == objt.laneId){
                        System.debug('STCC' +objt.stcc);                        
                        oppLane.NSSales_OnRamp__c = objt.onRamp;
                        oppLane.NSSales_OffRamp__c = objt.offRamp;
                        oppLane.NSSales_Shipper__c = objt.shipper;
                        oppLane.NSSales_Receiver__c = objt.receiver;
                        oppLane.NSSales_OriginRoad__c = objt.originRoad;
                        oppLane.NSSales_OriginCity__c = objt.originCity;
                        oppLane.NSSales_OriginState__c = objt.originState;
                        oppLane.NSSales_OriginHandlingLine__c = objt.originHandlingLine;
                        oppLane.NSSales_DestinRoad__c = objt.destinRoad;
                        oppLane.NSSales_DestinCity__c = objt.destinCity;
                        oppLane.NSSales_DestinState__c = objt.destinState;
                        oppLane.NSSales_STCC__c = objt.stcc;
                        oppLane.NSSales_Route__c = objt.route;
                        oppLane.NSSales_EstVolume__c = objt.estVolume;
                        oppLane.NSSales_EstVolumeUnits__c = objt.estVolumeUnits;
                        oppLane.NSSales_EstVolumePeriod__c = objt.estVolumePeriod;
                        oppLane.NSSales_EstRate__c = objt.estRate;
                        oppLane.NSSales_CompetitionType__c = objt.competitionType;
                        oppLane.NSSales_CarOwnership__c = objt.carOwnership;
                        oppLane.NSSales_CarType__c = objt.carType;
                        oppLane.NSSales_MinWeight__c = objt.minWeight;
                        oppLane.NSSales_MinWeightUnits__c = objt.minWeightUnits;
                        oppLane.NSSales_MinCars__c = objt.minCars;
                        oppLane.NSSales_MinCarsPeriod__c = objt.minCarsPeriod;
                        oppLane.NSSales_Lading__c = objt.lading;
                        oppLane.NSSales_Basis__c = objt.basis;
                        oppLane.NSSales_Rate__c = objt.activeRate;
                        oppLane.NSSales_Recommended_Rate__c = objt.reccRate;
                    if(objt.offerRate !=null){
                        oppLane.NSSales_Round_1_Rate__c = objt.offerRate;
                        oppLane.NSSales_Round_1_Rate_Update__c = System.today();
                    }
                    if(objt.finalRate !=null){
                        oppLane.NSSales_Final_Rate__c = objt.finalRate;
                        oppLane.NSSales_Final_Rate_Update__c = System.today();
                    } 
                        oppLane.NSSales_PrivateRate__c = objt.privateRate;
                        oppLane.NSSales_RateSource__c = objt.rateSource;
                        oppLane.NSSales_Lane_Status__c = objt.laneStatus;
                        oppLane.NSSales_Committed_Volume__c =objt.committedVol;
                        listLane.add(oppLane);
                    }
                }
            }
            if(!listLane.isEmpty()){
                update listLane;
            }
            response = response + '{"resultCode" : "0","resultDescription" : "Updated"}';
        }
        catch(Exception e) {
            response = 'Failure'+e.getMessage();
        }
        return response;
    }
}