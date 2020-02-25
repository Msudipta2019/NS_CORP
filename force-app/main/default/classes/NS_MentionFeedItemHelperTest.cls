/**@author  Accenture
* @Created Date 2019-11-11/**@author  Accenture
* @Created Date 2019-11-04
* @version  1.0
* @description This class handles feedComment  records.
*
*Modification History
*************************************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
*************************************************************************************************
-------------------------------------------------------------------------------------------------
*/

@isTest
public class NS_MentionFeedItemHelperTest {
    
    static testMethod void testTrigger() {

test.startTest();
        /*Create Test Account*/   
        Account accTest = AccountTestFactory.createAccountRecord(NS_StaticVariablesUtility.NAME); 
      /*Create feed item*/  
        FeedItem  fList = new FeedItem();
        fList.Body='@Customer Service';
        fList.ParentId =accTest.id;
         
        Database.SaveResult srList = Database.insert(fList, false);
        /*Assertion*/
        System.assertEquals(false,srList.isSuccess());   
        
  
    
test.stopTest();

}
}