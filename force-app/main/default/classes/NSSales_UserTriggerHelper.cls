/**@author  Accenture
* @Created Date Nov,2019
* @version  1.0
* @description This class conatins methods which are invoked by UserTrigger
*/ 

public class NSSales_UserTriggerHelper {
    
    /*This method updates the Time Delta field in accordance with the Time Zone when a new user record gets created*/
    public static void updateTimeDeltaOnCreate(List<User> users){
        
        for(User newUser : users){
            TimeZone tz = Timezone.getTimeZone(newUser.TimeZoneSidKey);
            DateTime dt = Datetime.now();
            Long dt1Long = dt.getTime();
            Long dt2Long = dt.addSeconds((tz.getOffset(dt)/1000)).getTime();
            Long milliseconds = dt1Long-dt2Long;
            Decimal seconds = milliseconds / 1000;
            Decimal minutes = seconds / 60;
            Decimal hours = minutes / 60;
            newUser.NSSales_TimeDelta__c = hours;
        }
        
    }
    
    /*This method updates the Time Delta when an existing user record's Time Zone gets updated*/
    public static void updateTimeDeltaOnUpdate(Map<Id,User> newUserMap, Map<Id,User> oldUserMap){
        
        for(User updatedUser : newUserMap.values()){
            if(oldUserMap.get(updatedUser.Id).TimeZoneSidKey != updatedUser.TimeZoneSidKey){
                TimeZone tz = Timezone.getTimeZone(updatedUser.TimeZoneSidKey);
                DateTime dt = Datetime.now();
                Long dt1Long = dt.getTime();
                Long dt2Long = dt.addSeconds((tz.getOffset(dt)/1000)).getTime();
                Long milliseconds = dt1Long-dt2Long;
                Decimal seconds = milliseconds / 1000;
                Decimal minutes = seconds / 60;
                Decimal hours = minutes / 60;
                updatedUser.NSSales_TimeDelta__c = hours;
            }
        }
    }
    public static void updateuser(Map<Id,User> newUserMap, Map<Id,User> oldUserMap){
        List<User> usersLst=New  List<User>();
        
        set<ID> userID= New set<ID>();
        List<NSSales_Marketing_Manager_Assignment__c> mmaLst=New List<NSSales_Marketing_Manager_Assignment__c>();
        List<NSSales_Marketing_Manager_Assignment__c> ex1=New List<NSSales_Marketing_Manager_Assignment__c>();
        
        List<User> abc=new List<User>();
        set<ID> accID= New set<ID>();
        set<ID> alluserID= New set<ID>();
        Map<Id, Boolean> mapUserToActive = new Map<Id, Boolean>();
        System.debug('newUserMap'+newUserMap);
        List<User> ted=new List<User>(); 
      // List  <NSSales_Marketing_Manager_Assignment__c> gfdg=[Select NSSales_Account__c,NSSales_MarketingManager__c from NSSales_Marketing_Manager_Assignment__c where NSSales_MarketingManager__c IN : ted];
        for (User a : newUserMap.values())  {
            System.debug('XXSRV SoS1 '+newUserMap.get(a.Id));
            System.debug('XXSRV SoS2 '+oldUserMap.get(a.Id));
            
            
            if(!newUserMap.get(a.Id).IsActive && oldUserMap.get(a.Id).IsActive){ 
                System.debug('XXSRV SS '+a.Name);
                
                
                ted.add(a);
            }
            } 
                mmaLst.addAll([Select NSSales_Account__c,NSSales_MarketingManager__c from NSSales_Marketing_Manager_Assignment__c where NSSales_MarketingManager__c IN : ted]);
              
        System.debug('mmaLst'+mmaLst);        
        // test.addall(mmaLst);
        for(NSSales_Marketing_Manager_Assignment__c mma:mmaLst)
        {
            accID.add(mma.NSSales_Account__c);
        } 
       
        System.debug('accID'+accID);
      
        for(NSSales_Marketing_Manager_Assignment__c mma1 :[Select NSSales_MarketingManager__c from NSSales_Marketing_Manager_Assignment__c where NSSales_Account__c  IN :accID]) 
        {
            alluserID.add(mma1.NSSales_MarketingManager__c);
           }
        System.debug('alluserID'+alluserID);
        
        List<user> uulst= New List<user>([select id,email,FirstName,LastName from user where id in :alluserID]);

        System.debug('username'+uulst);
        
        for( User u:uulst ){
            
            system.debug('ted-->'+ted[0]);
            String recipientName = ted[0].FirstName+ ' '+ ted[0].LastName;
            if(ted[0].id != u.id){
                String subject='Assigned User Has Been Deactivated';
                String plainTextBody ='The following Marketing Manager  ' +'    '+ recipientName +'  assigned to your Account has  been deactivated in ConnectNS.' ;
                sendEmail(u.Email,subject, plainTextBody);
                System.debug('Email'+u.Email);
                System.debug('subject'+subject);
                System.debug('plainTextBody'+plainTextBody);
            }
        }
        /* List<User> inactiveUsersList = new List<User>();
}
for(User userInactive : )*/
    }   
    @future
    public static void sendEmail(String toAddresses ,String subject ,String plainTextBody){    
        try{ 
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            //for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where Address='noreply@nscorp.com']) 
            for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName='No Reply'])
            {
                  message.setOrgWideEmailAddressId(owa.Id); 
                    //message.setOrgWideEmailAddressId('owa.Id');
                
                
                List<String>  toall = new  List<String>();
                toall.add(toAddresses);
                // message.setOrgWideEmailAddressId(owa);
                
                message.toAddresses = toall;
                message.subject = subject;
                message.plainTextBody = plainTextBody;
                
                
                System.debug('XXSRV MSG'+message);
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            }}catch(Exception Exp){
                system.debug('SOS EXP '+Exp.getLineNumber()+' : '+Exp.getMessage());
            }
        
    }
    
    public static void updateusermanager(Map<Id,User> newUserMap, Map<Id,User> oldUserMap){
        
        MAp<id,User> mapUser = new MAp<id,User>([SELECT FirstName,LastName, Id, Manager.Name, Manager.Id,email FROM User]);
        user manUser =new user();
        
        
        System.debug('newUserMap'+newUserMap);
        for (User a : newUserMap.values())  {
            System.debug('XXSRV SoS1 '+newUserMap.get(a.Id));
            System.debug('XXSRV SoS2 '+oldUserMap.get(a.Id));
            if(!newUserMap.get(a.Id).IsActive && oldUserMap.get(a.Id).IsActive && a.ManagerId!=null){ 
                System.debug('XXSRV SS '+mapUser.get(a.ManagerId));
                manUser=mapUser.get(a.ManagerId);
                String subject='Assigned User Has Been Deactivated'; 
                String plainTextBody ='The following user, ' +  a.FirstName +' '+ a.LastName + ' has been deactivated in ConnectNS. Please ensure ConnectNS records owned by '+  a.FirstName +' '+ a.LastName + ' is updated to a new owner.' ;
                //Id emailAddressId='noreply@nscorp.com';
                sendEmail(manUser.Email,subject, plainTextBody);
                System.debug('Email'+manUser.Email);
                System.debug('subject'+subject);
                System.debug('plainTextBody'+plainTextBody);
                
            }        
        }
        
    } 
    public static void updateoppmanager(Map<Id,User> newUserMap, Map<Id,User> oldUserMap){
        List<User> usersLst=New  List<User>();
        set<ID> userID= New set<ID>();
        
        //  List<Opportunity> abdc=[SELECT StageName FROM Opportunity where StageName!='Closed Won' AND  StageName!='Closed Lost'];
        List<OpportunityTeamMember> mmaLst1=New List<OpportunityTeamMember>();
        List<OpportunityTeamMember> ex2=New List<OpportunityTeamMember>();
        List<User> abc=new List<User>();
        set<ID> accID= New set<ID>();
        set<ID> alluserID= New set<ID>();
       
        Map<id, Boolean> mapUserToActive = new Map<Id, Boolean>();
        System.debug('newUserMap'+newUserMap); 
        System.debug('newUserMap'+newUserMap);
        map<id,Opportunity> yyyyy=new map<id,Opportunity>([SELECT  OwnerId,StageName FROM Opportunity where StageName!='Closed Won' AND  StageName!='Closed Lost' AND  StageName!='Cancelled']);
        System.debug('closed'+yyyyy.values());
        //for(Opportunity aaa:[SELECT StageName FROM Opportunity where StageName!='Closed Won' AND  StageName!='Closed Lost']){ 
       List<User> ted=new List<User>(); 
        List<OpportunityTeamMember> sus=([Select UserId, OpportunityId,Opportunity.StageName from OpportunityTeamMember where UserId IN : ted AND Opportunity.StageName NOT IN('Closed Won','Closed Lost') ]);
     
      for (User a : newUserMap.values())  {
            System.debug('newmapvalue '+newUserMap.get(a.Id));
            System.debug('oldmapvalue '+oldUserMap.get(a.Id));

            
            if(!newUserMap.get(a.Id).IsActive && oldUserMap.get(a.Id).IsActive   ){ 
                System.debug('Xx '+a.Name);
                //  manUser1=mapUser.get(a.Id);
                
                ted.add(a);
            }

      }
        mmaLst1.addAll([Select UserId, OpportunityId,Opportunity.StageName from OpportunityTeamMember where UserId IN : ted AND Opportunity.StageName NOT IN('Closed Won','Closed Lost') ]);
                
                                                                                             
            
        
        for(OpportunityTeamMember mma:mmaLst1)
        {
            
            accID.add(mma.OpportunityId );
        }
        
        for(OpportunityTeamMember mma1 :[Select UserId,OpportunityId,Opportunity.StageName from OpportunityTeamMember where OpportunityId  IN :accID AND Opportunity.StageName NOT IN('Closed Won','Closed Lost','Cancelled')])
        {
            alluserID.add(mma1.UserId);
        }
        
        List<user> uulst= New List<user>([select id,email,FirstName,LastName from user where id in :alluserID]);
        System.debug('username'+uulst);
        
        for( User u:uulst ){
            system.debug('ted-->'+ted[0]);
            String recipientName = ted[0].FirstName+'  '+ted[0].LastName;
            if(ted[0].id != u.id ||ted[0].id == u.id ){
                
                
                String subject='Opportunity Team Member Deactivated';
                String plainTextBody ='Hi '+' ' +  u.FirstName +'   ,\n\n Please note that the following Opportunity Team Member has been deactivated in ConnectNS:  '+ recipientName  ;
                // String fromaddress='noreply@gmail.com';
                sendEmail(u.Email,subject, plainTextBody);
                System.debug('Email'+u.Email);
                System.debug('subject'+subject);
                System.debug('plainTextBody'+plainTextBody);
            }
        }
    }
    
    public static void updatemanagerrole(Map<Id,User> newUserMap, Map<Id,User> oldUserMap){
        MAp<id,User> mapUser = new MAp<id,User>([SELECT FirstName,LastName, Id,Name, Manager.Id,email FROM User]);
        System.debug('mapUser'+mapUser);
        Map<id,User>  mapof=new Map<id,User>();
        
        user manUser =new user();
        System.debug('newUserMap'+newUserMap);
        for (User a : newUserMap.values())  {
            System.debug('XXSRV SoS1 '+newUserMap.get(a.Id));
            System.debug('XXSRV SoS2 '+oldUserMap.get(a.Id));
            if(newUserMap.get(a.Id).UserRoleId!=oldUserMap.get(a.Id).UserRoleId && a.ManagerId!=null){ 
                System.debug('XXSRV SS '+mapUser.get(a.Manager.Id));
                //    System.debug('XXSRV SS '+mapUser.get(a.Manager.Name));
                manUser=mapUser.get(a.ManagerId);
                String subject='Role has been changed';
                
                
                String plainTextBody ='Hi '+manUser.Name+', \n\nThe following user :' +  a.FirstName +' '+ a.LastName + ' has changed roles. Please review Leads and Opportunities that were assigned to '+  a.FirstName +' '+ a.LastName + '  and update the Owner if necessary.' ;
                // String plainTextBody ='Hi'+a.ManagerId , The following user ' +  a.FirstName +' '+ a.LastName + ' has changrd roles.Please review Leads and Opportunities that were assigned to  '+  a.FirstName +' '+ a.LastName + ' nd update the Owner if necessary.' ;
                sendEmail(manUser.Email,subject, plainTextBody);
                
                System.debug('Email'+manUser.Email);
                System.debug('subject'+subject);
                System.debug('plainTextBody'+plainTextBody);
                
            }
        } 
    }
    
    /*SRV send mail to all marketing managers*/
    public static void sendMailtoMarketingManagers(Map<Id,User> newMapUser, Map<Id,User> oldMapUser){
       list<id> allRelatedAddountid= new list<id>();
        list<NSSales_Marketing_Manager_Assignment__c> allMarketingManagerRelToAccnt = new list<NSSales_Marketing_Manager_Assignment__c>();
        list<NSSales_Marketing_Manager_Assignment__c> marketingManagerAssignedtoUser 
            =[select id,NSSales_Account__c from NSSales_Marketing_Manager_Assignment__c where NSSales_MarketingManager__c in :newMapUser.keyset()];
        for(NSSales_Marketing_Manager_Assignment__c markMan : marketingManagerAssignedtoUser){
            allRelatedAddountid.add(markMan.NSSales_Account__c);
        }
        allMarketingManagerRelToAccnt =[select id,Name,NSSales_Account__c from NSSales_Marketing_Manager_Assignment__c where NSSales_Account__c in :allRelatedAddountid];
        system.debug('SRV allMarketingManagerRelToAccnt '+allMarketingManagerRelToAccnt);
        
}
}