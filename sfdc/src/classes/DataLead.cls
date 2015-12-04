public with sharing class DataLead{
public list <lead> leadList{get;set;}
public lead leadObj{get;set;}
public DataLead(apexPages.StandardController controller){
   leadObj= new Lead();
   }
   public list<lead> getLeads(){
   leadList= new list<lead>();
     LeadList = [SELECT Phone, Name, MobilePhone,Fax, Title FROM Lead limit 100];
      return leadList;
    }
    public pageReference onSave(){
        try{
            insert LeadObj;
        }catch(Exception e){
            system.Debug('***Error in inserting***'+e.getMessage());
        }
        return null;
    }
}