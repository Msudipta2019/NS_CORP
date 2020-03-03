public class NSSales_WonLaneInfoWrapper {
    public String resultCode;
    public String resultDescription;
    public List<Result> result;
    
    public class Result {
        public String laneId;
        public String offerId;
        public String requestId;
        public String shipper;
        public String receiver;
        public String originRoad;
        public String originStation;
        public String originCity;
        public String originState;
        public String originHandlingLine;
        public String destinRoad;
        public String destinStation;
        public String destinCity;
        public String destinState;
        public String destinHandlingLine;
        public String stcc;
        public String stccMajorGroup;
        public String stccMinorGroup;
        public String route;
        public String estVolume;
        public String estVolumeUnits;
        public String estVolumePeriod;
        public String estRate;
        public String competitionType;
        public String carOwnership;
        public String carType;
        public String minWeight;
        public String minWeightUnits;
        public String minCars;
        public String minCarsPeriod;
        public String lading;
        public String basis;
        public String rate;
        public String privateRate;
        public String rateSource;
        //public Integer initialOffer;
        //public Integer finalOffer;
        //public String laneStatus;
        //public Integer carloadsMoved;
        public String initialOffer;
        public String finalOffer;
        public String laneStatus;
        public String carloadsMoved;
    }
}