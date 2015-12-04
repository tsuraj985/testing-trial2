public with sharing class WrapperDemo_Con {  
    public List<sObjectWrapper> wrappers{get;set;}  
    public WrapperDemo_Con(){  
     wrappers = getData();  
   }  
    public void deleteRecords(){  
     List<Contact> conToDel = new List<Contact>();  
     for(sObjectWrapper wrap : wrappers){  
          if(wrap.isSelected){  
         conToDel.add(wrap.myContact);  
       }  
     }  
        delete conToDel;  
       wrappers = getData();  
   }  
    private List<sObjectWrapper> getData(){  
     List<sObjectWrapper> wrappers = new List<sObjectWrapper>();  
     for(Contact con : [SELECT LastName,Id,Phone, Description FROM Contact limit 10]){  
          wrappers.add(new sObjectWrapper(con,false));  
     }  
     return wrappers;  
   }  
    public class sObjectWrapper{  
    public boolean isSelected{get;set;}  
    public Contact myContact{get;set;}  
    public sObjectWrapper(Contact myContact,Boolean isSelected){  
     this.myContact= myContact;  
     this.isSelected = isSelected;  
    }  
   }  
 }