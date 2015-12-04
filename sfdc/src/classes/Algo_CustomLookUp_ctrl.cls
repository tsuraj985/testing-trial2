/*----------------------------------------------------------------------------------------------------------------------------
// Project Name..........: <<Opportunity Manager>>
// File..................: <<Algo_customLookUp_ctrl>> 
// Version...............: <<1.0>>
// Created by............: <<Algoworks>>
// Created Date..........: <<08-08-2014>>
// Last Modified Date....: <<08-08-2014>>
// Description...........: <<Popup controller which shows all record on the basis of object ant their fields.>>
//---------------------------------------------------------------------------------------------------------------------------*/

public with sharing class Algo_CustomLookUp_ctrl {    
        
    public String fieldTypeForSelectedField {get;set;}     
    public transient list<PhoneNumberDetail> listOfLookupsElement {get;set;}
    //public list<list<PhoneNumberDetail>> listOfLookupsElementTotal {get;set;}
    public String objectName {get;set;}
    public String fieldName {get;set;}
    public String searchByName{get;set;}
    public String searchByPhone{get;set;}
    public boolean isChecked {get;set;}
    public String phoneNumberPassToTextBox {get;set;}
    public String phoneNamePassToHdn {get;set;}
    public boolean isAllSelectCheckBox {get;set;}
    public Paginate paginater {get;set;}
    public string isCheck{get;set;}
    /*Controller*/
    public Algo_customLookUp_ctrl (){
      
        listOfLookupsElement = new list<PhoneNumberDetail>();        
        string a = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('oN'));
        string b = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('fN'));
         
        objectName = EncodingUtil.urlDecode(a,'UTF-8');
        fieldName = EncodingUtil.urlDecode(b,'UTF-8');
        isAllSelectCheckBox = false;
        searchByPhone = '';
        searchByName ='';
        phoneNumberPassToTextBox = '';
        phoneNamePassToHdn  = '';
        phoneNamePassToHdn ='';
        
        List<PhoneNumberDetail> resultsList = getlistOfLookupsElement();
         
        //Set the page size
        Integer pageSize = 50;
         
        //Create a new instance of Paginate passing in the overall size of
        //the list of data and the page size you want
        this.paginater = new Paginate(resultsList.size(), pageSize);
         //These lists hold the data
        list<list<PhoneNumberDetail>> listOfLookupsElementTotal  = new List<List<PhoneNumberDetail>>();
        this.listOfLookupsElement = new List<PhoneNumberDetail>();
        //Break out the full list into a list of lists
        if(resultsList.size() > 0){
            List<PhoneNumberDetail> tempCC = new List<PhoneNumberDetail>();        
            Integer i = 0;
            for(PhoneNumberDetail cc : resultsList){
                tempCC.add(cc);
                i++;
                if(i == pageSize){
                    listOfLookupsElementTotal.add(tempCC);
                    tempCC = new List<PhoneNumberDetail>();
                    i = 0;
                }
            }
            if(!tempCC.isEmpty()){
                listOfLookupsElementTotal.add(tempCC);
            }
             
            //Gets the correct list of data to show on the page
            this.listOfLookupsElement= listOfLookupsElementTotal.get(this.paginater.index);
        }
   }
   /*to get list of lookup element*/
   public List<PhoneNumberDetail>getlistOfLookupsElement(){
        try{ 
            listOfLookupsElement = new list<PhoneNumberDetail>();
            list<SObject> s = Database.query('SELECT Name,'+String.escapeSingleQuotes(fieldName)+' FROM '+String.escapeSingleQuotes(objectName) +' WHERE isDeleted = false LIMIT 50000');
            String CountryCode = null; 
            boolean isCountryCodeAlreadyExist;       
            for(sObject sObj:s){ 
                CountryCode = null; 
                isCountryCodeAlreadyExist = false;    
                if(sObj.get(fieldName) != null && sObj.get('Name') != null){
                    if(String.valueOf(sObj.get(fieldName)).startsWith('+1')){
                        CountryCode = '+1';
                        isCountryCodeAlreadyExist = true;
                    } 
                    listOfLookupsElement.add(new PhoneNumberDetail(String.valueOf(sObj.get('Name')),String.valueOf(sObj.get('id'))));                    
                } 
            }
            
            
        }catch(Exception ex){
             apexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Parameter is not defined, Please contact your Administrator!'));
        }
        return       listOfLookupsElement;
    }
    /*Search event*/
    public void onSearch(){
        phoneNumberPassToTextBox = '';
        phoneNamePassToHdn  = '';
        isAllSelectCheckBox = false;
        listOfLookupsElement = new list<PhoneNumberDetail>();
        String byName = '\'%'+String.escapeSingleQuotes(searchByName) + '%\'';
        
        String CountryCode = null;
        boolean isCountryCodeAlreadyExist;
        try{
            String query ='SELECT Name,'+String.escapeSingleQuotes(fieldName)+' FROM '+String.escapeSingleQuotes(objectName) +' WHERE  name Like '+byName +' AND isDeleted = false LIMIT 50000';
            system.debug(query);
           list<SObject> s = Database.query(query); 
            for(sObject sObj:s){
                CountryCode = null;
                isCountryCodeAlreadyExist = false;   
                if(sObj.get(fieldName) != null && sObj.get('Name') != null){
                    listOfLookupsElement.add(new PhoneNumberDetail(String.valueOf(sObj.get('Name')),String.valueOf(sObj.get('id'))));
                }
            }
             List<PhoneNumberDetail> resultsList = listOfLookupsElement;
         
        //Set the page size
        Integer pageSize = 50;
         
        //Create a new instance of Paginate passing in the overall size of
        //the list of data and the page size you want
        this.paginater = new Paginate(resultsList.size(), pageSize);
         //These lists hold the data
        list<list<PhoneNumberDetail>>listOfLookupsElementTotal = new List<List<PhoneNumberDetail>>();
        this.listOfLookupsElement = new List<PhoneNumberDetail>();
        //Break out the full list into a list of lists
        if(resultsList.size() > 0){
            List<PhoneNumberDetail> tempCC = new List<PhoneNumberDetail>();        
            Integer i = 0;
            for(PhoneNumberDetail cc : resultsList){
                tempCC.add(cc);
                i++;
                if(i == pageSize){
                    listOfLookupsElementTotal.add(tempCC);
                    tempCC = new List<PhoneNumberDetail>();
                    i = 0;
                }
            }
            if(!tempCC.isEmpty()){
                listOfLookupsElementTotal.add(tempCC);
            }
             
            //Gets the correct list of data to show on the page
            this.listOfLookupsElement= listOfLookupsElementTotal.get(this.paginater.index);
        }  
        }catch(Exception ex){
            apexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Illegal Search parameter!'));
        }       
    }
    
    public pageReference onthere(){
        isCheck ='aaaad121';
        return null;
    }
    /*Event for check box checked*/
    public void onCheck(){
        phoneNumberPassToTextBox = '';
        phoneNamePassToHdn  = '';
        String CountryCode  = '';
        for(PhoneNumberDetail pn:listOfLookupsElement){
            if(pn.isChecked){
                phoneNamePassToHdn += pn.sObjectNameField+',';
            }
        }
        phoneNamePassToHdn ='aaa';
    }
        public PageReference previousPage(){
        this.paginater.decrement();
        return changeData();
    }
     
    public PageReference nextPage(){
        this.paginater.increment();
        return changeData();
    }
public PageReference lastPage(){
        this.paginater.lastPage();
        return changeData();
    }
 public PageReference firstPage(){
        this.paginater.firstpage();
        return changeData();
    }
    public PageReference updatePage(){
        this.paginater.firstPage();
        return changeData();
    }
 
     
    public PageReference changeData(){
         List<PhoneNumberDetail> resultsList = getlistOfLookupsElement();
          list<list<PhoneNumberDetail>> listOfLookupsElementTotal  = new List<List<PhoneNumberDetail>>();
        this.listOfLookupsElement = new List<PhoneNumberDetail>();
        //Break out the full list into a list of lists
        if(resultsList.size() > 0){
            List<PhoneNumberDetail> tempCC = new List<PhoneNumberDetail>();        
            Integer i = 0;
            for(PhoneNumberDetail cc : resultsList){
                tempCC.add(cc);
                i++;
                if(i == 50){
                    listOfLookupsElementTotal.add(tempCC);
                    tempCC = new List<PhoneNumberDetail>();
                    i = 0;
                }
            }
            if(!tempCC.isEmpty()){
                listOfLookupsElementTotal.add(tempCC);
            }
             
            //Gets the correct list of data to show on the page
           // this.listOfLookupsElement= listOfLookupsElementTotal.get(this.paginater.index);
        }
        this.listOfLookupsElement= listOfLookupsElementTotal.get(this.paginater.index);
        return null;
    }
    /*P2l Detail wrapper*/
    public class PhoneNumberDetail{
        public boolean isChecked {get;set;}
        public string sObjectNameField {get;set;}
        public string sObjectPhone {get;set;}
        public string countryCode {get;set;}
        public string id1{get;set;}
        public boolean isCountryCodeExist {get;set;}
        public PhoneNumberDetail(string sObjectNameField,string id1){
            this.sObjectNameField = sObjectNameField;
            this.id1 = id1;           
        }        
    }
}