trigger NSSalesCampaignMember on CampaignMember (after Insert, after Update,before Delete) {
    
    if(trigger.isInsert){
        if(trigger.isAfter){
            NSSalesCampaignMemberHelper.insertCreateRecord(Trigger.New);
       }
    }
    
    if(trigger.isDelete){
        if(trigger.isBefore){
            NSSalesCampaignMemberHelper.deleteCreateRecord(Trigger.Old);
       }
    }
    
    if(trigger.isUpdate){
        if(trigger.isAfter){
            NSSalesCampaignMemberHelper.updateCreateRecord(Trigger.NewMap,Trigger.OldMap);
       }
    }

}