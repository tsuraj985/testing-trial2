global class BatchDemo implements Database.Batchable<Sobject>{
   global integer j=1;
   global Database.QueryLocator start(Database.BatchableContext BC){
      String query = 'SELECT id FROM Account'; 
      return Database.getQueryLocator([SELECT id FROM Account limit 10]);
   }
   global void execute(Database.BatchableContext BC, List<Account> scope){
       integer i = 1;
       for(Account sobj : scope){
           Account acc =(Account) sobj;
           acc.name = 'Test'+j;
           j++;
       }
       update scope; 
   }
   global void finish(Database.BatchableContext BC){
   }
}