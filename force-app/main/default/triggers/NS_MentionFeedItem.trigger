/**@author  Accenture
* @Created Date 2019-11-04
* @version  1.0
* @description This Trigger handles all FeedItems.
*
*Modification History
*************************************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
*************************************************************************************************
-------------------------------------------------------------------------------------------------

*/
trigger NS_MentionFeedItem on FeedItem (before insert, before update){
    if(trigger.isinsert||trigger.isupdate){
        
        NS_MentionFeedItemHelper.restrictUser(trigger.new);
        
        
    }
    
}