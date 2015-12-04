@isTest(SeeAllData=true)  
public class nextPreviousButtonTest {
     public static testMethod void testMyController() {
         Account acc = new Account();
         acc.Name = 'test';
         acc.Type = 'Prospect';
         acc.BillingCity = 'abc';
         acc.BillingState = 'UP';
         acc.BillingCountry = 'IND';
         insert acc;
         
      // PageReference pageRef = new PageReference('/apex/StandardCampaign'); 
       //Test.setCurrentPage(pageRef);
        nextButton  nextButtonObj =new nextButton();
         nextButtonObj.getAccounts();
         nextButtonObj.Refresh();
        System.assertEquals('prospect', acc.Type);

     }

}