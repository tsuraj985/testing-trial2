public with sharing class addAttendee {
public Account accounts;
 public Contact del;
 public List<Contact> addattendeeList {get;set;}
 public List<Contact> delattendeeList {get;set;}
 public List<Contact> attendeeList {get;set;}
 public Integer totalCount {get;set;}
 public Integer rowIndex {get;set;}
 
 public List<Contact> delAttendees {get; set;} 
 public addAttendee(ApexPages.StandardController controller) {
 
 accounts = (Account)controller.getRecord();
 attendeeList = [Select id, firstName, LastName, Email, Phone from Contact where AccountId =: accounts.Id];
 totalCount = attendeeList.size();
 
 delattendeeList = new List<Contact>();
 delattendees = new List<Contact>();
 }
 
 public void addRow(){
 addattendeeList = new List<Contact>();
 attendeeList.add(new Contact(AccountId = accounts.Id));
 }
 
 public PageReference ave(){
 
 upsert attendeeList;
 delete delattendeeList;
 return (new ApexPages.StandardController(accounts)).view();
 } 
 
 public void deleteRow(){
 
 rowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
 System.debug('rowbe deleted ' + rowIndex );
 System.debug('rowm to be deleted '+attendeeList[rowIndex]);
 del = attendeeList.remove(rowIndex);
 delattendeeList.add(del);
 
 }
 }