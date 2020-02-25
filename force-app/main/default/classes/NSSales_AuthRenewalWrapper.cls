public class NSSales_AuthRenewalWrapper {

		public class RenewalId {
		public String bureau;
		public Integer authNum;
		public Integer sectNum;
		public String expDate;
	}

	public Integer resultCode;
	public String resultDescription;
	public List<Result> result;

	public class Result {
		public RenewalId renewalId;
		public String majorGrp;
		public String bureau;
		public Integer authNum;
		public Integer sections;
		public String expDate;
		public String custGrpName;
		public String mktMgrDesk;
		public String officerName;
		public String minEffDate;
		public Integer laneCount;
		public Boolean nSRated;
		public String status;
		public String carloads;
		public String nsRevenue;
		public String contribution;
		public String rcr;
	}

	
	public static NSSales_AuthRenewalWrapper parse(String json) {
		return (NSSales_AuthRenewalWrapper) System.JSON.deserialize(json, NSSales_AuthRenewalWrapper.class);
	}
}