public class NS_LocalServiceNotification {
   /*
	// Note: classname only specified local service events due to release timing (ENS 1st release), 
	// it is the main entry class to branch to handling of all ENS events
	*/
     
    public Static Final String evPlanned = 'PLANNED';
    public Static Final String evAdvisory = 'SVC_ADVISORY';
    public Static Final String evTransit = 'IN_TRANSIT';
    public Static Final String evOverload = 'OVERLOAD';
    public Static Final String evEta = 'ETACHANGE';
    public Static Final String evNobill = 'NOBILL';
    public Static Final String Pull = 'PULL';
    public Static Final String Plce = 'PLCE';
    
    public static void invokeNotificationInsert(List<Notification_Log__c> notifyList){
        
        System.debug('notifyList' +notifyList);
        List<String> notifyRacfId = new List<String>();
        List<String> notifyContactRacfId = new List<String>();
        List<String> notifyUserRacfId = new List<String>();
        Map<String,User> matchingUser = new Map<String,User>();
        Map<String,Contact> matchingContact = new Map<String,Contact>();
        String notificationDays;
        String notifyStartTime;
        String notifyEndTime;
        Integer intNotifyStartTime;
        Integer intNotifyEndTime;
        String ensPayload;
        Boolean notifyEnabled;
        Boolean notifyWindowEnabled;
        Boolean executeResponse = false;
        
        //compile list of racf where notification events shall be sent to Contact 
        for(Notification_Log__c notify : notifyList)
        {
            if (notify.isInternalUser__c)
            {
                notifyUserRacfId.add(notify.RACF_Id__c);
            }else
            {
                notifyContactRacfId.add(notify.RACF_Id__c);
            }
        }        
        
        for(User usr : [Select id,FederationIdentifier from User where FederationIdentifier =:notifyUserRacfId])
        {
            matchingUser.put(usr.FederationIdentifier,usr);
        }
        for(Contact con : [Select id,NS_RACF_ID__c,Notifications_Enabled__c,Notification_Delivery_Days__c,
                           Notification_Delivery_Hour_Starting__c,Notification_Delivery_Hour_Ending__c,
                           Notification_Delivery_Window_Enabled__c from Contact where NS_RACF_ID__c =:notifyContactRacfId])
        {
            matchingContact.put(con.NS_RACF_ID__c,con);
        }
        
        String createdDayofWk =System.now().format('EEE').toUpperCase();
        String createdTime =System.now().format('HHmm');
        Integer intcreatedTime = Integer.valueOf(createdTime);
        
        for(Notification_Log__c notification : notifyList)
        {
            ensPayload = notification.ENS_Message_Payload__c;
            //2.5, jlong, append country code to phone number for MC sms
            system.debug('input cell=' + notification.Cell_Phone__c);
            if (notification.Cell_Phone__c != null || ''.equalsIgnoreCase(notification.Cell_Phone__c) ){
                notification.Cell_Phone__c = '1' + notification.Cell_Phone__c;
            } 
            //populate notification_msg__c field value
            if((evPlanned.equalsIgnoreCase(notification.Event_Name__c)))
            {
                notification.Notification_Message__c =notification.Customer_Alert_Name__c
                    +' - Plan to place '+Integer.valueOf(notification.Total_Cars_to_Place__c)
                    +' cars and pull '+Integer.valueOf(notification.Total_Cars_to_Pull__c)
                    +'. Estimated window '+notification.Est_Service_Window_From__c.format()
                    +' - '+notification.Est_Service_Window_To__c.format()+' EST.';
            } else if((evAdvisory.equalsIgnoreCase(notification.Event_Name__c)))
            {
                notification.Notification_Message__c =notification.Customer_Alert_Name__c
                    +' - '+Integer.valueOf(notification.Total_Cars_to_Place__c)
                    +' cars were not placed and '
                    +Integer.valueOf(notification.Total_Cars_to_Pull__c)
                    +' were not pulled. Incomplete work will be attempted during next service window.';
            } else if((evTransit.equalsIgnoreCase(notification.Event_Name__c))){
                notification.Notification_Message__c =notification.Customer_Alert_Name__c
                    +' - Train Departed '+notification.Train_Departed_Time__c.format()
                    +' EST with  '+ Integer.valueOf(notification.Total_Cars_to_Place__c)
                    +' place cars. Plan to pull '+ Integer.valueOf(notification.Total_Cars_to_Pull__c)+' cars.';
            } else if((evNobill.equalsIgnoreCase(notification.Event_Name__c)))
            {
                notification.Notification_Message__c =notification.Customer_Alert_Name__c
                    +' - ' +notification.Equipment_Number__c
                    +' was pulled from '  +notification.Location_ClassCode__c +' '
                    +notification.Empty_Indicator__c +' '
                    +notification.Location_City__c +',' +notification.Location_State__c
                    +' without proper forwarding instructions.';
            }
			
            //for notification to internal NS users, set Notification_Log.User field based on RACF ID       
            if(notification.RACF_Id__c != null && notification.isInternalUser__c ==true){
                if(!matchingUser.isEmpty()){
                    notification.User__c = matchingUser.get(notification.RACF_Id__c).Id;
                    notification.OwnerId = matchingUser.get(notification.RACF_Id__c).Id;
                }
                //always process notification to internal user
                notification.Deliver_Now__c = True;
            } else if(notification.RACF_Id__c != null && notification.isInternalUser__c ==false)
			{//for notification to external customers, set Notification_Log.Contact field based on RACF ID
                if(!matchingContact.isEmpty()){
                    notification.Contact_Name__c = matchingContact.get(notification.RACF_Id__c).Id;
                    notificationDays =matchingContact.get(notification.RACF_Id__c).Notification_Delivery_Days__c;
                    notifyEnabled = matchingContact.get(notification.RACF_Id__c).Notifications_Enabled__c;
                    notifyWindowEnabled = matchingContact.get(notification.RACF_Id__c).Notification_Delivery_Window_Enabled__c;
                    notifyStartTime = matchingContact.get(notification.RACF_Id__c).Notification_Delivery_Hour_Starting__c;
                    notifyEndTime = matchingContact.get(notification.RACF_Id__c).Notification_Delivery_Hour_Ending__c;

                    System.debug('DayOfWeek =' + createdDayofWk + '; CurrentHrMin=' + createdTime+ 
                     ';deliveryDays=' +notificationDays +';notifyStartTime=' +notifyStartTime + ' ;notifyEndTime=' +notifyEndTime
                    );

                    if(!(''.equalsIgnoreCase(notifyStartTime)) && !(''.equalsIgnoreCase(notifyEndTime))
                      && notifyStartTime != null && notifyEndTime != null){
                        intNotifyStartTime = Integer.valueOf(notifyStartTime.trim());
                        intNotifyEndTime = Integer.valueOf(notifyEndTime.trim());

                        //set flag whether to process or discard notify msg based on contact delivery window set in AccessNS
                        if(notifyWindowEnabled == false) {                
                            //10.25, jlong, AccessNS does not currently set notification enabled field, remove from delivery condition
                            //if((notification.isInternalUser__c == false && notifyEnabled == true && notifyWindowEnabled == false) || notification.isInternalUser__c == true) {                
                            notification.Deliver_Now__c = True;
                        }
                        else {
                            if( !(''.equalsIgnoreCase(notificationDays)) && notificationDays.contains(createdDayofWk)){
                                //11.9, jlong, temp update set 2400 as 0 for AccessNS notify window start time bug,
                                if (intNotifyStartTime >= 2400){
                                    intNotifyStartTime = 0;                                
                                } 
                                // user notify start time in PM and end in AM
                                if (intNotifyStartTime >= 1200 && intNotifyEndTime < 1200){
                                    System.debug('...PM-AM, enter start time in PM and end in AM ');
                                     if (! (intNotifyEndTime < intcreatedTime && intNotifyStartTime > intcreatedTime)){
                                        System.debug('...PM-AM, current time greater than endtime, less than starttime...'); 
                                        notification.Deliver_Now__c = True;
                                    } 
                                } else{
                                    if (intNotifyStartTime <= intcreatedTime && intNotifyEndTime >= intcreatedTime){
                                        notification.Deliver_Now__c = True;
                                    }                                    
                                }
                            }
                        }
                    }
                }
                
            }
            
            if((evPlanned.equalsIgnoreCase(notification.Event_Name__c) || evAdvisory.equalsIgnoreCase(notification.Event_Name__c) || evTransit.equalsIgnoreCase(notification.Event_Name__c))){
                responseParser(ensPayload,notification);
            }
            else if(evOverload.equalsIgnoreCase(notification.Event_Name__c)){
                ENS_OverloadedNotification.overloadedResponseParser(ensPayload,notification);
            }
            else if(evEta.equalsIgnoreCase(notification.Event_Name__c)){
                ENS_ETANotification.etaResponseParser(ensPayload,notification);
            }
        }
    }
    
    public static void responseParser(String rawResponse,Notification_Log__c notificationList){
        
        System.debug('rawResponse' +rawResponse);
        if(rawResponse != null){
            NS_LocalServicePayloadWrapper wrapperList = (NS_LocalServicePayloadWrapper)JSON.deserialize(rawResponse,NS_LocalServicePayloadWrapper.class);
            
            Boolean placeCarFlag = false;
            Boolean pullCarFlag = false;
            Integer placeCarCount = 0;
            Integer placePrevCount;
            Integer pullCarCount = 0;
            Integer pullCarPrevCount;
            String jsonResponsePlaceSub;
            String jsonResponsePullSub;
            String jsonResponsePlace = '{"eqdtl":[{';
            String jsonResponsePull = '{"eqdtl":[{';

            Boolean plcUpdatedFlag=false;
            Integer plcUpdatedCount = 0;
            Integer plcUpdatedPrevCount;
            String jsonResponsePlaceUpdatedSub;
            String jsonResponsePlaceUpdated = '{"eqdtl":[{';
            
            for(NS_LocalServicePayloadWrapper.Eqdtl objt :wrapperList.Eqdtls.eqdtl){
                
                if(objt.action =='PLCE' && !('Y'.equalsIgnoreCase(objt.equpdatedind)) && placeCarCount < 3998){

                    placePrevCount  = jsonResponsePlace.length();
                    if (placeCarFlag== true)
                    {
                        jsonResponsePlace+=',{';
                    }
                    jsonResponsePlace+= '"eqinit":"'+objt.eqinit
                        +'","eqnr":"'+objt.eqnr
                        +'","wbsernr":"'+objt.wbsernr
                        +'","emptyind":"'+objt.emptyind
                        +'","cartype":"'+objt.cartype
                        +'","classcd":"'+objt.classcd
                        +'","commodity":"'+objt.commodity
                        +'","stcc":"'+objt.stcc
                        +'","wgt":"'+objt.wgt
                        +'","rlsereqtype":"'+objt.rlsereqtype
                        +'","totk":"'+objt.totk
                        +'","tospot":"'+objt.tospot
                        +'","eqloparsn":"'+objt.eqloparsn+'"}';                    
                    placeCarFlag = true;
                    placeCarCount =jsonResponsePlace.length();
                    
                }

                if(objt.action =='PLCE' && 'Y'.equalsIgnoreCase(objt.equpdatedind) && plcUpdatedCount < 3998){
                    plcUpdatedPrevCount  = jsonResponsePlaceUpdated.length();
                    if (plcUpdatedFlag == true)
                    {
                        jsonResponsePlaceUpdated+=',{';
                    }
                    jsonResponsePlaceUpdated+= '"eqinit":"'+objt.eqinit
                        +'","eqnr":"'+objt.eqnr
                        +'","wbsernr":"'+objt.wbsernr
                        +'","emptyind":"'+objt.emptyind
                        +'","cartype":"'+objt.cartype
                        +'","classcd":"'+objt.classcd
                        +'","commodity":"'+objt.commodity
                        +'","stcc":"'+objt.stcc
                        +'","wgt":"'+objt.wgt
                        +'","rlsereqtype":"'+objt.rlsereqtype
                        +'","totk":"'+objt.totk
                        +'","tospot":"'+objt.tospot
                        +'","eqloparsn":"'+objt.eqloparsn+'"}';                    
                    plcUpdatedFlag = true;
                    plcUpdatedCount =jsonResponsePlaceUpdated.length();                    
                }

                if(objt.action =='PULL' && pullCarCount < 3998){
                    pullCarPrevCount  = jsonResponsePull.length();
                    if (pullCarFlag== true)
                    {
                        jsonResponsePull+=',{';
                    }
                    jsonResponsePull+= '"eqinit":"'+objt.eqinit
                        +'","eqnr":"'+objt.eqnr
                        +'","wbsernr":"'+objt.wbsernr
                        +'","emptyind":"'+objt.emptyind
                        +'","cartype":"'+objt.cartype
                        +'","classcd":"'+objt.classcd
                        +'","commodity":"'+objt.commodity
                        +'","stcc":"'+objt.stcc
                        +'","wgt":"'+objt.wgt
                        +'","rlsereqtype":"'+objt.rlsereqtype
                        +'","fromtk":"'+objt.fromtk
                        +'","fromspot":"'+objt.fromspot
                        +'","eqloparsn":"'+objt.eqloparsn+'"}';
                    pullCarFlag= true;
                    pullCarCount =jsonResponsePull.length();    
                }
            }     
            
            // Place Car Details for 4000 character  
            if(placeCarCount > 4000){
                system.debug('Inside Count' +placeCarCount);
                jsonResponsePlaceSub = jsonResponsePlace.substring(0, placePrevCount);
                
            }
            else{
                jsonResponsePlaceSub = jsonResponsePlace.substring(0, placeCarCount);
            }
            // Updated Place Car Details for 4000 character  
            if(plcUpdatedCount > 4000){
                jsonResponsePlaceUpdatedSub = jsonResponsePlaceUpdated.substring(0, plcUpdatedPrevCount);
                
            }
            else{
                jsonResponsePlaceUpdatedSub = jsonResponsePlaceUpdated.substring(0, plcUpdatedCount);
            }            
            // Pull Car Details for 4000 character     
            if(pullCarCount > 4000){
                system.debug('Inside Count' +pullCarCount);
                jsonResponsePullSub = jsonResponsePull.substring(0, pullCarPrevCount);
                
            }
            else{
                jsonResponsePullSub = jsonResponsePull.substring(0, pullCarCount);
            }
            //If there is no Place Car Details, then display blank.    
            if(placeCarCount == 0){
                jsonResponsePlaceSub+='';
            }
            else{
                jsonResponsePlaceSub+=']}';
            }
            //If there is no Updated Place Car Details, then display blank.    
            if(plcUpdatedCount == 0){
                jsonResponsePlaceUpdatedSub+='';
            }
            else{
                jsonResponsePlaceUpdatedSub+=']}';
            }            
            //If there is no Pull Car Details, then display blank.  
            if(pullCarCount == 0){
                jsonResponsePullSub+='';  
            }
            else{
                jsonResponsePullSub+=']}';
            }
            
            notificationList.LS_Place_Cars_Detail__c = jsonResponsePlaceSub.replace('null', '-');
            notificationList.LS_Pull_Cars_Detail__c = jsonResponsePullSub.replace('null', '-');
            notificationList.LS_PlacedCars_Updated_Detail__c = jsonResponsePlaceUpdatedSub.replace('null', '-');
            
        } 
    }
    
}