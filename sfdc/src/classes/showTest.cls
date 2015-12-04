@isTest
private class showTest {
      static testMethod void testMyController() {
      PageReference pageRef = new PageReference('/apex/StandardCampaign'); 
          ApexPages.StandardController sc = new ApexPages.standardController(new Account());
          show  showObj =new show();
          show s1Obj = new show(sc);
          
          showObj.onsave();
       System.assertNotEquals(null,pageRef);
    }
    
}