public class ContactAndLeadSearch{

    public static List<List<SObject>> searchContactsAndLeads(String first)
    {
         List<List<sObject>> searchList=[FIND 'Smith' IN ALL FIELDS RETURNING Lead(FirstName,LastName),Contact(FirstName,LastName)];
            return searchList;
     }
}