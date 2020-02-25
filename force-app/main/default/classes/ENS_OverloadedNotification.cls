public class ENS_OverloadedNotification {
    
    public static void overloadedResponseParser(String rawResponse,Notification_Log__c recNotificationLog){
        
        if(rawResponse != null){
            
            ENS_OverloadedWrapper wrapperList = (ENS_OverloadedWrapper)JSON.deserialize(rawResponse,ENS_OverloadedWrapper.class);
            
            Boolean OverloadFlag = false;    
            String overloadJson = '{"eqdtl":[{';
            String overloadJsonSub;   
            String overloadStatus= wrapperList.Payload[0].OverloadStatus;
            String olString = 'Overloaded';
            String olResString = 'RESOLVED';
            Integer count = 0;
            Integer prevCount;
            
            if(overloadStatus.equalsIgnoreCase(olResString)){
                recNotificationLog.Event_SubType__c='RESOLVED';
            }
            
            for(ENS_OverloadedWrapper.Payload objt :wrapperList.Payload){
                // construct notification_message
                if (recNotificationLog.Total_Cars_Impacted__c ==1 && overloadStatus.equalsIgnoreCase(olString)) {
                    recNotificationLog.Notification_Message__c =recNotificationLog.Customer_Alert_Name__c 
                        +' - ' +objt.EquipmentNumber
                        +' is overloaded and must be reduced to gross or diverted to an alternate destination.';
                    recNotificationLog.Equipment_Number__c =objt.EquipmentNumber;
                } 
                else if (recNotificationLog.Total_Cars_Impacted__c >1 && overloadStatus.equalsIgnoreCase(olString)){
                    recNotificationLog.Notification_Message__c =recNotificationLog.Customer_Alert_Name__c
                        +' - '+ Integer.valueOf(recNotificationLog.Total_Cars_Impacted__c)
                        +' railcars are overloaded and must be reduced to gross or diverted to an alternate location.';               
                } 
                else if (recNotificationLog.Total_Cars_Impacted__c ==1 && overloadStatus.equalsIgnoreCase(olResString)){
                    recNotificationLog.Notification_Message__c =recNotificationLog.Customer_Alert_Name__c
                        +' - ' +objt.EquipmentNumber
                        +' was overloaded. The overload has been resolved.';
                    recNotificationLog.Equipment_Number__c =objt.EquipmentNumber;                
                }
                else if (recNotificationLog.Total_Cars_Impacted__c >1 && overloadStatus.equalsIgnoreCase(olResString)){
                    recNotificationLog.Notification_Message__c =recNotificationLog.Customer_Alert_Name__c
                        +' - ' + Integer.valueOf(recNotificationLog.Total_Cars_Impacted__c)
                        +' shipments were overloaded. The overload has been resolved.';
                }
                
                if(count < 3998){
                    prevCount  = overloadJson.length();
                    if (OverloadFlag== true)
                    {
                        overloadJson+=',{';
                    }
                    overloadJson+= '"eqids":"'+objt.EquipmentNumber
                        +'","lastevent":"'+objt.LastEventDescription
                        +'","lasteventtime":"'+Datetime.valueOf(objt.LastEventTime.replace('T', ' ')).format()+' EST'
                        +'","lasteventloc":"'+objt.LastEvtCity+','+objt.LastEvtState
                        +'","scalewtgrs":"'+objt.ScaleWeightGross
                        +'","umltotalwt":"'+objt.UmlerTotalWeight
                        +'","origloc":"'+objt.OriginLocCity +','+objt.OriginLocState
                        +'","shipper":"'+objt.Name
                        +'"}';                    
                    OverloadFlag = true;
                    count =overloadJson.length();
                } 
            }
            
            if(count > 4000){
                system.debug('Inside Count' +count);
                overloadJsonSub = overloadJson.substring(0, prevCount);
                
            }
            else{
                overloadJsonSub = overloadJson.substring(0, count);
            }
            
            if(count == 0){
                overloadJsonSub+='';
            }
            else{
                overloadJsonSub+=']}';
            }
            
            recNotificationLog.Overload_Cars_Detail__c = overloadJsonSub.replace('null', '-');
        }
    }
    
}