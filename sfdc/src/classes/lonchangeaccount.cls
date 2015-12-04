public with sharing class lonchangeaccount{
        public id aid{get;set;}
        public boolean render{get;set;}
      
        List<selectoption> options=new List<selectoption>();
        public  List<Contact> lstcont{get;set;}
        public lonchangeaccount(){
                    lstcont=new List<contact>();
           
            }
      
        Map<id,List<contact>> maplstcont=new Map<id,List<contact>>();
        public List<SelectOption>  getValues(){
                options.add(new selectOption('--None--','--None--'));
                for(Account acc:[select id,name,(select id,name,email from contacts)from account limit 10]){
                    options.add(new selectOption(acc.id,acc.name));
                    maplstcont.put(acc.id,acc.contacts);
               
                }
                return options;
        }
        public void  Contactlst(){
                        lstcont.clear();
                       if(aid!=null){
                            render=true;
                            lstcont.addAll(maplstcont.get(aid));
                        }
         }
}