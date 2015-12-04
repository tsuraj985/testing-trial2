public with sharing class DataTable 
{
    public list<Account> accountList{get;set;}
    public Account accObj{get;set;}
    
    public DataTable(ApexPages.StandardController controller) {
            accObj= new Account();
    }


    
    public List<Account> getAccounts() {
      accountList = new list<Account>();
      accountList = [SELECT id,AccountNumber,Name,Site,Rating,Phone,Website FROM Account limit 100];
      return accountList;
    }
    public pageReference onSave(){
        try{
            insert accObj;
        }catch(Exception e){
            system.Debug('***Error in inserting***'+e.getMessage());
        }
        return null;
    }
}