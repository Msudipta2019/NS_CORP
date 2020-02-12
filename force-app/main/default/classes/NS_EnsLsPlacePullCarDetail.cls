public with sharing class NS_EnsLsPlacePullCarDetail {    
    public List<eqdtlPlace> placeCarDtl { get; set; }
    public List<eqdtlPull> pullCarDtl { get; set; }
    public List<eqdtlPlace> plcUpdatedCarDtl { get; set; }
    public Decimal TotalplaceCar;
    public Decimal TotalpullCar;
    public Boolean UpdatedPlace=false;
    public String EventName;
    
    public Id notifyId;
	public Id getnotifyId(){
          return notifyId;           
    }
    public void setnotifyId(Id notify){
		notifyId = notify;
		NS_LSEventParse();
	}
    public Decimal getTotalplaceCar(){
  		return TotalplaceCar;
 	}
 	public void setTotalplaceCar(Decimal TotalplaceCar){
  		this.TotalplaceCar = TotalplaceCar;
 	}
    public Decimal getTotalpullCar(){
  		return TotalpullCar;
 	}
 	public void setTotalpullCar(Decimal TotalpullCar){
  		this.TotalpullCar = TotalpullCar;
 	}
    public String getEventName(){
  		return EventName;
 	}
 	public void setEventName(String eventName){
  		this.EventName = eventName;
 	}
    public Boolean getUpdatedPlace(){
  		return UpdatedPlace;
 	}
 	public void setUpdatedPlace(Boolean updatedPlace){
  		this.UpdatedPlace = updatedPlace;
 	}
    public  NS_EnsLsPlacePullCarDetail()
    {   
    }
    
    Public void NS_LSEventParse()
    {
        System.debug('notify Id in NS_Parse : '+notifyId);   
        List<Notification_Log__c> carList = [SELECT  LS_Place_Cars_Detail__c,LS_Pull_Cars_Detail__c,Total_Cars_to_Place__c,Total_Cars_to_Pull__c,Event_Name__c,LS_PlacedCars_Updated_Detail__c FROM Notification_Log__c WHERE Id =: notifyId];
        String placeCar = carList[0].LS_Place_Cars_Detail__c;
        String pullCar = carList[0].LS_Pull_Cars_Detail__c;
        String plcUpdatedCar = carList[0].LS_PlacedCars_Updated_Detail__c;
        Decimal TotalplaceCar = carList[0].Total_Cars_to_Place__c;
        Decimal TotalpullCar = carList[0].Total_Cars_to_Pull__c;
        String eventName =carList[0].Event_Name__c;
        setTotalplaceCar(TotalplaceCar);
        setTotalpullCar(TotalpullCar);
        setEventName(eventName);
        If (placeCar != null)
        {
            Integer placeLength = placeCar.length() - 1;
        	String placeString = placeCar.substring(9,placeLength);
            placeCarDtl = (List<eqdtlPlace>) System.JSON.deserialize(placeString , List<eqdtlPlace>.class);
        	System.debug('Place Car deseralize : '+placeCarDtl);
        }
        If (plcUpdatedCar != null)
        {
            Integer plcUpdatedLength = plcUpdatedCar.length() - 1;
        	String plcUpdatedString = plcUpdatedCar.substring(9,plcUpdatedLength);
            plcUpdatedCarDtl = (List<eqdtlPlace>) System.JSON.deserialize(plcUpdatedString , List<eqdtlPlace>.class);
        	setUpdatedPlace(true);
            System.debug('Updated Place Car deseralize : '+plcUpdatedCarDtl);
        }        
        If (pullCar != null)
        {
            Integer pullLength = pullCar.length() - 1;
            String pullString = pullCar.substring(9,pullLength);
            pullCarDtl = (List<eqdtlPull>) System.JSON.deserialize(pullString , List<eqdtlPull>.class);
            System.debug('Place Car deseralize : '+pullCarDtl);
        }
    }

    public class eqdtlPlace{

        public String eqinit{get;set;}
		public String eqnr{get;set;}
		public String wbsernr{get;set;}
		public String emptyind{get;set;}
		public String cartype{get;set;}
		public String classcd{get;set;}
		public String commodity{get;set;}
		public String stcc{get;set;}
		public String wgt{get;set;}
		public String rlsereqtype{get;set;}
		//public String fromtk{get;set;}
		//public String fromspot{get;set;}
		public String totk{get;set;}
		public String tospot{get;set;}
		public String eqloparsn{get;set;}
             
    }
    
    public class eqdtlPull{

        public String eqinit{get;set;}
		public String eqnr{get;set;}
		public String wbsernr{get;set;}
		public String emptyind{get;set;}
		public String cartype{get;set;}
		public String classcd{get;set;}
		public String commodity{get;set;}
		public String stcc{get;set;}
		public String wgt{get;set;}
		public String rlsereqtype{get;set;}
		public String fromtk{get;set;}
		public String fromspot{get;set;}
		//public String totk{get;set;}
		//public String tospot{get;set;}
		public String eqloparsn{get;set;}             
    }
    
}