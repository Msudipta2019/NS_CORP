public class NSSales_LightningTreeApexController {  
    
    public static Map<Id, List<Id>> getHierarchyMap(Id accountId){
        Map<Id, List<Id>> finalMap = new Map<Id, List<Id>>();
        List<items> finalWrp = new List<items>();  
        List<Id> level_1_accountIds= new List<Id>();
        List<Account> level_1_accounts=[select Id, Name, Type, parentId from Account where parentId =:accountId limit 50000];// LIMIT :getRemainingQueryRows()];
        for(Account acc :level_1_accounts )
        {
            level_1_accountIds.add(acc.id);
        }  
        
        finalMap.put(accountId,level_1_accountIds);
        Boolean newValueAdded = true; 
        List<id> allIds = new List<id>();
        
        while(newValueAdded){
            for(List<Id> ids : finalMap.values()){
                allIds.addAll(ids);
            }
            List<Account> accs2 = [select Id, Name, Type, parentId  from Account where parentId =: allIds limit 50000];// LIMIT :getRemainingQueryRows()];  
            newValueAdded = findChilds(accs2, finalMap);
        }
        return finalMap;
    }
    
    @AuraEnabled  
    public static List<items> getAccountHierarchy(Id accountId, Boolean expand) { 
        Map<Id, List<Id>> finalMap = new Map<Id, List<Id>>();
        List<items> finalWrp = new List<items>();  
        finalMap = getHierarchyMap(accountId); 
        finalWrp = createWrapperFromMap(finalMap,accountId,expand);
        return finalWrp;
    }
    
    private static boolean findChilds(List<Account> accs2, Map<Id, List<Id>> finalMap){
        Boolean newValueAdded = false;
        
        for(Account acc: accs2){
            if(finalMap.containsKey(acc.parentId)){
                List<Id> relatedChildIds = finalMap.get(acc.parentId);
                
                if(!relatedChildIds.contains(acc.id))
                {
                    relatedChildIds.add(acc.id);
                    finalMap.put(acc.parentId,relatedChildIds); 
                    newValueAdded = true;
                }             
            }
            else{
                List<Id> relatedChildIds = new List<Id>();
                relatedChildIds.add(acc.id);
                finalMap.put(acc.parentId,relatedChildIds);   
                newValueAdded = true;
            }
        } 
        return newValueAdded;
    }
    
    private Static List<items> getChild(Map<Id, List<Id>> finalMap,Map<id,Account> mapAccount, id relatedChildId, Boolean expand){
        List<items> childItems = new List<items>();
        List<items> childItems2 = new List<items>();
        List<Id> newRelatedChildIds = new List<Id>();
        
        newRelatedChildIds = finalMap.get(relatedChildId);
        
        for(Id newRelId: newRelatedChildIds){
            
            if(finalMap.containsKey(newRelId)){
                childItems2=getChild(finalMap,mapAccount,newRelId,expand);
            }
            
            Account acc = mapAccount.get(newRelId);         
            if(acc.recordtype.name=='Corporate')
            { 
                if(expand == TRUE){
                    items childItem =new items(acc.id, acc.Name, true, childItems2);  
                    childItems.add(childItem);   
                }
                else{
                    items childItem =new items(acc.id, acc.Name, false, childItems2);  
                    childItems.add(childItem);
                }               
            }
        }
        return childItems;
    }
    
    private static List<items> createWrapperFromMap(Map<Id, List<Id>> finalMap, Id accountId, boolean expand)  {
        List<items> finalWrp = new List<items>();
        Set<id> allAccIds = new Set<id>();
        for(list<id> accList :finalMap.values())
        {
            for(Id accId : accList)
            {
				allAccIds.add(accId);
            }
        }  
        allAccIds.add(accountId);
        Map<id,Account> mapAccount = new Map<id,Account>([select name,type,parentId,Parent.Name, Parent.Type, Recordtype.name from Account where id in : allAccIds limit 50000]);
        List<Id> relatedChildIds = new List<Id>();
        System.debug('All Keys : '+finalMap.keySet());     
        
        for(id keyId: finalMap.keySet()){
            if(keyId == accountId){
                relatedChildIds = finalMap.get(keyId);
                Account parentAcc = mapAccount.get(keyId);
                List<items> childItems = new List<items>();
                List<items> childItems2 = new List<items>();
                
                if(relatedChildIds.size()>0)
                {
                    for(Id relatedChildId : relatedChildIds )
                    {
                        Account acc = mapAccount.get(relatedChildId);                        
                        if(finalMap.containsKey(relatedChildId)){
                            childItems2=getChild(finalMap,mapAccount,relatedChildId,expand);
                        }
                        
                        if(acc.recordtype.name=='Corporate'){
                            if(expand==TRUE){
                                items childItem =new items(acc.id, acc.Name, true, childItems2); 
                                childItems.add(childItem);
                            }
                            else{
                                items childItem =new items(acc.id, acc.Name, false, childItems2);
                                childItems.add(childItem);
                            }
                            
                        }
                    }
                }
                if(parentAcc != NULL){
                if(parentAcc.recordtype.name=='Corporate' && parentAcc.id!=accountId){  
                    if(expand==TRUE){
                        items parentItem = new items(parentAcc.id, parentAcc.Name, true, childItems);
                        finalWrp.add(parentItem);
                    }
                    else{
                        items parentItem = new items(parentAcc.id, parentAcc.Name, false, childItems);
                        finalWrp.add(parentItem);
                    }
                    
                }
                
                    if(parentAcc.ParentId==null){  
                        if(expand==TRUE){
                            items parentItem = new items(parentAcc.id, parentAcc.Name + '  < (Current)', true, childItems);
                            finalWrp.add(parentItem);
                        }
                        else{
                            items parentItem = new items(parentAcc.id, parentAcc.Name + '  < (Current)', false, childItems);
                            finalWrp.add(parentItem);
                        }
                    }

                    else{
                        Id ultimateParentId = getTopLevleElement(accountId);
                        Boolean ultimateParent = false;
                        Boolean currRec = true; 
                        
                        List<items> allItems = childItems;
                        
                        while ( !ultimateParent) {                      
                            Account acc = [ Select Id, ParentId ,Name,Type,Parent.Name, Parent.Type,Recordtype.name,Parent.Recordtype.name From Account where Id =: accountId limit 1 ];//Test Bus 2
                            
                            if (currRec){
                                if(expand==TRUE){
                                    allItems = new List<items>{new items(acc.id, acc.Name + '  < (Current)', true, allItems)};
                                        currRec = false;
                                }
                                else{
                                    allItems = new List<items>{new items(acc.id, acc.Name + '  < (Current)', false, allItems)};
                                        currRec = false;    
                                }
                            }
                            else{
                                if(acc.recordtype.name=='Corporate'){
                                    allItems = new List<items>{new items(acc.id, acc.Name, true, allItems)};
                                        }
                            }
                            
                            if (acc.ParentId != ultimateParentId) {
                                accountId = acc.ParentId ; 
                            }
                            else {
                                ultimateParent = true;
                                if(acc.Parent.recordtype.name=='Corporate'){
                                    finalWrp.add(new items(acc.Parent.id, acc.Parent.Name, true, allItems)); 
                                }
                                else{
                                    finalWrp = allItems; 
                                }
                            }
                        }
                    }
                }
            }
        }
        return finalWrp;
    }
    
    private static Id getTopLevleElement(Id accountId){
        Boolean topLevelParent = false;
        while ( !topLevelParent ) {
            Account acc = [ Select Id, ParentId From Account where Id =: accountId limit 1 ];
            if ( acc.ParentID != null ) {
                accountId = acc.ParentID;
            }
            else {
                topLevelParent = true;
            }
        }
        return accountId ;
    }
    
    @AuraEnabled 
    public static List<items> expandAllItems(Id accountId,Boolean expand){
        Map<Id, List<Id>> finalMap = new Map<Id, List<Id>>();
        List<items> finalWrp = new List<items>();
        finalMap =  getHierarchyMap(accountId);
        finalWrp = createWrapperFromMap(finalMap,accountId,expand);
        return finalWrp;
    }
     
}