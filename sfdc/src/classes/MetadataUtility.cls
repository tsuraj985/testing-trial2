public class MetadataUtility {
  
    

    
     public static String genStringFilters(String textInput, String field) { 
         if(String.isNotEmpty(textInput)){
             String textQuery = '';
             List<String> charList  = textInput.split('');
             for(integer i = 0; i < charList.size(); i++) {
                 String a = charList[i];
                 if(a == '(') {
                     integer endIndex = textInput.indexOf(')', i);
                     String condition = textInput.subString(i, endIndex);
                     string operator =  (condition.split('=')[0]).trim();
                     String value = (condition.split('=')[1]).trim();
                     i = endIndex - 1;
                     
                     if(operator == 'Is equal to') {
                         //textQuery  +=  field + ' = \'' + String.escapeSingleQuotes(value) + '\'';
                         textQuery  +=  field + ' LIKE \'' +  escapeSpecialChars(value) + '\'';
                     } 
                     else if(operator == 'Is not equal to') {
                         //textQuery  +=  field + ' !=  \'' + String.escapeSingleQuotes(value) + '\'';  
                         textQuery  +=  ' (NOT ' + field + ' LIKE \'' +  escapeSpecialChars(value) + '\')';     
                     } else if(operator == 'Contains'){
                         textQuery  +=  field + ' LIKE \'%' +  escapeSpecialChars(value) + '%\'';          
                     } else if(operator == 'Does not contain'){
                         textQuery  +=  ' (NOT ' + field + ' LIKE \'%' +  escapeSpecialChars(value) + '%\')'; 
                     } else if(operator == 'Starts With'){
                          textQuery  += field + ' LIKE \'' + escapeSpecialChars(value) + '%\'';         
                     } else if(operator == 'Ends With'){
                          textQuery  += field + ' LIKE \'%' + escapeSpecialChars(value) + '\''; 
                     }
                 } else if(a == ')') {
                     integer endIndex =  textInput.indexOf('(', i);
                     if(endIndex != -1) {
                           textQuery += ' ' + textInput.subString(i, endIndex).trim() + ' ';
                           i = endIndex - 1;
                     }  
                 }    
             }
             return textQuery;
         }
         return null;   
     }
    

   
    
     public static String parseCutsomFilters(String jsonString, Map<String, String> fieldTypeMap) {        
        if(String.isNotEmpty(jsonString)){
            //system.debug('@@@@@@@@@@@@@!!!!!!!!!'+jsonString);    
            String queryString = '';
            String ESCAPECHAR = '\'';

            List<Object> filterList = (List<Object>)JSON.deserializeUntyped(jsonString);  //deserialized filter list  
            for(Object obj :filterList) {
                Map<String, Object> filterObj = (Map<String, Object>)obj;
                
                String filterType = (String)filterObj.get('type');
                String field = (String)filterObj.get('field');
                
     
                if(filterType.equalsIgnoreCase('string')) {
                    
                   
                    String filtervalue = (String)filterObj.get('value');
                    //system.debug('###'+ filtervalue);
                    String textFilter = genStringFilters(filtervalue , field);
                    //system.debug('@@@@' + textFilter);
                    if(String.isNotEmpty(textFilter)) {
                        
                        queryString += ' AND (' + textFilter + ' )';           
                    }
                    
                    /*//system.debug(textFilter);
                    
                    
                    String startsWithRegex = '(?i)startswith\\(.+\\)'; 
                    String containsRegex = '(?i)contains\\(.+\\)'; 
                    String isEmptyRegex = '(?i)isempty';
                    String isNotEmptyRegex = '(?i)isnotempty';
                  
                    
                    
                    Pattern startsPattern = Pattern.compile(startsWithRegex);
                    Pattern containsPattern = Pattern.compile(containsRegex);
                    Pattern isEmptyPattern = Pattern.compile(isEmptyRegex);
                    Pattern isNotEmptyPattern =  Pattern.compile(isNotEmptyRegex);
                    
                    Matcher startsMatcher = startsPattern.matcher(filtervalue);
                    Matcher containsMatcher = containsPattern.matcher(filtervalue);
                    
                    String valueList;
                    if((valueList = parseORFilters(filtervalue)) != null) {
                         queryString += ' AND ' + field + ' IN ' + valueList ;        
                    } 
                    else if((valueList = parseExcludeFilters(filtervalue)) != null) {
                        queryString += ' AND ' + field + ' NOT IN ' + valueList ;        
                    }
                    else if (startsMatcher.matches()) {
                        filtervalue = filtervalue.ReplaceFirst('(?i)startswith\\(','');
                        filtervalue = filtervalue.subString(0, filtervalue.length() - 1);                      
                        queryString += ' AND ' + field + ' LIKE \'' + filtervalue + '%\''; 
                    } else if (containsMatcher.matches()){
                        filtervalue = filtervalue.ReplaceFirst('(?i)contains\\(','');
                        filtervalue = filtervalue.subString(0, filtervalue.length() - 1); 
                        queryString += ' AND ' + field + ' LIKE \'%' + filtervalue + '%\'';     
                    } else if ((isEmptyPattern.matcher(filtervalue)).matches()){
                         //system.debug('EEEEMMMPP');
                         queryString += ' AND ' + field + ' = NULL' ;        
                    } else if ((isNotEmptyPattern.matcher(filtervalue)).matches()){
                         //system.debug('NOT  EEEEMMMPP');
                         queryString += ' AND ' + field + ' != NULL' ;    
                    }else {
                        queryString += ' AND ' + field + ' LIKE \'%' + escapeSpecialChars((String)filterObj.get('value')) + '%\'';       
                    }
                    
                    parseORFilters(filtervalue); */
                } 
                
                else if(filterType.equalsIgnoreCase('list')) {
                    List<Object> valueList = (List<Object>)filterObj.get('value');
                    
                    if(valueList.size() > 1) {
                        String valueString = '';
                        
                        for(Object a : valueList) {
                            valueString += ESCAPECHAR + escapeSpecialChars((String)a) + ESCAPECHAR + ',';     
                        }
                        valueString = valueString.subString(0, valueString.length() - 1);
                        queryString += ' AND ' +  field + ' IN (' + valueString + ')';
                    
                    } else if(valueList.size() == 1){
                    
                        queryString += ' AND ' +  field + ' = ' + ESCAPECHAR  + escapeSpecialChars((String)valueList[0]) + ESCAPECHAR;    
                    }
                } 
                
                else if(filterType.equalsIgnoreCase('boolean')){
                    queryString += ' AND ' +  field + ' = ' + (Boolean)filterObj.get('value');  
                } 
                
                else if(filterType.equalsIgnoreCase('numeric')){
                    String compare =  (String)filterObj.get('comparison'); 
                    
                    if(compare.equals('eq')){
                        queryString += ' AND ' +  field + ' = ' + (integer)filterObj.get('value'); 
                        
                    } else if(compare.equals('lt')){
                         queryString += ' AND ' +  field + ' < ' + (integer)filterObj.get('value'); 
                        
                    } else if(compare.equals('gt')){
                        queryString += ' AND ' +  field + ' > ' + (integer)filterObj.get('value');    
                    }                    
                         
                }  else if(filterType.equalsIgnoreCase('currency')){
                    String compare =  (String)filterObj.get('comparison'); 
                    
                    if(compare.equals('eq')){
                        queryString += ' AND ' +  field + ' = ' + (Decimal)filterObj.get('value'); 
                        
                    } else if(compare.equals('lt')){
                         queryString += ' AND ' +  field + ' < ' + (Decimal)filterObj.get('value'); 
                        
                    } else if(compare.equals('gt')){
                        queryString += ' AND ' +  field + ' > ' + (Decimal)filterObj.get('value');    
                    }                    
                         
                } else if(filterType.equalsIgnoreCase('date')) {
                    
                    if(fieldTypeMap.containsKey(field)) {
                       String fieldType = fieldTypeMap.get(field); 
                         
                        if(fieldType.equalsIgnoreCase('datetime')) {
                            String compare =  (String)filterObj.get('comparison'); 
                            Date cdate = Date.parse((String)filterObj.get('value'));
                           
                           if(compare.equals('eq')){
                                Datetime beforedate = datetime.newInstanceGmt(cdate.year(), cdate.month(),cdate.day());
                                Datetime afterdate = beforedate.addDays(1);
                               
                                 
                                queryString += ' AND ' +  field + ' >= ' +  beforedate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''); //beforedate.format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'');
                                queryString += ' AND ' +  field + ' < ' +  afterdate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                                
                            } else if(compare.equals('lt')){
                                 Datetime beforedate = datetime.newInstanceGmt(cdate.year(), cdate.month(),cdate.day());
                                 queryString += ' AND ' +  field + ' < ' +  beforedate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                                
                            } else if(compare.equals('gt')){
                                Datetime afterdate = datetime.newInstanceGmt(cdate.year(), cdate.month(),cdate.day());
                                queryString += ' AND ' +  field + ' >= ' +   afterdate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');    
                            }  
                           
                        } else if(fieldType.equalsIgnoreCase('date')) {
                            String compare =  (String)filterObj.get('comparison'); 
                            Date cdate = Date.parse((String)filterObj.get('value'));
                            Datetime cdatetime =  datetime.newInstanceGmt(cdate.year(), cdate.month(),cdate.day());
                            
                            if(compare.equals('eq')){                                                                                               
                                queryString += ' AND ' +  field + ' = ' +  String.valueOf(cdate);
                              
                            } else if(compare.equals('lt')){
                                 Datetime beforedate = datetime.newInstanceGmt(cdate.year(), cdate.month(),cdate.day());
                                 queryString += ' AND ' +  field + ' < ' + String.valueOf(cdate);
                                
                            } else if(compare.equals('gt')){
                                Datetime afterdate = datetime.newInstanceGmt(cdate.year(), cdate.month(),cdate.day());
                                queryString += ' AND ' +  field + ' >= ' +  String.valueOf(cdate);   
                            }                         
 
                        }                   
                    }
                    
                } 
                
                   
            }  
            
            return queryString;          
        } 
        return null;  
    }
    
    

    

    
    public static string escapeSpecialChars(String input){
        if(String.isNotEmpty(input)){
            input = input.replace('\'','\\\''); 
            input = input.replace('%','\\%');  
            input = input.replace('_','\\_');         
        }  
        return input;      
    }
    
   
   
 
   
  
        
  
   
   
        
        
   
   
    
}