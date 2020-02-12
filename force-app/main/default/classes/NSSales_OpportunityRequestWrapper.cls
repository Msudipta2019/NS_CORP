public class NSSales_OpportunityRequestWrapper {
    
    public String soucreSys;
	public String soucreSysId;
	public String sourceSysNum;
	public String custName;
	public String custNum;
	public String custGoodspell;
	public String custMdmId;
	public String customerType;
	public String customerContactName;
	public String customerContactEmail;
	public String customerContactPhone;
	public String requestDate;
	public String closeDate;
	public String requestedShipDate;
	public String estimatedShipDate;
	public String customerComments;
	public String internalComments;
	public String requestStatus;
	public String createdByRacf;
	public String connectnsStatus;
	public List<Lanes> lanes;

	public class Lanes {
		public String laneId;
		public String shipper;
		public String shipperNumber;
		public String imcName;
		public String imcNum;
		public String imcGoodspell;
		public String receiver;
		public String reveiverNumber;
		public String originRoad;
		public String originCity;
		public String originState;
		public String originHandlingLine;
        public String onRamp;
		public String destinRoad;
		public String destinCity;
		public String destinState;
		public String offRamp;
		public String stcc;
		public String route;
		public String estVolume;
		public String estVolumeUnits;
		public String estVolumePeriod;
		public String estRate;
		public String emptyRate;
		public String competitionType;
		public String carOwnership;
		public String carType;
		public String minWeight;
		public String minWeightUnits;
		public String minCars;
		public String minCarsPeriod;
		public String lading;
		public String basis;
		public String activeRate;
		public String privateRate;
		public String reccRate;
		public String offerRate;
		public String finalRate;
		public String rateSource;
		public String laneStatus;
        public String committedVol;
	}


}