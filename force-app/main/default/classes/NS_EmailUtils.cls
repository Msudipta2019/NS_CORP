/**@author  Accenture
* @Created Date 2019-08-13
* @version  1.0
* @description This class handles all inbound email Utils .
*
*Modification History
*************************************************************************************************
MODIFIED DATE       MODIFIED BY         DESCRIPTION
*************************************************************************************************
 10/09/2019         Gidon Payenson		IM02659096 - Clean up response emails 	
 10/14/19 	    	Daniel Glaser		Added code for Domain Routing		
 10/25/2019         Sudipta Mukherjee	Added the logic to assigned 3PL CS cases to Unidenfied Queue
 11/25/19           Daniel Glaser       Fix for Conrail, so when there is no TO address check the CC address
 12/13/2019          Sudipta Mukherjee   IM02737077  Email id length check upto 80 charecters
-------------------------------------------------------------------------------------------------

*/
public with sharing class NS_EmailUtils {
	
     public class accountIdTierCom {
        	public string TierCommodity;
        	public string id;
        }
	
	private static final string unidentifiedTierCommodity = 'CS_Unidentified';  // @Daniel Glaser Domain Routing code
	
	private static string getToAddresses(Messaging.InboundEmail email) {
		String toAddresses='';
        if (email.toAddresses != null) {
            for(String emailId : email.toAddresses) {
                toAddresses += emailId+ NS_StaticVariablesUtility.NS_SemiColon;
            }
        }	
        return toAddresses;	
	}
	
	private static string getCCaddresses( Messaging.InboundEmail email) {
		String ccAddresses='';
        if(email.ccAddresses != null){
            for(String emailId : email.ccAddresses){
                ccAddresses += emailId+ NS_StaticVariablesUtility.NS_SemiColon;
            }
        }  		
        return ccAddresses;
	}	
	
	/**********************************************************************************************
	*
	* Get a list of contacts that have the From Email Address. 
	* This functionality is used in two other methods
	*  @Daniel Glaser Domain Routing code
	***********************************************************************************************/
	public static List<contact> getContactsbyEmail(String emailFromAddress) {
	  //New record type '3PL' added by Sudipta as requested in Mail on 10/30/2019
		List<String> AccountRecordTypes = new List<String> {'Business','Corporate','Service','Slim Golden','3PL'};
		// locate the contact associated with the Email From Address. The only contacts that will selected
		// have an account with the type of 'Business','Corporate','Service','Slim Golden'
		
        List<contact> eContact =
            [SELECT name,AccountId,Account.Name
                                  FROM Contact where Email =:emailFromAddress and Account.RecordType.Name IN:AccountRecordTypes];
		system.debug('NS_EmailUtils getContactsbyEmail ');
		return eContact;                                  
		
	}
	
	/**********************************************************************************************
	 * Domain Routing
	 * Locate the contact from the email from address. If one contact Call retrieveTierCommodity else
	 * LocateAccountByDomain. The result will the the TierCommodity
	 * @Daniel Glaser Domain Routing code
	 ***********************************************************************************************/
	public static accountIdTierCom getTeirCommodity(String emailFromAddress) {
		//gp holds unidentified e2c metadata API name
		List<String> AccountRecordTypes = new List<String> {'Business','Corporate','Service','Slim Golden'};
		String TierCommodity = unidentifiedTierCommodity;
		accountIdTierCom acctTier = new accountIdTierCom();
		// SE-V2  get account(s) based on sender's email
		// locate the contact associated with the Email From Address. The only contacts that will selected
		// have an account with the type of 'Business','Corporate','Service','Slim Golden'
        List<contact> eContact = getContactsbyEmail(emailFromAddress);
        system.debug('NS_EmailUtils getTeirCommodity eContact value is '+eContact.size());

         if (eContact.size() == 1) { //found 1 contact
         	acctTier = RetrieveTierCommodity(eContact[0].accountid);
         } else {
         	acctTier = LocateAccountByDomain(emailFromAddress);
         }			
         system.debug('NS_EmailUtils getTeirCommodity '+acctTier);
		 return acctTier;
	}
	
	/**********************************************************************************************
	 * Domain Routing
	 * Using the account id to locate the account record.
	 * The result will the the TierCommodity
	 *  @Daniel Glaser Domain Routing code
	 ***********************************************************************************************/	
	public static accountIdTierCom RetrieveTierCommodity(String accountid) {
		String TierCommodity = unidentifiedTierCommodity;
		accountIdTierCom acctTier = new accountIdTierCom(); 
		acctTier.TierCommodity = TierCommodity;
		acctTier.id = '';
         /*****The variable TierCommodity is compiled as follows "CS_" + Major Commodity Option API name + "_" + Customer Segmentation toption API Name
         *     E.g. "CS_AgFP_Tier2". Major Commodity = "Agricultue & Forest Products"; Custoer Segmentation = "Core"
         *     The compiled name has to match respective e2c metadata record Name
		 *****/ 			
		List<String> AccountRecordTypes = new List<String> {'Corporate','Slim Golden'};
 		system.debug('NS_EmailUtils RetrieveTierCommodity  account '+AccountId);
 		// locate the account associated with the email or domain.
 		//Sudipta 10/25: Added NS_X3PL__c fields
 		account acct = [select Name, Parent.Id,  RecordType.Name, NS_Major_Commodity__c, NS_Account_Tier__c,NS_X3PL__c,
 							  Parent.NS_Account_Tier__c,parent.RecordType.Name, Parent.NS_Major_Commodity__c,Parent.NS_X3PL__c
 						from account where id =: accountid limit 1];
 					
 		if (acct != null) {		
 			acctTier.id = acct.id;		
			// Make sure Account has a record type of “Corporate” or “Slim Golden” or No Parent account
			// which breaks down to:
			// if business or service and NO parent
			// if Corporate or Slim Golden
			// if business or service and HAS parent perform ELSE
			if (acct.RecordType.Name == 'Corporate' || acct.RecordType.Name == 'Slim Golden' || acct.parentId ==null) {
	           	if 	(acct.NS_Major_Commodity__c == Null || acct.NS_Major_Commodity__c == '' ||
	                    acct.NS_Account_Tier__c == NULL || acct.NS_Account_Tier__c =='') //SE_V2 - No Commodity or Tier
	           	{
	               TierCommodity = unidentifiedTierCommodity; // gp No commodity identified
	           	}      
                //Sudipta 10/25: Logic added to bypass 3PL CS cases to Unidentify Queue 
                else if(acct.NS_X3PL__c==true)
                {
                    TierCommodity = unidentifiedTierCommodity;
                }                
                else  { 
                    
	            	TierCommodity= 'CS_'+acct.NS_Major_Commodity__c + '_' +
	                    					acct.NS_Account_Tier__c;  // SE_V2 Major Commodity Option API +
                    
	            }
			} else {
				// if has parent set tiercommodity to Parents conditions
	            if (acct.Parent.NS_Major_Commodity__c == NULL || acct.Parent.NS_Major_Commodity__c== '' ||
	                         acct.Parent.NS_Account_Tier__c == NULL || acct.Parent.NS_Account_Tier__c =='') //SE_V2 - Parent - No Commodity or Tier
	            {
	                TierCommodity = unidentifiedTierCommodity; //SE_V2 - No commodity or Tier
	            }
                //Sudipta 10/25: Logic added to bypass 3PL CS cases to Unidentify Queue 
                else if(acct.Parent.NS_X3PL__c==true)
                {
                    TierCommodity = unidentifiedTierCommodity;
                }            
                
                else { 
                   TierCommodity= 'CS_'+acct.Parent.NS_Major_Commodity__c + '_' +
	                        									acct.Parent.NS_Account_Tier__c;
                  
	                
	            }
	          //  acctTier.id = acct.Parent.id;
			}
	
	        //system.debug('TierCommodity 2 = '+ TierCommodity);
	        if (TierCommodity.length() > 40) { //Developer Name can only be 40 chracters
	          	TierCommodity=TierCommodity.substring(0,40);
	        }		
			acctTier.TierCommodity = TierCommodity;
	        system.debug('TierCommodity 2 = '+ TierCommodity);	        		
	        
 		}
 		system.debug('NS_EmailUtils RetrieveTierCommodity exit '+acctTier);
		return acctTier;
	}	
	
	/***********************************************************************************************
	 * Domain Routing
	 * If the email from from address does not exist in Contact or multiple contacts are found.
	 * In this case, the code will look for a Domain match in Account domain object that is
	 * extracted from the Email From address.
	 * If account domain is found then route to the Major/Segmentation queue of the account, if none found then
	 * route to ‘CS – Unidentified’.
	 *  @Daniel Glaser Domain Routing code
	 ***********************************************************************************************/
	public static accountIdTierCom LocateAccountByDomain(String emailFromAddress ) {
		String TierCommodity = unidentifiedTierCommodity;
		accountIdTierCom acctTier = new accountIdTierCom(); 
		acctTier.TierCommodity = TierCommodity;
		acctTier.id = '';
		
		string searchdomain = '';
		integer DomainEtart = 0;
		integer DomainEnd = 0;
		string domainname = '';
		string emailaddress = emailFromAddress;
		string srchchar = '@';                                // used to locate the start of the domain address
		integer startloc = emailaddress.indexOf(srchchar)+1;  // location of the beginning of the domain address       
        
		// if domain location exist proceed.
		if (startloc > 1) {
			system.debug('NS_EmailUtils LocateAccountByDomain Search char at '+startloc);
			// get the Domain name from the email from address. which is the length of the email address
			// minus the location of the srch char. 1235@demo.com the result will be demo.com
			domainname = emailaddress.right(emailaddress.length()-startloc);
			system.debug('NS_EmailUtils LocateAccountByDomain LocateAccountByDomain Domain name '+domainname);		
			// query the account domain object to locate the domainname
			list<Account_Domain__c> domaininfo = [select id, Account__c,
	                                Account__r.Name,Account__r.Parent.Id, Account__r.RecordType.Name,
	                                Account__r.NS_Major_Commodity__c,Account__r.NS_Account_Tier__c,
	                                Account__r.Parent.NS_Account_Tier__c,Account__r.Parent.NS_Major_Commodity__c
	                                from Account_Domain__c where Domain__c = :domainname];
			if (!domaininfo.isEmpty()) {
				acctTier = RetrieveTierCommodity(domaininfo[0].Account__c);
			}		 			
		}	
		system.debug('NS_EmailUtils LocateAccountByDomain TierCommodity '+acctTier);
		return acctTier;
	}
	
	
    /*
     * @Created Date - 10/09/2019 - IM02659096
     * @Description - Compare if email to address contains customer service emails that need to be handled by the EmailSingleAddress handler
    */ 
    public static boolean skipEamilToCaseHandler (Messaging.InboundEmail email){
        boolean bSkipThisHandler = false;
        system.debug('NS_EmailUtils skipEamilToCaseHandler entered');
        List<string> lstSingleEmailAddr = NS_StaticVariablesUtility.SINGLE_EMAIL_HANDLER_ADDR.split(';');
        // Fix for Conrail, so when there is no TO address check the CC address 
        list<String> ToAddresses = Email.toAddresses;
        if (email.ccAddresses != null && email.toAddresses == null) {	
        	ToAddresses = Email.ccAddresses;
        }
        if (ToAddresses != null) {
	        for (string toAddr:ToAddresses) {
	            for (string custService:lstSingleEmailAddr){
	               If (toAddr.containsIgnoreCase(custService)){
	                   bSkipThisHandler = true;
	                   break;
	               }
	            }
	    	}
        }
        //system.debug('NS_EmailUtils skipEamilToCaseHandler exited');
    	return bSkipThisHandler;
    }
    
    /*
	* IM02659096
	* @description This function compiles the response TO addresses and fills case email fields
   */ 
    public static case FillCaseForwardLastEmails(case newcase,  Messaging.InboundEmail email) {
        String forwardingEmails='';
        String emailFromAddress = email.fromAddress;
        List<String> allEmails = new List<String>();
        //Added By Sudipta to store the emails those are only having length upto 80 charecter 
        Integer maxemailidlength=81;
        
        List<String> emailFieldApiNames = new List<String>();
        String lastEmailToCc = '';         
        Set<string> setToAddr = new Set<string>();
        Map<string,string> mapForwardingEmails = New Map<string,string>();
        //Get forwarding emails from email2queue metadata
        List<NS_EmailToQueue__mdt> lstForwAddr= [SELECT Queue_Id__c, Forwarding_Address__c
                                                FROM NS_EmailToQueue__mdt LIMIT 50000];
		
        //Create map of forwarding emails
        For (NS_EmailToQueue__mdt etq: lstForwAddr)  {
            if (etq.Forwarding_Address__c != null) { //cannot split if null
                for (string strAddr:etq.Forwarding_Address__c.split(';')){
                    if (!mapForwardingEmails.containsKey(strAddr)) {
                        mapForwardingEmails.put(strAddr, strAddr);
                    }
                }
            }
        }      
        
        //create a set of To and CC emails. Use set to eliminate duplicates
        // system.debug('email.toAddresses = ' + email.toAddresses);
        If (email.toAddresses != NULL){ //to address should be always there, but still checking
            for(String strAddr : email.toAddresses) {
               //IM02737077: Email id length upto 80 charecters by sudipta
                If (!mapForwardingEmails.containsKey(strAddr) && strAddr.length()<maxemailidlength){
                    setToAddr.add(strAddr);
                }
            }
        }
        // system.debug ('email.ccAddresses = ' + email.ccAddresses);
        //cc email
        If (email.ccAddresses  != NULL){ //check for cc address
            for(String strAddr : email.ccAddresses) {
             //IM02737077: Email id length upto 80 charecters by sudipta    
                If (!mapForwardingEmails.containsKey(strAddr) && strAddr.length()<maxemailidlength){
                    setToAddr.add(strAddr);
                }
            }
        }   
		//transfer set into list for processing
        
        // System.debug('setToAddr = ' + setToAddr);
		// check for setToAddr contains records  @Daniel Glaser
        if (!setToAddr.isEmpty()) {
            allEmails.addAll(setToAddr);
        }   
        // system.Debug('allEmails = ' + allEmails);
        
        if (!allEmails.isEmpty()) {
	        //create space and semicolon separated email strings
	        for(String lstEmail : allEmails) {
	           forwardingEmails += lstEmail+' ';
	           lastEmailToCc += lstEmail+ NS_StaticVariablesUtility.NS_SemiColon; 
	        }
			//ensure list is <256
	        forwardingEmails = forwardingEmails.trim();
	        if(forwardingEmails.length() > 255){
	            forwardingEmails = forwardingEmails.substring(0, 250);
	        }
        }
        
		// Check for email from for contact id
		List<contact> eContact = getContactsbyEmail(emailFromAddress);
		// HAVE TO GET THE Contact ID - from eContact[0]
		if(!eContact.isEmpty() && eContact.size() == 1){
			newcase.ContactId = eContact[0].Id;
		}		
				
        //set case email specific fields
        newcase.NS_Email_1__c = email.fromAddress;
        newcase.Forwarding_Emails__c = forwardingEmails; 
        newcase.NS_LastEmailAddresses__c = lastEmailToCc;
       
       	//add all 25 email field api name starting from 2.
		for(Integer apiNameIndex = 2; apiNameIndex <= 25 ; apiNameIndex ++){
			emailFieldApiNames.add('NS_Email_'+apiNameIndex+'__c');
		}

		//update case email fields Email1, etc
		for(Integer i=0; i<allEmails.size(); i++){
			if(i == emailFieldApiNames.size()){
				break;
			}
			newcase.put(emailFieldApiNames.get(i),allEmails[i]);
			system.debug('NS_EmailUtils newcase.put(emailFieldApiNames.get(i) = ' + allEmails[i] );
		}
        return newcase;        
    }
    
	public static EmailMessage FillEmailToCC(EmailMessage newemail,  Messaging.InboundEmail email) {
        newemail.ToAddress=getToAddresses(email);
        newemail.CcAddress=getCCaddresses(email);
        return newemail;
		
	}    
    
    public static blob convertToPdf(string strhtmlbody, string emailtext) {
			String tmp = strhtmlbody;
			String htmltext = '';
			blob pdfcontents = null;
			Pattern p = Pattern.compile('(<table[^>]*) width="[^"]*"');
			Matcher m = p.matcher(tmp);

			integer f = 0;	
			integer striplen = 0; 
            do {
            	striplen += (NS_StaticVariablesUtility.NS_EmailBodyLimit*2);
            	if (striplen >= strhtmlbody.length() ) {
            		striplen = strhtmlbody.length();
            	}

            	tmp = strhtmlbody.substring(f, striplen);
            	// system.debug('replace html data to '+striplen+ ' from F= '+f);
           		m = p.matcher(tmp);
				while (m.find()) {
					// system.debug('find # '+f);
			 		tmp = tmp.replaceFirst(m.group(), m.group().replaceAll(' width="[^"]*"',''));
				}
			   htmltext+=tmp;
                            	
            	f+= (NS_StaticVariablesUtility.NS_EmailBodyLimit*2);
                            	
             } while (f < strhtmlbody.length());
			try {
				system.debug('NS_EmailUtils converttoPdf call toPDF '+htmltext.length());
				pdfcontents = blob.toPDF(htmltext);
			} catch (exception ex) {
				NS_StaticVariablesUtility.createExceptionRecord(ex, 'NS_EmailtoCaseHandler', 'convertToPdf' );
				system.debug('NS_EmailUtils converttoPdf blob.toPDF Failed use emailtext toPDF');
				pdfcontents = blob.toPDF(emailtext);
			}
		
			return(pdfcontents);  	 	
    }
    
}