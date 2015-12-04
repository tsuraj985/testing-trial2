public class show{

    public show(ApexPages.StandardController controller) {

    }

public list<account> accountList{get;set;}
public show(){
accountList = new list<Account>();
accountList =[select name, AccountNumber, phone, fax From account limit 10];
}
public pagereference onSave(){
return null;
}
}