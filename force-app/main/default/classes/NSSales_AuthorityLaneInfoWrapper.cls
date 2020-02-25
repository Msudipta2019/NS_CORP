public class NSSales_AuthorityLaneInfoWrapper {
	public String resultCode;
    public String resultDescription;
    public List<Result> result;
    
    public class Result {
        public String laneID;
        public String stcc;
        public String stccGrp;
        public String originRoad;
        public String originCity;
        public String originState;
        public String originHandlingLine;
        public String originGrpNumber;
        public String originGrpCity;
        public String originGrpState;
        public String destinRoad;
        public String destinCity;
        public String destinState;
        public String destinHandlingLine;
        public String destinGrpNumber;
        public String destinGrpCity;
        public String destinGrpState;
        public String route;
        public String carOwnership;
		public String basis;
        public String newRate;
        public String newNSFactor;
        public String expiringRate;
        public String expiringNSFactor;
        public String thCarloads;
        public String thNsRevenue;
        public String thTotalRevenue;
        public String thTons;
        public String epCarloads;
        public String epTotalRevenue;
        public String epTons;
        public String epTotalCost;
        public String epEquipmentCost;
        public String epDaysOnline;
        public String epLoadedMiles;
        public String alkFuelMiles; 
    }
}