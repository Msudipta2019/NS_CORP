/************************************
Description  : Trigger on Opportunity
Developer    : Accenture Solutions
Date         : 05-07-2019
**************************************/
trigger OpportunityTrigger on Opportunity (before insert, before update, after insert,after update) {
    
    
    if(System.isBatch())
    {
        
        return; 
    }
    if(trigger.isInsert){
        if(trigger.isBefore){
            //SRV
            //NS_Sales_OpportunityTriggerHelper.update609StageChangeDate(Trigger.new, null,true);
            
            NS_Sales_OpportunityTriggerHelper.updateOptyName(Trigger.new);
            //NS_Sales_OpportunityTriggerHelper.updateAccount(Trigger.new);
            /****** 609.1 Switch Removal***************************/
            NS_Sales_OpportunityTriggerHelper.changeRecTypeOn_609_1_Create(Trigger.new);
            NS_Sales_OpportunityTriggerHelper.primary_Account_Classification_AutoPopulate(Trigger.new);
            
            
        }
        if(trigger.isAfter){
            
            //NS_OppWorkBenchRequest.invokeOppStageChangeOnInsertWB(Trigger.newMap);
            //Gunjari 03/07 -- call insertAllOpportunityRollupRecord
            
            NS_Sales_OpportunityTriggerHelper.insertAllOpportunityRollupRecord(Trigger.new);
            NS_Sales_OpportunityTriggerHelper.sendEmailToCampaignMembersOnOptyCreate(Trigger.new);
            NS_Sales_OpportunityTriggerHelper.notify_Specific_Users_On_609_1_Create(Trigger.new);
            
        }
    }
    
    if(trigger.isUpdate){     
        
        if(trigger.isBefore){ 
            //SRV
           // NS_Sales_OpportunityTriggerHelper.update609StageChangeDate(Trigger.new, Trigger.oldMap,false);
            
            //SRV Scott
            NS_Sales_OpportunityTriggerHelper.validateAccess(trigger.New);
            
            //SRV 3315
            NS_Sales_OpportunityTriggerHelper.alertValidationStageChange30Days(Trigger.oldMap, Trigger.newMap);
            NS_Sales_OpportunityTriggerHelper.updateTimeStamps(Trigger.oldMap, Trigger.newMap);
            //END
            NS_Sales_OpportunityTriggerHelper.fetchSwitchCoordinates_609_1(Trigger.new);
            NS_Sales_OpportunityTriggerHelper.updateTimeinStatus(Trigger.newMap,Trigger.oldMap);
            
            // NS_Sales_OpportunityTriggerHelper.checkUpdateOnInsert(Trigger.oldMap,Trigger.newMap);
            
            NS_Sales_OpportunityTriggerHelper.updateCounterForFinalApproval(Trigger.new);
            
            NS_Sales_OpportunityTriggerHelper.updateOpportunity(Trigger.Old,Trigger.new);//comment EOD 24/7 for 31/7 deployment
            
            NS_Sales_OpportunityTriggerHelper.set_609_1_SendForApproval(Trigger.new);
            //NS_Sales_OpportunityTriggerHelper.oppStageChangeUpdate(Trigger.oldMap,Trigger.newMap);
            NS_Sales_OpportunityTriggerHelper.updateAccount(Trigger.new);
            
        }
        
        if(trigger.isAfter){
            /*Commented By Pranay Banerjee as Requested by Onshore D-1489 */
            //NS_OppWorkBenchRequest.invokeOppStageChangeOnInsertWB(Trigger.newMap);
            //  NS_OppWorkBenchRequest.invokeOppStageChangeOnUpdateWB(Trigger.oldMap, Trigger.newMap);
            //Gunjari 03/07 -- call updateAllCaseRollupRecord
            
            NS_Sales_OpportunityTriggerHelper.updateAllOpportunityRollupRecord(Trigger.newMap,Trigger.oldMap);
            
            NS_Sales_OpportunityTriggerHelper.sendEmailToCampaignMembersOnOptyUpdate(Trigger.newMap,Trigger.oldMap);
        }
        
        
    }
    
}