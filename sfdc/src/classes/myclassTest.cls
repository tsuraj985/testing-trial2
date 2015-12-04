@IsTest
public class myclassTest
{
static testMethod void tableConTest()
    {
    myclass Account = new myclass();
    Account acc=new Account();
    acc.Name='HelloDummy';
    acc.Site='delhi';
    acc.NumberOfEmployees=6;
    insert acc;
    
    Account tempAcc= new Account();
    tempAcc.Name='HelloDummy2';
    tempAcc.Site='Goa';
    tempAcc.NumberOfEmployees=4;
      try{
            insert tempAcc;
           }
        catch(exception e)
        {
            system.debug('tempAcc'+e.getMessage());
        }
      System.assertEquals(25, acc.NumberOfEmployees); 
    }    
}