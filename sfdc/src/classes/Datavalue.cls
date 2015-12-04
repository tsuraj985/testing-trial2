public class Datavalue 
{
    public list<Contact> contactList{get;set;}
    public contact contactObj{get;set;}
    
    public Datavalue(ApexPages.StandardController controller) {
            contactObj= new Contact();
    }


    
    public List<Contact> getContact() {
      contactList = new list<Contact>();
      contactList = [SELECT MobilePhone,HomePhone,Phone,Fax FROM Contact limit 100];
      return contactList;
    }
    public pageReference onSave(){
        try{
            insert contactObj;
        }catch(Exception e){
            system.Debug('***Error in inserting***'+e.getMessage());
        }
        return null;
    }
    }