global class CustomCommunityLoginController2 {

    global String username{get;set;}
    global String password{get;set;}
    global Contact coobj{get;set;}
    global Boolean authorize {get;set;}
    public string contactFirstName{get;set;}
    public string contactLastName{get;set;}
    public list<Contact> listCon{get;set;}
    public string str{get;set;}
    public List<string> StringArr {get; set;}
    public list <ConWrap> contobj {get;set;}
    public list <ConWrap> selectedContactList {get;set;}
    public list <ConWrap> selectedContactList1 {get;set;}
    public String searchstring { get; set; }
    public String searchclass { get; set; }
    public list <Contact> coobjstring {get;set;}
    public list <Contact> coobjclass {get;set;}
    public Integer counter = 0;
    public Integer limits = 5;
    public integer totalrecs=[select count() from contact];
    public string oldmail{get;set;}
    public string newmail{get;set;}
    public string cnfrmmail{get;set;}
    public contact conobj{get;set;}
    public string oldpass{get;set;}
    public string newpass{get;set;}
    public string cnfrmpass{get;set;}
    public contact conobj1{get;set;}
    public string tempEmail{get;set;}
    public string phoneNumber{get;set;}
    public string companyName{get;set;}
    public string addressCity{get;set;}
    public string addressState{get;set;}
    public string addressCountry{get;set;}
    public string addressPostalCode{get;set;}
    public string addressStreet{get;set;}
    public contact conobj2{get;set;}
    public contact conobj3{get;set;}
    public string tempPassword{get;set;}
     global CustomCommunityLoginController2() 
    {   
        str = ApexPages.CurrentPage().getparameters().get('id');
       system.debug('id from page'+str);
        Contact cStr = new Contact();  
            for(Contact c: [select id,FirstName, LastName, email,Phone,MailingCity,MailingState,MailingCountry,MailingPostalCode,MailingStreet from Contact where id =: str  limit 1]){
                contactFirstName = c.firstName;
                contactLastName = c.lastname;
                oldmail = c.email;
                phoneNumber = c.Phone;
                addressCity = c.MailingCity;
                addressState = c.MailingState;
                addressCountry = c.MailingCountry;
                addressPostalCode = c.MailingPostalCode;
                addressStreet = c.MailingStreet;
            }
       
        selectedContactList = new list<ConWrap>();
        listCon = new list<Contact>();
        authorize = true;
        try{
            tempShow();
        }catch(Exception ex){
            system.debug('Test1'+ex);
        }
    }
    
    global PageReference forwardToCustomAuthPage() {
        return new PageReference( '/CustomCommunityLoginPage');
    }
    global PageReference authenticate()
    {
       return null;
    } 
    global PageReference login() {
        str = ApexPages.CurrentPage().getparameters().get('id');
        system.debug('Current Page Id'+str);
        coobj = new contact();
       if(username != null && username != '' && password != null && password != ''){
      
   
       for(contact con : [select id,FirstName, LastName,email,Password__c from contact where email =: username AND Password__c =: password limit 1]){
           coobj = con;  
           
           system.debug('******');
                if(con != null){
                contactFirstName=con.FirstName;
                contactLastName=con.LastName;
            }
       }
         System.debug('+++++++'+coobj);
          System.debug('+++++++'+coobj.id);
       }
       System.debug('-----cjcd----'+coobj);
       if(coobj != null && coobj.email == username && coobj.Password__c == password)
            {
            authorize = true;
            
            System.debug('***********'+username+password);
            PageReference pgRef = new PageReference('http://lhc.force.com/Directory?id='+coobj.id);
            System.debug('&&&&&&&'+pgRef);
            return pgRef;
          
            }
        else 
        {       
            System.debug('########'+coobj);  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Valid username and password'));         
            
        }
                 
        return null;
       }
    public list <ConWrap> getSelectedList(){
        try{
        list<ConWrap> tempList = new list<ConWrap>();
        selectedContactList.clear();
        for(ConWrap wrapperObj : selectedContactList1){
            system.debug('@@@vool'+wrapperObj.bool);
            if(wrapperObj.bool){
                selectedContactList.add(new ConWrap(wrapperObj.con , false));
            }
        }
        system.debug('+++selected:'+selectedContactList);
        }catch(exception e){
            
            system.debug(e);
        }
        return selectedContactList;
    }
    public void tempShow(){
        list<Contact> tempContactList = new list<Contact>();
        selectedContactList1=new list<ConWrap>();
        string s = '%'+searchstring+'%';
        string s1 = '%'+searchclass+'%';
        
        if((searchstring == null || searchstring=='') && (searchclass== null || searchclass=='')){
        
            for(Contact cobj: [select Name,Account.Name,Title,Class_Of__c,Email,Phone from Contact where Add_to_Directory__c = true Limit 10 OFFSET : counter])
            {
                selectedContactList1.add(new ConWrap(cobj,false));
            }
            }
        else if(searchclass!=null && searchclass!=''){
            tempContactList =[select Name,
                                     Title,
                                     Class_Of__c,
                                     Email,
                                     Account.Name,
                                     Phone from Contact where Add_to_Directory__c = true AND Class_Of__c LIKE : s1 AND (Name Like : s OR email like : s OR Title like :s OR Phone like :s OR Account.Name like:s )  Limit 10 OFFSET : counter ];
        }
        else if(searchstring !=null && searchstring !=''){
            tempContactList =[select Name,
                                     Title,
                                     Class_Of__c,
                                     Email,
                                     Account.Name,
                                     Phone from Contact where Add_to_Directory__c = true AND (Name like :s OR email like : s OR Title like :s OR Phone like :s OR Account.Name like:s)  Limit 10 OFFSET : counter ];
        }
        else{
            tempContactList =[select Name,
                                     Title,
                                     Class_Of__c,
                                     Email,
                                     Account.Name,
                                     Phone from Contact where Add_to_Directory__c = true AND Class_Of__c LIKE : s1 AND (Name Like : s OR email like : s OR Title like :s OR Phone like :s OR Account.Name like:s)  Limit 10 OFFSET : counter];
        }
        
        
        
            for(Contact cobj: tempContactList ){
               {
                selectedContactList1.add(new ConWrap(cobj,false));
            }
        
        }
        
    }
      public void display()
      {
        coobjstring=new list <Contact>(); 
        string s = '%'+searchstring+'%';
        string s1 = '%'+searchclass+'%';       
        System.debug('ddddddddddd'+s);
        if(searchclass!=null && searchclass!=''){
            coobjstring=[select Name,Title,Class_Of__c,Email,Phone from Contact where Add_to_Directory__c = true AND Class_Of__c LIKE : s1 AND (Name Like : s OR email like : s) ];
        }
        else{
            coobjstring=[select Name,Title,Class_Of__c,Email,Phone from Contact where Add_to_Directory__c = true AND (Name like :s OR email like : s) ];
        }
        tempShow();
        System.debug('ddddddddddd'+coobjstring);
      }
      public void clear()
      {
        this.searchstring='';
        this.searchclass='';
        tempShow();
      }
      public void Next(){
        counter+=limits;
        tempShow();
    }
      
      public void Previous(){
        counter-=limits;
        tempShow();
    }
      
      public void first(){
        counter = 0;
        tempShow();
    }
    
      public void LastPage()
        {
            counter = totalrecs - math.mod(totalRecs,limits);
        }
      
      public boolean getprv()
        {
            if(counter == 0)
                return true;
            else
                return false;
        }
      
      public boolean getnxt()
        {
            if(counter == totalrecs - math.mod(totalRecs,limits))
                return true;
            else
                return false;
        }
        
        public boolean getlst()
        {
            if(counter == totalrecs - math.mod(totalRecs,limits))
                return true;
            else
                return false;
        }
        
    public void mysavemail()
    {
       conobj= new Contact();
       for(contact c: [select email from contact where id=: str limit 1])
       {
            conobj = c;
            tempEmail = conobj.email;
       }
     
        if(oldmail != null && oldmail != '' && oldmail != tempEmail){
            
            conobj.email = oldmail;
            update conobj;
            
        }
        
        conobj2= new Contact();
       for(contact c: [select Phone from contact where id=: str limit 1])
       {
            conobj2 = c;
       }
     
        if(phoneNumber != null && phoneNumber != ''){            
            conobj2.Phone = phoneNumber;
            update conobj2;
            
        }
        conobj3= new Contact();
       for(contact c: [select MailingCity,MailingState,MailingCountry,MailingPostalCode,MailingStreet from contact where id=: str limit 1])
       {
            conobj3 = c;
       }
                           
       if(addressCity != null && addressCity != '' ){
           conobj3.MailingCity = addressCity;
       }
       
       if( addressState != null && addressState != ''){
           conobj3.MailingState= addressState;
       }
       if( addressCountry != null && addressCountry != ''){
            conobj3.MailingCountry = addressCountry;
       }
       if(addressPostalCode != null && addressPostalCode != '' ){
            conobj3.MailingPostalCode = addressPostalCode;
       }
       if(addressStreet != null && addressStreet !=''){
            conobj3.MailingStreet = addressStreet;
       }     
      
       try{                                                  
         update conobj3;                 
       }catch(Exception e){
         system.debug(e);
       }
       
       conobj1 = new Contact();
       for(contact co: [select id,Password__c from contact where id =: str limit 1])
       {
            conobj1 = co;
       }
       try{
        if(oldpass == conobj1.Password__c && newpass == cnfrmpass)
        {
            conobj1.Password__c = newpass;
            
            update conobj1;
           
        }
        else
        {
            System.debug('cnfrmpass'+oldpass+newpass+cnfrmpass);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter valid password'));         
           
        }
       }
       catch(Exception e){
        system.debug(e);
       }
    }
     public PageReference mycancelpass()
    {
        PageReference pgRef = new PageReference('/apex/EventList');
        pgRef.setRedirect(false);
        return pgRef;
    }

    public class ConWrap{
        public Contact con{get;set;}
        public boolean bool{get;set;}
           
        public ConWrap(Contact c , Boolean b){
            con=c;
            bool = b;
        }
    }   
     public PageReference mycancelmail()
    {
        PageReference pgRef = new PageReference('/apex/EventList');
        pgRef.setRedirect(false);
        return pgRef;
    }
}