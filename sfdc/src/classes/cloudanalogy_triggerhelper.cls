/*****
  Author-Suraj Tripathi
  Date-  10 aug 2015
  company-cloud analogy

******/

public class cloudanalogy_triggerhelper
{
    public static void putParentRankingValueToAccount(list<account> listOfAccountToBeUpdated){
        system.debug('listOfAccountToBeUpdated'+listOfAccountToBeUpdated);
    
        Set<ID> ids = new Set<ID>();  
         List<Account> accountUpdate = new list<account>();
        for(account a :listOfAccountToBeUpdated ){
        ids.add(a.ParentId);
        }
        for(account parentAcc : [SELECT id, ranking__c, parent_ranking__c FROM account WHERE id =:ids]){
            for(Account acc : listOfAccountToBeUpdated)
            {
        if (Acc.ParentId != NULL)     
        {
         acc.parent_ranking__c=acc.parent.ranking__c;
        
                accountUpdate.add(acc);
        }
         }
    }
}
}