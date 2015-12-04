trigger insertContactTriggerCG on Account (after insert) {
    list<Contact> contactList = new list<Contact>();
    for (Account acc : trigger.new){
        Contact conTest = new contact();
        conTest.LastName = 'TestCG';
        conTest.Accountid = acc.id;
        contactList.add(conTest);
    }
    insert contactList;
}