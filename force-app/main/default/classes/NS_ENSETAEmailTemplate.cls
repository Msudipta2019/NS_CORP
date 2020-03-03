public with sharing class NS_ENSETAEmailTemplate {
    
    public List<etaCar> etaCarDtl { get; set; }
    public Decimal EtaCarNumber;
    public DateTime EventDate;
    
    public Id notifyId;
	public Id getnotifyId(){
          return notifyId;           
    }
    public void setnotifyId(Id notify){
		notifyId = notify;
		NS_Parse();
	}
    public Decimal getEtaCarNumber(){
  		return EtaCarNumber;
 	}
 	public void setEtaCarNumber(Decimal EtaCarNumber){
  		this.EtaCarNumber = EtaCarNumber;
 	}
    public DateTime getEventDate(){
  		return EventDate;
 	}
 	public void setEventDate(DateTime EventDate){
  		this.EventDate = EventDate;
 	}
    
    public  NS_ENSETAEmailTemplate()
    {   
    }
    
    Public void NS_Parse(){
        
        List<Notification_Log__c> carList = [SELECT  ETA_Car_Detail__c,Total_Cars_Impacted__c,Event_Name__c,Event_Date_Time__c FROM Notification_Log__c WHERE Id =: notifyId];
        
        String etachangeCar = carList[0].ETA_Car_Detail__c;
        Decimal EtaCarNumber = carList[0].Total_Cars_Impacted__c;
        DateTime EventDate = carList[0].Event_Date_Time__c;
        
        setEtaCarNumber(EtaCarNumber);
        setEventDate(EventDate);
        
        if(etachangeCar !=null){
            Integer placeLength = etachangeCar.length() - 1;
        	String placeString = etachangeCar.substring(9,placeLength);
          etaCarDtl = (List<etaCar>) System.JSON.deserialize(placeString, List<etaCar>.class);  
        }
        
    }
    
 public class etaCar{

        public String eqids{get;set;}
		public String acctloc{get;set;}
		public String lastevent{get;set;}
		public String lasteventtime{get;set;}
		public String lasteventloc{get;set;}
		public String delaydesc{get;set;}
		public String neweta{get;set;}
        public String oldeta{get;set;}
        public String emptyStat{get;set;}
        public String stcc{get;set;}
     
             
    }
}