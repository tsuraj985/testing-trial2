global class AccountList {

    public String selectedRadiusUnit { get; set; }
    public list<Account> objAccounts {get;set;}
    public String selectedRadius{get;set;} 
    public Boolean isContractExpirationDate{get;set;}
    public Integer accLength{get;set;}
    public Integer wrapperLength{get;set;}
    public List<PicklistWrapper> accountType1{get;set;}
    public list<WrapperForMarker> accountWrapperList{get;set;}
    public static string key = 'AIzaSyDS2SlXCXwaXnpU6PMnNFYVDi8Rrta0ZG4';
    
    public AccountList(){
        try{
          
          // assigning records for field set
          this.accObj1 = getAccountRecord();
          
          Account_Tracker__c objAT = init();  
            List<PicklistWrapper>  accountType2 = getAccountType();
            accountWrapperList = new list<WrapperForMarker>();
            accountType1 = new List<PicklistWrapper>();
            isContractExpirationDate = false;
            if(objAT.Selected_Radius__c != null){            
                selectedRadius = objAT.Selected_Radius__c;
            }else{
                 selectedRadius = '1';
            }
            if(objAT.Radius_Unit__c != null){
                selectedRadiusUnit = objAT.Radius_Unit__c;
            }else{
                selectedRadiusUnit = 'mi';
            }
            for(PicklistWrapper at:accountType2){
                PicklistWrapper pwob = at;
                //for(String pw:objAT.Radius__c.split(',')){ 
                    if(objAT.Account_Type__c != null && objAT.Account_Type__c != ''){
                        if(objAT.Account_Type__c.indexOf(pwob.value) != -1){
                            pwob.isChecked = true;
                        }    
                    }                
                //}
                accountType1.add(pwob);
            }
            objAccounts = new list<Account>();  
            Account acc = new Account();
            
            
            User us = [Select Name,Street,City,PostalCode,Country,Latitude,Longitude from User where id=:userInfo.getUserId()];
            acc.Name = us.Name;
            acc.BillingStreet = us.Street;
            acc.BillingCity = us.City;
            acc.BillingPostalCode = us.PostalCode;
            acc.BillingCountry = us.Country;
            objAccounts.add(acc);
            list<String> accountTypeIn = new list<String>();
            if(objAT.Account_Type__c != null && objAT.Account_Type__c != ''){
                for(String act:objAT.Account_Type__c.split(',')){
                    accountTypeIn.add(act);
                }
               String query1 = 'SELECT ';
                for(Schema.FieldSetMember f : this.getFields()) {
                query1 += f.getFieldPath() + ', ';
            }
            
            String accTypesIn = quoteKeySet(accountTypeIn);
            
             query1 += 'Id FROM Account Where BillingCountry <> null AND isDeleted = false AND type IN '+accTypesIn;
             //query1 += 'Id FROM Account Where BillingCountry <> null AND isDeleted = false';
             objAccounts.addAll((List<Account>)Database.query(query1));
               
               /* objAccounts.addAll([SELECT Name,BillingStreet,BillingCity,BillingPostalCode,BillingLatitude,BillingLongitude,
                                    BillingCountry FROM Account 
                                    Where BillingCountry <> null AND isDeleted = false AND type IN:accountTypeIn]);*/
            }else{
              
              String query2 = 'SELECT ';
                for(Schema.FieldSetMember f : this.getFields()) {
                query2 += f.getFieldPath() + ', ';
            }
            
            if(query2.contains('BillingLatitude') || query2.contains('BillingLongitude')){
              query2 += 'Id FROM Account Where BillingCountry <> null AND isDeleted = false';
            }
            else{
              query2 += 'Id,BillingLatitude FROM Account Where BillingCountry <> null AND isDeleted = false';
            }
            if(query2.contains('BillingLongitude')){
              query2 += 'Id FROM Account Where BillingCountry <> null AND isDeleted = false';
            }
            else{
              query2 += 'Id,BillingLatitude FROM Account Where BillingCountry <> null AND isDeleted = false';
            }
            
            objAccounts.addAll((List<Account>)Database.query(query2));
             
               /* objAccounts.addAll([SELECT Name,BillingStreet,BillingCity,BillingPostalCode,BillingLatitude,BillingLongitude,
                                BillingCountry FROM Account 
                                Where BillingCountry <> null AND isDeleted = false]);*/
            }
            /*for(Account accObj:objAccounts){
                 accountWrapperList.add(new WrapperForMarker(accObj));
            }
            wrapperLength=accountWrapperList.size();
            accLength = objAccounts.size();*/
            system.debug('****'+objAccounts);
            system.debug('****'+objAccounts.size());
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:'
                                                        +ex.getMessage()));
        }
    }
    
    
    private String quoteKeySet(List<String> mapKeySet)
    {
        String newSetStr = '' ;
        for(String str : mapKeySet)
            newSetStr += '\'' + str + '\',';
          newSetStr = newSetStr.lastIndexOf(',') > 0 ? '(' + newSetStr.substring(0,newSetStr.lastIndexOf(',')) + ')' : newSetStr ;
    
    System.debug('quoteKeySet() :  newSetStr ============ ' + newSetStr);   

        return newSetStr;

    }
    /*** Field Set Snippet Start ***************/
    public Account accObj1{ get; set; }
    
    //Also assigning records for field set in constructor
    
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Account.FieldSets.Description_For_Map.getFields();
    }
    private Account getAccountRecord() {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        
        query += 'Id FROM Account LIMIT 1';
        
        return Database.query(query);
    }
    
    /*** Field Set Snippet End ***************/
    public static String getLatitudeLongitude(String address){
        String location='';
        
        try{
                Double latitude = null;
            Double longitude = null;
            
                Http httpGetRequest = new Http();
                HttpRequest httpReq = new HttpRequest();
                system.debug('******Address---'+address);
                address=address.replaceAll(' ','+');
                address = address.replace('\r\n', ' ');
                        address = address.replace('\n', ' ');
                        address = address.replace('\r', ' ');
                        system.debug('******After       Address---'+address);
                        httpReq.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?key='+key+'&address=' +address + '&sensor=false');
            httpReq.setMethod('GET');
            httpReq.setTimeout(6000);
            HttpResponse httpResponseAddress = httpGetRequest.send(httpReq);
                system.debug('res body: ' + httpResponseAddress.getBody());
                JSONParser parser = JSON.createParser(httpResponseAddress.getBody());
            
            
            while (parser.nextToken() != null)
            {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location'))
                    {
                       // Jump to latitude and longtitude fields.
                        parser.nextToken();

                        while (parser.nextToken() != JSONToken.END_OBJECT)
                        {
                            String text = parser.getText();
                            parser.nextToken();
                            if (text == 'lat') latitude = parser.getDoubleValue();
                            else if (text == 'lng') longitude = parser.getDoubleValue();
                        }
                    } 
            }

            // Update Account coordinates.
            if (latitude != null)
            {
                location+= latitude + ', ' +  longitude;               
            }
            
            
        }catch(Exception e){
                system.debug('***** Exception Occured '+e.getMessage());
        }
        return location;
    }
    /*@RemoteAction
    global static List<Account> getNearby(String position){
    return null;
    }*/
    
    public list<SelectOption> getRadius(){
        list<SelectOption> rd = new list<SelectOption>();
        try{        
            String rad = Account_Tracker__c.getAll().get('default').Radius__c;
            for(String r:rad.split(',')){
                rd.add(new selectOption(r,r));
            }
        }catch(Exception ex){
            rd.add(new selectOption('','--None--'));
        }
        return rd; 
    }
    
    public List<PicklistWrapper> getAccountType(){ 
        list<PicklistWrapper> PicklistWrapperList = new list<PicklistWrapper>();        
        Schema.DescribeFieldResult fieldResult = Account.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
        Integer index = 0;      
        for( Schema.PicklistEntry f : ple){
          PicklistWrapperList.add(new PicklistWrapper(f.getLabel(), f.getValue(),'cls'+index));
          index ++;
        }  
        PicklistWrapperList.add(new PicklistWrapper('Contract Expiration Date', 'Contract Expiration Date','cls'+index)); 
        return PicklistWrapperList;
    }

    public class PicklistWrapper{
        public Boolean ischecked{get;set;}
        public String label{get;set;}
        public String value{get;set;}
        public String clsname{get;set;}
        public PicklistWrapper(String label,String value,String clsname){
            this.label = label;
            this.value = value;
            this.ischecked = false;
            this.clsname = clsname;
        }
    }
    
    public pageReference onSave(){
        Account_Tracker__c objAccount_Tracker = new Account_Tracker__c();
        if(Account_Tracker__c.getAll() != null){
            objAccount_Tracker = Account_Tracker__c.getAll().get('default');
        }
        String accountType = '';
        for(PicklistWrapper at:accountType1){
            if(at.ischecked == true){
                accountType += ','+at.value;
            }
        }
        if(accountType!='' && accountType!=null){
                objAccount_Tracker.Account_Type__c = accountType.replaceFirst(',','');
                //objAccount_Tracker.Expiration_Date__c = null;
                objAccount_Tracker.Enable_Contract_expiration_date__c = accountType.indexOf('Contract Expiration Date')!=-1;
        }
        objAccount_Tracker.Selected_Radius__c = selectedRadius;
        objAccount_Tracker.Radius_Unit__c  = selectedRadiusUnit;
        upsert objAccount_Tracker;
        pageReference pr = new pageReference('/apex/Business?core.apexpages.devmode.url=1');
        pr.setRedirect(true);        
        return pr;
    }
    private Account_Tracker__c init(){
        Account_Tracker__c objAccount_Tracker = new Account_Tracker__c();
        if(Account_Tracker__c.getAll() != null){
            objAccount_Tracker = Account_Tracker__c.getAll().get('default');
        }
        return objAccount_Tracker;
    }
    
    public pagereference test(){
        pagereference p = new pagereference('/apex/GoogleAccountMap');
        p.setRedirect(true);
        return p;
    }
    
    public class WrapperForMarker{
    
        public Account accObj{get;set;}
        public String latitude{get;set;}
        public String longitude{get;set;}
        
        public WrapperForMarker(Account accObj){
                this.accObj = accObj;
                
                String address = accObj.BillingStreet+accObj.BillingCity+accObj.BillingPostalCode+accObj.BillingCountry;
                String latLongCombo = AccountList.getLatitudeLongitude(address);
                if(latLongCombo!=null && latLongCombo!='' && latLongCombo.contains(',')){
                        String[] splittedValue = latLongCombo.split(',');
                        
                        this.latitude = splittedValue[0];
                        this.longitude = splittedValue[1];
                }
                //getLocation(address);
        }
        
    }
}