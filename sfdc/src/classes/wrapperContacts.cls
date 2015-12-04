public class wrapperContacts{
    public list<WrapperContactsDemo> wrapperListContacts{get;set;}
     public wrapperContacts(){
     wrapperListContacts= new list<WrapperContactsDemo>();
     for(Contact con:[SELECT id, LastName From Contact limit 10]){
        wrapperListContacts.add(new wrapperContactsDemo(con));
          }  
       }
       public class wrapperContactsDemo{
       public Contact contact{get;set;}
        public boolean isChecked{get;set;}
        public wrapperContactsDemo(){
        
        }
        public wrapperContactsDemo(Contact contact){
            this.contact = contact;
            this.isChecked = false;
        }
        public wrapperContactsDemo(Contact contact , boolean isChecked){
            this.contact = contact;
            this.isChecked = ischecked;
        }
    }
    public void deleteContact(){
        list<Contact> conList = new list<Contact>();
        for(wrapperContactsDemo wrapperMain : wrapperListContacts){
            if(wrapperMain.isChecked){
                conlist.add(wrapperMain.contact);
            }
        }
        delete conList;
    }
       
}