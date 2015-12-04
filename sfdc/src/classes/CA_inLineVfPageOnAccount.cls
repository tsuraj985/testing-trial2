public with sharing class CA_inLineVfPageOnAccount{
public account a{get;set;}
public account acc{get;set;}
public CA_inLineVfPageOnAccount(apexPages.StandardController controller){
system.debug('+++++controller+++++'+controller);
this.a = (Account)controller.getRecord();
   acc=new account();
   acc=[select id,name,ranking__c,phone,Fax,parentId from Account where id=: controller.getId() AND ParentId!=null limit 1];
        if(null!=acc)
   {
        acc=[select id,name,ranking__c,phone,Fax,parentId from Account where id =: acc.parentId limit 1];
        
        } 
}
public pageReference onSave()
     {
         update acc;
           return null;
     }
}