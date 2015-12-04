public with sharing class dataTableCG{
    public string inputValue;
    public list<Account>accList;
    public string searchTable{get; set;}
    
    public dataTableCG(){
        searchTable='SELECT Name,Phone,BillingCity,BillingPostalCode FROM Account';
    }
    
    public void setInputValue (string inputValue){
        this.inputvalue = inputValue;
    }
    
    public string getInputValue(){
        return inputValue;
    }
    public List <Account>getaccList(){
        accList=new list<Account>();
        accList=Database.query(searchTable);
        return accList;
    }
    public pagereference search(){
        searchTable ='SELECT Name,Phone,BillingCity,BillingPostalCode FROM Account WHERE Name LIKE \'%'+inputValue+'%\'';
        return null;
    }
    public pageReference clear(){
        accList.clear();
        searchTable='SELECT Name,Phone,BillingCity,BillingPostalCode FROM Account LIMIT 50';
        return null;
    }    
}