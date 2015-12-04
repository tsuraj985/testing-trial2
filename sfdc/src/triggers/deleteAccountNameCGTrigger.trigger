trigger deleteAccountNameCGTrigger on Contact (after insert,after update,before delete) {
        list<Account> accountList=new list<account>();
    if(trigger.isInsert || trigger.isUpdate){
        for(Contact con:[SELECT Accountid,Account.Name,LastName FROM Contact WHERE Id In:trigger.new]){
            if (con.Account.Name!=NULL){
                con.Account.Name+=con.LastName;
                accountList.add(con.Account);
            }
        }
    }
    else if(trigger.isDelete){
        for(Contact con : [SELECT Accountid,Account.Name,LastName FROM Contact WHERE Id In:trigger.old]){
            con.Account.Name=con.Account.Name.replace(con.LastName,'');
            accountList.add(con.Account);
            }        
    }
    update accountList;
    }