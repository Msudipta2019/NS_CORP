public with sharing class NS_ENSOverloadEmailTemplate {
    
    public List<overloadCar> overloadCarDtl { get; set; }
    public String EventSubType;
    public String CustomerName;
    
    public Id notifyId;
	public Id getnotifyId(){
          return notifyId;           
    }
    public void setnotifyId(Id notify){
		notifyId = notify;
		NS_Parse();
	}
    public String getEventSubType(){
  		return EventSubType;
 	}
 	public void setEventSubType(String evtSubType){
  		this.EventSubType = evtSubType;
 	}
     public String getCustomerName(){
  		return CustomerName;
 	}
 	public void setCustomerName(String CustomerName){
  		this.CustomerName = CustomerName;
 	}
    
    public  NS_ENSOverloadEmailTemplate()
    {   
    }
    
    Public void NS_Parse(){
        
        List<Notification_Log__c> carList = [SELECT Customer_Alert_Name__c,Overload_Cars_Detail__c,Event_SubType__c,Event_Name__c,Event_Date_Time__c FROM Notification_Log__c WHERE Id =: notifyId];
        
        String overloadCar = carList[0].Overload_Cars_Detail__c;
        String evtSubType = carList[0].Event_SubType__c;
        String CustomerName = carList[0].Customer_Alert_Name__c;
        
        setEventSubType(evtSubType);
        setCustomerName(CustomerName);
        
        if(overloadCar !=null){
            Integer placeLength = overloadCar.length() - 1;
        	String placeString = overloadCar.substring(9,placeLength);
          overloadCarDtl = (List<overloadCar>) System.JSON.deserialize(placeString, List<overloadCar>.class);  
        }        
    }
    
    public class overloadCar{
        public String eqids{get;set;}
		public String origloc{get;set;}
		public String shipper{get;set;}
		public String lastevent{get;set;}
        public String lasteventtime{get;set;}
        public String lasteventloc{get;set;}             
		public String scalewtgrs;
		public String umltotalwt;
        
        public String getScalewtgrs(){
            if (''.equalsIgnoreCase(scalewtgrs.trim()) || '-'.equalsIgnoreCase(scalewtgrs.trim()) ){
                return '-';
            } else{
            	return Decimal.valueOf(scalewtgrs).toPlainString();
            }            
        }
        public void setScalewtgrs(String ipScalewtgrs){
            this.scalewtgrs = ipScalewtgrs;            
        }
        public String getUmltotalwt(){
            if (''.equalsIgnoreCase(umltotalwt.trim()) || '-'.equalsIgnoreCase(umltotalwt.trim()) ){
                return '-';
            } else{
            	return Decimal.valueOf(umltotalwt).toPlainString();
            }
        }
        public void setUmltotalwt(String ipUmltotalwt){
            this.umltotalwt = ipUmltotalwt;
        }        
    }

}