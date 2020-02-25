public class NSSales_ResponseRateRequestWrapper {
    
   public String resultCode;
	public String resultDescription;
	public List<Result> result;

	public class Result {
		public String requestId;
        public String requestNumber;
		public String requestName;
		public String customerName;
		public String customerNumber;
		public String customerType;
		public String customerContactName;
		public String customerContactEmail;
		public String customerContactPhone;
		public String requestedShipDate;
		public String estimatedShipDate;
		public String customerComments;
		public String internalComments;
		public String requestSource;
		public String requestStatus;
		public String declinedReason;
		public String originalAssignedToRacf;
		public String originalAssignedToMajorGroup;
		public String assignedToRacf;
		public String assignedToMajorGroup;
		public String createdByRacf;
		public String createdDate;
		public String interlineDate;
		public String pricedDate;
		public String archivedDate;
		public String lastModified;
		public Boolean deleted;
	}
    
    

}