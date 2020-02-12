public class ENS_ETANotification {
    
    public static void etaResponseParser(String rawResponse,Notification_Log__c recNotificationLog){
        if(rawResponse != null){
            
            ENS_ETAWrapper wrapperList = (ENS_ETAWrapper)JSON.deserialize(rawResponse,ENS_ETAWrapper.class);
            
            Boolean etaFlag = false;    
            String etaJson = '{"eqdtl":[{';
            String etaJsonSub;   
            Integer count = 0;
            Integer prevCount;

            // construct notification_message for multi cars/equipments event
            if (recNotificationLog.Total_Cars_Impacted__c >1){
                recNotificationLog.Notification_Message__c =recNotificationLog.Customer_Alert_Name__c
                    +' - '+ Integer.valueOf(recNotificationLog.Total_Cars_Impacted__c)
                    +' shipments have been rescheduled.';                 
            }            
            for(ENS_ETAWrapper.Equipment objt :wrapperList.EquipmentList.Equipment){
                if(count < 3998){
                    prevCount  = etaJson.length();
                    if (etaFlag== true)
                    {
                        etaJson+=',{';
                    }
                    etaJson+= '"eqids":"'+objt.EquipmentNumber
                        +'","acctloc":"'+objt.Locations.Location[0].AcctLocCity + ',' + objt.Locations.Location[0].AcctLocState 
                        +'","lastevent":"'+objt.LastEventDescription
                        +'","lasteventtime":"'+Datetime.valueOf(objt.LastEventTime.replace('T', ' ')).format()+' EST'
                        +'","lasteventloc":"'+objt.LastEvtCity+','+objt.LastEvtState
                        +'","delaydesc":"'+objt.DelayDescription
                        // change wrapper once source field name for old eta is provided
                        +'","oldeta":"'+ Datetime.valueOf(objt.PriorETA.replace('T', ' ')).format() +' EST'  
                        +'","neweta":"'+Datetime.valueOf(objt.NewETA.replace('T', ' ')).format()+' EST'
                        +'","emptyStat":"'+objt.LoadEmptyStatus
                        +'","stcc":"'+objt.Commodity                        
                        +'"}';                    
                    etaFlag = true;
                    count =etaJson.length();
                }
                // construct notification_message for 1 car/equipment event
                if (recNotificationLog.Total_Cars_Impacted__c ==1){
                    recNotificationLog.Notification_Message__c =recNotificationLog.Customer_Alert_Name__c
                        +' - '+ objt.EquipmentNumber
                        +' is rescheduled to ' + Datetime.valueOf(objt.NewETA.replace('T', ' ')).format()+' EST.';
                    recNotificationLog.Equipment_Number__c =objt.EquipmentNumber;
                }
                
            }          
            if(count > 4000){
                system.debug('Inside Count' +count);
                etaJsonSub = etaJson.substring(0, prevCount);
                
            }else{
                etaJsonSub = etaJson.substring(0, count);
            }
            
            if(count == 0){
                etaJsonSub+='';
            }
            else{
                etaJsonSub+=']}';
            }
            
            recNotificationLog.ETA_Car_Detail__c = etaJsonSub.replace('null', '-');
            
        }
    }
}