public class ENS_ETAWrapper {
    
    public EquipmentList EquipmentList;

	public class Equipment {
		public String EquipmentNumber;
		public Locations Locations;
		public String LastEventTime;
		public String LastEventDescription;
		public String LastEvtCity;
		public String LastEvtState;
		public String DelayDescription;
		public String PriorETA;
		public String NewETA;
        public String LoadEmptyStatus;
        public String Commodity;
	}

	public class Locations {
		public List<Location> Location;
	}

	public class Location_Z {
		public Object AccountNumber;
	}

	public class Locations_Z {
		public List<Location_Z> Location;
	}

	public class EquipmentList {
		public List<Equipment> Equipment;
	}

	public class Location {
		public String AccountNumber;
        public String AcctLocCity;
        public String AcctLocState;
	}

}