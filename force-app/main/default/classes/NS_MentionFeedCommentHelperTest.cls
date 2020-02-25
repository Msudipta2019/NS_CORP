/**@author  Accenture
* @Created Date 2019-11-11
* @version  1.0
* @description This Test class is used for NS_MentionFeedCommentHelper class.
*
*Modification History
*************************************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
*************************************************************************************************
-------------------------------------------------------------------------------------------------

*/

@isTest
public class NS_MentionFeedCommentHelperTest {
    
     
    static testMethod void testTrigger() {

test.startTest();
   /*Create Test Account*/     
        Account accTest = AccountTestFactory.createAccountRecord(NS_StaticVariablesUtility.NAME); 
   /*Create feed item*/     
        FeedItem  fList = new FeedItem();
        fList.Body='Service';
        fList.ParentId =accTest.id;
        Database.SaveResult srListFeedItem = Database.insert(fList, false);
   /*Create feed comment*/       
        FeedComment fc = new FeedComment(CommentBody='@Automated Process Test Comment',FeedItemId= fList.Id);
        Database.SaveResult srListComment = Database.insert(fc, false);
         
       
       /*Assertion*/  
        System.assertEquals(false,srListComment.isSuccess());   
        
  
    
test.stopTest();

}

}