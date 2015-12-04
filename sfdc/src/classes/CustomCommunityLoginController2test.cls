@isTest
public class CustomCommunityLoginController2test 
{
    public static testMethod void testbyAjay() {
      
     contact con=new contact();
        con.FirstName='Ashu';
        con.LastName='Pal';
        con.email='ashu08@gmail.com';
        con.Password__c='ashu@1234';
        con.Phone='(00) 0000 0000';
        con.MailingState='delhi';
        con.MailingCountry='India';
        con.MailingStreet='Ashok Nagar';
        con.MailingPostalCode='210201';
        con.MailingCity='delhi';
            insert con;
        Contact cc = [SELECT id, Name FROM Contact];
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', cc.id);
      
        // Instantiate a new controller with all parameters in the page
              CustomCommunityLoginController2 controller = new CustomCommunityLoginController2();
        controller.str = cc.id;
        controller.oldmail = 'ashu08@gmail.com';
        controller.phoneNumber = '(00) 0000 0000';
        controller.addressPostalCode = 'asdfads';
        controller.addressCountry = 'asdf';
        controller.addressCity = 'asdf';
        controller.addressStreet = 'asdf';
        controller.mysavemail();
        controller.username = 'ashu08@gmail.com';
        controller.password = 'ashu@1234';
        controller.login();
        controller.cnfrmmail = 'ajay@gmail.com';
            controller.newmail = 'test@gmail.com';
            controller.companyName ='resasd';
            controller.tempPassword = 'asdfasdfas';
        controller.searchclass ='asdfasdf';
        controller.searchstring ='asdf';
 controller.tempshow();
    }
    
    public static testMethod void testMyController() {
      
     contact con=new contact();
        con.FirstName='Ashu';
        con.LastName='Pal';
        con.email='ashu08@gmail.com';
        con.Password__c='ashu@1234';
        con.Phone='(00) 0000 0000';
        con.MailingState='delhi';
        con.MailingCountry='India';
        con.MailingStreet='Ashok Nagar';
        con.MailingPostalCode='210201';
        con.MailingCity='delhi';
            insert con;
        Contact cc = [SELECT id, Name FROM Contact];
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', cc.id);
      
        // Instantiate a new controller with all parameters in the page
              CustomCommunityLoginController2 controller = new CustomCommunityLoginController2();
 
    }
    
    static testMethod void test()
        { 
       contact con=new contact();
        con.FirstName='Ashu';
        con.LastName='Pal';
        con.email='ashu08@gmail.com';
        con.Password__c='ashu@1234';
        con.Phone='(00) 0000 0000';
        con.MailingState='delhi';
        con.MailingCountry='India';
        con.MailingStreet='Ashok Nagar';
        con.MailingPostalCode='210201';
        con.MailingCity='delhi';
            insert con;
       CustomCommunityLoginController2 controller=new CustomCommunityLoginController2();
        controller.login();
        controller.forwardToCustomAuthPage();
        controller.authenticate();
        controller.getSelectedList();
        controller.display();
        controller.clear();
        controller.Next();
        controller.Previous();
        controller.first();
        controller.LastPage();
        controller.getprv();
        controller.getnxt();
        controller.getlst();
        controller.mysavemail();
        controller.mycancelpass();
        controller.mycancelmail();
      //  controller.tempshow();
        list<contact> co=new list<contact>();
         co.add(con);
        CustomCommunityLoginController2.ConWrap oWrapper = new CustomCommunityLoginController2.ConWrap(con,true);
       // system.assert(co.size()>0,'Error');
     } 
     
    static testMethod void Test2(){
      CustomCommunityLoginController2 controller=new CustomCommunityLoginController2();
       
       string searchstring='abc';
      contact con=new contact();
        con.FirstName='Ashu';
        con.LastName='Pal';        
        con.email='ashu08@gmail.com';
        con.Password__c='ashu@1234';
        con.Phone='(00) 0000 0000';
        con.MailingState='delhi';
        con.MailingCountry='India';
        con.MailingStreet='Ashok Nagar';
        con.MailingPostalCode='210201';
        con.MailingCity='delhi';
        
        con.Class_Of__c='new';
        con.Add_to_Directory__c=true;
            insert con;
        controller.tempshow();
        
       
       string searchclass='qwerty';
        contact con1=new contact();
        con1.FirstName='Ashu';
        con1.LastName='Pal'; 
         con1.Title='text';
         con1.email='ashu08@gmail.com';
        con1.Class_Of__c='s';
        con1.Account=con.Account;
         con1.Phone='(00) 0000 0000';
         con1.Class_Of__c='new';
        con1.Add_to_Directory__c=true;
        
        insert con1;
        controller.tempshow();
     }
     
   
}