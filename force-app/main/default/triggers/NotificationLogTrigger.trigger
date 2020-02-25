trigger NotificationLogTrigger on Notification_Log__c (before insert,after insert) {

if(trigger.IsBefore){

    if(trigger.IsInsert){
        NS_LocalServiceNotification.invokeNotificationInsert(Trigger.New);
        }
    }
    
}