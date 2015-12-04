Public with sharing class DataTableHelper{
      list<Account> acclist;
      public list<Account> getAccounts()
           {
           accList=[SELECT Name,Phone,AccountNumber,Rating,Region__c FROM Account WHERE Name like '%testing%' limit 100];
            return accList;
           }
    }