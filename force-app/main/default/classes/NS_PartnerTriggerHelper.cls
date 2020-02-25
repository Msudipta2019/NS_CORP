public class NS_PartnerTriggerHelper {
    
    
    public static void insertRelatedRecord(List<NS_Partner__c> ListPartner){
        Set<id> OppId = new Set<id>();
        List<Opportunity> listToUpdate = new  List<Opportunity>();
        map<id,Opportunity> mapUpdate = new map<id,Opportunity>();
        for(NS_Partner__c recPartner :ListPartner){
            OppId.add(recPartner.NS_Related_Opportunity__c);
        }
        
        map<id, Opportunity> mapOpp = new map<id, Opportunity>([Select id,
                                                                NS_Partner_Account_1__c,
                                                                NS_Partner_Account_Type_1__c,
                                                                NS_Partner_Account_2__c,
                                                                NS_Partner_Account_Type_2__c,
                                                                NS_Partner_Account_3__c,
                                                                NS_Partner_Account_Type_3__c,
                                                                NS_Partner_Account_4__c,
                                                                NS_Partner_Account_Type_4__c
                                                                from Opportunity where id in :OppId]);
        for(NS_Partner__c recFinalPartner :ListPartner){
            Opportunity parentOpportunity = mapOpp.get(recFinalPartner.NS_Related_Opportunity__c);
            
            if(parentOpportunity.NS_Partner_Account_1__c==null){
                parentOpportunity.NS_Partner_Account_1__c=recFinalPartner.NS_Partner_Account__c;
                parentOpportunity.NS_Partner_Account_Type_1__c=recFinalPartner.NS_Partner_Account_Type__c;
                listToUpdate.add(parentOpportunity);
            }Else if(parentOpportunity.NS_Partner_Account_2__c==null){
                parentOpportunity.NS_Partner_Account_2__c=recFinalPartner.NS_Partner_Account__c;
                parentOpportunity.NS_Partner_Account_Type_2__c=recFinalPartner.NS_Partner_Account_Type__c;
                listToUpdate.add(parentOpportunity);
            }else if (parentOpportunity.NS_Partner_Account_3__c==null){
                parentOpportunity.NS_Partner_Account_3__c=recFinalPartner.NS_Partner_Account__c;
                parentOpportunity.NS_Partner_Account_Type_3__c=recFinalPartner.NS_Partner_Account_Type__c;
                listToUpdate.add(parentOpportunity);
            }else if (parentOpportunity.NS_Partner_Account_4__c==null){
                parentOpportunity.NS_Partner_Account_4__c=recFinalPartner.NS_Partner_Account__c;
                parentOpportunity.NS_Partner_Account_Type_4__c=recFinalPartner.NS_Partner_Account_Type__c;
                listToUpdate.add(parentOpportunity);
            }
            
        }
        
        if(listToUpdate.size()>0){
            mapUpdate.putAll(listToUpdate);
        }
        update mapUpdate.values();
        
    }
    
    public static void updateRelatedRecord(List<NS_Partner__c> ListPartner){
        Set<id> OppId = new Set<id>();
        map<id,Opportunity> mapUpdate = new map<id,Opportunity>();
        List<Opportunity> listToUpdate = new  List<Opportunity>();
        for(NS_Partner__c recPartner :ListPartner){
            OppId.add(recPartner.NS_Related_Opportunity__c);
        }
        map<id, Opportunity> mapOpp = new map<id, Opportunity>([Select id,
                                                                NS_Partner_Account_1__c,
                                                                NS_Partner_Account_Type_1__c,
                                                                NS_Partner_Account_2__c,
                                                                NS_Partner_Account_Type_2__c,
                                                                NS_Partner_Account_3__c,
                                                                NS_Partner_Account_Type_3__c,
                                                                NS_Partner_Account_4__c,
                                                                NS_Partner_Account_Type_4__c
                                                                from Opportunity where id in :OppId]);
        for(NS_Partner__c recFinalPartner :ListPartner){
            Opportunity parentOpportunity = mapOpp.get(recFinalPartner.NS_Related_Opportunity__c);
            NS_Partner__c oldPartnerRecord = (NS_Partner__c)trigger.oldmap.get(recFinalPartner.ID);
            
            if(parentOpportunity.NS_Partner_Account_1__c==oldPartnerRecord.NS_Partner_Account__c && parentOpportunity.NS_Partner_Account_Type_1__c==oldPartnerRecord.NS_Partner_Account_Type__c){
                parentOpportunity.NS_Partner_Account_1__c=recFinalPartner.NS_Partner_Account__c;
                parentOpportunity.NS_Partner_Account_Type_1__c=recFinalPartner.NS_Partner_Account_Type__c;
                listToUpdate.add(parentOpportunity);
            }Else if(parentOpportunity.NS_Partner_Account_2__c==oldPartnerRecord.NS_Partner_Account__c&& parentOpportunity.NS_Partner_Account_Type_2__c==oldPartnerRecord.NS_Partner_Account_Type__c){
                parentOpportunity.NS_Partner_Account_2__c=recFinalPartner.NS_Partner_Account__c;
                parentOpportunity.NS_Partner_Account_Type_2__c=recFinalPartner.NS_Partner_Account_Type__c;
                listToUpdate.add(parentOpportunity);
            }else if (parentOpportunity.NS_Partner_Account_3__c==oldPartnerRecord.NS_Partner_Account__c&& parentOpportunity.NS_Partner_Account_Type_3__c==oldPartnerRecord.NS_Partner_Account_Type__c){
                parentOpportunity.NS_Partner_Account_3__c=recFinalPartner.NS_Partner_Account__c;
                parentOpportunity.NS_Partner_Account_Type_3__c=recFinalPartner.NS_Partner_Account_Type__c;
                listToUpdate.add(parentOpportunity);
            }else if (parentOpportunity.NS_Partner_Account_4__c==oldPartnerRecord.NS_Partner_Account__c&& parentOpportunity.NS_Partner_Account_Type_4__c==oldPartnerRecord.NS_Partner_Account_Type__c){
                parentOpportunity.NS_Partner_Account_4__c=recFinalPartner.NS_Partner_Account__c;
                parentOpportunity.NS_Partner_Account_Type_4__c=recFinalPartner.NS_Partner_Account_Type__c;
                listToUpdate.add(parentOpportunity);
            }
            
        }
        if(listToUpdate.size()>0){
            mapUpdate.putAll(listToUpdate);
        }
        update mapUpdate.values();
        
        
    }
    
    public static void deleteRelatedRecord(List<NS_Partner__c> ListPartner){
        Set<id> OppId = new Set<id>();
        map<id,Opportunity> mapUpdate = new map<id,Opportunity>();
        List<Opportunity> listToUpdate = new  List<Opportunity>();
        for(NS_Partner__c recPartner :ListPartner){
            OppId.add(recPartner.NS_Related_Opportunity__c);
        }
        map<id, Opportunity> mapOpp = new map<id, Opportunity>([Select id,
                                                                NS_Partner_Account_1__c,
                                                                NS_Partner_Account_Type_1__c,
                                                                NS_Partner_Account_2__c,
                                                                NS_Partner_Account_Type_2__c,
                                                                NS_Partner_Account_3__c,
                                                                NS_Partner_Account_Type_3__c,
                                                                NS_Partner_Account_4__c,
                                                                NS_Partner_Account_Type_4__c
                                                                from Opportunity where id in :OppId]);
        
        
        List<NS_Partner__c> ListrRelatedPartner =  [Select id,NS_Related_Opportunity__c,NS_Partner_Account__c,NS_Partner_Account_Type__c from NS_Partner__c where NS_Related_Opportunity__c=:OppId];
       
        List<NS_Partner__c> notUsedPartner = new List<NS_Partner__c>();
        
        
        for(NS_Partner__c relPartRec :ListrRelatedPartner){
            Opportunity parentOpp = mapOpp.get(relPartRec.NS_Related_Opportunity__c);
            
            list<String> oppAccountDetail = new List<String>();
            
            if(parentOpp.NS_Partner_Account_1__c!= null && parentOpp.NS_Partner_Account_Type_1__c!= null){
                oppAccountDetail.add
                    ( parentOpp.NS_Partner_Account_1__c+
                     parentOpp.NS_Partner_Account_Type_1__c);
            }
            if(parentOpp.NS_Partner_Account_2__c!= null && parentOpp.NS_Partner_Account_Type_2__c!= null){
                oppAccountDetail.add
                    ( parentOpp.NS_Partner_Account_2__c+
                     parentOpp.NS_Partner_Account_Type_2__c);
            }
            if(parentOpp.NS_Partner_Account_3__c!= null && parentOpp.NS_Partner_Account_Type_3__c!= null){
                oppAccountDetail.add
                    ( parentOpp.NS_Partner_Account_3__c+
                     parentOpp.NS_Partner_Account_Type_3__c);
            }
            if(parentOpp.NS_Partner_Account_4__c!= null && parentOpp.NS_Partner_Account_Type_4__c!= null){
                oppAccountDetail.add
                    ( parentOpp.NS_Partner_Account_4__c+
                     parentOpp.NS_Partner_Account_Type_4__c);
            }
   

            if(!oppAccountDetail.contains(relPartRec.NS_Partner_Account__c+relPartRec.NS_Partner_Account_Type__c)){
                notUsedPartner.add(relPartRec);
            }
        }   
        
        
        for(NS_Partner__c recFinalPartner :ListPartner){
            Opportunity parentOpportunity = mapOpp.get(recFinalPartner.NS_Related_Opportunity__c);
            
            
            
            if(parentOpportunity.NS_Partner_Account_1__c==recFinalPartner.NS_Partner_Account__c && parentOpportunity.NS_Partner_Account_Type_1__c==recFinalPartner.NS_Partner_Account_Type__c){
                if(notUsedPartner.size()>0){
                    NS_Partner__c unusedPartner = notUsedPartner[0];
                    parentOpportunity.NS_Partner_Account_1__c=unusedPartner.NS_Partner_Account__c;
                    parentOpportunity.NS_Partner_Account_Type_1__c=unusedPartner.NS_Partner_Account_Type__c;
                    notUsedPartner.remove(0);
                }else{
                    parentOpportunity.NS_Partner_Account_1__c=null;
                    parentOpportunity.NS_Partner_Account_Type_1__c=null;
                }
                
                
                listToUpdate.add(parentOpportunity);
            }Else if(parentOpportunity.NS_Partner_Account_2__c==recFinalPartner.NS_Partner_Account__c&& parentOpportunity.NS_Partner_Account_Type_2__c==recFinalPartner.NS_Partner_Account_Type__c){
                if(notUsedPartner.size()>0){
                    NS_Partner__c unusedPartner = notUsedPartner[0];
                    parentOpportunity.NS_Partner_Account_2__c=unusedPartner.NS_Partner_Account__c;
                    parentOpportunity.NS_Partner_Account_Type_2__c=unusedPartner.NS_Partner_Account_Type__c;
                    notUsedPartner.remove(0);
                }else{
                    parentOpportunity.NS_Partner_Account_2__c=null;
                    parentOpportunity.NS_Partner_Account_Type_2__c=null;
                }
                listToUpdate.add(parentOpportunity);
            }else if (parentOpportunity.NS_Partner_Account_3__c==recFinalPartner.NS_Partner_Account__c&& parentOpportunity.NS_Partner_Account_Type_3__c==recFinalPartner.NS_Partner_Account_Type__c){
                if(notUsedPartner.size()>0){
                    NS_Partner__c unusedPartner = notUsedPartner[0];
                    parentOpportunity.NS_Partner_Account_3__c=unusedPartner.NS_Partner_Account__c;
                    parentOpportunity.NS_Partner_Account_Type_3__c=unusedPartner.NS_Partner_Account_Type__c;
                    notUsedPartner.remove(0);
                }else{
                    parentOpportunity.NS_Partner_Account_3__c=null;
                    parentOpportunity.NS_Partner_Account_Type_3__c=null;
                }
                listToUpdate.add(parentOpportunity);
            }else if (parentOpportunity.NS_Partner_Account_4__c==recFinalPartner.NS_Partner_Account__c&& parentOpportunity.NS_Partner_Account_Type_4__c==recFinalPartner.NS_Partner_Account_Type__c){
                if(notUsedPartner.size()>0){
                    NS_Partner__c unusedPartner = notUsedPartner[0];
                    parentOpportunity.NS_Partner_Account_4__c=unusedPartner.NS_Partner_Account__c;
                    parentOpportunity.NS_Partner_Account_Type_4__c=unusedPartner.NS_Partner_Account_Type__c;
                    notUsedPartner.remove(0);
                }else{
                    parentOpportunity.NS_Partner_Account_4__c=null;
                    parentOpportunity.NS_Partner_Account_Type_4__c=null;
                }
                listToUpdate.add(parentOpportunity);
            }
            
        }
        if(listToUpdate.size()>0){
            mapUpdate.putAll(listToUpdate);
        }
        update mapUpdate.values();
        
    }
}