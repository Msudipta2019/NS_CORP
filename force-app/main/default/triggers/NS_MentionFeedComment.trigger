/**@author  Accenture
* @Created Date 2019-11-04
* @version  1.0
* @description This Trigger handles all FeedComments .
*
*Modification History
*************************************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
*************************************************************************************************
-------------------------------------------------------------------------------------------------

*/

trigger NS_MentionFeedComment on FeedComment (before insert, before update) {
    
    
        
     if(trigger.isinsert||trigger.isupdate){
        
        NS_MentionFeedCommentHelper.restrictUserComment(trigger.new);
  
        
    }

}