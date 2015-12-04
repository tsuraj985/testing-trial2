public with sharing class  DiamondSearch_ctrl{
    public list<Product2> products{get;set;}
    public list<Product2> selectedProducts{get;set;}
    public list<DBUtility.CertDiamondProduct> objProducts{get;set;} 
    public list<DBUtility.CertDiamondProduct> selectedCertProducts{get;set;}
    public list<DBUtility.CertDiamondProduct> selectedCertProductstotransfer{get;set;} 
    public map<String,String> getDuplicateSelected{get;set;}
    public string selectedFluorescence{get;set;}
    public string selectedPrice{get;set;}
    public string selectedItemNumber {get;set;}
    public string selectedAddedAfter {get;set;}
    public string selectedAddedBefore {get;set;}
    public string selectedTypeOfCertificate {get;set;}
    public string selectedShapes {get;set;}
    public string selectedCertificateNumber {get;set;}
    public string selectedCut {get;set;}
    public string selectedClarity {get;set;}
    public string selectedCarat {get;set;}
    public string selectedPolish {get;set;}
    public string selectedColor {get;set;}
    public boolean selectedFancyColoredDiamond {get;set;}  
    
    /* AccountSelectForDiamondSearch*/
    public String fieldTypeForSelectedField {get;set;}     
    public list<SearchResult> listOfLookupsElement {get;set;}
    public list<SearchResult> slectedAcc {get;set;}
    public String objectName {get;set;}
    public String fieldName {get;set;}
    public String condition {get;set;}
    public String condition1 {get;set;}
    public String searchByName{get;set;}
    public String conditionForInventory{get;set;}
    public String rowIndex{get;set;}
    public boolean isChecked {get;set;}
    public String phoneNumberPassToTextBox {get;set;}
    public String phoneNamePassToHdn {get;set;}
        public String calledFrom { get; set; }
        public String nameValue ='';
    public boolean isAllSelectCheckBox {get;set;}
    set<Id> certAndParcelId = new set<Id>();
    Set<String> scrapMetalNames ;
    Set<String> scrapDiamondNames ;
    Set<Id> scrapMetalsId ;
    Set<Id> scrapDiamondsId ;
    Map<Id,RecordType> recordTypeIdToRT ;
    list<Account> acclst =new list<Account>();
    public list<SelectOption> toSelectAccount  { get; set; }
    public Id selectedAccountId { get; set; }
    public string AccName{ get; set;}
    public Boolean confirmSection{ get; set;}
    public Boolean AccScreen{ get; set;}
    public list<DBUtility.CertDiamondProduct> listToMemo {get; set;}
    public list<DBUtility.CertDiamondProduct> listToMail {get; set;}
    public Opportunity oppObjToTransfer { get; set; }
    public list<OpportunityLineItem> oliOnNewOpplst{ get; set;} 
    public Boolean searchSection{ get; set;}
    public Boolean searchButton{ get; set;}
    public String headerString{ get; set;}
        public String bodyString { get; set;}
        public Set<Id> prdid{get; set;}
        public map<id,Product2> prdtmap { get; set;}
        public string emailAddress{get; set;}
        public Boolean EmailSection{get; set;}
        public list<Contact> emailList{get; set;}
        public Boolean flag {get; set;}
        public Boolean returnbuton {get; set;}
    public Double totalSellPrice{get;set;}    
    public boolean selectedStone{get;set;}
    public DiamondSearch_ctrl(){
        //getlistOfLookupsElement();
        selectedFluorescence = '0;4';
        totalSellPrice  = 0.0;
        init();
    }
    
    public void init(){
        //objProducts = new list<CertDiamondProduct>();
        toSelectAccount = new list<SelectOption>();
        selectedCertProducts = new list<DBUtility.CertDiamondProduct>();
        getDuplicateSelected = new map<String,String>();
        selectedProducts = new list<Product2>();
        objProducts = DBUtility.getCertifiedDiamondsByFilter(null);
        oliOnNewOpplst = new list<OpportunityLineItem>();
        confirmSection = true;
        AccScreen = true;
        searchSection = true;
        searchButton = true;
        EmailSection = true;
        returnbuton = true;
        emailList = new list<Contact>();
        emailList.add(new Contact());
        flag  = true;
    }
    
    public pageReference onReset(){
        selectedFluorescence = '';
        selectedPrice = '';
        selectedItemNumber = ''; 
        selectedAddedAfter = ''; 
        selectedAddedBefore = ''; 
        selectedTypeOfCertificate = ''; 
        selectedShapes = ''; 
        selectedCertificateNumber = ''; 
        selectedCut = ''; 
        selectedClarity = ''; 
        selectedCarat = '';
        selectedPolish  = '';
        selectedColor = '';
        selectedFancyColoredDiamond = false;  
        /*pageReference pr = new pageReference('/apex/DiamondSearch1');  
        pr.setRedirect(true);
        return pr;*/
        objProducts = DBUtility.getCertifiedDiamondsByFilter(null);
        return null;    
    }
    
    public pageReference priceSlid(){
        if(selectedPrice != null && selectedPrice != ''){
            system.debug('>>>>>>'+selectedPrice);
            list<String> pricelValues = selectedPrice.split(';');
            decimal maxPrice = decimal.valueOf(pricelValues.get(1));
            decimal minPrice = decimal.valueOf(pricelValues.get(0));
            system.debug('minPrice::'+minPrice +'>>>>>>maxPrice::'+maxPrice );   
            objProducts = new list<DBUtility.CertDiamondProduct>(); 
            
            if(maxPrice != 50000){    
                products = [Select Item_No__c,Item_Name__c,Product_ID__c,Cost_per_item__c,Total_Sell_Price__c,Fluorescence__c,Available_for_Sale__c,L_W_Ratio__c ,Width__c, White_Pine_Item_No_Old_from_Gemini__c, White_Pine_Item_No_New__c, Watch_Type__c, Watch_Condition__c, WPS_Size__c, Type__c, Treatment__c, Total_Quantity__c, Table_percent__c, SystemModstamp, Symmetry__c, Supplier_Model_Number__c, Style_Number__c, Shape__c, Serial_Number__c, Sell_Price__c, Sell_Price_CloseOut_Jewelry__c,  Report_Number__c, Report_Agency__c, Refurbished__c, RecordTypeId, Quantity_on_Hand__c,   Product__c, ProductCode, Polish__c, Painting__c,Owner__c,Original_piece__c, Original_Papers__c, Original_Buckle__c, Original_Box__c, Original_Band__c,  Name, Movement_Type__c, Model_Name__c, Long_Description__c, Length__c, LastModifiedDate, LastModifiedById, IsDeleted, IsActive, Id, Gender__c, Fluorescence_Intensity__c, Final_Cut__c, Fancy_Color_Secondary_Tone__c, Fancy_Color_Primary_Tone__c, Fancy_Color_Grade__c, Family, Dial_Color__c, Description, Depth_percent__c, Depth__c, De_Identified_Serial_Number__c,  Crystal__c, CreatedDate, CreatedById, Country_of_Origin__c,  Cost_Price__c, Condition__c, Color__c, Clarity__c, Center_Inclusion__c, Case_Width__c, Case_Shape__c, Case_Primary_Metal__c, Case_Height__c, Carats__c, Brand__c, Bezel_Type__c, Band_Type__c, Aftermarket_Components__c From Product2 WHERE RecordType.Name = 'WPS Single Stone' AND (Total_Sell_Price__c >= :minPrice  AND Total_Sell_Price__c <= :maxPrice) AND Total_Quantity__c > 0 limit 500];         
            }
            else{
                products = [Select Item_No__c,Item_Name__c,Product_ID__c,Cost_per_item__c,Total_Sell_Price__c,Fluorescence__c,Available_for_Sale__c,L_W_Ratio__c ,Width__c, White_Pine_Item_No_Old_from_Gemini__c, White_Pine_Item_No_New__c, Watch_Type__c, Watch_Condition__c, WPS_Size__c, Type__c, Treatment__c, Total_Quantity__c, Table_percent__c, SystemModstamp, Symmetry__c, Supplier_Model_Number__c, Style_Number__c, Shape__c, Serial_Number__c, Sell_Price__c, Sell_Price_CloseOut_Jewelry__c,  Report_Number__c, Report_Agency__c, Refurbished__c, RecordTypeId, Quantity_on_Hand__c,   Product__c, ProductCode, Polish__c, Painting__c,Owner__c,Original_piece__c, Original_Papers__c, Original_Buckle__c, Original_Box__c, Original_Band__c,  Name, Movement_Type__c, Model_Name__c, Long_Description__c, Length__c, LastModifiedDate, LastModifiedById, IsDeleted, IsActive, Id, Gender__c, Fluorescence_Intensity__c, Final_Cut__c, Fancy_Color_Secondary_Tone__c, Fancy_Color_Primary_Tone__c, Fancy_Color_Grade__c, Family, Dial_Color__c, Description, Depth_percent__c, Depth__c, De_Identified_Serial_Number__c,  Crystal__c, CreatedDate, CreatedById, Country_of_Origin__c,  Cost_Price__c, Condition__c, Color__c, Clarity__c, Center_Inclusion__c, Case_Width__c, Case_Shape__c, Case_Primary_Metal__c, Case_Height__c, Carats__c, Brand__c, Bezel_Type__c, Band_Type__c, Aftermarket_Components__c From Product2 WHERE RecordType.Name = 'WPS Single Stone' AND Total_Sell_Price__c >= :minPrice  AND Total_Quantity__c > 0 limit 500];         
            }
            system.debug('--------------'+products  );   
            for(Product2 p:products){
                objProducts.add(new DBUtility.CertDiamondProduct(false,p,false));
            }    
        }        
        return null;
    }
    
    
    public pageReference itemNumber(){
        if(selectedItemNumber != null && selectedItemNumber != ''){
            objProducts = new list<DBUtility.CertDiamondProduct>();     
            products = [Select Item_No__c,Item_Name__c,Certified_Number__c,Product_ID__c,Cost_per_item__c,Total_Sell_Price__c,Fluorescence__c,Available_for_Sale__c ,L_W_Ratio__c,Width__c, White_Pine_Item_No_Old_from_Gemini__c, White_Pine_Item_No_New__c, Watch_Type__c, Watch_Condition__c, WPS_Size__c, Type__c, Treatment__c, Total_Quantity__c, Table_percent__c, SystemModstamp, Symmetry__c, Supplier_Model_Number__c, Style_Number__c, Shape__c, Serial_Number__c, Sell_Price__c, Sell_Price_CloseOut_Jewelry__c,  Report_Number__c, Report_Agency__c, Refurbished__c, RecordTypeId, Quantity_on_Hand__c,   Product__c, ProductCode, Polish__c, Painting__c,Owner__c,Original_piece__c, Original_Papers__c, Original_Buckle__c, Original_Box__c, Original_Band__c,  Name, Movement_Type__c, Model_Name__c, Long_Description__c, Length__c, LastModifiedDate, LastModifiedById, IsDeleted, IsActive, Id, Gender__c, Fluorescence_Intensity__c, Final_Cut__c, Fancy_Color_Secondary_Tone__c, Fancy_Color_Primary_Tone__c, Fancy_Color_Grade__c, Family, Dial_Color__c, Description, Depth_percent__c, Depth__c, De_Identified_Serial_Number__c,  Crystal__c, CreatedDate, CreatedById, Country_of_Origin__c,  Cost_Price__c, Condition__c, Color__c, Clarity__c, Center_Inclusion__c, Case_Width__c, Case_Shape__c, Case_Primary_Metal__c, Case_Height__c, Carats__c, Brand__c, Bezel_Type__c, Band_Type__c, Aftermarket_Components__c From Product2 WHERE RecordType.Name = 'WPS Single Stone' AND Product_ID__c Like: '%'+selectedItemNumber.trim()+'%' AND Total_Quantity__c > 0 limit 500];         
            for(Product2 p:products){
                objProducts.add(new DBUtility.CertDiamondProduct(false,p,false));
            }
        }else{
            init(); 
        }
        return null;
    }
    
    public pageReference certificateNumber(){
        if(selectedCertificateNumber != null && selectedCertificateNumber != ''){
            objProducts = new list<DBUtility.CertDiamondProduct>();     
            products = [Select Item_No__c,Item_Name__c,Certified_Number__c ,Product_ID__c,Cost_per_item__c,Total_Sell_Price__c,Fluorescence__c,Available_for_Sale__c,L_W_Ratio__c ,Width__c, White_Pine_Item_No_Old_from_Gemini__c, White_Pine_Item_No_New__c, Watch_Type__c, Watch_Condition__c, WPS_Size__c, Type__c, Treatment__c, Total_Quantity__c, Table_percent__c, SystemModstamp, Symmetry__c, Supplier_Model_Number__c, Style_Number__c, Shape__c, Serial_Number__c, Sell_Price__c, Sell_Price_CloseOut_Jewelry__c,  Report_Number__c, Report_Agency__c, Refurbished__c, RecordTypeId, Quantity_on_Hand__c,   Product__c, ProductCode, Polish__c, Painting__c,Owner__c,Original_piece__c, Original_Papers__c, Original_Buckle__c, Original_Box__c, Original_Band__c,  Name, Movement_Type__c, Model_Name__c, Long_Description__c, Length__c, LastModifiedDate, LastModifiedById, IsDeleted, IsActive, Id, Gender__c, Fluorescence_Intensity__c, Final_Cut__c, Fancy_Color_Secondary_Tone__c, Fancy_Color_Primary_Tone__c, Fancy_Color_Grade__c, Family, Dial_Color__c, Description, Depth_percent__c, Depth__c, De_Identified_Serial_Number__c,  Crystal__c, CreatedDate, CreatedById, Country_of_Origin__c,  Cost_Price__c, Condition__c, Color__c, Clarity__c, Center_Inclusion__c, Case_Width__c, Case_Shape__c, Case_Primary_Metal__c, Case_Height__c, Carats__c, Brand__c, Bezel_Type__c, Band_Type__c, Aftermarket_Components__c From Product2 WHERE RecordType.Name = 'WPS Single Stone' AND Certified_Number__c = :selectedCertificateNumber.trim() AND Total_Quantity__c > 0 limit 500];         
            for(Product2 p:products){
                objProducts.add(new DBUtility.CertDiamondProduct(false,p,false));
            }
        }else{
            init(); 
        }
        return null;
    }
    
    
    public void onSelect(){   
        system.debug('objProducts::'+objProducts.size()); 
        
        system.debug('getDuplicateSelected::'+getDuplicateSelected);
        //totalSellPrice = 0.0;
        for(DBUtility.CertDiamondProduct cp:objProducts){
            system.debug('objProd::'+cp.objProd);
            if(cp.isSelected){
            	system.debug('Enterd Here::');
            }
            if(cp.isSelected && !getDuplicateSelected.Containskey(cp.objProd.Id)){
            	
                getDuplicateSelected.put(cp.objProd.Id,cp.objProd.name);
                cp.isSelectedProd = false;
                totalSellPrice += cp.objProd.Sell_Price__c != null?cp.objProd.Sell_Price__c:0.0;
                selectedCertProducts.add(cp);
            }
        }
        system.debug('selectedCertProducts::'+selectedCertProducts.size());
    }
    public void onRemove(){      
        /*list<CertDiamondProduct> tempToRemove = new list<CertDiamondProduct>();
        tempToRemove.addAll(selectedCertProducts); 
        if(!selectedCertProducts.isEmpty()){
            for(Integer i=0; i < tempToRemove.size() ;i++){
                if(tempToRemove[i].isSelectedProd){
                    getDuplicateSelected.remove(tempToRemove[i].objProd.Id);
                    selectedCertProducts.remove(i);
                }
            }   
        }*/
        if(!selectedCertProducts.isEmpty()){
            list<DBUtility.CertDiamondProduct> tempToRemove = new list<DBUtility.CertDiamondProduct>();
            tempToRemove.addAll(selectedCertProducts);
            Integer j = 0;
            while (j < selectedCertProducts.size()){
              if(selectedCertProducts.get(j).isSelectedProd){
                selectedCertProducts.remove(j);
                getDuplicateSelected.remove(tempToRemove.get(j).objProd.Id);
              }else{
                j++;
              }
            }
       
            for(Integer i=0; i < tempToRemove.size() ;i++){
                if(tempToRemove[i].isSelectedProd){
                    getDuplicateSelected.remove(tempToRemove[i].objProd.Id);                    
                }
            }   
        }             
    }
    
    public string inBetween(String inBetweenVal, String listofValues){
        string retunVal = inBetweenVal;
        if(inBetweenVal != null && inBetweenVal != '' && listofValues != '' && listofValues != null){
                String result = '';
                list<String> val = inBetweenVal.split(';');
                retunVal = val.get(0)+listofValues.substringBetween(val.get(0),val.get(1))+val.get(1);
                for(String v:retunVal.split(',')){
                        result += ',\''+v+'\'';
                } 
                result = result.replaceFirst(',','');                   
                return '('+result+')';
        }
        return retunVal;
    }
    
    public string filterGenerator(){
        String filter = ' isDeleted = false ';
        list<String> slidValue = new list<String>();        
        String firstVal = '';
        String secondVal = '';        
        if(selectedPrice != null && selectedPrice != ''){
            slidValue = new list<String>();  
            slidValue = selectedPrice.split(';');
            if(slidValue.get(1) == '50000' ){
                filter += ' AND (Sell_Price__c >='+ slidValue.get(0) +') ';
            }else{
                filter += ' AND (Sell_Price__c >='+ slidValue.get(0) +' AND Sell_Price__c  <='+ slidValue.get(1)+') ';
            }
            
        }if(selectedCarat != null && selectedCarat != ''){
            slidValue = new list<String>();
            slidValue = selectedCarat.split(';');
            if(slidValue.get(1) == '4' ){
                filter += ' AND (Carats__c >='+ slidValue.get(0) +') ';
            }else{
                filter += ' AND (Carats__c >='+ slidValue.get(0) +' AND Carats__c <='+ slidValue.get(1)+') ';
            }
        }if(selectedFluorescence != null && selectedFluorescence != ''){
            String fl = '(';
            for(string f:selectedFluorescence.split(',')){
                fl+=',\''+f+'\''; 
            }
            fl = fl.replaceFirst(',', '')+')';
            filter += ' AND Fluorescence_Intensity__c IN '+ fl ;
        }if(selectedTypeOfCertificate != null && selectedTypeOfCertificate != ''){
            String tc = '(';
            for(string t:selectedTypeOfCertificate.split(',')){
                tc+=',\''+t+'\''; 
            }
            tc = tc.replaceFirst(',', '')+')';
            filter += ' AND Certified_Number__c IN '+ tc ;
        }if(selectedShapes != null && selectedShapes != ''){
            String ss = '(';
            for(string s:selectedShapes.split(',')){
             if(s == 'Other'){
                 ss+=',\''+'Other'+'\'' +
                   ',\''+'Baguette'+'\''  +                                
                   ',\''+'Cut Cornered Princess'+'\''+
                   ',\''+'Square Radiant'+'\''+
                   ',\''+'Fancy Mix'+'\''+
                   ',\''+'Half Moon'+'\''+
                    ',\''+'Old Miner'+'\''+ 
                    ',\''+'Trapeze'+'\''+   
                    ',\''+'Old European'+'\''+
                    ',\''+'Square'+'\''+    
                    ',\''+'Square Emerald'+'\''+
                    ',\''+'Trilliant'+'\''+
                    ',\''+'Triangle'+'\''+
                    ',\''+'Specialty Shapes'+'\''+
                    ',\''+'Mix'+'\'';

                    }else{
                        ss+=',\''+s+'\''; 
                    } 
            }
            
            ss = ss.replaceFirst(',', '')+')';
            filter += ' AND Shape__c IN '+ ss ;           
        }if(selectedCut != null && selectedCut != ''){
            String sc = '(';
            for(string c1:selectedCut.split(',')){
                sc+=',\''+c1+'\''; 
            }
            sc = sc.replaceFirst(',', '')+')';
            system.debug('sc::'+sc);
            filter += ' AND Final_Cut__c IN '+ sc ;            
        }if(selectedClarity != null && selectedClarity != ''){
            String sc1 = '(';
            for(string c11:selectedClarity.split(',')){
                sc1+=',\''+c11+'\''; 
            }
            sc1 = sc1.replaceFirst(',', '')+')';
            filter += ' AND Clarity__c IN '+ sc1 ;            
        }if(selectedPolish != null && selectedPolish != ''){
            String sp = '(';
            for(string sp1:selectedPolish.split(',')){
                sp+=',\''+sp1+'\''; 
            }
            sp = sp.replaceFirst(',', '')+')';
            system.debug('sp::'+sp);
            filter += ' AND Polish__c IN '+ sp ;            
        }if(selectedColor != null && selectedColor != ''){
            String sc11 = '(';
            for(string s12:selectedColor.split(',')){
                if(s12 == 'M+'){
                    S12 = 'M\',\'N\',\'O\',\'P\',\'Q\',\'R\',\'S\',\'T\',\'U\',\'V\',\'W\',\'X\',\'Y\',\'Z';
                }
                sc11+=',\''+s12+'\''; 
            }
            sc11 = sc11.replaceFirst(',', '')+')';
            System.debug('>>>>>>>>>>>>>>>>>>>>>>>'+sc11 );
            filter += ' AND Color__c IN '+ sc11 ;           
        }if(selectedAddedAfter != null && selectedAddedAfter != ''){
            String []dt = selectedAddedAfter.split('/');
            if(dt.size() == 3){
                //date after = Date.valueOf(dt[2]+'-'+dt[0]+'-'+dt[1]);
                Datetime after1 = Datetime.newInstance(Integer.valueOf(dt[2]), Integer.valueOf(dt[0]), Integer.valueOf(dt[1]));
                filter += ' AND Created_Date_Gemini__c >='+after1.format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'');    
            }
        }if(selectedAddedBefore != null && selectedAddedBefore != ''){
            String []dt1 = selectedAddedBefore.split('/'); 
            if(dt1.size() == 3){
                Datetime befor1 = Datetime.newInstance(Integer.valueOf(dt1[2]), Integer.valueOf(dt1[0]), Integer.valueOf(dt1[1]));
                filter += ' AND Created_Date_Gemini__c <='+ befor1.format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'');     
            }              
        }if(selectedFancyColoredDiamond == true){
            filter += ' AND (Fancy_Color_Primary_Tone__c != null OR Fancy_Color_Primary_Tone__c != \'\') AND (Fancy_Color_Grade__c != null OR Fancy_Color_Grade__c != \'\') ';//+ selectedFancyColoredDiamond ;
        }   
        if(selectedStone == true){
            filter += ' AND Quantity_on_Hand__c > 0 ';
        }    
        system.debug('---filter--'+filter);
        return filter;
        /*if(selectedItemNumber != null && selectedItemNumber != ''){
            slidValue = new list<String>();
            slidValue = selectedItemNumber.split(';');
            firstVal = slidValue.get(1);
            secondVal = slidValue.get(0);
            filter += ' AND Item_No__c >=: secondVal AND Item_No__c <=: firstVal ';
        }if(selectedAddedAfter != null && selectedAddedAfter != ''){
            slidValue = new list<String>();
            slidValue = selectedAddedAfter.split(';');
            firstVal = slidValue.get(1);
            secondVal = slidValue.get(0);
            filter += 'AND CreatedDate >=: secondVal AND CreatedDate <=: firstVal ';
        }if(selectedAddedBefore != null && selectedAddedBefore != ''){
            slidValue = new list<String>();
            slidValue = selectedAddedBefore.split(';');
            firstVal = slidValue.get(1);
            secondVal = slidValue.get(0); 
            filter += 'AND CreatedDate >=: secondVal AND CreatedDate <=: firstVal ';
        }if(selectedCertificateNumber != null && selectedCertificateNumber != ''){
            slidValue = new list<String>();
            slidValue = selectedCertificateNumber.split(';');
            firstVal = slidValue.get(1);
            secondVal = slidValue.get(0);
            filter += 'AND Certified_Number__c >=: secondVal AND Certified_Number__c <=: firstVal ';
        }*/
    }

    public pageReference onSearch(){
        try{
            /*TO do dates validation.*/
            dateValidator();
            objProducts = new list<DBUtility.CertDiamondProduct>();
            objProducts = DBUtility.getCertifiedDiamondsByFilter(filterGenerator()); 
            //priceSlid();
            system.debug('>>>>selectedFluorescence>>>>>>'+selectedFluorescence);
            system.debug('>>>>>selectedPrice>>>>>'+selectedPrice);
            system.debug('>>>>>selectedItemNumber>>>>>'+selectedItemNumber );
            system.debug('>>>>>>selectedAddedAfter>>>>'+selectedAddedAfter );
            system.debug('>>>>>selectedAddedBefore>>>>>'+selectedAddedBefore );
            system.debug('>>>>selectedTypeOfCertificate>>>>>>'+selectedTypeOfCertificate );
            system.debug('>>>>>selectedShapes>>>>>'+selectedShapes );
            system.debug('>>>>>>selectedCertificateNumber>>>>'+selectedCertificateNumber );
            system.debug('>>>>>selectedCut>>>>>'+selectedCut );
            system.debug('>>>>>selectedClarity>>>>>'+selectedClarity );
            system.debug('>>>>>selectedCarat>>>>>'+selectedCarat );
            system.debug('>>>>>selectedPolish>>>>>'+selectedPolish );
            system.debug('>>>>>selectedColor>>>>>'+selectedColor);
            system.debug('>>>>>selectedFancyColoredDiamond>>>>>'+selectedFancyColoredDiamond);  
        }catch(Exception ex){
            ApexPages.addmessage(new Apexpages.Message(ApexPages.Severity.Error,ex.getMessage()));
        }
        return null;
    }
    
    public void dateValidator(){
        try{
            if(selectedAddedAfter != null && selectedAddedAfter.trim() != '' && selectedAddedBefore != null && selectedAddedBefore != ''){
                String []dt = selectedAddedAfter.split('/');
                date after = Date.valueOf(dt[2]+'-'+dt[0]+'-'+dt[1]);
                dt = selectedAddedBefore.split('/'); 
                date befor = Date.valueOf(dt[2]+'-'+dt[0]+'-'+dt[1]);
                if(after > befor ){
                    ApexPages.addmessage(new Apexpages.Message(ApexPages.Severity.Error,'Min Date can not be greater than Max Date!' ));
                }
            }
        }catch(Exception e){
            ApexPages.addmessage(new Apexpages.Message(ApexPages.Severity.Error,e.getMessage()));
        }
        
    }
    
       /* public PageReference addToMemo(){
                confirmSection = false;
                EmailSection = false;
                AccScreen = true;
                searchSection = true;
                searchButton = true;
                
                //listOfLookupsElement = new list<SearchResult>();        
        //objectName = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('oN'));
        //rowIndex = ApexPages.CurrentPage().getParameters().get('ri');
        fieldName = 'RecordType.Name';
        //condition = ApexPages.CurrentPage().getParameters().get('condition');
        //condition1 = ApexPages.CurrentPage().getParameters().get('condition1');
        //nameValue = ApexPages.CurrentPage().getParameters().get('NameValue');
        //system.debug('condition :: '+condition);
        //conditionForInventory = condition + ' IN ( '+ condition1 + ' )';
        //system.debug('condition1 :: '+ condition1);
        //calledFrom = ApexPages.CurrentPage().getParameters().get('calledFrom');
        isAllSelectCheckBox = false;
        searchByName ='';
        phoneNumberPassToTextBox = '';
        phoneNamePassToHdn  = '';
        getlistOfLookupsElement();
        flag = true;
        
        listToMemo = new list<DBUtility.CertDiamondProduct>();
        
        for(DBUtility.CertDiamondProduct cdp : selectedCertProducts){
                        if(cdp.isSelectedProd == true){
                                listToMemo.add(cdp);
                        }
                }
         system.debug('listToMemo::'+listToMemo);       
         if(!listToMemo.isEmpty()){
            for(DBUtility.CertDiamondProduct cdpobj : listToMemo){
                    if(cdpobj.objProd.Quantity_on_Hand__c == 0){
                            flag = false;
                    }
                    
            }    
         
        }else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please Select The Product'));
        }
        system.debug('flag::'+flag);
        if(flag == true){
            PageReference pageRef = new PageReference('/apex/selectAccountForDiamondSearch');
            return pageRef;
        }
        else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Item not available to put on memo'));
                return null;
        } 
            
        //AccScreen = true;
        
        //pageRef.setredirect(true);
        }       
        public PageReference returnpage(){
                PageReference pageRef = new PageReference('/apex/DiamondSearch1');
                return pageRef;
        }
        
        public void getlistOfLookupsElement(){
                try{
                        toSelectAccount.clear();
                        String query ;
            listOfLookupsElement = new list<SearchResult>();
                //query = 'SELECT Name,'+fieldName+' FROM Account  LIMIT 10 ' ;
                system.debug('query::'+query);
                
                list<Account> acclst = [Select id,Name From Account Limit 10];
                for(Account accobj : acclst){
                        toSelectAccount.add(new SelectOption( accobj.Id , accobj.Name ));
                }
                }
                catch(Exception ex){
             apexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Parameter is not defined, Please contact your Administrator!'));
        }
        }
        
        public void onSearchAcc(){
                toSelectAccount.clear();
        listOfLookupsElement = new list<SearchResult>();
        String byName =String.escapeSingleQuotes(searchByName);
        try{
                String query;
                byName = '%'+byName+'%';
                System.debug('byName :: '+byName);
                        System.debug('conditionForInventory :: '+conditionForInventory);
                //query ='SELECT Name,'+fieldName+' FROM Account WHERE  Name Like :byName  LIMIT 10';
                
                list<Account> acclst = [SELECT Name,id FROM Account WHERE  Name Like :byName  LIMIT 10]; 
                for(Account accobj : acclst){
                   toSelectAccount.add(new SelectOption( accobj.Id , accobj.Name ));
                }
                system.debug('acclst::'+acclst);
                system.debug('toSelectAccount::'+toSelectAccount);
        }
        catch(Exception ex){
                apexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Illegal Search parameter!'));
        }       
    }
    
    
    public void whenClicked(){
        system.debug('selectedAccountId::'+selectedAccountId);
        if(null != selectedAccountId){
          AccName = [Select Name from Account where ID =: selectedAccountId].Name;
          confirmSection = true;
        }else {
                confirmSection = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please Select The Acount'));
        }
        
        system.debug('selectedAccountId::'+selectedAccountId);
        system.debug('AccName::'+AccName);
        listToMemo = new list<DBUtility.CertDiamondProduct>();
        
        for(DBUtility.CertDiamondProduct cdp : selectedCertProducts){
                        if(cdp.isSelectedProd == true){
                                listToMemo.add(cdp);
                        }
                }
               
         if(null == listToMemo || listToMemo.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please Select The Product'));
                confirmSection = false;
        }else{
                confirmSection = true;
                
        }
        
        //AccScreen = false;
        
        system.debug('listToMemo::'+listToMemo);
    }
    
    /*public PageReference confirmTransfer(){
        searchSection = false;
        AccScreen = false;
        confirmSection = false;
        searchButton = false;
        returnbuton = false;
        if(!listToMemo.isEmpty() && null != selectedAccountId){
            Savepoint mySavepoint = Database.setSavepoint();
            try{
                oppObjToTransfer = new Opportunity();
                oppObjToTransfer.Name = DateTime.now().format(' yyyyMMdd') + ' - ' +AccName ;
                oppObjToTransfer.StageName = 'Approving';
                oppObjToTransfer.CloseDate = Date.today();
                oppObjToTransfer.Accountid = selectedAccountId;
                                
                try{
                        insert oppObjToTransfer;
                }
                catch(DMLException excep){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, excep.getMessage()));
                        Database.rollback(mySavepoint);
                }
                                
                map<Id , PriceBookEntry> locToLineItemsToInsertOnNewOpp = new map<Id , PriceBookEntry>();   
                
                for(DBUtility.CertDiamondProduct certobj :listToMemo){
                    locToLineItemsToInsertOnNewOpp.put(certobj.objProd.id, Null);
                }
                
                for(PriceBookEntry pbe : [Select Id , UnitPrice, Product2Id from PriceBookEntry where Product2Id IN :locToLineItemsToInsertOnNewOpp.keySet() AND PriceBook2.Name = 'Wholesale' ]){
                    locToLineItemsToInsertOnNewOpp.put(pbe.Product2Id, pbe);
                }
                
                try{    
                    for(DBUtility.CertDiamondProduct certobj :listToMemo){
                         system.debug('certobj.objProd.Total_Quantity__c::'+certobj.objProd.Total_Quantity__c);
                        system.debug('locToLineItemsToInsertOnNewOpp.get(certobj.objProd.id).id::'+locToLineItemsToInsertOnNewOpp.get(certobj.objProd.id).id);
                        OpportunityLineItem oliOnNewOpp = new OpportunityLineItem();
                        oliOnNewOpp.OpportunityId = oppObjToTransfer.Id;
                        if(locToLineItemsToInsertOnNewOpp.containsKey(certobj.objProd.id))
                                oliOnNewOpp.PricebookEntryId = locToLineItemsToInsertOnNewOpp.get(certobj.objProd.id).id;
                        else 
                                continue;
                        oliOnNewOpp.Quantity = certobj.objProd.Total_Quantity__c;
                        oliOnNewOpp.Status__c = 'Shipping';
                        oliOnNewOpp.UnitPrice = locToLineItemsToInsertOnNewOpp.get(certobj.objProd.id).UnitPrice;       
                        oliOnNewOpplst.add(oliOnNewOpp);
                }
                
                        insert oliOnNewOpplst;
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ' Transfer Successful'));
                        
                        
                }
                catch(Exception excep){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error - Please Select Valid Product.'));
                    searchSection = true;
                    AccScreen = true;
                    confirmSection = true;
                    searchButton = true;
                    returnbuton = true;
                    Database.rollback(mySavepoint);
                    
                }
               } 
              catch(Exception excep){
                  //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error - Please Select Valid Product.'));
                        searchSection = true;
                        AccScreen = true;
                        confirmSection = true;
                        searchButton = true;
                        returnbuton = true;
                        Database.rollback(mySavepoint);
                } 
            }
                system.debug('oppObjToTransfer.Id::'+oppObjToTransfer.Id);
                if(null != oppObjToTransfer.Id){
                Pagereference page = new Pagereference('/'+oppObjToTransfer.Id);
                //page.setRedirect(true);
                return page; 
                }
                else{
                    return null;
                }
                
        }
        
        public PageReference emailscreen(){
                EmailSection = true;
                //PageReference pageRef = addToMemo();
                PageReference pageRef = new PageReference('/apex/selectAccountForDiamondSearch');              
                searchButton = false;
                AccScreen = false;
                confirmSection = false;
                searchSection = false;
                searchButton = false;
                return pageRef;
                
        }
        
        public void addrow(){
                emailList.add(new Contact());
                
        }
        
        //Email The CSV of selcted Certified Diamonds
        public void emaillist(){
                
                system.debug('emailAddress::'+emailList);
                
                
                
                listToMail = new list<DBUtility.CertDiamondProduct>();
                 prdid = new Set<Id>();
                for(DBUtility.CertDiamondProduct cdp : selectedCertProducts){
                if(cdp.isSelectedProd == true){
                        listToMail.add(cdp);
                        //prdtmap.put(cdp.objProd.id , cdp.objProd);
                }
        }
        prdtmap  = new map<id, Product2>([Select id,Fluorescence__c,Product_ID__c, Name,Item_Name__c,Carats__c,Shape__c,Color__c,Clarity__c,Final_Cut__c,Polish__c,Symmetry__c,Depth_percent__c,Table_percent__c,L_W_Ratio__c,Certified_Number__c From Product2 Where Id IN : (prdid) ]);
        
        if(null != listToMail && !listToMail.isEmpty()){
                        try{
                                headerString =  'Certificate Number,Item Number,PPC,Total Price,Carat,Shape,Color,Clarity,Cut,Polish,Symmetry,Fluor,Depth%,Table%'+'\n';
                                bodyString = '';
                                for(DBUtility.CertDiamondProduct certobj :listToMail){
                                        system.debug('certobj.objProd.Certified_Number__c::'+certobj.objProd.Certified_Number__c);
                                        //DBUtility.CertDiamondProduct certobjtemp = new DBUtility.CertDiamondProduct();
                                        
                                        if(String.isBlank(certobj.objProd.Report_Number__c)){
                                                bodyString += '"'+'","';
                                        }
                                        else{
                                                bodyString += '"'+certobj.objProd.Report_Number__c+'","';//+certobj.objProd.Certified_Number__c+
                                        }
                                        
                                        if(null == certobj.objProd.Product_ID__c){
                                                bodyString += ''+'","';
                                        }
                                        else{
                                                bodyString += certobj.objProd.Product_ID__c+'","';
                                        }
                                        
                                        if(null == certobj.objProd.Sell_Price__c){
                                                bodyString += ''+'","';
                                        }
                                        else{
                                                bodyString += certobj.objProd.Sell_Price__c+'","';
                                        }
                                        
                                        if(null == certobj.objProd.Total_Sell_Price__c){
                                                bodyString += ''+'","';
                                        }
                                        else{
                                                bodyString += certobj.objProd.Total_Sell_Price__c+'","';
                                        }
                                        
                                        if(null == certobj.objProd.Carats__c){
                                                bodyString += ''+'","';
                                        }
                                        else{
                                                bodyString += certobj.objProd.Carats__c+'","';
                                        }
                                        
                                        if(null == certobj.objProd.Shape__c){
                                                bodyString += ''+'","';
                                        }
                                        else{
                                                bodyString += certobj.objProd.Shape__c+'","';
                                        }
                                        
                                        if(null == certobj.objProd.Color__c){
                                                bodyString += ''+'","';
                                        }
                                        else{
                                                bodyString += certobj.objProd.Color__c+'","';
                                        }
                                        
                                        if(null == certobj.objProd.Clarity__c){
                                                bodyString += ''+'","';
                                        }
                                        else{
                                                bodyString += certobj.objProd.Clarity__c+'","';
                                        }
                                        
                                        if(null == certobj.objProd.Final_Cut__c){
                                                bodyString += ''+'","';
                                        }
                                        else{
                                                bodyString += certobj.objProd.Final_Cut__c+'","';
                                        }
                                        
                                        if(null == certobj.objProd.Polish__c){
                                                bodyString += ''+'","';
                                        }
                                        else{
                                                bodyString += certobj.objProd.Polish__c+'","';
                                        }
                                        
                                        if(null == certobj.objProd.Symmetry__c){
                                                bodyString +=''+'","';
                                        }
                                        else{
                                                bodyString += certobj.objProd.Symmetry__c+'","';
                                        }
                                        
                                        if(null == certobj.objProd.Fluorescence__c){
                                                bodyString +=''+'","';
                                        }
                                        else{
                                                bodyString += certobj.objProd.Fluorescence__c+'","';
                                        }
                                        
                                        if(null == certobj.objProd.Depth_percent__c){
                                                bodyString += ''+'","';
                                        }
                                        else{
                                                bodyString += certobj.objProd.Depth_percent__c+'","';
                                        }
                                        
                                        if(null == certobj.objProd.Table_percent__c){
                                                bodyString += ''+'"';
                                        }
                                        else{
                                                bodyString += certobj.objProd.Table_percent__c+'"';
                                        }
                
                                        bodyString += '\n';
                                        
                                        system.debug('bodyString::'+bodyString.length());
                                }
                                
                                bodyString = headerString+bodyString;        
                        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                        blob csvBlob = Blob.valueOf(bodyString);
                        string csvname= 'White Pine Trading Certified Diamonds.csv';
                        csvAttc.setFileName(csvname);
                        csvAttc.setBody(csvBlob);
                        
                        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
                        String[] toAddresses = new list<string>();
                        String subject ='CertDiamond CSV';
                        email.setSubject(subject);
                        for(Contact con: emailList){ 
                                system.debug(con.email);
                                if(null != con.email && '' != con.email){
                                        toAddresses.add(con.email);
                                }
                        }
                        email.setToAddresses( toAddresses );
                        email.setPlainTextBody('Account CSV ');
                        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
                        //HttpResponse response = CsvAttachment(csvBlob,csvname);
                        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email Sent.'));
                        
                        }
                        catch(Exception excep){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error - '+ excep.getMessage()));
                        }
        }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error - Please Select Products.'));
        }
        
        
        }*/
        
        
        
    public class SearchResult{
        public list<SelectOption> isChecked {get;set; }
        public Boolean isAccountChecked {get;set;}
        public string accountNameField {get;set;}
        public string id1 {get;set;}
        public String fieldName {get;set;}
        public String radioButtonValue{get;set;}
        
        public SearchResult(list<SelectOption> isChecked,  String id111, string accountNameField, String fieldName){
            this.isChecked = isChecked ;
                        this.id1 = id111;
            this.accountNameField = accountNameField;
            this.fieldName = fieldName;
        }        
    }
    
    
    
}