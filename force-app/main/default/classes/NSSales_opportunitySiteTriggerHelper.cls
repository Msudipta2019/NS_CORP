/*******************************************************
Description  : Helper class for Opportunity SIte Trigger
Developer    : Accenture Solutions
Date         : 05-07-2019
*********************************************************/
public class NSSales_opportunitySiteTriggerHelper {
    
    public static void updateOpportunity(List<Opportunity_Site__c> opSiteList){
        
        List<Opportunity_Site__c> siteToUpdateWon= new List<Opportunity_Site__c>();
        List<Opportunity_Site__c> siteToUpdateLost= new List<Opportunity_Site__c>();
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        List<Opportunity> oppSiteNameUpdate = new List<Opportunity>();
        List<Opportunity> oppSiteNameUpdateLost = new List<Opportunity>();
        List<Id> oppIdList = new List<Id>();
        
        for(Opportunity_Site__c opsite : opSiteList){
            
            if(opsite.NSSales_Stage__c =='Won')
            {
                siteToUpdateWon.add(opsite);
                oppIdList.add(opsite.Opportunity__c);
            }
            else if(opsite.NSSales_Stage__c =='Lost')
            {
                siteToUpdateLost.add(opsite);
                oppIdList.add(opsite.Opportunity__c);
            }
            else{
                system.debug('no action');
            }
        }
        oppToUpdate = [SELECT Id,NSSales_Site_Won__c,NSSales_Site_Lost__c FROM Opportunity WHERE ID in :oppIdList]; 
        for(Opportunity_Site__c site : siteToUpdateWon){
            for(Opportunity opp : oppToUpdate){
                if(site.Opportunity__c == opp.Id){
                        if(string.isEmpty(opp.NSSales_Site_Won__c)){
                            opp.NSSales_Site_Won__c =  site.NSSales_Site_Name__c;
                        }
                        else{
                            opp.NSSales_Site_Won__c = opp.NSSales_Site_Won__c +';'+ site.NSSales_Site_Name__c;
                        }
                        oppSiteNameUpdate.add(opp);
                    }         
                }
            }
            update oppSiteNameUpdate;
        for(Opportunity_Site__c site : siteToUpdateLost){
            for(Opportunity opp : oppToUpdate){
                if(site.Opportunity__c == opp.Id){
                        if(string.isEmpty(opp.NSSales_Site_Lost__c)){
                            opp.NSSales_Site_Lost__c =  site.NSSales_Site_Name__c;
                        }
                        else{
                            opp.NSSales_Site_Lost__c = opp.NSSales_Site_Lost__c +';'+ site.NSSales_Site_Name__c;
                        }
                        oppSiteNameUpdateLost.add(opp);
                    }         
                }
            }
       update oppSiteNameUpdateLost;
     }
    }