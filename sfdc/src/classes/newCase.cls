public with sharing class newCase{
public list<Case> caseList{get;set;}
public Case CaseObj{get;set;}
public newCase(ApexPages.StandardController controller){
      CaseObj=new Case();
      }
        
        
        public list<Case> getCases(){
        caseList= new List<Case>();
          caseList = [SELECT Reason,Status,CaseNumber,Type FROM Case limit 100];
      return caseList;
    }
    public pageReference onSave(){
        try{
            insert CaseObj;
        }catch(Exception e){
            system.Debug('***Error in inserting***'+e.getMessage());
        }
        return null;
    }
}