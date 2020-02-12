@isTest(SeeAllData=false)
private class NS_BatchForAccountUpdateTest {
    static testmethod void testTerminalInsert(){
        Test.startTest();
         NS_BatchForAccountUpdate BC=new NS_BatchForAccountUpdate();
        Account a=new Account(name='NS_3PL');
            insert a;
         List<Account> alist=[Select name from Account where name like '%NS_3PL%'];
         DataBase.executeBatch(BC,200);
Test.stopTest();

    }
}