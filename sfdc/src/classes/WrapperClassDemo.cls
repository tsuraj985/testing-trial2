public with sharing class WrapperClassDemo{
    public list<WrapperMainDemo> wrapperListDemo{get;set;}
    public WrapperClassDemo(){
        wrapperListDemo = new list<WrapperMainDemo>();
        for(Account acc : [SELECT id,name FROM Account limit 10]){
            wrapperListDemo.add(new WrapperMainDemo(acc));
        }
    }
    
    public class WrapperMainDemo{
        public Account account{get;set;}
        public boolean isChecked{get;set;}
        public WrapperMainDemo(){
        
        }
        public WrapperMainDemo(Account account){
            this.account = account;
            this.isChecked = false;
        }
        public WrapperMainDemo(Account account , boolean isChecked){
            this.account = account;
            this.isChecked = ischecked;
        }
    }
    public void deleteMyAccount(){
        list<Account> accList = new list<Account>();
        for(WrapperMainDemo wrapperMain : wrapperListDemo){
            if(wrapperMain.isChecked){
                acclist.add(wrapperMain.account);
            }
        }
        delete accList;
    }
    
}