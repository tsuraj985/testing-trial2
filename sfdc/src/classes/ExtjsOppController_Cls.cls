global with sharing class ExtjsOppController_Cls {
   
   // code added from here =========
    
    public Opportunity oppList{get;set;}
    public List<Opportunity> oppList1{get;set;}
    public static List<String> stage {get;set;} 
    public List<String> AllStages{get;set;}
    public String time1 {get;set;} 
    public String openClosed {get;set;} 
    public String ForecastCategory {get;set;}
    public boolean isOwnerChecked{get;set;}
    public Transient list<Schema.Picklistentry> stagePicklist{get;set;}
    public Transient List<Schema.PicklistEntry> forecastPicklist {get;set;}
    public Transient List<Schema.PicklistEntry> leadSourcelist {get;set;}
    public Transient List<Schema.PicklistEntry> Typelist {get;set;}
    public Map<Id, Opportunity_Manager_Setting__c> cs2 = new Map<Id, Opportunity_Manager_Setting__c>();
    public string testing1121{get;set;}
    
   // code added ends here ========= 
   
   public Transient List<SelectOption> ListViewList{get;set;}
   public String selListView{get;set;}
   public String listViewFilter{get; private set;}
   public String listViewScope{get;set;}
   public String collist{get; set;}
   public List<SelectOption> leftPickListValues{get; private set;}
   public List<SelectOption> rightPickListValues{get; private set;}
   public String getSelectedValues{get;set;}
   public Boolean isMetadataPermission{get; private set;}
   private Map<String, String> fieldLabelNameMap = new Map<String, String>();
   public String filterparams{get; private set;}
   
   public String selOppId{get;set;}
   
   //Default fields
   public String stageField{get;set;}
   public String allStageField{get;set;}
   public String leadSourceField{get;set;}
   public String oppTypeField{get;set;}
   public String forecastCategoryField{get;set;}
   public String openClosedField{get;set;}
   public String timeFrameField{get;set;}
   public Boolean ownerCheckedField{get;set;}
   public String accountField{get;set;}
   public String campaignField{get;set;}    
   public boolean flag{get;set;}
   public Map<string,Opportunity_Manager_Setting__c> cs{get;set;}
   
   
   /// export to excel variable
    public list<Opportunity> objOpp{get;set;}
    public list<String> columns{get;set;}
    public list<String> columns1{get;set;}
    public list<ExcelColumnInfo> columnInfo{get;set;}
    public Map<String, Schema.SObjectField> fieldMap{get;set;}
    public String exportFilter {get;set;}
    public String fieldsObj {get;set;}
    public list<List<Opportunity>> mainList {get;set;}
    
    global static Boolean isACMEnabled{get;set;}
    global static String defaultCurrency{get;set;}
    private boolean flag1{get;private set;}
    
   public List<Account> acc{get;set;}
   
   public String oppAccountName{get;set;}
   public String oppCampaignName{get;set;}
   public ExtjsOppController_Cls(ApexPages.StandardController controller) {
        defaultCurrency = UserInfo.getDefaultCurrency();
        if(UserInfo.isMultiCurrencyOrganization()){
            isACMEnabled = true;
        }
        else{
            isACMEnabled = false;
        }
        //oppAccountName = 'Test';
       // system.debug('defaultCurrency>> '+defaultCurrency);
       // system.debug('isACMEnabled>> '+isACMEnabled);
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
        //oppList= (Opportunity)oppList.getRecord();
        retListView();    
        filterparams = '';   
                
    }
    
    public pagereference ex2ex(){
        pageReference pr = new pageReference('/apex/Export2ExcelGrid');
        return pr;
    }
    
    public void export2Excel(){
        try{
            columnInfo = new list<ExcelColumnInfo>();
            //String filter = ApexPages.CurrentPage().getParameters().get('f');
            fieldMap = Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap();
            fieldsObj = '';
            columns = new list<String>();//{'name','Amount'};
            columns1 = new list<String>();
            List<Opportunity_Manager_Setting__c> ls = [select id,Name,Default_Values__c from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
            Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);
            //Opportunity_Manager_Setting__c fieldSetting = Opportunity_Manager_Setting__c.getInstance('Default Fields');
            //system.debug('cs.keySet()>>>>>>>>'+cs.keySet());
            //system.debug('cs>>>>>>>>'+cs);
            if(!cs.keySet().isEmpty()){
                //system.debug('))))))when not emplty))))');
                for(String s :cs.keySet()){
                    //system.debug('!!!'+s);
                    //if(cs.get(s).Name ==  'A-0006'){   
                            if(cs.get(s).Default_Values__c != null ){
                                fieldsObj = cs.get(s).Default_Values__c.replaceAll('-','');
                            }
                    //}
                }   
            } 
            
            // === added code to display saved values data ===
            onLoadCheckSavedValues(); 
             List<string> onLoadFiltersList = new List<string>();
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
                 }
                 
                 if(ownRecordValue){
                    String ss1 = 'OwnerId = ' + '\'' +  UserInfo.getUserId() + '\'';                    
                    onLoadFiltersList.add(ss1);         
                 }
                                 
                 if(!String.isBlank(time11)){
                    time11 = timeFrame(time11);
                    onLoadFiltersList.add(time11); 
                    //pageLoadcheck = true;         
                 }
                 String paramvalExcelFilter = '';
                 String onCheckSize = '';
                 for(String str:onLoadFiltersList){
                    onCheckSize+=str;
                 }
                 if(onLoadFiltersList != null &&onCheckSize.length()>1 ){
                    system.debug('onLoadFiltersList'+onLoadFiltersList.size());
                    if(String.isBlank(paramvalExcelFilter)){
                        paramvalExcelFilter = ' WHERE ';
                     }
                     
                     paramvalExcelFilter = paramvalExcelFilter + String.join(onLoadFiltersList,' AND '); 
                     paramvalExcelFilter = paramvalExcelFilter.trim();
                     String andCheck = paramvalExcelFilter.substring(paramvalExcelFilter.length()-4,paramvalExcelFilter.length());
                     if(andCheck.contains('AND')){
                        paramvalExcelFilter = paramvalExcelFilter.subString(0,paramvalExcelFilter.length()-4);
                     }
                 }  
                 system.debug('paramval>>>>> '+paramvalExcelFilter+' <<<<<paramval');  
            
            // == code ends ===== 
            
            
            
            
            if(String.isNotEmpty(fieldsObj)){
                system.debug('?????'+fieldsObj);
                 map<String,string> fieldLabelVsLookup =lookupCheckAgain(fieldsObj);
                 system.debug(fieldLabelVsLookup +'@@@@@@@');
                for(String a :fieldsObj.split(',')){
                    Schema.DescribeFieldResult dfr = fieldMap.get(a.replace('-','').replace('','')).getDescribe();
                    columns.add(a.trim().toLowerCase()); 
                    columns1.add(dfr.getLabel()); 
                    columnInfo.add(new ExcelColumnInfo(''+dfr.getType(),dfr.getLabel(),a.replace('-','').replace('','').trim().toLowerCase(),fieldLabelVsLookup.get(dfr.getName()),fieldLabelVsLookup.get(dfr.getName()).replace('.',' ').capitalize()));     
                }
            }
            system.debug(columnInfo+'@@@@@@@');
            String fieldsObject =lookupCheck(fieldsObj);
            system.debug(fieldsObject +'@@@@@@@');
            String query = ' select '+fieldsObject +' from opportunity ';
            system.debug('>>>>>>>>>>>>>>>>>>>>>>>exportFilter'+exportFilter);
            if(exportFilter != null && exportFilter  != '') {
                system.debug('>>>>>>>>>>>>>if>>>>>>>>>>exportFilter'+exportFilter);
                query += ' where '+ EncodingUtil.urlDecode(exportFilter,'UTF-8'); 
            }
            else{
                system.debug('>>>>>>>>>>>>else>>>>>>>>>>>exportFilter'+exportFilter);
                query += paramvalExcelFilter;
            }
            try{  
                system.debug('>>>>>>>>>>>>>>>>>>>>>>>exportFilter'+query);
                testing1121 = query;    
                objOpp = database.query(query);
            }catch(Exception e){if(e.getMessage().contains('Too many')){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.info, 'More Records to display. Please Select Filter Wisely.');
                ApexPages.addMessage(msg);              
            }}            
            mainList = new List<List<sObject>>();
            List<sObject> innerList = null;
            Integer idx = 0;
            for(sObject obj:objOpp){
                if (Math.mod(idx++, 1000) == 0 ) {
                    innerList = new List<sObject>();
                    mainList.add(innerList);
                }
                innerList.add(obj);           
            } 
        }catch(Exception e){
            //system.debug('Error: '+ e);
        }
    }
    
    public class ExcelColumnInfo{
        public string datatype{get;set;}
        public string label{get;set;}
        public string fieldname{get;set;}
        public String lookupField{get;set;}
        public String lookupLabel{get;set;}
        public ExcelColumnInfo(string datatype,string label,string fieldname,String lookupField,String lookupLabel){
                this.datatype = datatype;
                this.label = label;
                this.fieldname = fieldname;
                this.lookupField =lookupField;
               this.lookupLabel = lookupLabel;
        }
    }
    public static Boolean onLoadCheck = false;
    public String time11 = '';
    
    String leadSourceValue = '';
    String opportunityTypeValue = '';
    String forecastCategoryValue = '';
    String openClosedValue = '';   
    String accountValue = '';
    String campaignValue = '';
    String stageValue = '';
    Boolean ownRecordValue = false;
    
    public void onLoadCheckSavedValues(){
        //List<Opportunity_Manager_Setting__c> ls = [select Id,Only_own_records__c,Stage__c,Account__c,Campaign__c,Open_Closed__c ,Forecast_Category__c,Opportunity_Type__c,Lead_Source__c,Timeframe__c,Name, Save_Filers2__c, Save_Filers__c, Save_Filers3__c from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
        List<Opportunity_Manager_Setting__c> ls = [select Id,Only_own_records__c,Stage1__c,Account__c,Campaign__c,Open_Closed__c ,Forecast_Category__c,Opportunity_Type__c,Lead_Source__c,Timeframe__c,Name, Save_Filers2__c, Save_Filers__c, Save_Filers3__c from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
        Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls); 
        if(!cs.keySet().isEmpty()){
            for(String s :cs.keySet()){
                if(cs.get(s).Timeframe__c != null && cs.get(s).Timeframe__c == 'This Quarter'){
            //          onLoadChartThisQuarter = true;
                        time11 = 'This Quarter';
                }
                else if(cs.get(s).Timeframe__c != null){
                    time11 = cs.get(s).Timeframe__c;    
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
    }
    
    public ExtjsOppController_Cls() {
        defaultCurrency = UserInfo.getDefaultCurrency();
        if(UserInfo.isMultiCurrencyOrganization()){
            isACMEnabled = true;
        }
        else{
            isACMEnabled = false;
        }
        flag1 = false;
       
        String STRAND = ' AND ';
        onLoadCheck = true;
        //listViewFilter = '';
        String filterQuery = '';
        //filterparams = '';
        List<FilterWrapper> filtersList = new List<FilterWrapper>();
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
        oppList= new Opportunity();
        retListView();  
        filterparams = '';
        
        // on load to show the saved state =============================
        //onLoadCheckSavedValues();
        //List<Opportunity_Manager_Setting__c> ls = [select Id,Only_own_records__c,Stage__c,Account__c,Campaign__c,Open_Closed__c ,Forecast_Category__c,Opportunity_Type__c,Lead_Source__c,Timeframe__c,Name, Save_Filers2__c, Save_Filers__c, Save_Filers3__c from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
        List<Opportunity_Manager_Setting__c> ls = [select Id,Only_own_records__c,Stage1__c,Account__c,Campaign__c,Open_Closed__c ,Forecast_Category__c,Opportunity_Type__c,Lead_Source__c,Timeframe__c,Name, Save_Filers2__c, Save_Filers__c, Save_Filers3__c from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
        Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls); 
        if(!cs.keySet().isEmpty()){
            for(String s :cs.keySet()){
                if(cs.get(s).Timeframe__c != null)
                {
                    time1 = cs.get(s).Timeframe__c; 
                }               
                if(cs.get(s).Lead_Source__c != null && cs.get(s).Lead_Source__c != '--None--'){ 
                    leadSourceField = cs.get(s).Lead_Source__c;
               }
               if(cs.get(s).Opportunity_Type__c != null && cs.get(s).Opportunity_Type__c != '--None--'){ 
                    oppTypeField = cs.get(s).Opportunity_Type__c;
               }
               if(cs.get(s).Forecast_Category__c != null && cs.get(s).Forecast_Category__c != '--None--'){ 
                    forecastCategory = cs.get(s).Forecast_Category__c;
               }
               if(cs.get(s).Open_Closed__c != null && cs.get(s).Open_Closed__c != '--None--'){ 
                    openClosed = cs.get(s).Open_Closed__c;
               }
               if(cs.get(s).Account__c != null && cs.get(s).Account__c != '--None--'){ 
                    accountName(cs.get(s).Account__c);
               }
               if(cs.get(s).Campaign__c != null && cs.get(s).Campaign__c != '--None--'){ 
                    campaignName(cs.get(s).Campaign__c);
               }
               //if(cs.get(s).Stage__c != null && cs.get(s).Stage__c != '--None--'){ 
                    //String ss = cs.get(s).Stage__c;
                    //stage = ss.split(',');
               //}
               if(cs.get(s).Stage1__c != null && cs.get(s).Stage1__c != '--None--'){ 
                    String ss = cs.get(s).Stage1__c;
                    stage = ss.split(',');
               }
               if(cs.get(s).Only_own_records__c != null && cs.get(s).Only_own_records__c != false){ 
                    isOwnerChecked = cs.get(s).Only_own_records__c;
               }
            }
        }
        if(time1 == null || time1 == ''){
            //time1 = 'All time';
            time1 = 'This Quarter';
        }
        if(null != ls && !ls.isEmpty() && ls[0].Account__c != '--None--' && ls[0].Account__c != Null && ls[0].Account__c != ''){
            oppList.accountId = ls[0].Account__c;
            
           oppAccountName = [SELECT id,name FROM ACCOUNT WHERE ID=:oppList.accountId].name;
        }
        if(null != ls && !ls.isEmpty() &&  ls[0].Campaign__c != '--None--' && ls[0].Campaign__c != Null && ls[0].Campaign__c != ''){
            oppList.campaignId= ls[0].Campaign__c;
            
           oppCampaignName = [SELECT id,name FROM Campaign WHERE ID=:oppList.campaignId].name;
        }
        
        //Stages;
       
        //oppList.LeadSource = 'web';
        //leadSourceField = 'web'; 
        oppList.LeadSource = leadSourceField;
        oppList.Type = oppTypeField;
        system.debug('oppList.LeadSource');
        // on load to show the saved state =============================   
    }
    public void FirstTimeCall(){
        //system.debug('>>>>>>>>>dsdCSDC>>>>>>');
        List<Opportunity_Manager_Setting__c> ls = [select id,Name,Default_Values__c from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
        //Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);
        If(ls.size() == 0){
            Opportunity_Manager_Setting__c OppRecord = new Opportunity_Manager_Setting__c();
            //OppRecord.Name = 'Default Fields';
            OppRecord.OwnerId = UserInfo.getUserId();
            OppRecord.Save_Filers__c = 'All'; 
            OppRecord.Save_Filers2__c = 'Count';
            OppRecord.Save_Filers3__c = 'Stage'; 
            OppRecord.Default_Values__c = 'AccountId,Amount,CloseDate,CreatedById,LeadSource,Name,OwnerId,StageName';
            OppRecord.Account__c = '--None--';
            OppRecord.Campaign__c = '--None--';
            OppRecord.Forecast_Category__c = '--None--';
            OppRecord.Lead_Source__c = '--None--';
            OppRecord.Open_Closed__c = '--None--';
            OppRecord.Opportunity_Type__c = '--None--';
            //OppRecord.Stage__c = '--None--';
            OppRecord.Stage1__c = '--None--';
            //OppRecord.Timeframe__c = 'All time';
            OppRecord.Timeframe__c = 'This Quarter'; 
            try{
                    if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers__c.isCreateable() &&
                            Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers2__c.isCreateable() &&
                            Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers3__c.isCreateable() &&
                            Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Default_Values__c.isCreateable() &&
                            Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Account__c.isCreateable() &&
                            Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Campaign__c.isCreateable() &&
                            Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Forecast_Category__c.isCreateable() &&
                            Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Lead_Source__c.isCreateable() &&
                            Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Open_Closed__c.isCreateable() &&
                            Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Opportunity_Type__c.isCreateable() &&
                            //Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Stage__c.isCreateable() &&
                            Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Stage1__c.isCreateable() &&
                            Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Timeframe__c.isCreateable()){
                            insert OppRecord;
                    }
                    else{
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                    }
            }
            catch(DmlException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }     
        }
    }
   public void ResetAllField(){
    //system.debug(')))))))))))))');
            //time1 = 'All time';
        
            time1 = 'This Quarter';   
            
            /* Modified By Gulshan*/
            
            List<Opportunity_Manager_Setting__c> ls = [select id,Name,Default_Values__c from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
            Map<Id, Opportunity_Manager_Setting__c> cs2 = new Map<Id, Opportunity_Manager_Setting__c>(ls);
            //system.debug('cs2.keySet()>>>>>>>>'+cs2.keySet());
            //system.debug('cs2>>>>>>>>'+cs2);
            if(!cs2.keySet().isEmpty()){
                //system.debug('))))))when not emplty))))');
                for(String s :cs2.keySet()){
                    //system.debug('!!!'+s);
                    //if(cs.get(s).Name ==  'A-0006'){   
                            if(cs2.get(s).Default_Values__c != null ){
                                    //system.debug('>>>>>>>>>>>[[[[[>>>>>>>>cs.get(s)'+cs2.get(s));
                                    cs2.get(s).Default_Values__c = 'AccountId,Amount,CloseDate,CreatedById,LeadSource,Name,OwnerId,StageName'; 
                                        try{
                                            if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Default_Values__c.isUpdateable()){
                                                update cs2.get(s);
                                            }
                                            else{
                                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                                                                }
                                        //system.debug(cs2.get(s));
                                        }
                                        catch(DmlException e) {
                                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                                                                            //system.debug('The following exception has occurred: ' + e.getMessage());
                                                                        }
                            }
                    //}           
                }
            }
            else {
                //system.debug('))))))when emplty))))');
                Opportunity_Manager_Setting__c OppRecord = new Opportunity_Manager_Setting__c();
                                //OppRecord.Name = 'Default Fields';
                                OppRecord.Save_Filers__c = 'All';
                                OppRecord.Save_Filers2__c = 'Count';
                                OppRecord.Save_Filers3__c = 'Stage'; 
                                OppRecord.Default_Values__c = 'AccountId,Amount,CloseDate,CreatedById,LeadSource,Name,OwnerId,StageName';
                                OppRecord.Account__c = '--None--';
                                OppRecord.Campaign__c = '--None--';
                                OppRecord.Forecast_Category__c = '--None--';
                                OppRecord.Lead_Source__c = '--None--';
                                OppRecord.Open_Closed__c = '--None--';
                                OppRecord.Opportunity_Type__c = '--None--';
                                //OppRecord.Stage__c = '--None--';
                                OppRecord.Stage1__c = '--None--';
                               // OppRecord.Timeframe__c = 'All time';
                                OppRecord.Timeframe__c = 'This Quarter';  
                                try{
                                        if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers__c.isCreateable() &&
                                                Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers2__c.isCreateable() &&
                                                Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Save_Filers3__c.isCreateable() &&
                                                Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Default_Values__c.isCreateable() &&
                                                Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Account__c.isCreateable() &&
                                                Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Campaign__c.isCreateable() &&
                                                Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Forecast_Category__c.isCreateable() &&
                                                Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Lead_Source__c.isCreateable() &&
                                                Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Open_Closed__c.isCreateable() &&
                                                Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Opportunity_Type__c.isCreateable() &&
                                                //Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Stage__c.isCreateable() &&
                                                Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Stage1__c.isCreateable() &&
                                                Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Timeframe__c.isCreateable()){
                                                insert OppRecord;
                                        }
                                        else{
                                                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                                                        }
                                }
                                catch(DmlException e) {
                                                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                                                                }                         
            }
            /* Modified By Gulshan*/
            //return null;
   }
  
   
  
   
   public void retListView() {
       leftPickListValues = new List<SelectOption>();
       rightPickListValues = new List<SelectOption>();
       listViewFilter = '';
        String objName = 'Opportunity';
        Map<String, Schema.SObjectType> objTypeMap = Schema.getGlobalDescribe();
        if (!objTypeMap.containsKey(objName)) {
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No SObject named ' + objName + ' found'));   
             //return null;
        }
        Schema.SObjectType sobj = objTypeMap.get(objName);
        Map<String, Schema.SObjectField> fieldMap = sobj.getDescribe().fields.getMap(); 
        
        collist = '';
        Schema.DescribeFieldResult dfr;
        
     
        for(String fieldToken :fieldMap.keySet()){
            dfr = fieldMap.get(fieldToken).getDescribe(); 
            if(dfr.isAccessible()){
                collist += fieldToken + ','; 
                rightPickListValues.add(new selectOption(dfr.getName() , dfr.getLabel()));  
            } 
        }
        collist = collist.subString(0, collist.length() - 1);                         
   } 
   
   
   
   public void goClick(){
       collist = '';
       ////system.debug('@@@@@@' + getSelectedValues); 
       if(String.isNotEmpty(getSelectedValues)){
           collist = getSelectedValues;  
           ////system.debug('>>' + collist);    
       } else {
           ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select at least one Column to Display'));    
       }   
   }
   
   
   // get field label and check its accessbility by current user
   
       
   public PageReference gotoRefreshFilter() {
       PageReference page = new PageReference('/apex/RefreshFilterPage');
       page.setRedirect(true);
       return page;
   }
   
  // code addded from here ============
      
    public List<SelectOption> getStages() { //Dynamic picklist values of multi picklist Stage field
        stagePicklist=  Opportunity.fields.StageName.getDescribe().getpicklistvalues();
        List<SelectOption> options = new List<SelectOption>();
        for(Schema.Picklistentry s: stagePicklist){
            options.add(new SelectOption(s.getLabel(), s.getLabel()));
        }
        return options;
    }
        
   public List<selectOption> getTimeFrame(){ //Method to return the value on Timeframe field
        List <selectOption> option1= new List<selectOption>();
   
         Option1.add(new SelectOption('1 Week','1 Week'));
         Option1.add(new SelectOption('1 Month','1 Month'));
         Option1.add(new SelectOption('3 Months','3 Months'));
         Option1.add(new SelectOption('6 Months','6 Months'));
         Option1.add(new SelectOption('12 Months','12 Months'));
         Option1.add(new SelectOption('This Week','This Week'));
         Option1.add(new SelectOption('This Month','This Month'));
         Option1.add(new SelectOption('This Quarter','This Quarter'));         
         Option1.add(new SelectOption('This Year','This Year'));
         Option1.add(new SelectOption('Last Week','Last Week'));
         Option1.add(new SelectOption('Last Month','Last Month'));
         Option1.add(new SelectOption('Last Quarter','Last Quarter'));
         Option1.add(new SelectOption('Last Year','Last Year'));
         Option1.add(new SelectOption('All time','All time'));
         
         return option1;
    }
    
    
        
    public List<selectOption> getOpenOpp(){ // Method to return the value on Open/closed field
        List <selectOption> option1= new List<selectOption>();
        Option1.add(new SelectOption('','--None--'));
        Option1.add(new SelectOption('Open','Open'));
        Option1.add(new SelectOption('Closed Won','Closed Won'));
        Option1.add(new SelectOption('Closed Lost','Closed Lost'));
        return option1;
    }
    public List<selectOption> getForecast(){ // Method to return the dynamic value on Open/closed field
        forecastPicklist=  Opportunity.fields.ForecastCategoryName.getDescribe().getpicklistvalues();
        List <selectOption> option1= new List<selectOption>();
        option1.add(new SelectOption('', '--None--'));
        for(Schema.Picklistentry f: forecastPicklist){
        option1.add(new SelectOption(f.getLabel(), f.getLabel()));
        }
        return option1;
    }   
    ////////////
    public List<selectOption> getLeadSource(){ // Method to return the dynamic value on Open/closed field
        leadSourcelist=  Opportunity.fields.LeadSource.getDescribe().getpicklistvalues();
        List <selectOption> option1= new List<selectOption>();
        option1.add(new SelectOption('', '--None--'));
        for(Schema.Picklistentry f: leadSourcelist){
        option1.add(new SelectOption(f.getLabel(), f.getLabel()));
        }
        return option1;
    }
    
    public List<selectOption> getType(){ // Method to return the dynamic value on Open/closed field
        Typelist=  Opportunity.fields.Type.getDescribe().getpicklistvalues();
        List <selectOption> option1= new List<selectOption>();
        option1.add(new SelectOption('', '--None--'));
        for(Schema.Picklistentry f: Typelist){
        option1.add(new SelectOption(f.getLabel(), f.getLabel()));
        }
        return option1;
    }
    ////////////  
    
    // reset all filters to their default values
    public void resetFilter(){
        
        isOwnerChecked = false;
        stage = new List<String>();
        oppList.LeadSource = null;
        leadSourceField = null;
        //time1 = 'All time'; 
        time1 = 'This Quarter';  
        oppList.Type = null;
        oppTypeField = null;
        forecastCategory = '--None--';
        oppList.AccountId = NULL;
        openClosed = '--None--';
        oppList.CampaignId = NULL;  
        ResetAllField();
        renderPanel();
    }
    
    List<Account> accList = New List<Account>();
    public void accountName(String accountID){
        if(accountID != null){
         accList = [Select Name from Account where id = : accountID LIMIT 1]; 
        }
        if(accList != null && accList.size()>0 && accList[0].Name != null && accList[0].Name.Trim() != ''){         
            oppAccountName = accList[0].Name;   
        }
        else{
            oppAccountName = '';
        }
    }
    
    List<Campaign> campaignList = New List<Campaign>();
    public void campaignName(String campaignID){
        if(campaignId != null ){
            campaignList = [Select Name from Campaign where id = : campaignId LIMIT 1]; 
        }
        if(campaignList != null && campaignList.size()>0 && campaignList[0].Name != null && campaignList[0].Name.Trim() != ''){         
            oppCampaignName = campaignList[0].Name; 
        }
        else{
            oppCampaignName = '';
        }
    }
    
    public void renderPanel()
    {
        system.debug(flag1);
        //========Code starts to display the account name ===================   
        system.debug('!!!!!!!!!!!!!!!!'+opplist.accountId);
        if(opplist.accountId != null && !flag1 ){
            accountName(opplist.accountId);
        }else{
            opplist.accountId =null;
            oppAccountName ='';
        }        
        //========Code ends   to display the account name ======================        
        //========Code starts   to display the campaign name ===================        
        
        system.debug('!!!!!!!!!!!!!!!!'+opplist.CampaignId);
        if(oppList.CampaignId != null ){
            campaignName(oppList.CampaignId);
        }        
        //========Code ends   to display the account name ===================
        
        //oppAccountName = opplist.accountId;
        //system.debug('>>>>>>>>>opplist.accountId'+opplist.accountId);
        flag = true;
       
        //system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.');
        // create filter criteria for extjs grid component
        String STRAND = ' AND ';
        listViewFilter = '';
        String filterQuery = '';
        filterparams = '';
        List<FilterWrapper> filtersList = new List<FilterWrapper>();
        //List<Opportunity_Manager_Setting__c> ls = [select Id,Name,Account__c,Stage__c, Save_Filers2__c,Lead_Source__c, Save_Filers__c, Save_Filers3__c from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
        //List<Opportunity_Manager_Setting__c> ls = [select Id,Name,Account__c,Stage1__c, Save_Filers2__c,Lead_Source__c, Save_Filers__c, Save_Filers3__c from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
        //List<Opportunity_Manager_Setting__c> ls=[select Id,Opportunity_Type__c, Name, Account__c, Stage__c, Save_Filers2__c, Lead_Source__c,
        List<Opportunity_Manager_Setting__c> ls=[select Id,Opportunity_Type__c, Name, Account__c, Stage1__c, Save_Filers2__c, Lead_Source__c, 
                                                            Save_Filers__c, Forecast_Category__c, Open_Closed__c, Only_own_records__c, Timeframe__c, 
                                                            Save_Filers3__c,Campaign__c 
                                                            from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];  
        Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);
        //Map<string,Opportunity_Manager_Setting__c> cs = Opportunity_Manager_Setting__c.getAll(); 
        //for(String s :cs.keySet()){
        //  cs.get(s).Stage__c = '';
        //  cs.get(s).Stage1__c = '';
        //}
        system.debug('stagedvsdvsdv >>>>'+stage);
        
        if(Null != stage &&  !stage.isEmpty()){
            ////system.debug('Inside If Condition ::');
            filterQuery += '(';
            String allStagesValues = '';
            for(String a :stage){
              ////system.debug('in for loop >>>>'+a);
              if(!cs.keySet().isEmpty()){
                    ////system.debug('in if loop >>>>'+cs.keySet());
                    for(String s :cs.keySet()){
                    ////system.debug('s!!!!'+s);
                       // if(s.contains('Default Fields')){
                                //if(cs.get(s).Stage__c != null ){
                                if(cs.get(s).Stage1__c != null ){
                                        ////system.debug('asdfcasdfcascf'+cs.get(s).Stage__c);
                                        ////system.debug('asdfcasdfcascf'+cs.get(s).Stage1__c);
                                        if(allStagesValues == ''){allStagesValues = a;}
                                        else{allStagesValues = allStagesValues +','+a;}
                                        //cs.get(s).Stage__c = allStagesValues;
                                        cs.get(s).Stage1__c = allStagesValues;
                                            try{
                                                //if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Stage__c.isUpdateable()){
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Stage1__c.isUpdateable()){
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
                       // }           
                    }
                }                
                filterQuery += '\'' + String.escapeSingleQuotes(a) + '\',';
                system.debug('filterQuery>>>>'+filterQuery);
            }
           
            filterQuery = filterQuery.substring(0, filterQuery.length() -1) + ')';
            system.debug('filterQuery>>>>'+filterQuery);
            filterparams = STRAND + 'StageName IN ' + filterQuery;
            system.debug('filterQuery>>>>'+filterparams);
            
            filtersList.add(new FilterWrapper('StageName', 'IN', filterQuery));
            system.debug('filterQuery>>>>'+filtersList);
            
            //listViewFilter.add('\'' + String.escapeSingleQuotes(filterQuery) + '\'');
         }
         else {
                for(String s :cs.keySet()){
                    cs.get(s).Stage1__c = '--None--';
                }
            } 
        //oppList.LeadSource = null;
        oppList.LeadSource = leadSourceField;
        //system.debug('oppListoppListoppListoppListoppList'+oppList);
        if(oppList != NULL) {
            
        //system.debug('oppList.LeadSourceoppList.LeadSourceoppList.LeadSourceoppListoppList.LeadSource'+oppList.LeadSource);
            if(oppList.LeadSource != NULL){
              if(!cs.keySet().isEmpty()){
                    
                    for(String s :cs.keySet()){
                    ////system.debug('s!!!!'+s);
                        //if(s.size() > 0){
                                if(cs.get(s).Lead_Source__c != null ){
                                        cs.get(s).Lead_Source__c = oppList.LeadSource; 
                                            try{    
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Lead_Source__c.isUpdateable()){
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
                filterparams += STRAND +  'LeadSource = ' + '\'' + oppList.LeadSource + '\'';       
            }
            else {
                for(String s :cs.keySet()){
                    cs.get(s).Lead_Source__c = '--None--';
                }
            }
            system.debug('oppListoppLitypestoppListoppListoppList'+oppList.Type);
          //  oppList.Type = null;
            oppList.Type = oppTypeField;
            if(oppList.Type != NULL){
                
              if(!cs.keySet().isEmpty()){
                    
                    for(String s :cs.keySet()){
                    ////system.debug('s!!!!'+s);
                        //if(s.size() > 0){
                                if(cs.get(s).Opportunity_Type__c != null ){
                                        cs.get(s).Opportunity_Type__c = oppList.Type; 
                                            try{
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Opportunity_Type__c.isUpdateable()){
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
                        //}           
                    }
                }
                filterparams += STRAND +  'Type = ' + '\'' + oppList.Type + '\'';    
            }
            else {
                for(String s :cs.keySet()){
                    cs.get(s).Opportunity_Type__c = '--None--';
                }
            }
           String accountIdValueToSave = oppList.AccountId;
           // if(oppList.AccountId != NULL){
             system.debug('accountIdValueToSave'+accountIdValueToSave);
           if(accountIdValueToSave != null && accountIdValueToSave.Trim() != '' && !flag1){
              if(!cs.keySet().isEmpty()){
                    
                    for(String s :cs.keySet()){
                   // system.debug('s!!!!'+s);
                        //if(s.size() > 0){
                     //   system.debug('s!!ascasccacs.get(s).Account__cscasc!!'+cs.get(s).Account__c);
                      //  system.debug('s!!ascasccasoppList.AccountIdcasc!!'+oppList.AccountId);
                        if(cs.get(s).Account__c != null )
                        {
                            //cs.get(s).Account__c = 'aaa' ;
                            cs.get(s).Account__c = accountIdValueToSave;
                            system.debug('accountIdValueToSave'+accountIdValueToSave);
                            //accountIdValue = oppList.AccountId;
                           // system.debug('s!!ascasccascasc!!'+s + ' >>>> '+ cs.get(s).Account__c);
                            try{    
                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Account__c.isUpdateable()){ 
                                   update cs.get(s);
                                    //system.debug('s!!cascasc!!oppList.AccountId>>>>>> '+ s + ' >>>>> '+ oppList.AccountId+ ' >>>>> ');
                                }
                                else{
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                                }
                            }
                            catch(DmlException e) {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                            }
                        }
                        //}           
                    }
                }
                //filterparams += STRAND +  'AccountId = ' + '\'' + accountIdValue + '\'';               
                filterparams += STRAND +  'AccountId = ' + '\'' + oppList.AccountId + '\'';   
                system.debug('>>>>>>>>.filterparams'+filterparams); 
            }
            else {
                for(String s :cs.keySet()){
                    cs.get(s).Account__c = '--None--';
                }
            }
             String CampaignIdValueToSave = oppList.CampaignId;
            flag1= false;
           if(CampaignIdValueToSave != null && CampaignIdValueToSave.Trim() != ''){
          
            
            //if(oppList.CampaignId != NULL){
              if(!cs.keySet().isEmpty()){
                    
                    for(String s :cs.keySet()){
                    ////system.debug('s!!!!'+s);
                        //if(s.size() > 0){
                        if(cs.get(s).Campaign__c != null ){
                            cs.get(s).Campaign__c = CampaignIdValueToSave ;
                          //  cs.get(s).Campaign__c = oppList.CampaignId;
                            try{
                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Campaign__c.isUpdateable()){ 
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
                        //}           
                    }
                }
                filterparams += STRAND +  'CampaignId = ' + '\'' + oppList.CampaignId + '\'';    
            }
            else {
                for(String s :cs.keySet()){
                    cs.get(s).Campaign__c = '--None--';
                }
            } 
        }
        
        if(String.isNotEmpty(forecastCategory) && forecastCategory != '--None--') {
            if(!cs.keySet().isEmpty()){
                    
                    for(String s :cs.keySet()){
                    ////system.debug('s!!!!'+s);
                        //if(s.size() > 0){
                                if(cs.get(s).Forecast_Category__c != null ){
                                        cs.get(s).Forecast_Category__c = forecastCategory; 
                                            try{
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Forecast_Category__c.isUpdateable()){
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
                        //}           
                    }
                }
                filterparams += STRAND + 'ForecastCategory = ' +  '\'' + forecastCategory + '\'';    
        }
        else {
                for(String s :cs.keySet()){
                    cs.get(s).Forecast_Category__c = '--None--';
                }
            } 
         system.debug('openClosed>>>> '+openClosed);   
        if(openClosed != null &&  openClosed != '--None--'){
              if(!cs.keySet().isEmpty()){
                    
                    for(String s :cs.keySet()){
                    ////system.debug('s!!!!'+s);
                        //if(s.size() > 0){
                                if(cs.get(s).Open_Closed__c != null ){
                                        cs.get(s).Open_Closed__c = openClosed; 
                                            try{
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Open_Closed__c.isUpdateable()){
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
                        //}           
                    }
                }
         
            if(openClosed == 'Open'){
                filterparams += STRAND + 'IsClosed = false';        
            } else if(openClosed == 'Closed Won'){
                filterparams += STRAND + 'IsClosed = true AND IsWon = true';    
            }               
            else if(openClosed == 'Closed Lost'){
                filterparams += STRAND + 'IsClosed = true AND IsWon = false';    
            }
        }
        else {
                for(String s :cs.keySet()){
                    cs.get(s).Open_Closed__c = '--None--';
                }
            } 
        
        if(isOwnerChecked) {
            if(!cs.keySet().isEmpty()){
                    
                    for(String s :cs.keySet()){
                    ////system.debug('s!!!!'+s);
                        //if(s.size() > 0){
                                if(cs.get(s).Only_own_records__c != null ){
                                        cs.get(s).Only_own_records__c = isOwnerChecked; 
                                            try{
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Only_own_records__c.isUpdateable()){
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
                        //}           
                    }
                }
            filterparams += STRAND + 'OwnerId = ' + '\'' +  UserInfo.getUserId() + '\'';        
        }else{
              if(!cs.keySet().isEmpty()){
                    
                    for(String s :cs.keySet()){
                    ////system.debug('s!!!!'+s);
                        //if(s.size() > 0){
                                if(cs.get(s).Only_own_records__c != null ){
                                        cs.get(s).Only_own_records__c = isOwnerChecked; 
                                            try{
                                                if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Only_own_records__c.isUpdateable()){
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
                        //}           
                    }
                }
        }
        
        
        if(String.isNotEmpty(time1)){
            //system.debug('Query in if');        
            Date startDate;
            Date endDate;
            Date todayDate = Date.today();
            
              if(!cs.keySet().isEmpty()){
                    
                    for(String s :cs.keySet()){
                    ////system.debug('s!!!!'+s);
                        //if(s.size() > 0){
                        if(cs.get(s).Timeframe__c != null ){
                            cs.get(s).Timeframe__c = time1; 
                                try{
                                    if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Timeframe__c.isUpdateable()){
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
                        //}           
                    }
                }
            String ss = timeFrame(time1);
            /*
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
            */
            if(ss != NULL && ss.Trim() != '') {
                filterparams += STRAND + ss; 
            }
        }
        else {//system.debug('Query in else');
                for(String s :cs.keySet()){
                    cs.get(s).Timeframe__c = '--None--';
                }
        } 
        
        
        if(String.isNotEmpty(filterparams)){
            filterparams = EncodingUtil.urlEncode(filterparams.substring(4, filterparams.length()), 'UTF-8');
            system.debug('filterparamsfilterparamsfilterparams'+filterparams);     
        } 
        
        if(!filtersList.isEmpty()){
            listViewFilter = String.escapeSingleQuotes(json.serialize(filtersList));
        }
        exportFilter = filterparams;//EncodingUtil.urlEncode(filterparams,'UTF-8'); 
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
            totalFilter = ' CloseDate >='  + String.valueOf(startDate) +  ' AND  CloseDate <='  + String.valueOf(endDate);
        }
        return totalFilter;
    }
    
    public class FilterWrapper {
        public String field;
        public String operator;
        public String value;
        
        public FilterWrapper(String field, String operator, String value){
            this.field = field;
            this.operator = operator;
            this.value = value; 
        }
    }
   public string lookupCheck(String fieldsTobeQueried){
        
        try{List<String> fieldsTobeQuriedFromOriginal = new list<String>();
        for(String str: fieldsTobeQueried.split(',')){
            fieldsTobeQuriedFromOriginal.add(str);
        }
        String type='Opportunity';
        String queryTobeReplaced='';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
     
        for (String fieldName: fieldsTobeQuriedFromOriginal) {
 
        //It provides to get the object fields label.
       
            String fieldLabel = fieldMap.get(fieldName.replace('-','').replace('','')).getDescribe().getLabel();
     
           //It provides to get the object fields data type.
            Schema.DisplayType fielddataType = fieldMap.get(fieldName.replace('-','').replace('','')).getDescribe().getType();
                system.debug(fielddataType);
                if(fielddataType == Schema.DisplayType.Reference){
                        system.debug('In Reference');
                    if(fieldName.length() > 2 &&( fieldName.lastIndexOf('Id')!= -1 || fieldName.lastIndexOf('id') != -1) ){
                        system.debug('In Reference1');
                        
                        String tobeadded = fieldName.toLowerCase().replace('id','.name');
                        system.debug('In Reference1'+tobeadded);
                        queryTobeReplaced +=','+tobeadded ;
                    }else if(fieldName.length() > 2 && (fieldName.lastIndexOf('__c') != -1 ||fieldName.lastIndexOf('__C') != -1 )){
                         String tobeadded = fieldName.toLowerCase().replace('__c','__r.name');
                         queryTobeReplaced +=','+tobeadded ;
                    }
                
                }else{
                    system.debug('I am here for normal');
                     queryTobeReplaced +=','+fieldName;
                    
                
                }
            
            }
          queryTobeReplaced=queryTobeReplaced.replaceFirst(',','');
            return queryTobeReplaced;
         } catch(Exception e){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error Message.'+e.getMessage()+e.getLineNumber()));
      
         return null;
      }
   
    
    }
    public map<String,String>lookupCheckAgain(String fieldsTobeQueried){
        map<String,String> fieldVsLookUpField =  new map<String,String>();
        List<String> fieldsTobeQuriedFromOriginal = new list<String>();
        for(String str: fieldsTobeQueried.split(',')){
            fieldsTobeQuriedFromOriginal.add(str);
        }
        String type='Opportunity';
        String queryTobeReplaced='';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
     try{
        for (String fieldName: fieldsTobeQuriedFromOriginal) {
 
        //It provides to get the object fields label.
             system.debug('???????'+fieldName);
             system.debug(fieldName.replace('-','').replace('',''));
             system.debug(fieldMap.get(fieldName.replace('-','').replace('','')));
            String fieldLabel = fieldMap.get(fieldName.replace('-','').replace('','')).getDescribe().getLabel();
     
           //It provides to get the object fields data type.
            Schema.DisplayType fielddataType = fieldMap.get(fieldName.replace('-','').replace('','')).getDescribe().getType();
                system.debug(fielddataType);
                if(fielddataType == Schema.DisplayType.Reference){
                        system.debug('In Reference');
                    if(fieldName.length() > 2 &&( fieldName.lastIndexOf('Id')!= -1 || fieldName.lastIndexOf('id') != -1) ){
                        system.debug('In Reference1');
                        
                        String tobeadded = fieldName.toLowerCase().replace('id','.name');
                        system.debug('In Reference1'+tobeadded);
                        queryTobeReplaced +=','+tobeadded ;
                        fieldVsLookUpField.put(fieldName,tobeadded);
                    }else if(fieldName.length() > 2 && (fieldName.lastIndexOf('__c') != -1 ||fieldName.lastIndexOf('__C') != -1 )){
                         String tobeadded = fieldName.toLowerCase().replace('__c','__r.name');
                         queryTobeReplaced +=','+tobeadded;
                         fieldVsLookUpField.put(fieldName,tobeadded);
                    }
                
                }else{
                    system.debug('I am here for normal');
                     queryTobeReplaced +=','+fieldName;
                     fieldVsLookUpField.put(fieldName,fieldName);
                    
                
                }
            
            }}catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error Message.'+e.getMessage()));
            
            }
          queryTobeReplaced=queryTobeReplaced.replaceFirst(',','');
          return fieldVsLookUpField;
    }
    public boolean isExist(list<String> stringList,string stringObject){
        for(String str:stringList){
            if(str.equalsIgnoreCase(stringObject)){
                return true;
            }else 
                return false;
        
        }
        return false;
    }
    public string nameofCampaingnOrAccount{get;set;}
    public void removeValueFromLookUp(){
        system.debug(nameofCampaingnOrAccount +'!!!!!!!!!!');
        if(nameofCampaingnOrAccount == null || nameofCampaingnOrAccount==''){
              oppList.accountId = null;
               // update oppList;
               oppAccountName='';
               flag1 = true;
            List<Opportunity_Manager_Setting__c> ls = [select Id,Only_own_records__c,Stage__c,Account__c,Campaign__c,Open_Closed__c ,Forecast_Category__c,Opportunity_Type__c,Lead_Source__c,Timeframe__c,Name, Save_Filers2__c, Save_Filers__c, Save_Filers3__c from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];    
            if(ls != null && !ls.isEmpty()){
                ls[0].Account__c='--None--';
               update ls[0];
            }
        }
        
        system.debug(  oppList.accountId );
    }
    public string nameofCampaingnOrAccount1{get;set;}
    public void removeValueFromLookUp1(){
        if(nameofCampaingnOrAccount1 == null || nameofCampaingnOrAccount1==''){
             List<Opportunity_Manager_Setting__c> ls = [select Id,Only_own_records__c,Stage__c,Account__c,Campaign__c,Open_Closed__c ,Forecast_Category__c,Opportunity_Type__c,Lead_Source__c,Timeframe__c,Name, Save_Filers2__c, Save_Filers__c, Save_Filers3__c from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];    
            if(ls != null && !ls.isEmpty()){
                ls[0].Campaign__c='--None--';
                update ls[0];
                oppList.campaignId = null;
                oppCampaignName ='';
            }
        
        }
    
    }
    
  
  // code ends here =============
}