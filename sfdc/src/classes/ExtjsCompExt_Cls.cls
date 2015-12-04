global with sharing class ExtjsCompExt_Cls {

    global static String ObjectName;
    global static List<SelectOption> ListViewList;
    global static list<Sobject> debug12{get;set;}
    global static CRUDResponse todebug{get;set;}
    global static Boolean isACMEnabled{get{return UserInfo.isMultiCurrencyOrganization();}set;}
    global static String defaultCurrency{get{return UserInfo.getDefaultCurrency();}set;}
    global static  string demoField{get;set;}
    //global static ListView__c selListView;
    
   // static boolean defaultCurrencyACM = UserInfo.isMultiCurrencyOrganization();
   // static String defaultCurrency1 = UserInfo.getDefaultCurrency();
    
    // a class for supplying field property info to the VF component for use in setting up the grid
    global ExtjsCompExt_Cls() {
        if(isACMEnabled){
            isACMEnabled = true;
        }
        else{
            isACMEnabled = false;
        }
        

    }
    
    global class FieldInfo {
        global String name;
        global Boolean modifiable;
        global Boolean sortable;
        global Boolean nillable;
        global Boolean filterable;
        global Boolean hidden;
        global String fieldType;
        global String label;
        global List<List<String> > picklistValues;      // a list of string pairs as needed by picklist column editor
        global Boolean hasPickListValues;
        global String relationName;
        global String relatedField; // get the relation name for parent field
        global Boolean relObjectAccess; // if related object is accessible or not
    }
    
    static List<Opportunity_Manager_Setting__c> ls = [select Id,Name,Default_Values__c,Account__c, Save_Filers2__c, Save_Filers__c, Save_Filers3__c from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
    
    // get object metadata and supply to component
    static Map<String, Schema.SObjectType> objTypeMap = Schema.getGlobalDescribe();
    
    @RemoteAction
    global static List<FieldInfo> describeFields(String objName, List<String> fieldNames) {
        
        /*objName = String.escapeSingleQuotes(objName); 
        List<String> fieldNames = new List<String>();
        for(String ss:fieldNames1){
            ss =String.escapeSingleQuotes(ss);
            fieldNames.add(ss);
        }
        */ 
        
        //system.debug('describeFieldsdebug');
         //defaultCurrency = defaultCurrency1 ;
        //defaultCurrency = UserInfo.getDefaultCurrency();
        if(isACMEnabled){
            isACMEnabled = true;
        }
        else{
            isACMEnabled = false;
        }          
        // get default column list 
        Set<String> defaultcols = new Set<String>();
        List<string> val = new List<string>();
        List<boolean> val1 = new List<boolean>();
        String fieldsObj = '';
        
        /*Modified By Gulshan*/
        
        Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);
        //system.debug('>>>>>>>>>>>cs>>>>>>'+cs);
        try {
            if(!cs.keySet().isEmpty()){
                //system.debug('>>>>>>>>>>>>>>>>>');
                for(String s :cs.keySet()){
                    if(cs.get(s).Default_Values__c != null){
                        //system.debug('fieldsObjfieldsObjfieldsObj'+fieldsObj);
                         fieldsObj = cs.get(s).Default_Values__c;
                    }
                }
            }
            if(String.isNotEmpty(fieldsObj)){
                for(String a :fieldsObj.split(',')){
                    defaultcols.add(a.trim().toLowerCase());    
                }
            }
            ////system.debug('defaultcols>>>> '+defaultcols);
        } catch(Exception e){
            ////system.debug('Error ::' + e.getMessage());
        }
        /*Modified By Gulshan*/
        
        
        if (!objTypeMap.containsKey(objName)) {
            throw new DescribeException('No SObject named ' + objName + ' found');
        }
        // TODO: check for accessibility as well
        Schema.SObjectType sobj = objTypeMap.get(objName);
        ////system.debug('sobj>>>>>'+sobj);
        ////system.debug('objName>>>>>'+objName);
        Map<String, Schema.SObjectField> fieldMap = sobj.getDescribe().fields.getMap();
        // iterate, supplying meta information in format Ext likes
        List<FieldInfo> result = new List<FieldInfo>();
        ////system.debug('fieldNames>>>>>>>>'+fieldNames);
        list<String> fieldNames1 = new list<String>();
        for(String col: fieldsObj.split(',')){
            fieldNames1.add(col.replace('-','').replace('',''));
        }
        boolean flag = true;
        //system.debug('>>>>>>>>fieldNames'+fieldNames);
        //fieldNames.sort();
        for(String col: fieldNames){
            /*
            string a = 'ForecastCategoryName';
            If(col.contains(a)){
                col =  col.replaceFirst(a , '');
            } 
            */
            flag = true;
            
            for (String field : fieldsObj.split(',')) {
                //system.debug(field +'======= =='+ col);
                string temp = field; 
                string temp1 = col;
                
                if(field == col || temp.replace('-','').replace('','') == temp1.replace('-','').replace('','')){
                    flag = false;
                }
            }
            if(flag){
                fieldNames1.add(col.replace('-','').replace('',''));
            }
        }
      //  system.debug(fieldNames+'%%%%%%%%%%');
        system.debug('fieldNames1>>> '+fieldNames1);
        integer handlePickListGovernanceLimit = 0;
        
        for (String field : fieldNames1) {
            if('forecastcategory'.equalsIgnoreCase(field)){
                continue;
            }
            FieldInfo fi = new FieldInfo();
            Schema.DescribeFieldResult dfr;
            String linkedField;  // ContactId- Contact.Name
            
            ////system.debug('field ::' + field);
            
            
            if(field.indexOf('-') != -1 && field.indexOf('.') != -1) {                
                linkedField = field.substring(field.indexOf('-') + 1, field.length()); 
                field = field.subString(0, field.indexOf('-'));   
            }
            
            if(fieldMap.containsKey(field)) {
                //system.debug('>>>>>describe>>>'+field);
                dfr = fieldMap.get(field).getDescribe(); 
                fi.label = dfr.getLabel();    
            }
             // check for user fields
            else if(field.containsIgnoreCase('Owner.') || field.containsIgnoreCase('CreatedBy.') || field.containsIgnoreCase('LastModifiedBy.')) {
               sobj =  objTypeMap.get('User');
               dfr  =  sobj.getDescribe().fields.getMap().get(field.subString(field.indexOf('.') + 1, field.length()) ).getDescribe();        
               if(field.containsIgnoreCase('Owner.')){
                   fi.label = 'Owner ' + dfr.getLabel();       
               } else if(field.containsIgnoreCase('CreatedBy.')){
                   fi.label = 'Created By';         
               } else if(field.containsIgnoreCase('LastModifiedBy.')){
                  fi.label = 'Last Modified By';      
               }
               
            }
            // check for record type fields
            else if(field.containsIgnoreCase('RecordType.')){
               sobj =  objTypeMap.get('RecordType');
               dfr  =  sobj.getDescribe().fields.getMap().get(field.subString(field.indexOf('.') + 1, field.length())).getDescribe();
               fi.label = 'RecordType ' + dfr.getLabel(); 
            } 
             
            
            else if(!fieldMap.containsKey(field)) {
                throw new DescribeException('Looks like Opportunity Manager Setting is not created.<br/> Please refresh the page <b>or</b> click on "Reset Filter" button!');
            } 
            
            
            //fi.name = field;
            fi.name =  dfr.getName();  
            fi.modifiable = dfr.isCreateable() | dfr.isUpdateable();
            fi.sortable = dfr.isSortable();
            fi.nillable = dfr.isNillable();
            fi.filterable = dfr.isFilterable();
            
            if(String.isEmpty(fi.fieldType)) {
                fi.fieldType = String.valueOf(dfr.getType()).toLowerCase();
            }
           
            if (dfr.getType() == Schema.DisplayType.Picklist) {
                
                fi.picklistValues = new List<List<String> >();
                
                // Only 100 getDescribe call is allowed in SFDC for PickList, hence we are limiting it to 100 only.
                // So for 100 Picklist, options will be available in the filter section. For others, text filter will be applicable.
                if(handlePickListGovernanceLimit < 100)
                {
                    
                    fi.hasPickListValues = true;
                   
                    for (Schema.PicklistEntry plv : dfr.getPicklistValues()) {
                        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@'+plv.getValue());
                        if (plv.isActive()) {
                            fi.picklistValues.add(new String[]{plv.getLabel(), plv.getValue()});
                        }
                    } 
                    // add empty string option if nillable
                    if (dfr.isNillable()) {
                        fi.picklistValues.add(new String[]{'None', ''});
                    }
                   
                    handlePickListGovernanceLimit++;
                } else
                {
                    fi.hasPickListValues = false;
                    //fi.picklistValues.add(new String[]{'Too_Many_Picklist', 'Too_Many_Picklist'});
                }
                
            } else if(dfr.getType() == Schema.DisplayType.Reference) {
                Schema.SObjectType relObject;
                String relfield;
                String member = '.';
                fi.relationName =  dfr.getRelationshipName();  // get relationship name
                relObject = dfr.getReferenceTo().get(0);       // get related object 
                Schema.DescribeSObjectResult relObjInfo = relObject.getDescribe();
                if(relObjInfo.isAccessible()){
                    fi.relObjectAccess = true;    
                } else {
                    fi.relObjectAccess = false; 
                }
                
                Map<String, Schema.SObjectField> relObjfieldMap = relObjInfo.fields.getMap();
                
                if(String.isNotEmpty(linkedField)) {
                    // for standard relationships;
                    fi.relatedField = fi.relationName + member + linkedField.split('\\.')[1];
                    fi.label = linkedField.replaceFirst('\\.', ' '); 
                } else {
                // for custom relationships
                // find primary field of an Sobject
                    if(relObjfieldMap.containsKey('Name')){ 
                        relfield =  'Name';     
                    } else if(relObjfieldMap.containsKey('Title')) { 
                        relfield =  'Title'; 
                    } else if(relObjfieldMap.containsKey('CaseNumber')) { 
                        relfield =  'CaseNumber';        
                    }
                    fi.relatedField =  fi.relationName + member + relfield; 
                    
                    if(!dfr.isCustom()){
                        if(relfield == 'Name') {
                            fi.label = dfr.getRelationshipName()  + ' ' + relfield;  
                        }  else {
                            fi.label = dfr.getRelationshipName();    
                        }
                    } else {
                        fi.label = dfr.getLabel(); 
                    }         
                }
                     
            }
            ////system.debug('fi!!!!!!!!!!!1'+fi);
            fi.hidden = false;
             
            ////system.debug('defaultcols!!!!!!!!!!!1'+defaultcols+ fi.name);
            if(!defaultcols.contains(fi.name.trim().toLowerCase())){
                fi.hidden = true;
            } 
            
            
            ////system.debug('fi.hidden>>>>>>>>defaultcols>>>>>>>>>>>>. '+defaultcols+fi.hidden+fi.Name);
            //For(List<string> a : fi.Name){
            //val.add(a);
            //}
            val.add(fi.Name);
            val1.add(fi.hidden);
            ////system.debug('val>>>>>>>>>>>>>>>'+val);
            ////system.debug('val1>>>>>>>>>>>>>>>'+val1);
            result.add(fi);
            dfr = null;
        }
        List<String> var2 = new List<String>(); 
        ////system.debug('result>>>>>>> '+result);
        //result = sortByName(result,'');

       
        return result;
        
        
    }
    /*
    public static list<FieldInfo> sortByName(list<FieldInfo> wrapperObject,String sortingOrder) {
        if(wrapperObject == null || wrapperObject.size() <= 1){
            return wrapperObject ;
        }
        List<FieldInfo> lessSelectOption = new List<FieldInfo>();
        List<FieldInfo> greaterSelectOption = new List<FieldInfo>();
        integer pivot = wrapperObject.size() / 2;
        
        //save the pivot and remove it from the wrapper list
        FieldInfo pivotValue = wrapperObject[pivot];
        wrapperObject.remove(pivot);        
        for(FieldInfo SO : wrapperObject){
            if(sortingOrder == 'Desc'){
                if(SO.name > pivotValue.name){
                    lessSelectOption.add(SO);
                }else if(SO.name <= pivotValue.name){
                    greaterSelectOption.add(SO);   
                }
            }else{
                if(SO.name <= pivotValue.name){
                    lessSelectOption.add(SO);
                }else if(SO.name > pivotValue.name){ 
                    greaterSelectOption.add(SO);   
                }
            }
        }
        list<FieldInfo> sortedSelectOptions = new list<FieldInfo>(); 
        sortedSelectOptions.addAll(sortByName(lessSelectOption,''));
        sortedSelectOptions.add(pivotValue);
        sortedSelectOptions.addAll(sortByName(greaterSelectOption,''));
        return SortedSelectOptions;
    }
    */
    // a user-defined class that will serialize to the JSON expected by the ExtJS DirectProxy api methods
  
    global class CRUDResponse {
        global Boolean success;
        global String errorMessage;
        global List<SObject> records;
        global Integer total;
        public CRUDResponse() {
            records = new List<SObject>();
            success = true;
        }
    }
    
    // Unfortunately JS Remoting member functions must be static, so cannot access non-static class members,
    // which means we cannot cache query results in this controller but must respond to each request anew
    
    
    global class QueryObj {
        global String sobjname;
        global String fields;
        global Map<String, String> fieldTypeMap;
        global String queryscope;
        global String queryfilter;
        global Integer start;
        global Integer recordCount;
        global String filter;     // json filter string
        global List<Map<String, String> > sortParams;
    }
    
    // turn grid's page load/sort request into SOQL and return data
    @RemoteAction @readOnly
    global static CRUDResponse query(QueryObj qobj) {
        
        //System.debug('-------onLoadCheck-------------'+onLoadCheck);
        if(qobj.sobjname!=null && qobj.sobjname!='')
        qobj.sobjname = String.escapeSingleQuotes(qobj.sobjname);
        if(qobj.fields!=null && qobj.fields!='')
        qobj.fields = String.escapeSingleQuotes(qobj.fields);
       // qobj.fieldTypeMap = String.escapeSingleQuotes(qobj.fieldTypeMap.keyset());
       // qobj.queryscope = String.escapeSingleQuotes(qobj.queryscope);
        //qobj.queryfilter = String.escapeSingleQuotes(qobj.queryfilter);
       // qobj.filter = String.escapeSingleQuotes(qobj.filter);
       // qobj.sortParams = String.escapeSingleQuotes(qobj.sortParams);
        
        system.debug('----------'+qobj);
        system.debug('!!!!!!!!!!'+qobj.fields.indexOf('probability'));
        CRUDResponse resp = new CRUDResponse();
        String gridFilter = '';
        String totalFilter = '';
        
        system.debug('qobj.queryfilter>>>>>>>>>>>>'+qobj.queryfilter);
         // add top filter params in query 
         if(String.isNotEmpty(qobj.queryfilter)){
             totalFilter =  '(' +  EncodingUtil.urlDecode(qobj.queryfilter, 'UTF-8') + ')';             
         }
         /*else{
             totalFilter = 
         }*/
         system.debug('totalFilter else>>>'+totalFilter );
         Boolean filterValueNullCheck = false;
         Boolean gridOnlyFilterCheck = false;
         // add grid filter params in query
         if(qobj.filter != null) {
             gridFilter = MetadataUtility.parseCutsomFilters(qobj.filter, qobj.fieldTypeMap);
             if(String.isNotEmpty(totalFilter)){
                 totalFilter += gridFilter; 
                 system.debug('totalFilter >>>'+totalFilter );
                 gridOnlyFilterCheck = false;  
             }
             else {                 
                 filterValueNullCheck = true;
                 gridOnlyFilterCheck = true;
                 totalFilter = gridFilter.subString(4, gridFilter.length());
                 system.debug('totalFilter else>>>'+totalFilter );
             }
         }
         string abc = ' AccountId = \'\' AND';
         if(totalFilter.indexOf(abc) != -1){
             totalFilter = totalFilter.replace(abc,' ');
         }
         string def = ' CampaignId = \'\' AND';
         if(totalFilter.indexOf(def) != -1){
             totalFilter = totalFilter.replace(def,' ');
         }
         system.debug('totalFilter else>>>'+totalFilter );
         if(String.isNotEmpty(totalFilter)){
             totalFilter = ' WHERE ' + totalFilter;
             system.debug('totalFilter >>>'+totalFilter );
             //totalFilter = totalFilter.subString(0,totalFilter.lastIndexOf('AND'))+' '+totalFilter.subString(totalFilter.lastIndexOf('AND'),totalFilter.length());
             //totalFilter = totalFilter.replaceFirst('AND', ' WHERE ');
         }
         else{
             filterValueNullCheck = true;    
             system.debug('totalFilter >>>'+totalFilter );   
         }
         system.debug('totalFilter else>>>'+totalFilter );
        totalFilter = totalFilter.replace('AND )', ' )');
        system.debug('totalFilter else>>>'+totalFilter );
        String time1= '';
        String leadSourceValue = '';
        String opportunityTypeValue = '';
        String forecastCategoryValue = '';
        String openClosedValue = '';   
        String accountValue = '';
        String campaignValue = '';
        String stageValue = '';
        Boolean ownRecordValue = false;
        /*===================================================*/
          List<Opportunity_Manager_Setting__c> lss = [select Id,Account__c,Open_Closed__c,Forecast_Category__c,Opportunity_Type__c,
                                                                    Lead_Source__c,Timeframe__c,Name, Save_Filers2__c, Save_Filers__c, 
                                                                    Save_Filers3__c,Campaign__c,Default_Values__c,Only_own_records__c,  
                                                                    Stage1__c
                                                                    from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
          Map<Id, Opportunity_Manager_Setting__c> css = new Map<Id, Opportunity_Manager_Setting__c>(lss); 
          if(!css.keySet().isEmpty()){
                for(String s :css.keySet()){
                    /*
                   if(css.get(s).Timeframe__c != null && css.get(s).Timeframe__c == 'This Quarter'){
                        filterValueCheck = true;
                        
                   }
                   if(css.get(s).Timeframe__c != null && css.get(s).Timeframe__c != 'This Quarter'){
                        filterValueCheck = false;
                   }
                   */
                   if(css.get(s).Timeframe__c != null && css.get(s).Timeframe__c.Trim() != ''){
                        time1 = css.get(s).Timeframe__c;
                   }
                   else{
                        time1 = 'This Quarter';
                   }
                   if(css.get(s).Lead_Source__c != null && css.get(s).Lead_Source__c != '--None--'){ 
                        leadSourceValue = css.get(s).Lead_Source__c;
                   }
                   if(css.get(s).Opportunity_Type__c != null && css.get(s).Opportunity_Type__c != '--None--'){ 
                        opportunityTypeValue = css.get(s).Opportunity_Type__c;
                   }
                   if(css.get(s).Forecast_Category__c != null && css.get(s).Forecast_Category__c != '--None--'){ 
                        forecastCategoryValue = css.get(s).Forecast_Category__c;
                   }
                   if(css.get(s).Open_Closed__c != null && css.get(s).Open_Closed__c != '--None--'){ 
                        openClosedValue = css.get(s).Open_Closed__c;
                   }
                   if(css.get(s).Account__c != null && css.get(s).Account__c != '--None--'){ 
                        accountValue = css.get(s).Account__c;
                   }
                   if(css.get(s).Campaign__c != null && css.get(s).Campaign__c != '--None--'){ 
                        campaignValue = css.get(s).Campaign__c;
                   }
                   //if(css.get(s).Stage__c != null && css.get(s).Stage__c != '--None--'){ 
                        //stageValue = css.get(s).Stage__c;
                   //}
                   if(css.get(s).Stage1__c != null && css.get(s).Stage1__c != '--None--'){ 
                        stageValue = css.get(s).Stage1__c;
                   }
                   if(css.get(s).Only_own_records__c != null && css.get(s).Only_own_records__c != false){ 
                        ownRecordValue = css.get(s).Only_own_records__c;
                   }               
                       
                    
                }
          }
          else{
                time1 = 'This Quarter';
          } 
            boolean isAllTime = false;
            Date startDate;
            Date endDate;
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
                startDate = Date.newInstance(2000, 1, 1);
                endDate = todayDate;  
                isAllTime =true;    
            }
             List<string> onLoadFiltersList = new List<string>();
            if(filterValueNullCheck)
            {                        system.debug('totalFilter >>>'+totalFilter );
                if(startDate != NULL && endDate != NULL) {
                    if(totalFilter != null && totalFilter.Trim() !='' && !isAllTime){                             system.debug('totalFilter >>>'+totalFilter );            
                        totalFilter += ' AND (CloseDate >='  + String.valueOf(startDate) +  ' AND CloseDate <='  + String.valueOf(endDate)+') ' ;
                        system.debug('totalFilter >>>'+totalFilter );
                    }
                    else if(totalFilter != null && totalFilter.Trim() !='' && isAllTime){                             system.debug('totalFilter >>>'+totalFilter );            
                    //    totalFilter += ' AND (CloseDate >='  + String.valueOf(startDate) +  ' AND CloseDate <='  + String.valueOf(endDate)+') ' ;
                        system.debug('totalFilter >>>'+totalFilter );
                    }
                     else if(isAllTime){                             system.debug('totalFilter >>>'+totalFilter );            
                    //    totalFilter += ' AND (CloseDate >='  + String.valueOf(startDate) +  ' AND CloseDate <='  + String.valueOf(endDate)+') ' ;
                        system.debug('totalFilter >>>'+totalFilter );
                    }
                    else
                    {
                        totalFilter = ' Where (CloseDate >='  + String.valueOf(startDate) +  ' AND CloseDate <='  + String.valueOf(endDate)+') ' ;
                        system.debug('totalFilter >>>'+totalFilter );
                    }
                    
                }
                 
                if(!String.isBlank(leadSourceValue)){
                    leadSourceValue = ' LeadSource = ' + '\'' + leadSourceValue + '\''; 
                    onLoadFiltersList.add(leadSourceValue);          
                 }       
             
                 if(!String.isBlank(opportunityTypeValue)){
                    opportunityTypeValue = ' Type = ' + '\'' + opportunityTypeValue + '\'';
                    onLoadFiltersList.add(opportunityTypeValue);             
                 }
                 
                 if(!String.isBlank(forecastCategoryValue)){
                    forecastCategoryValue = ' ForecastCategory = ' +  '\'' + forecastCategoryValue + '\'';  
                    onLoadFiltersList.add(forecastCategoryValue);            
                 }
                 
                 if(!String.isBlank(openClosedValue)){
                    if(openClosedValue == 'Open'){
                        openClosedValue = ' IsClosed = false';        
                    }
                    else if(openClosedValue == 'Closed Won'){
                        openClosedValue = ' IsClosed = true AND IsWon = true';    
                    }               
                    else if(openClosedValue == 'Closed Lost'){
                        openClosedValue = ' IsClosed = true AND IsWon = false';    
                    }                     
                    onLoadFiltersList.add(openClosedValue);          
                 }
                 
                 if(!String.isBlank(accountValue)){
                    accountValue = ' AccountId = ' + '\'' + accountValue + '\'';                    
                    onLoadFiltersList.add(accountValue);            
                 }
                 
                 if(!String.isBlank(campaignValue)){
                    campaignValue = ' CampaignId = ' + '\'' + campaignValue + '\'';                     
                    onLoadFiltersList.add(campaignValue);           
                 }
                 if(!String.isBlank(stageValue)){
                    String stageFilter = ' ';
                    stageFilter += '(';
                    String[] ss = stageValue.split(',');
                    for(String a: ss){
                        stageFilter += '\'' + String.escapeSingleQuotes(a) + '\',';
                    } 
                    stageFilter = stageFilter.substring(0, stageFilter.length() -1) + ')';
                    stageValue = ' StageName IN ' + stageFilter + ' ';
                    system.debug('stageValue'+stageValue);
                    onLoadFiltersList.add(stageValue);
                 }
                 
                 if(ownRecordValue){
                    String ss1 = ' OwnerId = ' + '\'' +  UserInfo.getUserId() + '\'';                   
                    onLoadFiltersList.add(ss1);         
                 }
                 if(onLoadFiltersList != null && onLoadFiltersList.size()>0){                        
                     system.debug('1totalFilter >>>'+totalFilter );
                     /*if(totalFilter != null && totalFilter.trim() != ''){
                        totalFilter = ' WHERE ' +  String.join(onLoadFiltersList,' AND ');
                     }else{
                        totalFilter = totalFilter + ' AND ' +  String.join(onLoadFiltersList,' AND ');
                     }*/ 
                     if(totalFilter != null && totalFilter.length() >1)
                        totalFilter = totalFilter + ' AND ' +  String.join(onLoadFiltersList,' AND ');
                     else{
                        totalFilter = ' where '+  String.join(onLoadFiltersList,' AND ');
                     } 
                     totalFilter = totalFilter.trim();                         system.debug('totalFilter >>>'+totalFilter );
                     String andCheck = totalFilter.substring(totalFilter.length()-4,totalFilter.length());
                     if(andCheck.contains('AND')){
                        totalFilter = totalFilter.subString(0,totalFilter.length()-4);
                     }
                     system.debug('2totalFilter >>>'+totalFilter );
                 }  
            }
            else
            {
                if(startDate != NULL && endDate != NULL && !isAllTime) {
                    totalFilter += ' AND (CloseDate >='  + String.valueOf(startDate) +  ' AND CloseDate <='  + String.valueOf(endDate) +') ' ;
                    system.debug('totalFilter else>>>'+totalFilter );
                } else if(startDate != NULL && endDate != NULL && isAllTime){
                      //totalFilter += ' AND (CloseDate >='  + String.valueOf(startDate) +  ' AND CloseDate <='  + String.valueOf(endDate) +') ' ;
                    system.debug('totalFilter else>>>'+totalFilter );
                }
            }
            /*=============================================================================*/
         
         system.debug('totalFilter else>>>'+totalFilter );
         
         /* Create paging response */ 
        try {  
            if( lss.get(0).Timeframe__c == 'All time'){
                 totalFilter = totalFilter.replace('AND )', ' )');
            } 
            system.debug('totalFilter else>>>'+totalFilter );         
            String countQuery = String.format('SELECT COUNT() FROM {0} {1} Limit 100000', new List<String>{qobj.sobjname, totalFilter});   
            system.debug('countQuery >>>' + countQuery); 
            resp.total = Database.countQuery(countQuery.replace('Opportunity AND','Opportunity WHERE '));
        } catch (Exception e) {         
            resp.success = false;
            resp.records = null;
            resp.errorMessage = e.getMessage();
            if(e.getMessage().contains('Too many')){
                resp.errorMessage = 'More Records to display. Please Select Filter Wisely.';                
            }
     //       system.debug('dcvasdcascdsds'); 
            return resp;
            
        }
        /* Create paging response */
        
       system.debug('totalFilter else>>>'+totalFilter );
        
        // Sobject Query 
        totalFilter = ' ' + totalFilter;
        String qstr = 'SELECT ' + qobj.fields + ' FROM ' + qobj.sobjname;
        System.debug('--------------------'+qstr);
        // Query Filter
        if (String.isNotEmpty(totalFilter)){
            qstr += totalFilter;    
        }
      
       if (qobj.sortParams != null) {
            qstr += ' ORDER BY ';
            // collect sort fields/directions
            qstr += qobj.sortParams[0].get('property');
            for (Integer i = 1; i < qobj.sortParams.size(); i++) {
                qstr += ',' + qobj.sortParams[i].get('property');
            }
            // SOQL only supports a single direction, so ignoring others. Probably should return error instead.
            qstr += ' ' + qobj.sortParams[0].get('direction');
            qstr += ' NULLS LAST';

        }       
        ////system.debug('Query>>>>>' + qstr);       
        qstr +=  ' Limit 100000';
        system.debug('>>>>>Query: '+qstr);
        try {
            
            integer counter  = 1;
            qstr = qstr.replaceAll('.null','Id').replaceAll('.Null','Id');
            system.debug('>>>>>>'+qstr);
            String fieldsCSV = '';
            String fieldsCSVNew = '';
            for(String fld:qstr.split(',')){
                //system.debug('<<<<<<<<<<<<<<<<<<---------'+fieldsCSV.toLowerCase().contains(fld.toLowerCase()));
                //list<String> fldVal = fld.split(' ');

                if(!fieldsCSV.toLowerCase().contains(','+fld.toLowerCase()+',')){
                    if(fld.toLowerCase() != 'connectionreceivedid'){
                        fieldsCSV += ','+fld;
                    }
                    //fieldsCSV += ','+fld;
                    //system.debug('<<<<<<<<<<<<<<<<<<'+fld);
                }
            }
            fieldsCSV = fieldsCSV.replaceFirst(',', '');
            /*for(String str:fieldsCSV.split(',')){
                if(str.indexOf('SELECT') != -1){
                    String str1 = str.substringAfter('SELECT ');
                    str1 = 'str1;
                    
                    str = 'SELECT '+str1;
                
                }
                else if(str.indexOf('__c') != -1){
                    str = str;                
                
                }
                fieldsCSVNew+=','+str;
            
            
                system.debug('SSSSSSSSSSSSSSSSSSSS'+str);
            }*/
             //fieldsCSVNew =fieldsCSVNew.replaceFirst(',', '');
             //fieldsCSV = fieldsCSVNew;
             
             //system.debug('fieldsCSVNEW 112'+fieldsCSVNew);
             //system.debug('fieldsCSVNEW 112'+getRefiendQuery(fieldsCSV));
            //debug12 = Database.query(fieldsCSV);
            system.debug('>>>>>>>>>>>>>>----->>'+fieldsCSV);
        //    system.debug('>>>>>>>>>>>>>>----->>'+getRefiendQuery(fieldsCSV));
        demoField = fieldsCSV;
            for (List<SObject> rlit : Database.query(getRefiendQuery(fieldsCSV))) {
                
                if(counter + rlit.size() <= qobj.start) {
                    counter = counter + rlit.size();
                    continue;
                } 
                 
                           
                for (SObject rit : rlit) {
                    
                        if(counter > qobj.start && counter <= (qobj.start + qobj.recordCount)) { 
                             resp.records.add(rit);
                        }
                     
                     counter ++;
                     if(counter > (qobj.start + qobj.recordCount)){
                         break;
                     }
                }
                
                 if(counter > (qobj.start + qobj.recordCount)){
                         break;
                 }
                
            }
                                                 
        } catch (Exception e) {
            resp.success = false;
            resp.records = null;
            resp.errorMessage = e.getMessage();
            if(e.getMessage().contains('Too many')){
                resp.errorMessage = 'More Records to display. Please Select Filter Wisely.';                
            }
            return resp;
        }
    //    system.debug('totalFiltertotalFiltertotalFiltertotalFiltertotalFilter'+totalFilter);
     //   system.debug('totalFiltertresprespotalFiltertotalFiltertotalFiltertotalFilter'+resp);
        return resp;
    }

    public static String getRefiendQuery(String query){
        String q = query;
        if(query != null && query != ''){            
            query = query.toLowerCase();        
            string fieldsArray = query.substringBetween('select ',' from ').trim();
            String toReplaceWithSelect = 'select ';
            
            boolean isNameFound = false;
            boolean isTypeFound = false;
            boolean isAmountFound = false;
            
            for(String fld:fieldsArray.split(',')){             
                if(fld.trim() == 'name'){
                    isNameFound = true;
                }else if(fld.trim() == 'type'){
                    isTypeFound = true;
                }else if(fld.trim() == 'amount'){
                    isAmountFound = true;
                }
            }
            if(!isNameFound)
            {
                q = q.replace('SELECT ', 'SELECT name,');
            }
            if(!isTypeFound)
            {
                q = q.replace('SELECT ', 'SELECT type,');
            }
            if(!isAmountFound)
            {
                q = q.replace('SELECT ', 'SELECT amount,');
            }
            
        }
        return q; 
         
    }
    
    // C,U,D methods from DirectProxy all have the same argument format:
    global class CRUDData {
        global String sobjname;
        global String fields;
        global String oppId;
        global String parentFieldName;
        global List<Map<String, String> > records;
    }

    // Utility method to refresh newly created/updated objects after the DML operation, for returning to the grid
   global static CRUDResponse refreshObjects(CRUDData crudData, List<SObject> sobjs) {
        ////system.debug('>>>>Refresh <<<<<' + crudData.fields);
        
        CRUDResponse resp = new CRUDResponse();

        String objName = crudData.sobjname;
        String fieldList = crudData.fields;
        String[] fieldNames = fieldList.split(',');
        Set<ID> updatedIds = new Set<ID>();
        for (SObject sobj : sobjs) {
            updatedIds.add(sobj.id);
        }
        try{//system.debug('checking final');
        for (List<SObject> rlit : Database.query('SELECT ' + fieldList + ' FROM ' + objName +
                                                 ' WHERE Id IN :updatedIds')) {
            for (SObject rit : rlit) {
                resp.records.add(rit);
            }
        }
        }catch(Exception e){if(e.getMessage().contains('Too many')){
                resp.errorMessage = 'More Records to display. Please Select Filter Wisely.';                
            }}        
        return resp;        
    }
    

    // Create and Update are very similar.
    // Create supplies all specified fields but no Id; Update specifies Id and only the fields that changed
    @RemoteAction
    global static CRUDResponse create(CRUDData crudData) {
        ////system.debug('create crudData>>>????>>>>>' + crudData);
        CRUDResponse resp = new CRUDResponse();
        List<SObject> sobjs = unpackSobjects('create', crudData, resp);
        ////system.debug('sobjs ::::'+sobjs+'>>>'+crudData +'resp '+ resp);
        
        
        
        if (!resp.success) {
            return resp;
        }
        
        try {
                
            
            
            if (Schema.sObjectType.Opportunity.fields.Name.isCreateable() && 
                Schema.sObjectType.Opportunity.fields.StageName.isCreateable() &&
                Schema.sObjectType.Opportunity.fields.Accountid.isCreateable() &&
                Schema.sObjectType.Opportunity.fields.Amount.isCreateable() &&
                Schema.sObjectType.Opportunity.fields.CloseDate.isCreateable() &&
                Schema.sObjectType.Opportunity.fields.Type.isCreateable() &&
                Schema.sObjectType.Opportunity.fields.Probability.isCreateable() &&
                Schema.sObjectType.Opportunity.fields.LeadSource.isCreateable() &&
                Schema.sObjectType.Opportunity.fields.NextStep.isCreateable() &&
                Schema.sObjectType.Opportunity.fields.IsPrivate.isCreateable() &&
                Schema.sObjectType.Opportunity.fields.ForecastCategoryName.isCreateable() &&
                Schema.sObjectType.Opportunity.fields.Description.isCreateable()){
                insert sobjs;
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
                ////system.debug('You dont have permission to insert that record.');
            }
            
        } catch (Exception e) {
            resp.success = false;
            resp.errorMessage = 'create: insert failed with error ' + e.getMessage();
            return resp;
        }

        return refreshObjects(crudData, sobjs);
    }

    // "update" and "delete" are keywords so must pick something else
    // Ken Thompson is supposed to have said that if he could redo anything about Unix,
    // he'd spell "creat" with an extra "e".  So in that spirit:
   @RemoteAction
    global static CRUDResponse updat(CRUDData crudData) {
        CRUDResponse resp = new CRUDResponse();
        List<SObject> sobjs = unpackSobjects('update', crudData, resp);
        if (!resp.success) {
            return resp;
        }

        try {
             if (Schema.sObjectType.Opportunity.fields.Name.isUpdateable() && 
                Schema.sObjectType.Opportunity.fields.StageName.isUpdateable() &&
                Schema.sObjectType.Opportunity.fields.Accountid.isUpdateable() &&
                Schema.sObjectType.Opportunity.fields.Amount.isUpdateable() &&
                Schema.sObjectType.Opportunity.fields.CloseDate.isUpdateable() &&
                Schema.sObjectType.Opportunity.fields.Type.isUpdateable() &&
                Schema.sObjectType.Opportunity.fields.Probability.isUpdateable() &&
                Schema.sObjectType.Opportunity.fields.LeadSource.isUpdateable() &&
                Schema.sObjectType.Opportunity.fields.NextStep.isUpdateable() &&
                Schema.sObjectType.Opportunity.fields.IsPrivate.isUpdateable() &&
                Schema.sObjectType.Opportunity.fields.ForecastCategoryName.isUpdateable() &&
                Schema.sObjectType.Opportunity.fields.Description.isUpdateable()){
                update sobjs;
             }
             else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
             }
        } catch (Exception e) {
            resp.success = false;
            resp.errorMessage = 'update: failed with error ' + e.getMessage();
            return resp;
        }

        return refreshObjects(crudData, sobjs);
    }
    
    @RemoteAction
    global static CRUDResponse delet(CRUDData crudData) {
        CRUDResponse resp = new CRUDResponse();

        // produce a list of IDs from each supplied sObject
        List<Map<String, String> > sobjs = crudData.records;
        List<String> idlist = new List<String>();
        for (Map<String, String> sobj : sobjs) {
            idlist.add(sobj.get('Id'));
        }
        
        try {
            if (!Opportunity.sObjectType.getDescribe().isDeletable()) {
                Database.delete(idlist);
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have permission to Opportunity Manager custom object, Please contact to System Administrator.'));
            }
            //Database.delete(idlist);
        } catch (Exception e) {
            resp.success = false;
            resp.errorMessage = 'delete: failed with error ' + e.getMessage();
        }
        
        return resp;
    }

    // utility functions
    
    // create, update, and delete all supply things that resemble SObjects
    // (although update only has changed fields and delete only has IDs)

    // this method may seem a bit redundant when Remoting can now accept SObjects.  There are two important
    // things we do here that can't be done just by accepting List<sObject> in our methods:
    // 1) a generic sObject (not created from a describe "token") and without an Id cannot be used in DML,
    //    so we have to generate a new sObject anyway for "create" operations
    // 2) There is something funny about Date fields - I haven't been able to find a format
    //    that the server will accept.  A plain Date parameter can be supplied via UTC string, but
    //    one that is a field inside an SObject gives problems.  Converting from a string works fine though.
    
    
    static List<SObject> unpackSobjects(String action, CRUDData crudData, CRUDResponse resp) {
              
        ////system.debug(action);
        ////system.debug(crudData);
        resp.success = false;
        Set<String> modfieldSet = new Set<String>();
        
        if(String.isNotEmpty(crudData.fields)){
            modfieldSet.addAll(crudData.fields.split(',')); // list of modifiable fields
        }
        
        // use "base" params to find the sobject type we need to create
        if (crudData.sobjname == null) {
            resp.errorMessage = 'SObject name not supplied in client call';
            return null;
        }
        String objName = crudData.sobjname;
        String oppId = crudData.oppId;
        String parentField = crudData.parentFieldName;
        
        //Map<String, Schema.SObjectType> objTypeMap = Schema.getGlobalDescribe();
        if (!objTypeMap.containsKey(objName)) {
            resp.errorMessage = 'No SObject named ' + objName + ' found';
            return null;
        }
        Schema.SObjectType sobjToken = objTypeMap.get(objName);  // "token" representing this sObject type
        Map<String, Schema.SObjectField> fieldMap = sobjToken.getDescribe().fields.getMap();
        
        if (crudData.records == null) {
            resp.errorMessage = 'argument ' + crudData + ' contained no records field';
            return null;
        }
        
        List<Map<String, String> > records = crudData.records;
        List<SObject> sobjs = new List<SObject>();
        
        for (Map<String, String> recmap : records) {
            
            SObject sobj;
            if (recmap.containsKey('Id')) {
                // create SObject using supplied Id (setting it as a field will fail)
                sobj = sobjToken.newSObject(recmap.get('Id'));
            } else {
                sobj = sobjToken.newSObject();
            }
            
            for (String k : recmap.keySet()) {
                if(modfieldSet.contains(k)) {
                    ////system.debug(k + '>>' + recmap.get(k));
                    // definitely an empty value if null, empty string, or the string 'null' but the type is not string
                    // TODO it does seem like I should be able to map 'null' to null somehow in mapUnpack()
                    Boolean emptyValue = (recmap.get(k) == null) || (recmap.get(k) == '') ||
                                          (fieldMap.get(k).getDescribe().getType() != Schema.DisplayType.string) &&
                                          (recmap.get(k) == 'null');
                    if ((k != 'Id') &&  // never try to set Id this way (see above)
                        ((action == 'update') || // don't try to set an empty value unless this is an update
                         !emptyValue)) {
                        if (emptyValue) {
                            sobj.put(k, null);
                        } else if (fieldMap.get(k).getDescribe().getType() == Schema.DisplayType.date) {
                            // Date fields appear to need to be set from Date values, not strings, so:
                            // sobj.put(k, Date.valueOf(recmap.get(k)));
                            sobj.put(k, Date.parse(recmap.get(k)));
                        } else if (fieldMap.get(k).getDescribe().getType() == Schema.DisplayType.boolean) {
                            sobj.put(k, Boolean.valueOf(recmap.get(k)));
                        } else if (fieldMap.get(k).getDescribe().getType() == Schema.DisplayType.integer) {
                            sobj.put(k, Integer.valueOf(recmap.get(k)));
                        } else if (fieldMap.get(k).getDescribe().getType() == Schema.DisplayType.double) {
                            sobj.put(k, Double.valueOf(recmap.get(k)));
                        }else if (fieldMap.get(k).getDescribe().getType() == Schema.DisplayType.Currency) {
                            sobj.put(k, Decimal.valueOf(recmap.get(k)));
                        } else {
                            sobj.put(k, recmap.get(k));
                        } 
                        
                        // TODO: handle other types, esp. Currency
                        //sobj.put('Opportunity__c', crudData.oppId); 
                        /*if(action == 'create') {
                            sobj.put(parentField , crudData.oppId);
                        }*/
                    }
                }
            }
            sobjs.add(sobj);
        }
        resp.success = true;
        return sobjs;
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
     
     
     
    @RemoteAction
    global static String setDefaulColumns(String columnlist) {
        /* Modified by Gulshan*/
        //system.debug(columnlist.length()+'columnlist><<<<<<<<<<<<<'+columnlist);
        String[] arrayFields = new list<String>();
        if(columnlist != null && columnlist != ''){
            arrayFields =  columnlist.split(',');
        }
        columnlist = '';
        for(String fld:arrayFields){
            if(fld.contains('.Name') || fld.contains('.name')){
                columnlist += ',' + fld.replaceAll('.Name','Id').replaceAll('.name','Id').replaceAll('-','').replaceAll('__rId','__c');//.replaceAll('','');
            }else if(fld.contains('.null') || fld.contains('.Null') ){
                columnlist += ',' + fld.replaceAll('.null','Id').replaceAll('.Null','Id').replaceAll('-','');//.replaceAll('','');
            }else{
                columnlist += ',' +fld.replaceAll('-','');//.replaceAll('',''); 
            }
        }
        columnlist = columnlist.replaceFirst(',','');
        //system.debug(columnlist.length()+'columnlist><<<<<<<<<<<<<'+columnlist);
        ////system.debug('columnlist><<<<<<<<<<<<<'+columnlist);
        
        //List<Opportunity_Manager_Setting__c> ls = [select Id,Name, Default_Values__c,OwnerId from Opportunity_Manager_Setting__c where OwnerId =:UserInfo.getUserId() limit 1];
        Map<Id, Opportunity_Manager_Setting__c> cs = new Map<Id, Opportunity_Manager_Setting__c>(ls);
            //Map<string,Opportunity_Manager_Setting__c> cs = Opportunity_Manager_Setting__c.getAll(); 
            for(String s :cs.keySet()){
               //system.debug('!!!'+s);
               //if(cs.get(s).Name ==  'A-0006'){           
                       if(cs.get(s).Default_Values__c != null ){
                        //system.debug('!!!1');
                            cs.get(s).Default_Values__c = columnlist;
                            try{
                                    if (Schema.sObjectType.Opportunity_Manager_Setting__c.fields.Default_Values__c.isUpdateable()){  
                                    //system.debug('!!!2');
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
        /*Modified by gulshan*/
        return null;    
    }
    global class DescribeException extends Exception {}
}