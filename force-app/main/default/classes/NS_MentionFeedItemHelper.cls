/**@author  Accenture
* @Created Date 2019-11-04
* @version  1.0
* @description This class handles feedItem  records.
*
*Modification History
*************************************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
*************************************************************************************************
-------------------------------------------------------------------------------------------------

*/

public class NS_MentionFeedItemHelper {
    
    /*Class Name*/
    private static final String CLASS_NAME = 'NS_MentionFeedItemHelper';
    /*Method Name*/
    private static final String METHOD_NAME='restrictUser';
    
    /**********************************************************************************************
* Get a list of FeedItem that comes from Trigger. 
* This functionality is used to restrict user from mentioning context users in chatter
***********************************************************************************************/
    public static void restrictUser(list<FeedItem> feedtrip){
        
        try{
            
            
            List<User> listUserPlatform = [SELECT ID, Name FROM User where NS_Context_User__c=true];
            
            List<String> listNameUserPlatform = new List<String>();
            
            for(User u : listUserPlatform) {
                listNameUserPlatform.add('@'+u.Name);
            }
            
            for(FeedItem f : feedtrip) {
                Boolean nameFinded = false;
                for(Integer i=0; i < listNameUserPlatform.size() && !nameFinded; i++) {
                    if( f.Body.contains(listNameUserPlatform.get(i)) ) {
                        nameFinded=true;
                        f.addError(Label.NS_errorOnContextUser);
                    }
                }
                
            }
            
        }
        catch (Exception exp) {
            /*Inserting a record in Exception object*/
            NS_StaticVariablesUtility.createExceptionRecord(exp, CLASS_NAME, METHOD_NAME);
        }          
        
    }
    
}