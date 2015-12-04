Public with sharing class myclass{
 public List<Account> acc{get;set;}

 Public myclass(){
  acc= new List<Account>();
  acc= [select name,phone,fax,site from Account limit 10];
 }
}