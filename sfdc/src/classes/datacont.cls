public with sharing class datacont 
{
    public list<contract> contractList{get;set;}
    public contract ContractObj{get;set;}
    
    public datacont(ApexPages.StandardController controller) {
            contractObj= new Contract();
    }


    
    public List<Contract> getContract() {
      contractList = new list<Contract>();
      contractList = [SELECT Status,EndDate,StartDate,Name,Description FROM contract limit 100];
      return ContractList;
    }
    public pageReference onSave(){
        try{
            insert contractObj;
        }catch(Exception e){
            system.Debug('***Error in inserting***'+e.getMessage());
        }
        return null;
    }
}