Public with sharing class scrollableList{
    list<Account> accountList;
    public list<Account> getAccounts(){
    accountList=[SELECT Name,AccountNumber,Phone FROM Account WHERE Name LIKE '%testing%' LIMIT 100];
    return accountList;
    }
    
}