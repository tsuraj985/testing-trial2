public with sharing class ChartExt_Cls {
    
    public String timeframegroup {get;set;}
    public String aggregateField {get;set;}
    public String groupbyField {get;set;}
    public transient String recordjson{get; private set;}
    public String paramval;
    public String chartType{get; private set;}
    public Set<String> jsonFields{get; private set;}
    public string displayText{get;set;}
    public static  List<String> filterValuesList {get; set;}
    public string isLoad{get;set;} 
    public Boolean onLoadChartThisQuarter = false;
    public String time1 = '';
    
    String leadSourceValue = '';
    String opportunityTypeValue = '';
    String forecastCategoryValue = '';
    String openClosedValue = '';   
    String accountValue = '';
    String campaignValue = '';
    String stageValue = '';
    Boolean ownRecordValue = false;
    
    public ChartExt_Cls() {  
        
        paramval = ApexPages.currentPage().getParameters().get('filterparams');
        ////system.debug('paramval!!!!!!!!!!!!!!!!!!!'+paramval);
        paramval = string.escapesinglequotes(paramval);
        system.debug('paramval!!!!!!dsvfsdf!!!!!!!!!!!!!'+paramval);
        if(String.isNotEmpty(paramval)){
            string whereclause = 'WHERE';
            ////system.debug('paramval ####'+paramval);
            paramval= whereclause + EncodingUtil.urlDecode(paramval, 'UTF-8');
            ////system.debug('paramval ####'+paramval);
            //paramval = string.escapeSingleQuotes(paramval);
        } else {
            ////system.debug('paramval #### else'+paramval);
            paramval = '';
        }
        
        ////system.debug('<<paramval>>' + paramval); 
        List<Opportunity_Manager_Setting__c> ls = [select Id,Account__c,Open_Closed__c,Forecast_Category__c,Opportunity_Type__c,
                                                                    Lead_Source__c,Timeframe__c,Name, Save_Filers2__c, Save_Filers__c, 
                                                                    Save_Filers3__c,Campaign__c,Default_Values__c,Only_own_records__c,  
                                                                    Stage1__c
                                                                    from Opportunity_Manager_Setting__c 
                                                                    where OwnerId =:UserInfo.getUserId() limit 1];
        Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls); 
        //Map<string,Opportunity_Manager_Setting__c> cs = Opportunity_Manager_Setting__c.getAll(); 
            if(!cs.keySet().isEmpty()){
                for(String s :cs.keySet()){
                       if(cs.get(s).Timeframe__c != null && cs.get(s).Timeframe__c == 'This Quarter'){
                            onLoadChartThisQuarter = true;
                            time1 = 'This Quarter';
                       }
                       else if(cs.get(s).Timeframe__c != null){
                            time1 = cs.get(s).Timeframe__c; 
                       }
                       if(cs.get(s).Save_Filers__c != null ){
                           timeframegroup = cs.get(s).Save_Filers__c; 
                       }
                       
                       if(cs.get(s).Save_Filers2__c != null ){
                           aggregateField = cs.get(s).Save_Filers2__c;
                       }
                       
                       if(cs.get(s).Save_Filers3__c != null ){ 
                            groupbyField = cs.get(s).Save_Filers3__c;
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
                       
                            
                       else{
                            chartType = 'pie';
                       }
                }
            }
            else{
                time1 = 'This Quarter';
            }
        ////system.debug('timeframegroup>>>>>>>>>>'+timeframegroup);
        //timeframegroup = 'All';
        //aggregateField = 'Count';
        //groupbyField = 'Stage';
        //chartType = 'pie';
        jsonFields = new Set<String>();        
        init();
        ////system.debug('>>>>--------'+isLoad);
    }
    
    public void init(){  
    //isLoad = isLoad;      
    fetchAggregateData();
    }
    
    public String timeFrame(String timeValue){
        String totalFilter='';
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
        if(startDate != NULL && endDate != NULL) {
            totalFilter += ' CloseDate >='  + String.valueOf(startDate) +  ' AND  CloseDate <='  + String.valueOf(endDate);
        }
        system.debug('totalFilter'+totalFilter);
        return totalFilter;
    }
    
    public void fetchAggregateData() {
        
        String totalFilter = '';
        filterValuesList = new List<string>();
        jsonFields = new Set<String>();
        String groupfieldapi = getGroupByValue();
        List<string> onLoadFiltersList = new List<string>();
        List<AggregateResult> aggregateResult = new List<AggregateResult>();
        
        string getAggregateValueCheck = getAggregateValue();
        if(!String.isBlank(getAggregateValueCheck)){     
            if(paramval != null && paramval.Trim() != ''){
                 string abc = ' AccountId = \'\' AND';
                 if(paramval.indexOf(abc) != -1){                
                     paramval = paramval.replace(abc,' ');
                 }
                 if(paramval.indexOf(' AccountId = \'\'') != -1){
                    paramval = paramval.replace(' AccountId = \'\'',' ');
                 }
                 string def = ' CampaignId = \'\' AND';
                 if(paramval.indexOf(def) != -1){            
                     paramval = paramval.replace(def,' ');
                 }  
                 if(paramval.indexOf(' CampaignId = \'\'') != -1){
                    paramval = paramval.replace(' CampaignId = \'\'',' ');
                 }
                 paramval = paramval.Trim();    
             }
             else{
                 if(!String.isBlank(leadSourceValue)){
                    leadSourceValue = 'LeadSource = ' + '\'' + leadSourceValue + '\''; 
                    onLoadFiltersList.add(leadSourceValue);     
                      system.debug('paramVal'+onLoadFiltersList);        
                 }       
             
                 if(!String.isBlank(opportunityTypeValue)){
                    opportunityTypeValue = 'Type = ' + '\'' + opportunityTypeValue + '\'';
                    onLoadFiltersList.add(opportunityTypeValue);   
                      system.debug('paramVal'+onLoadFiltersList);        
                 }
                 
                 if(!String.isBlank(forecastCategoryValue)){
                    forecastCategoryValue = 'ForecastCategory = ' +  '\'' + forecastCategoryValue + '\'';  
                    onLoadFiltersList.add(forecastCategoryValue);
                      system.debug('paramVal'+onLoadFiltersList);            
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
                      system.debug('paramVal'+onLoadFiltersList);        
                 }
                 
                 if(!String.isBlank(accountValue)){
                    accountValue = 'AccountId = ' + '\'' + accountValue + '\'';                     
                    onLoadFiltersList.add(accountValue);  
                      system.debug('paramVal'+onLoadFiltersList);       
                 }
                 
                 if(!String.isBlank(campaignValue)){
                    campaignValue = 'CampaignId = ' + '\'' + campaignValue + '\'';                  
                    onLoadFiltersList.add(campaignValue);    
                      system.debug('paramVal'+onLoadFiltersList);       
                 }
                 
                 if(!String.isBlank(stageValue)){
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
                      system.debug('paramVal'+onLoadFiltersList);
                 }
                 
                 if(ownRecordValue){
                    String ss1 = 'OwnerId = ' + '\'' +  UserInfo.getUserId() + '\'';                    
                    onLoadFiltersList.add(ss1);  
                      system.debug('paramVal'+onLoadFiltersList);       
                 }
                                 
                 if(!String.isBlank(time1)){
                    system.debug(onLoadFiltersList.size());
                    time1 = timeFrame(time1);
                    onLoadFiltersList.add(time1); 
                    //pageLoadcheck = true;         
                 }
                 String toCheckSize ='';
                 for(String str:onLoadFiltersList){
                    toCheckSize+=str;
                 }
                 system.debug(onLoadFiltersList.size());
                 if(onLoadFiltersList != null && !onLoadFiltersList.isEmpty() && toCheckSize.length()>0){
                    if(String.isBlank(paramval)){
                        paramval = ' WHERE ';
                     }
                     
                     paramval = paramval + String.join(onLoadFiltersList,' AND '); 
                     paramval = paramval.trim();
                     String andCheck = paramval.substring(paramval.length()-4,paramval.length());
                     if(andCheck.contains('AND')){
                        paramval = paramval.subString(0,paramval.length()-4);
                     }
                 }  
             }
             system.debug('paramVal'+paramVal);
             try{
                {
                    system.debug('SELECT '+getAggregateValue()+','+groupfieldapi+' FROM Opportunity ' + paramval + ' GROUP BY '+groupfieldapi+' ORDER BY '+groupfieldapi);
                    aggregateResult = Database.query('SELECT '+getAggregateValue()+','+groupfieldapi+' FROM Opportunity ' + paramval + ' GROUP BY '+groupfieldapi+' ORDER BY '+groupfieldapi);
                }
            }
            catch(Exception Ex){
                if(Ex.getMessage().contains('Too many')){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.info, 'More Records to display. Please Select Filter Wisely.');
                    ApexPages.addMessage(msg);
                }
            }
           system.debug('aggregateResult>>>>>>' + aggregateResult);
        }
        else{////system.debug('else>>>>>>' + aggregateResult);
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.info, 'Please Click on the Reset Filter Button');
            ApexPages.addMessage(msg);
        }
        List<ModelWrapper> wrapObj = new List<ModelWrapper>();  
        String aggnamefield = groupfieldapi;
        
        // get name from field if field name like Account.Name
        
        ////system.debug('####' + aggregateResult);
        if(!aggregateResult.isEmpty()){
            if(aggnamefield.contains(',')){
            
                List<String>  resultFieldList = aggnamefield.split(',');
                String minorgroup = resultFieldList[resultFieldList.size() - 1].trim();
                String minorvalue;
                String groupnew;
                String groupprev;
                String separator;
                
               // get field name fro fields like Account.Name
               if(minorgroup.indexOf('.') != -1){
                   minorgroup = minorgroup.substring(minorgroup.lastIndexOf('.') + 1, minorgroup.length());   
               }
               
                JSONGenerator gen = JSON.createGenerator(false);
                gen.writeStartArray();
              ////system.debug('aggregateResult>>>>>>>>>>>>>>'+aggregateResult);
              ////system.debug('resultFieldList>>>>>>>>>>>>>>'+resultFieldList);
                for (AggregateResult a :aggregateResult) {
                   
                    if(resultFieldList.size() == 2){
                    ////system.debug('aggregateResult>>>>>>>>>>>>>>'+aggregateResult);
                        groupnew = String.valueOf(a.get('expr1')); 
                    } else if(resultFieldList.size() == 3) {
                    ////system.debug('aggregateResult>>>>>>>>>>>>>>'+aggregateResult);
                        if(timeframegroup == 'Weekly'){
                            groupnew = String.valueOf(a.get('expr2')) + '-' + String.valueOf(a.get('expr1')).substring(2,4);     
                        } else {
                            groupnew = String.valueOf(a.get('expr2')) + '-' + String.valueOf(a.get('expr1')); 
                            ////system.debug('groupnew>>>>>>>>>'+groupnew);   
                            ////system.debug('a.get>>>jhh>>>>>>>>>'+a.get('expr1')); 
                            ////system.debug('a.get>>>jhhjhggjuh>>>>>>>>>'+a.get('expr2'));     
                        }     
                    }
                    minorvalue =  (String)a.get(minorgroup);
                    ////system.debug('a.getdcsdcsdcdscsdcsdcsdcsdcsdcdssd><>>>>>>>'+a.get(minorgroup)); 
                     
                    if(groupprev != groupnew) {
                        if(groupprev != NULL) {
                            gen.writeEndObject();   
                        }
                        groupprev = groupnew;
                        gen.writeStartObject();
                        
                        gen.writeStringField('expr1', groupprev);  
                    } 
                    if(minorvalue == NULL) {
                        minorvalue = 'None';
                    }
                    
                    Object aggvalue = (Object)a.get('expr0');
                    if(aggvalue == NULL) {
                       aggvalue = 0;     
                    }
                    gen.writeObjectField(minorvalue, aggvalue);
                    jsonFields.add(minorvalue);
                   
                } 
                gen.writeEndObject();
                gen.writeEndArray(); 
                ////system.debug('@@@@@>>>>' + gen.getAsString()); 
                
                recordjson =  gen.getAsString();
                
                /*if(recordjson != null){
                    recordjson =  gen.getAsString();
                }
                else{
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.info, 'There is no data found');
                    ApexPages.addMessage(msg);
                }*/
                
                ////system.debug('@@@@@' + recordjson); 
                gen.close();
            } else {
            
               if(aggnamefield.indexOf('.') != -1){
                   aggnamefield = aggnamefield.substring(aggnamefield.lastIndexOf('.') + 1, aggnamefield.length());   
               } 
               
               for (AggregateResult a :aggregateResult){             
                    if(a.get('expr0') != null && Integer.valueOf(a.get('expr0')) > 0){ 
                        wrapObj.add(new ModelWrapper((String)a.get(aggnamefield.trim()), (Object)a.get('expr0')));  
                    }   
                } 
                
                //if(recordjson != '' &&  recordjson != null){
                    
                //   //system.debug('AAAAAAAAAAAA' + wrapObj);
                    recordjson = (JSON.serialize(wrapObj));
                    
                //    //system.debug('AAAAAAAAAAAA' + recordjson); 
                //}
                //else{
                ////system.debug('ERROR>>>>>>>>>>' + recordjson); 
                //    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.info, 'There is no data found');
                //    ApexPages.addMessage(msg);
                //}
                recordjson = JSON.serialize(wrapObj);   
            }
            ////system.debug('@@@@@' + recordjson); 
        }  
        //return JSONString;
        ////system.debug('@@@@@chartType'+chartType);
    }
    
    
    
    private String getAggregateValue() {    
        String aggregatefun = ''; 
        
        /* Modified By Gulshan*/
        if (aggregateField == 'Count') {
            aggregatefun =  'Count(Id)';
            List<Opportunity_Manager_Setting__c> ls = [select Name,Timeframe__c,Save_Filers__c,Save_Filers2__c,OwnerId from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
            Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);
            //Map<string,Opportunity_Manager_Setting__c> cs = Opportunity_Manager_Setting__c.getAll(); 
            for(String s :cs.keySet()){
               //system.debug('!!!'+s + cs.get(s).Name);
               //if(cs.get(s).Name == 'A-0006'){
               //system.debug('!!!>>>>>>>>>>>>>>>');    
                       if(cs.get(s).Timeframe__c != null && cs.get(s).Timeframe__c != 'This Quarter'){
                            onLoadChartThisQuarter = true;
                       }     
                       if(cs.get(s).Save_Filers__c != null ){
                                
                                //system.debug(cs.get(s));
                                //system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                cs.get(s).Save_Filers2__c = 'Count';
                                //system.debug('>>>>>>>>>>cs.get(s)>>>>>>>>>>>>>>>>'+cs.get(s));
                                //abc.add(cs.get(s));    
                                if(Apexpages.currentPage().getParameters().get('lo') == 'true'){     
                                        try{
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers2__c.isUpdateable()){
                                                    //system.debug('>>>>>>>>>>>>>>>>wsedfv>>>>>>>>>');
                                                        update cs.get(s); 
                                                }
                                                else{
                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                                                }
                                        }
                                        catch(DmlException e) {
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                                            //system.debug('The following exception has occurred: ' + e.getMessage());
                                        }
                                }
                        }
                //}
            }   
        } else if(aggregateField == 'Amount'){
            aggregatefun = 'Sum(Amount)';    
            List<Opportunity_Manager_Setting__c> ls = [select Id,Name,Timeframe__c, Save_Filers2__c, Save_Filers__c,OwnerId from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
            Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);  
            //Map<string,Opportunity_Manager_Setting__c> cs = Opportunity_Manager_Setting__c.getAll(); 
            for(String s :cs.keySet()){ 
               ////system.debug('!!!'+s);
               //if(cs.get(s).Name ==  'A-0006'){   
                        if(cs.get(s).Timeframe__c != null && cs.get(s).Timeframe__c != 'This Quarter'){
                            onLoadChartThisQuarter = true;
                       }     
                       if(cs.get(s).Save_Filers__c != null ){
                                ////system.debug(cs.get(s));
                                ////system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                cs.get(s).Save_Filers2__c = 'Amount';
                                ////system.debug('>>>>>>>>>>cs.get(s)>>>>>>>>>>>>>>>>'+cs.get(s));
                                //abc.add(cs.get(s));    
                                if(Apexpages.currentPage().getParameters().get('lo') == 'true'){  
                                        try{    
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers2__c.isUpdateable()){  
                                                        //system.debug('>>>>>>>>>>>>>>>>wsedfv>>>>>>>>>');
                                                        update cs.get(s);
                                                }
                                                
                                                else{
                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                                                }
                                        }
                                        catch(DmlException e) {
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                                            ////system.debug('The following exception has occurred: ' + e.getMessage());
                                        }
                                }
                        }
                //}
            }          
        } else if(aggregateField == 'Revenue') {
            aggregatefun = 'Sum(ExpectedRevenue)' ;  
            List<Opportunity_Manager_Setting__c> ls = [select Id,Name,Timeframe__c,Save_Filers2__c, Save_Filers__c,OwnerId from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
            Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls); 
            //Map<string,Opportunity_Manager_Setting__c> cs = Opportunity_Manager_Setting__c.getAll(); 
            for(String s :cs.keySet()){ 
               //system.debug('!!!'+s);
               //if(cs.get(s).Name ==  'A-0006'){  
                        if(cs.get(s).Timeframe__c != null && cs.get(s).Timeframe__c != 'This Quarter'){
                            onLoadChartThisQuarter = true;
                       }      
                       if(cs.get(s).Save_Filers__c != null ){
                                ////system.debug(cs.get(s));
                                //system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                cs.get(s).Save_Filers2__c = 'Revenue';
                                //system.debug('>>>>>>>>>>cs.get(s)>>>>>>>>>>>>>>>>'+cs.get(s));
                                //abc.add(cs.get(s));    
                                    try{
                                        if(Apexpages.currentPage().getParameters().get('lo') == 'true'){    
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers2__c.isUpdateable()){  
                                                        //system.debug('>>>>>>>>>>>>>>>>wsedfv>>>>>>>>>');
                                                        update cs.get(s);
                                                }
                                                else{
                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                                                }
                                        }
                                    }
                                    catch(DmlException e) {
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                                                ////system.debug('The following exception has occurred: ' + e.getMessage());
                                    }
                        }
                //}
            }  
        } else if(aggregateField == 'Quantity'){
            aggregatefun = 'Sum(TotalOpportunityQuantity)';
            List<Opportunity_Manager_Setting__c> ls = [select Id,Name,Timeframe__c, Save_Filers2__c, Save_Filers__c,OwnerId from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
            Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);
            //Map<string,Opportunity_Manager_Setting__c> cs = Opportunity_Manager_Setting__c.getAll(); 
            for(String s :cs.keySet()){
               ////system.debug('!!!'+s);
               //if(cs.get(s).Name ==  'A-0006'){     
                        if(cs.get(s).Timeframe__c != null && cs.get(s).Timeframe__c != 'This Quarter'){
                            onLoadChartThisQuarter = true;
                       }   
                       if(cs.get(s).Save_Filers__c != null ){
                                ////system.debug(cs.get(s));
                                ////system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                cs.get(s).Save_Filers2__c = 'Quantity';
                                ////system.debug('>>>>>>>>>>cs.get(s)>>>>>>>>>>>>>>>>'+cs.get(s));
                                //abc.add(cs.get(s));    
                                if(Apexpages.currentPage().getParameters().get('lo') == 'true'){    
                                        try{
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers2__c.isUpdateable()){  
                                                        //system.debug('>>>>>>>>>>>>>>>>wsedfv>>>>>>>>>');
                                                        update cs.get(s);
                                                }
                                                else{
                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                                                }
                                        }
                                        catch(DmlException e) {
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                                            ////system.debug('The following exception has occurred: ' + e.getMessage());
                                        }
                                }
                        }
                //}
            }  
        }
        /* Modified By Gulshan*/
        //if(Apexpages.currentPage().getParameters().get('lo') == 'true'){
            return aggregatefun; 
        //}
        //return ''; 
    }
    
    public String getGroupByValue() { 
        String aggregateStr = '';
        //chartType = 'pie'; 
        ////system.debug(isLoad+'>>>>>----+++'+Apexpages.currentPage().getParameters().get('lo'));
                
        /*Modified By Gulshan*/
        if(timeframegroup == 'Yearly'){
            aggregateStr = 'CALENDAR_YEAR(CloseDate),';
          List<Opportunity_Manager_Setting__c> ls = [select Id,Name,Timeframe__c, Save_Filers2__c, Save_Filers__c,OwnerId from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
          Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);
          //Map<string,Opportunity_Manager_Setting__c> cs = Opportunity_Manager_Setting__c.getAll(); 
            for(String s :cs.keySet()){
                ////system.debug('!!!'+s);
                //if(cs.get(s).Name ==  'A-0006'){   
                        if(cs.get(s).Timeframe__c != null && cs.get(s).Timeframe__c != 'This Quarter'){
                            onLoadChartThisQuarter = true;
                       } 
                        if(cs.get(s).Save_Filers__c != null ){  
                                ////system.debug(cs.get(s));
                                ////system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                cs.get(s).Save_Filers__c = 'Yearly';
                                if(Apexpages.currentPage().getParameters().get('lo') == 'true'){    
                                        try{
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers__c.isUpdateable()){  
                                                        update cs.get(s);
                                                }
                                                else{
                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                                                }
                                        }
                                        catch(DmlException e) {
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                                            ////system.debug('The following exception has occurred: ' + e.getMessage());
                                        }
                                }
                                ////system.debug('>>>>>>>>>>cs.get(s)>>>>>>>>>>>>>>>>'+cs.get(s));
                        }
                //}
            }        
            chartType = 'bar';
            if(chartType=='bar'){
                chartType='Bar';
            }
           
            ////system.debug('gulshan Yearly');
            
        } else if(timeframegroup == 'Monthly'){
            aggregateStr = 'CALENDAR_YEAR(CloseDate),CALENDAR_MONTH(CloseDate),';
          List<Opportunity_Manager_Setting__c> ls = [select Id,Name,Timeframe__c, Save_Filers2__c, Save_Filers__c,OwnerId from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
          Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);
            for(String s :cs.keySet()){
                ////system.debug('!!!'+s);
                //if(cs.get(s).Name ==  'A-0006'){   
                        if(cs.get(s).Timeframe__c != null && cs.get(s).Timeframe__c != 'This Quarter'){
                            onLoadChartThisQuarter = true;
                       }     
                        if(cs.get(s).Save_Filers__c != null ){
                                ////system.debug(cs.get(s));
                                ////system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                cs.get(s).Save_Filers__c = 'Monthly';
                                 if(Apexpages.currentPage().getParameters().get('lo') == 'true'){    
                                        try{
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers__c.isUpdateable()){  
                                                        update cs.get(s);
                                                }
                                                else{
                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                                                }
                                        }
                                        catch(DmlException e) {
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                                            ////system.debug('The following exception has occurred: ' + e.getMessage());
                                        }
                                }
                                ////system.debug('>>>>>>>>>>cs.get(s)>>>>>>>>>>>>>>>>'+cs.get(s));
                        }
                //}
            }
            chartType = 'bar'; 
            if(chartType=='bar'){
                chartType='Bar';
            }  
              ////system.debug('gulshan Monthly');
        } else if(timeframegroup == 'Weekly') {
            aggregateStr = 'CALENDAR_YEAR(CloseDate),WEEK_IN_YEAR(CloseDate),'; 
          List<Opportunity_Manager_Setting__c> ls = [select Id,Name,Timeframe__c, Save_Filers2__c, Save_Filers__c,OwnerId from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
          Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);
          //Map<string,Opportunity_Manager_Setting__c> cs = Opportunity_Manager_Setting__c.getAll(); 
            for(String s :cs.keySet()){
               ////system.debug('!!!'+s);
               //if(cs.get(s).Name ==  'A-0006'){  
                        if(cs.get(s).Timeframe__c != null && cs.get(s).Timeframe__c != 'This Quarter'){
                            onLoadChartThisQuarter = true;
                       }     
                       if(cs.get(s).Save_Filers__c != null ){
                                ////system.debug(cs.get(s));
                                ////system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                cs.get(s).Save_Filers__c = 'Weekly';
                                ////system.debug('>>>>>>>>>>cs.get(s)>>>>>>>>>>>>>>>>'+cs.get(s));
                                //abc.add(cs.get(s));    
                                if(Apexpages.currentPage().getParameters().get('lo') == 'true'){    
                                        try{
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers__c.isUpdateable()){  
                                                        update cs.get(s);
                                                }
                                                else{
                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                                                }
                                        }
                                        catch(DmlException e) {
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                                            ////system.debug('The following exception has occurred: ' + e.getMessage());
                                        }
                                }
                                
                        }
                //}
            }
            chartType = 'bar'; 
            if(chartType=='bar'){
                chartType='Bar';
            }
                ////system.debug('gulshan Weekly');
        }
        else {
        ////system.debug('!!!in');
            //aggregateStr = 'CALENDAR_YEAR(CloseDate),WEEK_IN_YEAR(CloseDate),'; 
          List<Opportunity_Manager_Setting__c> ls = [select Id,Name,Timeframe__c, Save_Filers2__c, Save_Filers__c,OwnerId from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
          Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);
          //Map<string,Opportunity_Manager_Setting__c> cs = Opportunity_Manager_Setting__c.getAll(); 
           for(String s :cs.keySet()){
               ////system.debug('!!!'+s);
               //if(cs.get(s).Name ==  'A-0006'){      
                        if(cs.get(s).Timeframe__c != null && cs.get(s).Timeframe__c != 'This Quarter'){
                            onLoadChartThisQuarter = true;
                       } 
                       if(cs.get(s).Save_Filers__c != null ){
                                ////system.debug(cs.get(s));
                                ////system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                cs.get(s).Save_Filers__c = 'All';
                                ////system.debug('>>>>>>>>>>cs.get(s)>>>>>>>>>>>>>>>>'+cs.get(s));
                                //abc.add(cs.get(s));    
                                if(Apexpages.currentPage().getParameters().get('lo') == 'true'){    
                                        try{
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers__c.isUpdateable()){  
                                                        update cs.get(s);
                                                }
                                                else{
                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                                                }
                                        }
                                        catch(DmlException e) {
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                                            ////system.debug('The following exception has occurred: ' + e.getMessage());
                                        }
                                }
                                
                        }
                //}
            }
            chartType = 'pie';
            if(chartType=='pie'){
                chartType='Pie';
            }
          
            ////system.debug('gulshan all'+chartType);
        } 
        if(groupbyField == 'Stage'){
            aggregateStr += 'StageName';  
            List<Opportunity_Manager_Setting__c> ls = [select Id,Name,Timeframe__c, Save_Filers2__c, Save_Filers__c,OwnerId from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
            Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);
            //Map<string,Opportunity_Manager_Setting__c> cs = Opportunity_Manager_Setting__c.getAll(); 
            for(String s :cs.keySet()){
               ////system.debug('!!!'+s);
               //if(cs.get(s).Name ==  'A-0006'){   
                        if(cs.get(s).Timeframe__c != null && cs.get(s).Timeframe__c != 'This Quarter'){
                            onLoadChartThisQuarter = true;
                       }     
                       if(cs.get(s).Save_Filers__c != null ){ 
                                ////system.debug(cs.get(s));
                                ////system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                cs.get(s).Save_Filers3__c = 'Stage';
                                ////system.debug('>>>>>>>>>>cs.get(s)>>>>>>>>>>>>>>>>'+cs.get(s));
                                //abc.add(cs.get(s));    
                                if(Apexpages.currentPage().getParameters().get('lo') == 'true'){    
                                        try{
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers3__c.isUpdateable()){  
                                                        update cs.get(s);
                                                }
                                                else{
                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                                                }
                                        }
                                        catch(DmlException e) {
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                                            ////system.debug('The following exception has occurred: ' + e.getMessage());
                                        }
                                }
                        }
                //}
            } 
        } else if(groupbyField == 'Source'){
            aggregateStr += 'LeadSource';
            List<Opportunity_Manager_Setting__c> ls = [select Id,Name,Timeframe__c, Save_Filers2__c, Save_Filers__c,OwnerId from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
            Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);
            //Map<string,Opportunity_Manager_Setting__c> cs = Opportunity_Manager_Setting__c.getAll(); 
            for(String s :cs.keySet()){
               ////system.debug('!!!'+s);
               //if(cs.get(s).Name ==  'A-0006'){      
                        if(cs.get(s).Timeframe__c != null && cs.get(s).Timeframe__c != 'This Quarter'){
                            onLoadChartThisQuarter = true;
                       } 
                       if(cs.get(s).Save_Filers__c != null ){
                                ////system.debug(cs.get(s));
                                ////system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                cs.get(s).Save_Filers3__c = 'Source';
                                ////system.debug('>>>>>>>>>>cs.get(s)>>>>>>>>>>>>>>>>'+cs.get(s));
                                //abc.add(cs.get(s));    
                                if(Apexpages.currentPage().getParameters().get('lo') == 'true'){    
                                        try{
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers3__c.isUpdateable()){  
                                                        update cs.get(s);
                                                }
                                                else{
                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                                                }
                                        }
                                        catch(DmlException e) {
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                                            ////system.debug('The following exception has occurred: ' + e.getMessage());
                                        }
                                } 
                        }
                //}
            }    
        } else if(groupbyField == 'Type'){
            aggregateStr += 'Type';
            List<Opportunity_Manager_Setting__c> ls = [select Id,Name,Timeframe__c, Save_Filers2__c, Save_Filers__c,OwnerId from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
            Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);
            for(String s :cs.keySet()){
               ////system.debug('!!!'+s);
               //if(cs.get(s).Name ==  'A-0006'){      
                        if(cs.get(s).Timeframe__c != null && cs.get(s).Timeframe__c != 'This Quarter'){
                            onLoadChartThisQuarter = true;
                       }       
                       if(cs.get(s).Save_Filers__c != null ){
                                ////system.debug(cs.get(s));
                                ////system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                cs.get(s).Save_Filers3__c = 'Type';
                                ////system.debug('>>>>>>>>>>cs.get(s)>>>>>>>>>>>>>>>>'+cs.get(s));
                                //abc.add(cs.get(s));    
                                if(Apexpages.currentPage().getParameters().get('lo') == 'true'){    
                                        try{
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers3__c.isUpdateable()){  
                                                        update cs.get(s);
                                                }
                                                else{
                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                                                }
                                        }
                                        catch(DmlException e) {
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                                            ////system.debug('The following exception has occurred: ' + e.getMessage());
                                        }
                                }
                        }
                //}
            }      
        } else if(groupbyField == 'Account'){
            aggregateStr += 'Account.Name';
            List<Opportunity_Manager_Setting__c> ls = [select Id,Name,Timeframe__c, Save_Filers2__c, Save_Filers__c,OwnerId from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
            Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);
            for(String s :cs.keySet()){
               ////system.debug('!!!'+s);
               //if(cs.get(s).Name ==  'A-0006'){    
                        if(cs.get(s).Timeframe__c != null && cs.get(s).Timeframe__c != 'This Quarter'){
                            onLoadChartThisQuarter = true;
                       } 
                       if(cs.get(s).Save_Filers__c != null ){
                                ////system.debug(cs.get(s));
                                ////system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                cs.get(s).Save_Filers3__c = 'Account';
                                ////system.debug('>>>>>>>>>>cs.get(s)>>>>>>>>>>>>>>>>'+cs.get(s));
                                //abc.add(cs.get(s));    
                                if(Apexpages.currentPage().getParameters().get('lo') == 'true'){    
                                        try{
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers3__c.isUpdateable()){  
                                                        update cs.get(s);
                                                }
                                                else{
                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                                                }
                                        }
                                        catch(DmlException e) {
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                                            ////system.debug('The following exception has occurred: ' + e.getMessage());
                                        }
                                }
                        }
                //}
            }        
        } else if(groupbyField == 'Campaign'){
            aggregateStr += 'Campaign.Name';    
            List<Opportunity_Manager_Setting__c> ls = [select Id,Name,Timeframe__c, Save_Filers2__c, Save_Filers__c,OwnerId from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
            Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);
            //Map<string,Opportunity_Manager_Setting__c> cs = Opportunity_Manager_Setting__c.getAll(); 
            for(String s :cs.keySet()){
               ////system.debug('!!!'+s);
               //if(cs.get(s).Name ==  'A-0006'){         
                        if(cs.get(s).Timeframe__c != null && cs.get(s).Timeframe__c != 'This Quarter'){
                            onLoadChartThisQuarter = true;
                       }   
                       if(cs.get(s).Save_Filers__c != null ){
                                ////system.debug(cs.get(s));
                                ////system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                cs.get(s).Save_Filers3__c = 'Campaign';
                                ////system.debug('>>>>>>>>>>cs.get(s)>>>>>>>>>>>>>>>>'+cs.get(s));
                                //abc.add(cs.get(s));    
                                if(Apexpages.currentPage().getParameters().get('lo') == 'true'){    
                                        try{
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers3__c.isUpdateable()){  
                                                        update cs.get(s);
                                                }
                                                else{
                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                                                }
                                        }
                                        catch(DmlException e) {
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                                            ////system.debug('The following exception has occurred: ' + e.getMessage());
                                        }
                                }
                        }
                //}
            }     
        }
        /*Modified By Gulshan*/
        
        return aggregateStr;
    }
    public void mouseHoverText(){
        ////system.debug('chartType>>>>>>'+chartType);
        if(chartType == 'Pie'){
            displayText = 'It is working';
        }
        if(chartType != 'Pie'){
            displayText = 'It is working bar';
        }
    }
    
   
    public class ModelWrapper {
        public String name{get;set;} // subgroup
        public Object data{get;set;}
      
            
        public ModelWrapper(String name, Object data){
            if(String.isEmpty(name)){
                this.name = 'None';
            } else {
                this.name = name;    
            }
            this.data = data;
        }
    }
    
    
    
}