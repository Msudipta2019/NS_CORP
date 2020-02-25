public class ENS_OverloadedWrapper {

    public List<Payload> Payload;

    // 1.22, jlong, updated for tep new schema  
	public class Payload {
		public String LocationAccountNumber;
		public String OverloadStatus;
		public String EquipmentNumber;
		public String LastEventDescription;
		public String OriginLocCity;
		public String OriginLocState;
		public String Name;           
		public String LastEvtCity;
		public String LastEvtState;
		public String LastEventTime;
		public String STCC;
		public String ScaleWeightGross;
		public String UmlerTotalWeight;
	}

}