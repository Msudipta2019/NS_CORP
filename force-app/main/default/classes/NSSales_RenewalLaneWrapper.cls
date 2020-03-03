public class NSSales_RenewalLaneWrapper {
    public class RenewalId {
        public String quoteId;
		public Integer id;
    }
    public List<Result> result;
    public class Result {
        public RenewalId Id;
        public String commodityCode;
        public String originRoad;
        public String originCity;
        public String originState;
        public String destRoad;
        public String destCity;
        public String destState;
        public String equipment;
        public String loadedRate;
        public String emptyRate;
        public String volume;
        
    }
    public static NSSales_RenewalLaneWrapper parse(String json) {
		return (NSSales_RenewalLaneWrapper) System.JSON.deserialize(json, NSSales_RenewalLaneWrapper.class);
	}
}