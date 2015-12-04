@isTest
public class RandomContactFactoryTest
{
    static testMethod void ContactFactoryTest()
    {
        Contact[] con = RandomContactFactory.generateRandomContacts(1,'pal'); 
      system.assert(con.size()>0,'error');  
    }
    
}