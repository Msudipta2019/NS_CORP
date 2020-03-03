/*======================================================================================================
* @Class Name : NSSales_AuthRenwalsTest
* @author : Accenture
* @Purpose: This class is used to used to test the Auth class: NSSales_AuthRenwals data.
* @created date: 22-03-2019
* @Change Logs:                                 
----------------------------------------------------------------------------------------------------------
Developer name        Date          Description        
----------------------------------------------------------------------------------------------------------
@Arjun Ghosh          22-03-2019    Phase-II: Created the class for testing
==========================================================================================================*/
@isTest
public class NSSales_AuthRenwalsTest {
    public static final string USER_REP = 'OSS Rep';
    public final  static String GARDN ='GARDN';
    @isTest
    static void testTransitData() {
        Profile agent = UserTestFactory.createProfile(USER_REP);
        User testUser = UserTestFactory.createUser(25,agent.Id);  
        system.runAs(testUser){
            Account acc = AccountTestFactory.createOnlineServiceAccountRecord(NS_StaticVariablesUtility.Name);            
            String accId= (String)acc.id;
            NS_IntegParams datum= new NS_IntegParams();
            datum.setClassCode(acc.NS_ClassCode__c);
            datum.setStationCode(GARDN);
            datum.setUserId(UserInfo.getUserId());
            datum.setGoodSpell('testGoogspell');
            System.debug('Datum'+ datum);
            System.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
            system.test.StartTest();
            NS_WebService ar= new NSSales_AuthRenewals(); 
            try{
            ar.invokeCallout(datum);}
            catch(Exception exp) {}
            System.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
            System.test.StopTest();
        }
    }
}