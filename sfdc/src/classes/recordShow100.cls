public with sharing class recordShow100 {
public list<Account> accountList{get;set;}
public recordShow100(){
accountList = new list<Account>();
accountList = [SELECT id,name FROM Account LIMIT 100];
}
}