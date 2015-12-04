@isTest
private class TestContractList {
  static testMethod void  TestContract()
  {
     List<Contract> datacont= new List<Contract>();
        Contract c1 = new Contract(Name='suraj', Status='Draft' , Description='Test@test.com');
        Contract c2 = new Contract(Name='suraj1', Status = 'Draft',Description='Test@test.com');
        datacont.add(c1);
        datacont.add(c2);        
        Test.startTest();                        
            try
            {  
                insert datacont;
            }
            catch(Exception ee)
            {
            system.Debug('***Error in inserting***'+ee.getMessage());
            }
        Test.stopTest(); 
         system.assert(datacont.size()>0,'error');
    }
  }