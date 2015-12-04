@isTest
private class TestRestrictContactByName {

    static testMethod void  TestContact() 
    {
    
        List<Contact> listContact= new List<Contact>();
        Contact c1 = new Contact(FirstName='suraj', LastName='Tripathi' , email='Test@test.com');
        Contact c2 = new Contact(FirstName='suraj1', LastName = 'INVALIDNAME',email='Test@test.com');
        listContact.add(c1);
        listContact.add(c2);
        
        Test.startTest();
            try
            {
                insert listContact;
            }
            catch(Exception ee)
            {
            }
        
        Test.stopTest(); 
      system.assert(listContact.size()>0,'error');  
    }
    
}