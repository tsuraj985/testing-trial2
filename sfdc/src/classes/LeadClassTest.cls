@isTest
public class LeadClassTest {

 public static testMethod void testMyController() {
 PageReference pageRef = new PageReference('/apex/StandardCampaign'); 
        Test.setCurrentPage(pageRef);
 Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'standt', Email='standarduser2372387@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='s1tandarduse89233287r@testorg.com');

      System.runAs(u) {
           
      Lead ld = new Lead(LastName='Test', Company='Test1', Status='New');
        insert ld;

        DataLead controller = new DataLead(new ApexPages.StandardController(ld));
        controller.getLeads();
        List<Lead> op = new List<Lead>();
        op.add(new Lead(firstName='asdfasdf',LastName='asdf', Company='asdfasdf'));
        controller.leadList = op;
        controller.onSave();
        system.assert(op.size()>0,'error');
        }
             

}
public static testMethod void testMyController34() {
 PageReference pageRef = new PageReference('/apex/StandardCampaign'); 
        Test.setCurrentPage(pageRef);
 Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'standt', Email='standarduser2372387@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='s1tandarduse89233287r@testorg.com');

      System.runAs(u) {

 Contact ld = new contact(LastName='asdfasdf');
        insert ld;
        Datavalue controller = new Datavalue(new ApexPages.StandardController(ld));
        controller.getContact();
        List<Contact> op = new List<Contact>();
        op.add(new Contact(LastName='asdfasdf'));
        controller.contactList = op;
        controller.onSave();
        system.assert(op.size()>0,'error');
        }

}

public static testMethod void testMyController3432() {
 PageReference pageRef = new PageReference('/apex/StandardCampaign'); 
        Test.setCurrentPage(pageRef);
 Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'standt', Email='standarduser2372387@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='s1tandarduse89233287r@testorg.com');

      System.runAs(u) {
           
      Account ld = new Account(Name='asdfasdf',NumberOfEmployees=23);
        insert ld;

        DataTable controller = new DataTable(new ApexPages.StandardController(ld));
        controller.getAccounts();
        List<Account> op = new List<Account>();
        op.add(new Account(Name='asdfasdf',NumberOfEmployees=23));
        controller.accountList= op;
        controller.onSave();
        system.assert(op.size()>0,'error');
        }

}
public static testMethod void testMyController343asdf2() {

 PageReference pageRef = new PageReference('/apex/StandardCampaign'); 
        Test.setCurrentPage(pageRef);
 Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'standt', Email='standarduser2372387@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='s1tandarduse89233287r@testorg.com');

      System.runAs(u) {
      
       Contract id = new Contract(Name='asdfasdf',StartDate=date.today(), Status='Draft',ContractTerm=3); 
   try{    
        insert id;   
        }
        catch (exception ee)
        {
        } 
        datacont controller = new datacont(new ApexPages.StandardController(id));
        controller.getContract();
        List<Contract> op = new List<Contract>();
        op.add(new contract(Name='asdfasdf',StartDate=date.today(), Status='Draft',ContractTerm=3));
        controller.ContractList= op;
        controller.onSave();
        system.assert(op.size()>0,'error');
        }

}
/**
public static testMethod void testMyController3s2() {
Account ui = new Account();
ui.getAccounts();
Account ld = new Account(Name='asdfasdf',NumberOfEmployees=23);
        insert ld;

PageBlockTable op = new PageBlockTable(new ApexPages.StandardController(ld));
**/


public static testMethod void testMyControllf2() {

 PageReference pageRef = new PageReference('/apex/StandardCampaign'); 
        Test.setCurrentPage(pageRef);
 Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'standt', Email='standarduser2372387@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='s1tandarduse89233287r@testorg.com');

      System.runAs(u) {
        
      Case ld = new Case(Origin='Phone',  Status = 'New');
            try{    
        insert ld;   
        }
        catch (exception ee)
        {
        } 

        newCase controller = new newCase(new ApexPages.StandardController(ld));
        controller.getCases();
        List<Case> op = new List<Case>();
        op.add(new Case(Origin='Phone',  Status = 'New'));
        controller.caseList= op;
        controller.onSave();
        system.assert(op.size()>0,'error');   
        }

}

}