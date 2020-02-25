public class NS_LocalServicePayloadWrapper{

    public class Eqdtl {
        public String action;
        public String eqinit;
        public String eqnr;
        public String wbsernr;
        public String emptyind;
        public String cartype;
        public String classcd;
        public String commodity;
        public String stcc;
        public String wgt;
        public String rlsereqtype;
        public String fromtk;
        public String fromspot;
        public String totk;
        public String tospot;
        public String eqloparsn;
        public String equpdatedind;
    }

    public String TotalPlaceCar;
    public String TotalPullCar;
    public String EstimatedWindowStartHour;
    public String EstimatedWindowEndHour;
    public String LocationAccountNumber;
    public Eqdtls eqdtls;

    public class Eqdtls {
        public List<Eqdtl> eqdtl;
    }
}