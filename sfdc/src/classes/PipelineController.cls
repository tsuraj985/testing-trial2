global with sharing class PipelineController {
    
    public List<String> oppStageList{get;set;}
    public Boolean isChatterEnabled{get;set;}
    private String paramval = '';
   // public Boolean isACMEnabled{get;set;}
   // public String defaultCurrency{get;set;}   
    global Boolean isACMEnabled{get{return UserInfo.isMultiCurrencyOrganization();}set;}
    global String defaultCurrency{get{return UserInfo.getDefaultCurrency();}set;}
    
   
    public List<WrapFields> wrapFieldsList{get;set;}
    
    public String currencyInContext{get;set;}
    public Double defaultCurrConversionRate{get;set;}
    public Map<String, Double> currConversionValue{get;set;}
    public static boolean checkMultiCurrencyTestClass = false;    
    List<WrapCurrency> wrapCurrencyList = new List<WrapCurrency>();
    
    public class WrapCurrency{
        public String isoCode{get;set;}
        public Double conversionRate{get;set;}
        public Boolean isCorporate{get;set;}
        Public WrapCurrency(String isoCode, Double conversionRate,Boolean isCorporate){
            this.isoCode = isoCode;
            this.conversionRate = conversionRate;
            this.isCorporate = isCorporate;
        }
    }
    
    public void setDataForMulticurrency()
    {
        String currencyInContext = '';
        //String defaultCurr = UserInfo.getDefaultCurrency();
        String defaultCurr = defaultCurrency;
        Double defaultCurrConversionRate = 1;
        Map<String, Double> currConversionValue = new Map<String, Double>();    
        
        if(defaultCurr != null && defaultCurr != '')
        {
            currencyInContext = defaultCurr;
        }
        Integer currListSize = 0;
        
        if(checkMultiCurrencyTestClass || isACMEnabled)
        {
            if(!Test.IsRunningTest()){
                String dynamicQuery = 'Select ISOCode, ConversionRate, IsCorporate from CurrencyType';
                List<Sobject> currList = Database.Query(dynamicQuery);
                //system.debug('currList >> ' + currList);
                
                if(currList != null && currList.size() > 0){
                    for(Sobject rec : currList){
                        wrapCurrencyList.add(new WrapCurrency((String)rec.get('IsoCode'), (Double)rec.get('ConversionRate'), (Boolean)rec.get('IsCorporate')));
                    }
                }
            }
            
            if(Test.IsRunningTest()){               
                wrapCurrencyList.add(new WrapCurrency('USD', 1, true));
                wrapCurrencyList.add(new WrapCurrency('GBP', 1, false));
                wrapCurrencyList.add(new WrapCurrency('YEN', 1, false));
                wrapCurrencyList.add(new WrapCurrency('INR', 1, false));            
            }
            currListSize = wrapCurrencyList.size();
            
            
            for(Integer currencyCountTemp = 0; currencyCountTemp < currListSize; currencyCountTemp++)
            {
                WrapCurrency currType = wrapCurrencyList.get(currencyCountTemp);
                String isoCode = currType.isoCode;
                Double convRate = currType.conversionRate;
                if(currencyInContext == null || currencyInContext == '')
                {
                    if(currType.isCorporate)
                    {
                        currencyInContext = isoCode;
                        defaultCurrConversionRate = convRate;
                    }
                }
                else
                {
                    if(isoCode == currencyInContext)
                    {
                        defaultCurrConversionRate = convRate;
                    }
                }
                
            }
            
            if(currencyInContext == null || currencyInContext == '')
            {
                currencyInContext = 'USD';
                defaultCurrConversionRate = 1;
            }
        
            for(Integer currencyCount = 0; currencyCount < currListSize; currencyCount++)
            {
                WrapCurrency currType = wrapCurrencyList.get(currencyCount);
                String isoCode = currType.isoCode;
                Double convRate = currType.conversionRate;
                currConversionValue.put(isoCode, convRate/defaultCurrConversionRate);
            }
            //system.debug('$$$---'+currConversionValue);
        
        }
        
        if(currencyInContext == null || currencyInContext == '')
        {
            currencyInContext = 'USD';
            defaultCurrConversionRate = 1;
        }
        
        /*******NEED to be DELETED**************/
        
        if(Test.IsRunningTest()){
            currConversionValue.put('USD', 1);
            currConversionValue.put('GBP', 0.62);
            currConversionValue.put('YEN', 106.19);
            currConversionValue.put('INR', 60);
        }
        
        /***********************/
        
        this.currConversionValue = currConversionValue;
        this.currencyInContext = currencyInContext;
        this.defaultCurrConversionRate = defaultCurrConversionRate;
        //system.debug('currencyInContext>>> '+currencyInContext);
        //system.debug('defaultCurrConversionRate>>> '+defaultCurrConversionRate);
        //system.debug('currConversionValue>>> '+currConversionValue);
    }
    
   
   
    public class WrapFields{
        public String currencyIsoCodeValue{get;set;}
        public Opportunity opp{get;set;}
        public WrapFields(String str ,Opportunity opp){
            this.currencyIsoCodeValue = str;
            this.opp = opp;
        }                                           
    }
    
    String time1 = '';    
    String leadSourceValue = '';
    String opportunityTypeValue = '';
    String forecastCategoryValue = '';
    String openClosedValue = '';   
    String accountValue = '';
    String campaignValue = '';
    String stageValue = '';
    Boolean ownRecordValue = false;
    
    public PipelineController(){        
        // code added on 8 Sept 2014 starts ====
        //defaultCurrency = UserInfo.getDefaultCurrency();
        if(isACMEnabled){
            isACMEnabled = true;
        }
        else{
            isACMEnabled = false;
        }
        // code added on 8 Sept 2014 ends ====
        
        if(ApexPages.currentPage().getParameters().get('params') != null){
            paramval = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('params'));
            paramval = paramval.replace('\\\'','\'');
        }
        else{
            
        }
        
        oppStageList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe(); 
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry f : ple){
            //if(f.getLabel() != 'Closed Lost' && f.getLabel() != 'Closed Won'){
                oppStageList.add(f.getLabel()); 
            //}
        } 
        
        /**Code added to add the filter in the query starts here**/
        
        Boolean onLoadPipelineThisQuarter = false;
        List<Opportunity_Manager_Setting__c> ls = [select Id,Account__c,Open_Closed__c,Forecast_Category__c,Opportunity_Type__c,
                                                                    Lead_Source__c,Timeframe__c,Name, Save_Filers2__c, Save_Filers__c, 
                                                                    Save_Filers3__c,Campaign__c,Default_Values__c,Only_own_records__c,  
                                                                    Stage1__c
                                                                    from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
        system.debug('ls >>>>> '+ls);
        Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls); 
        if(!cs.keySet().isEmpty()){
            for(String s :cs.keySet()){
               if(cs.get(s).Timeframe__c != null){          
                    onLoadPipelineThisQuarter = true;              
                    time1 = cs.get(s).Timeframe__c; 
               }
               if(cs.get(s).Lead_Source__c != null && cs.get(s).Lead_Source__c != '--None--'){ 
                    leadSourceValue = cs.get(s).Lead_Source__c;
               }
               if(cs.get(s).Opportunity_Type__c != null && cs.get(s).Opportunity_Type__c != '--None--'){ 
                    opportunityTypeValue = cs.get(s).Opportunity_Type__c;
               }
               if(cs.get(s).Forecast_Category__c != null && cs.get(s).Forecast_Category__c != '--None--'){ 
                    forecastCategoryValue = cs.get(s).Forecast_Category__c;
               }
               if(cs.get(s).Open_Closed__c != null && cs.get(s).Open_Closed__c != '--None--'){ 
                    openClosedValue = cs.get(s).Open_Closed__c;
               }
               if(cs.get(s).Account__c != null && cs.get(s).Account__c != '--None--'){ 
                    accountValue = cs.get(s).Account__c;
               }
               if(cs.get(s).Campaign__c != null && cs.get(s).Campaign__c != '--None--'){ 
                    campaignValue = cs.get(s).Campaign__c;
               }
               //if(cs.get(s).Stage__c != null && cs.get(s).Stage__c != '--None--'){ 
                    //stageValue = cs.get(s).Stage__c;
               //}
               if(cs.get(s).Stage1__c != null && cs.get(s).Stage1__c != '--None--'){ 
                    stageValue = cs.get(s).Stage1__c;
               }
               if(cs.get(s).Only_own_records__c != null && cs.get(s).Only_own_records__c != false){ 
                    ownRecordValue = cs.get(s).Only_own_records__c;
               }    
            }
        }         
           
        /**Code added to add the filter in the query ends here**/
         List<string> onLoadFiltersList = new List<string>();      
        if(String.isNotEmpty(paramval)){
            paramval= EncodingUtil.urlDecode(paramval, 'UTF-8');
        } else {
             if(!String.isBlank(leadSourceValue)){
                leadSourceValue = 'LeadSource = ' + '\'' + leadSourceValue + '\''; 
                onLoadFiltersList.add(leadSourceValue);          
             }       
         
             if(!String.isBlank(opportunityTypeValue)){
                opportunityTypeValue = 'Type = ' + '\'' + opportunityTypeValue + '\'';
                onLoadFiltersList.add(opportunityTypeValue);             
             }
             
             if(!String.isBlank(forecastCategoryValue)){
                forecastCategoryValue = 'ForecastCategory = ' +  '\'' + forecastCategoryValue + '\'';  
                onLoadFiltersList.add(forecastCategoryValue);            
             }
             
             if(!String.isBlank(openClosedValue)){
                if(openClosedValue == 'Open'){
                    openClosedValue = 'IsClosed = false';        
                }
                else if(openClosedValue == 'Closed Won'){
                    openClosedValue = 'IsClosed = true AND IsWon = true';    
                }               
                else if(openClosedValue == 'Closed Lost'){
                    openClosedValue = 'IsClosed = true AND IsWon = false';    
                }                     
                onLoadFiltersList.add(openClosedValue);          
             }
             
             if(!String.isBlank(accountValue)){
                accountValue = 'AccountId = ' + '\'' + accountValue + '\'';                     
                onLoadFiltersList.add(accountValue);            
             }
             
             if(!String.isBlank(campaignValue)){
                campaignValue = 'CampaignId = ' + '\'' + campaignValue + '\'';                  
                onLoadFiltersList.add(campaignValue);           
             }
             
             if(!String.isBlank(stageValue)){ // if the database has some value then on page refresh only that stage's value is to be shown              
                String stageFilter = '';
                stageFilter += '(';
                String[] ss = stageValue.split(',');
                for(String a: ss){
                    stageFilter += '\'' + String.escapeSingleQuotes(a) + '\',';
                } 
                stageFilter = stageFilter.substring(0, stageFilter.length() -1) + ')';
                stageValue = 'StageName IN ' + stageFilter + ' ';
                system.debug('stageValue'+stageValue);               
                onLoadFiltersList.add(stageValue);
             }else{// if the database has no value all stages gets populated in query 
                for(String s: oppStageList){
                    system.debug('stageValue>>>'+s);
                }
                String ss = 'StageName IN :oppStageList';
                onLoadFiltersList.add(ss);
             }
             
             
             if(ownRecordValue){
                String ss1 = 'OwnerId = ' + '\'' +  UserInfo.getUserId() + '\'';                    
                onLoadFiltersList.add(ss1);         
             }
                             
             if(!String.isBlank(time1)){
                time1 = timeFrame(time1);
                onLoadFiltersList.add(time1); 
                //pageLoadcheck = true;         
             }
             if(onLoadFiltersList != null && onLoadFiltersList.size()>0){               
                    paramval = paramval + String.join(onLoadFiltersList,' AND ');                
                    paramval = paramval.trim();
                    String andCheck = paramval.substring(paramval.length()-4,paramval.length());
                    if(andCheck.contains('AND')){
                        paramval = paramval.subString(0,paramval.length()-4);
                    }
                
             }            
        }
        
        //============================
         string abc = ' AccountId = \'\' AND';
         if(paramval.indexOf(abc) != -1){
             paramval = paramval.replace(abc,' ');
         }
    
         string def = ' CampaignId = \'\' AND';
         if(paramval.indexOf(def) != -1){
             paramval = paramval.replace(def,' ');
         }
        //============================
        
        
        
        system.debug('paramval>>>> '+paramval);
        isChatterEnabled = checkChatterEnabled(); 
        
        wrapFieldsList();
        setDataForMulticurrency();
    }  
    
    public List<wrapFields> wrapFieldsList(){
        List<Opportunity> oppList = new List<Opportunity>();
        String dynamicQuery;
        if(isChatterEnabled){
                if(isACMEnabled){ 
                    dynamicQuery = String.format('SELECT Name, Amount,'
                                        + ' CurrencyIsoCode,'
                                        + ' StageName, AccountId,' 
                                        + ' Account.Name, Owner.Name,'
                                        + ' Owner.SmallPhotoUrl' 
                                        + ' FROM Opportunity'
                                        + ' WHERE {0}'
                                        + ' ORDER BY Createddate'
                                        + ' LIMIT 9999', 
                                        new List<String>{paramval});}
                else{
                    dynamicQuery = String.format('SELECT Name, Amount,'  
                                        + ' StageName, AccountId,' 
                                        + ' Account.Name, Owner.Name,'
                                        + ' Owner.SmallPhotoUrl' 
                                        + ' FROM Opportunity'
                                        + ' WHERE {0}'
                                        + ' ORDER BY Createddate'
                                        + ' LIMIT 9999', 
                                        new List<String>{paramval});}
           
            
        } 
        else {
                if(isACMEnabled){
                    dynamicQuery = String.format('SELECT Name, Amount,' 
                                        + ' CurrencyIsoCode,'
                                        + ' StageName, AccountId,' 
                                        + ' Account.Name, Owner.Name'
                                        + ' FROM Opportunity'
                                        + ' WHERE {0}'
                                        + ' ORDER BY Createddate'
                                        + ' LIMIT 9999', 
                                        new List<String>{paramval});}
                else{
                    dynamicQuery = String.format('SELECT Name, Amount,' 
                                        + ' StageName, AccountId,' 
                                        + ' Account.Name, Owner.Name'
                                        + ' FROM Opportunity'
                                        + ' WHERE {0}'
                                        + ' ORDER BY Createddate'
                                        + ' LIMIT 9999', 
                                        new List<String>{paramval});}
            
        } 
        /*if(isChatterEnabled){
        
            dynamicQuery = String.format('SELECT Name, Amount,'  
                                        + ' StageName, AccountId,' 
                                        + ' Account.Name, Owner.Name,'
                                        + ' Owner.SmallPhotoUrl' 
                                        + ' FROM Opportunity'
                                        + ' WHERE {0}'
                                        + ' ORDER BY Createddate'
                                        + ' LIMIT 1000', 
                                        new List<String>{paramval});
            
        } else {
            dynamicQuery = String.format('SELECT Name, Amount,' 
                                        + ' StageName, AccountId,' 
                                        + ' Account.Name, Owner.Name'
                                        + ' FROM Opportunity'
                                        + ' WHERE {0}'
                                        + ' ORDER BY Createddate'
                                        + ' LIMIT 1000', 
                                        new List<String>{paramval});
        }*/
     //   system.debug('>>>>>>>>' + dynamicQuery);
        if(dynamicQuery != null && dynamicQuery != ''){
            oppList = Database.query(dynamicQuery); 
        }
        wrapFieldsList = new List<WrapFields>();
        //system.debug('checking if OppList is not nullllll or blank');
        if(oppList != null && oppList.size()>0){
            //system.debug('OppList is not nullllll or blank');
            Integer count = 0;
            for(Opportunity rec :oppList){
                //system.debug('Counting opportunities::::::::::::::' + ++count);
                Boolean isDefaultCurrentSet = true;
                if(isACMEnabled)
                {
                    String currIsoCodeTmp = (string)rec.get('CurrencyIsoCode');
                    if(currIsoCodeTmp != null && currIsoCodeTmp != '')
                    {
                        wrapFieldsList.add(new WrapFields(currIsoCodeTmp, rec));
                    } else { isDefaultCurrentSet = false; }
                }
                else
                {
                    isDefaultCurrentSet = false;
                }
                
                if(!isDefaultCurrentSet)
                {
                    if(defaultCurrency != null && defaultCurrency != '')
                    {
                        wrapFieldsList.add(new WrapFields(defaultCurrency, rec));
                    } else { wrapFieldsList.add(new WrapFields('', rec)); }
                }
            }
        }
        //system.debug('wrapFieldsList>>> '+wrapFieldsList.size() + ' >> ' + wrapFieldsList);
        return wrapFieldsList;
//        return oppList;    
    }
    
    public String timeFrame(String timeValue){
        String totalFilter = '';
        Date startDate;
        Date endDate;
        String time1= timeValue;
        Date todayDate = Date.today();
        if(time1 == '1 Week') {
        
            endDate = todayDate;
            startDate = endDate.addDays(-6);        
        } else if(time1 == '1 Month'){
        
            endDate = todayDate;
            startDate = endDate.addMonths(-1);    
        } else if(time1 == '3 Months'){
        
            endDate = todayDate;  
            startDate = endDate.addMonths(-3);      
        } else if(time1 == '6 Months'){
        
            endDate = todayDate;  
            startDate = endDate.addMonths(-6);    
        } else if(time1 == '12 Months'){
        
            endDate = todayDate;  
            startDate = endDate.addMonths(-12);    
        } else if(time1 == 'This Week'){ 
        
            startDate = todayDate.toStartOfWeek();
            endDate = startDate.addDays(6);
        } else if(time1 == 'This Month'){ 
           
            startDate = todayDate.toStartOfMonth();
            endDate = startDate.addMonths(1).addDays(-1);     
        } else if(time1 == 'This Quarter'){ 
        
            integer monthoffset = Math.mod(todayDate.month(), 3);
            if(monthoffset > 0){
                startDate = todayDate.addMonths(1 - monthoffset).toStartOfMonth();        
            } else {
                startDate = todayDate.addMonths(-2).toStartOfMonth();    
            }
            endDate = startDate.addMonths(3).addDays(-1);    
        } else if(time1 == 'This Year'){ 
        
            startDate = Date.newInstance(todayDate.year(), 1, 1);
            endDate = startDate.addYears(1).addDays(-1);
            //startDate = Date.today().   
        } else if(time1 == 'Last Week'){
        
            startDate = todayDate.toStartOfWeek().addDays(-1);
            endDate = startDate.addDays(6); 
        } else if(time1 == 'Last Month'){ 
            
            startDate = todayDate.toStartOfMonth();
            endDate = startDate.addMonths(-1);    
            startDate = startDate.addDays(-1);
            
        } else if(time1 == 'Last Quarter'){ 
        
            todayDate = todayDate.addMonths(-3);
            integer monthoffset = Math.mod(todayDate.month(), 3);
            if(monthoffset > 0){
                startDate = todayDate.addMonths(1 - monthoffset).toStartOfMonth();        
            } else {
                startDate = todayDate.addMonths(-2).toStartOfMonth();    
            }
            endDate = startDate.addMonths(3).addDays(-1);    
            
        } else if(time1 == 'Last Year'){ 
        
            startDate = Date.newInstance( (todayDate.year() -1) , 1, 1);
            endDate = startDate.addYears(1).addDays(-1);
            
        }  else if(time1 == 'All time'){ 
            // no date filter        
        }
        //if(onLoadChartThisQuarter){
       // String paramTotalFilterTimeFrameCheck = 'CloseDate >='  + String.valueOf(startDate) +  ' AND  CloseDate <='  + String.valueOf(endDate); 
        if(startDate != NULL && endDate != NULL) {
            totalFilter += ' CloseDate >='  + String.valueOf(startDate) +  ' AND  CloseDate <='  + String.valueOf(endDate);
        }
        return totalFilter;
    }
    // check if chatter is enabled or not
    
    private Boolean checkChatterEnabled(){
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        if(gd.containsKey('FeedItem')){
           //system.debug('Chatter is enabled!');
           return true;
        }
        else{
           //system.debug('Chatter is disabled!');
           return false;
        }
    }
    
    
    @RemoteAction
    global static String changeOpportunityStage(String oppId, String oldStage, String newStage) {
        if((oldStage != newStage) && String.isNotEmpty(oppId)){
            Opportunity opp = new Opportunity(Id=oppId, StageName = newStage);
            try {
                if (Schema.sObjectType.Opportunity.fields.StageName.isUpdateable()){
                    update opp; }else{ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));}
                opp = [SELECT Id, StageName, Amount 
                        FROM Opportunity 
                        WHERE Id = :opp.Id 
                        LIMIT 1];   
                        
                return '{\"Records\":' + JSON.serialize(opp) +',\"error\": null, \"status\":\"SUCCESS\"}'; } catch(Exception e) {return '{\"Records\":' + JSON.serialize(opp) +', \"error\": \"' + e.getMessage() + '\", \"status\":\"FAILURE\" }';          
            } }return '{\"Records\":null, \"error\": \"Invalid opportunity Id or StageName\", \"status\":\"FAILURE\" }';
    }
    
    
    @RemoteAction
    global static String deleteOpportunity(String oppId) {
        if(String.isNotEmpty(oppId)){
            Opportunity opp = new Opportunity(Id=oppId);
            
                try{
                    if (Opportunity.sObjectType.getDescribe().isDeletable()){
                        delete opp;
                    }else{ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));}}catch(DmlException e) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                    //System.debug('The following exception has occurred: ' + e.getMessage());
                }         
            return '{\"status\":\"SUCCESS\"}';}return '{\"error\": \"Invalid opportunity Id or StageName\", \"status\":\"FAILURE\"}';                   
    }
    
    @RemoteAction
    global static String UScurrencyformat(String totalAmountValue){
        string totalAmountVal = '870 '+ totalAmountValue;        
        return '{\"Records\":' + JSON.serialize(totalAmountVal) +',\"error\": null, \"status\":\"SUCCESS\"}';
    }
        
        
}