public class RandomContactFactory 
{
     public static List<Contact> generateRandomContacts(Integer numConts, String lastNameOfConts) 
     {
         List<Contact> conts = new List<Contact>();
         for(Integer i=0;i<numConts;i++) 
         {
            Contact con = new Contact(FirstName='TestContact' + i,LastName='lastNameOfConts');
            conts.add(con);
         }
        return conts;
     }
}