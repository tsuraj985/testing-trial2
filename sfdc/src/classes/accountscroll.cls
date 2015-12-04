public with sharing class accountscroll
{
public list<Account> accountList{get;set;} 
public accountscroll()
 { 
 accountList = new list<Account>(); 
 accountList = [SELECT id,name,Phone,Fax,site FROM Account LIMIT 20]; 
 } 
}