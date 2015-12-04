global with sharing class OppLookupController_Cls{

   
    public OppLookupController_Cls(ExtjsOppController_Cls controller) {
         ExtjsOppController_Cls controller1= (ExtjsOppController_Cls) controller;
    }

/*
    public OppLookupController_Cls(ExtjsOppController_Copy controller) {

    }


    //All variables declaration    
    public OppLookupController_Cls(ExtjsOppController controller) {
    ExtjsOppController controller1= (ExtjsOppController) controller;
       
    }
*/    
    public OppLookupController_Cls(){      
         
    }  
    
    public OppLookupController_Cls(ApexPages.StandardController controller){
         
    }
    /* Object used to populate reference to user */
    public Opportunity opp{get;set;}
    @RemoteAction
    global static String getAccountData(String oppId){
    
        Account accRecord = [SELECT Name,Phone ,Site, Owner.Name, Type FROM Account WHERE Id = : oppId];
        // These methods are for serializing  Apex objects into JSON format available since Winter’12 release
        // Find out more at http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_methods_system_json.htm
        String JSONString = JSON.serialize(accRecord);
        //Depends on your needs and way you want to format your result. Lets just hardcode the status value for now.
        return '{"Records":' +JSONString+', "error": "null", "status":"SUCCESS"}';
    }
}