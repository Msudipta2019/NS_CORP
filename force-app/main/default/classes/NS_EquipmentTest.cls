@isTest
public class NS_EquipmentTest {
    public static final string USER_REP = 'OSS Rep';
    public final  static String GARDN ='GARDN';
    
    @isTest
    static void testTransitData() {
        Profile agent = UserTestFactory.createProfile(USER_REP);
        User testUser = UserTestFactory.createUser(25,agent.Id);  
        system.runAs(testUser){
             Account acc = AccountTestFactory.createAccountRecord(NS_StaticVariablesUtility.Name);
            Case abc = CaseTestFactory.createCaseRecord('Local Service Inquiry','Local Service',acc.Id); 
            insert abc;
            System.debug(abc.id);
            String abcId= (String)abc.id;
            NS_IntegParams datum= new NS_IntegParams();
            datum.setClassCode(acc.NS_ClassCode__c);
            datum.setStationCode(GARDN);
            datum.setUserId(UserInfo.getUserId());
           datum.setequipmentID('EMHU 262418');
            System.debug('Datum'+ datum);
            System.Test.setMock(HttpCalloutMock.class, new NscorpWSCalloutRequestHandler_Mock());
            system.test.StartTest();
            NS_WebService ar= new NS_EquipmentSummary(); 
            ar.invokeCallout(datum);
            System.test.StopTest();
        }
    }
}