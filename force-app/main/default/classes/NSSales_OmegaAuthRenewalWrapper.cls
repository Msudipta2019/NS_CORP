public class NSSales_OmegaAuthRenewalWrapper {
    public List<Result> result;
    public class Result {
        public String id;
        public String quoteNumber;
        public String section;
        public String series;
        public String file;        
        public String pricingOfficerId;
        public String effectiveDate;
        public String expirationDate;
        public String beneficialOwnerNumber;
        public String beneficialOwner;
        public String contractHolderNumber;    
        public String contractHolder;    
        public String numLanes;
        public String loadedVolume;
        public String emptyVolume;
        public String loadedRevenue; 
        public String emptyRevenue;
        public String loadedContribution;
        public String emptyContribution;
    }

	public static NSSales_OmegaAuthRenewalWrapper parse(String json) {
		return (NSSales_OmegaAuthRenewalWrapper) System.JSON.deserialize(json, NSSales_OmegaAuthRenewalWrapper.class);
	}
}