public class DBUtility {
    /*
     *@Description: To Get 999 products.  
     */
     
    public static list<Product2> getProducts(){
        try{
            list<Product2> objProducts = new list<Product2>();
            objProducts.addAll([Select Item_No__c,Created_Date_Gemini__c,Certified_Number__c ,Product_ID__c,L_W_Ratio__c,Total_Sell_Price__c,Item_Name__c,Fluorescence__c,Cost_per_item__c,Available_for_Sale__c ,Width__c, White_Pine_Item_No_Old_from_Gemini__c, White_Pine_Item_No_New__c, Watch_Type__c, Watch_Condition__c, WPS_Size__c, Type__c, Treatment__c, Total_Quantity__c, Table_percent__c, SystemModstamp, Symmetry__c, Supplier_Model_Number__c, Style_Number__c, Shape__c, Serial_Number__c, Sell_Price__c, Sell_Price_CloseOut_Jewelry__c,  Report_Number__c, Report_Agency__c, Refurbished__c, RecordTypeId, Quantity_on_Hand__c,   Product__c, ProductCode, Polish__c, Painting__c,Owner__c,Original_piece__c, Original_Papers__c, Original_Buckle__c, Original_Box__c, Original_Band__c, Name, Movement_Type__c, Model_Name__c, Long_Description__c, Length__c, LastModifiedDate, LastModifiedById, IsDeleted, IsActive, Id, Gender__c, Fluorescence_Intensity__c, Final_Cut__c, Fancy_Color_Secondary_Tone__c, Fancy_Color_Primary_Tone__c, Fancy_Color_Grade__c, Family, Dial_Color__c, Description, Depth_percent__c, Depth__c, De_Identified_Serial_Number__c,  Crystal__c, CreatedDate, CreatedById, Country_of_Origin__c,  Cost_Price__c, Condition__c, Color__c, Clarity__c, Center_Inclusion__c, Case_Width__c, Case_Shape__c, Case_Primary_Metal__c, Case_Height__c, Carats__c, Brand__c, Bezel_Type__c, Band_Type__c, Aftermarket_Components__c From Product2 WHERE isActive=true AND Total_Quantity__c >0 limit 100]);         
            return objProducts;
        }catch(Exception ex){
            throw new WPDCustomException('Error:'+ex.getMessage()+' at Line # '+ex.getLineNumber());
        }
        return null;
    } 
    
    /*
     @Description: To Get 999 Diamond products.  
    */
    public static list<Product2> getDiamonds(){
        try{
            list<Product2> objProducts = new list<Product2>();
            objProducts.addAll([Select Item_No__c,Created_Date_Gemini__c,Certified_Number__c,Product_ID__c,L_W_Ratio__c,Total_Sell_Price__c,Item_Name__c,Fluorescence__c,Cost_per_item__c,Available_for_Sale__c ,Width__c, White_Pine_Item_No_Old_from_Gemini__c, White_Pine_Item_No_New__c, Watch_Type__c, Watch_Condition__c, WPS_Size__c, Type__c, Treatment__c, Total_Quantity__c, Table_percent__c, SystemModstamp, Symmetry__c, Supplier_Model_Number__c, Style_Number__c, Shape__c, Serial_Number__c, Sell_Price__c, Sell_Price_CloseOut_Jewelry__c,  Report_Number__c, Report_Agency__c, Refurbished__c, RecordTypeId, Quantity_on_Hand__c,   Product__c, ProductCode, Polish__c, Painting__c,Owner__c,Original_piece__c, Original_Papers__c, Original_Buckle__c, Original_Box__c, Original_Band__c,  Name, Movement_Type__c, Model_Name__c, Long_Description__c, Length__c, LastModifiedDate, LastModifiedById, IsDeleted, IsActive, Id, Gender__c, Fluorescence_Intensity__c, Final_Cut__c, Fancy_Color_Secondary_Tone__c, Fancy_Color_Primary_Tone__c, Fancy_Color_Grade__c, Family, Dial_Color__c, Description, Depth_percent__c, Depth__c, De_Identified_Serial_Number__c,  Crystal__c, CreatedDate, CreatedById, Country_of_Origin__c,  Cost_Price__c, Condition__c, Color__c, Clarity__c, Center_Inclusion__c, Case_Width__c, Case_Shape__c, Case_Primary_Metal__c, Case_Height__c, Carats__c, Brand__c, Bezel_Type__c, Band_Type__c, Aftermarket_Components__c From Product2 WHERE isActive=true AND RecordType.Name = 'WPS Single Stone' AND Total_Quantity__c >0 limit 100]);         
            return objProducts;
        }catch(Exception ex){
            throw new WPDCustomException('Error: '+ex.getMessage()+' at Line # '+ex.getLineNumber());
        }
        return null;
    }
    
    /*
     @Description: To Get 999 Diamond products.  
    */
    public static list<CertDiamondProduct> getCertifiedDiamonds(){
        try{
            list<CertDiamondProduct> objProducts = new list<CertDiamondProduct>();            
            for(Product2 p:[Select Item_No__c,Created_Date_Gemini__c,Certified_Number__c,Product_ID__c,L_W_Ratio__c,Total_Sell_Price__c,Item_Name__c,Fluorescence__c,Cost_per_item__c,Available_for_Sale__c ,Width__c, White_Pine_Item_No_Old_from_Gemini__c, White_Pine_Item_No_New__c, Watch_Type__c, Watch_Condition__c, WPS_Size__c, Type__c, Treatment__c, Total_Quantity__c, Table_percent__c, SystemModstamp, Symmetry__c, Supplier_Model_Number__c, Style_Number__c, Shape__c, Serial_Number__c, Sell_Price__c, Sell_Price_CloseOut_Jewelry__c,  Report_Number__c, Report_Agency__c, Refurbished__c, RecordTypeId, Quantity_on_Hand__c,   Product__c, ProductCode, Polish__c, Painting__c,Owner__c,Original_piece__c, Original_Papers__c, Original_Buckle__c, Original_Box__c, Original_Band__c,  Name, Movement_Type__c, Model_Name__c, Long_Description__c, Length__c, LastModifiedDate, LastModifiedById, IsDeleted, IsActive, Id, Gender__c, Fluorescence_Intensity__c, Final_Cut__c, Fancy_Color_Secondary_Tone__c, Fancy_Color_Primary_Tone__c, Fancy_Color_Grade__c, Family, Dial_Color__c, Description, Depth_percent__c, Depth__c, De_Identified_Serial_Number__c,  Crystal__c, CreatedDate, CreatedById, Country_of_Origin__c,  Cost_Price__c, Condition__c, Color__c, Clarity__c, Center_Inclusion__c, Case_Width__c, Case_Shape__c, Case_Primary_Metal__c, Case_Height__c, Carats__c, Brand__c, Bezel_Type__c, Band_Type__c, Aftermarket_Components__c From Product2 WHERE RecordType.Name = 'WPS Single Stone' AND isActive=true AND Total_Quantity__c >0 order by createdDate limit 100]){
                objProducts.add(new CertDiamondProduct(false,p,false));
            }
            return objProducts;
        }catch(Exception ex){
            throw new WPDCustomException('Error: '+ex.getMessage()+' at Line # '+ex.getLineNumber());
        }
        return null;
    }
    
    public static list<CertDiamondProduct> getCertifiedDiamondsByFilter(String filter){
        try{
            if(filter != null && filter != ''){
                list<CertDiamondProduct> objProducts = new list<CertDiamondProduct>();   
                list<Product2> objProductsList = (list<Product2>)Database.query('Select Item_No__c,Created_Date_Gemini__c,Product_ID__c,Item_Name__c,L_W_Ratio__c,Total_Sell_Price__c,Fluorescence__c,Certified_Number__c ,Cost_per_item__c,Available_for_Sale__c ,Width__c, White_Pine_Item_No_Old_from_Gemini__c, White_Pine_Item_No_New__c, Watch_Type__c, Watch_Condition__c, WPS_Size__c, Type__c, Treatment__c, Total_Quantity__c, Table_percent__c, SystemModstamp, Symmetry__c, Supplier_Model_Number__c, Style_Number__c, Shape__c, Serial_Number__c, Sell_Price__c, Sell_Price_CloseOut_Jewelry__c,  Report_Number__c, Report_Agency__c, Refurbished__c, RecordTypeId, Quantity_on_Hand__c,   Product__c, ProductCode, Polish__c, Painting__c,Owner__c,Original_piece__c, Original_Papers__c, Original_Buckle__c, Original_Box__c, Original_Band__c,  Name, Movement_Type__c, Model_Name__c, Long_Description__c, Length__c, LastModifiedDate, LastModifiedById, IsDeleted, IsActive, Id, Gender__c, Fluorescence_Intensity__c, Final_Cut__c, Fancy_Color_Secondary_Tone__c, Fancy_Color_Primary_Tone__c, Fancy_Color_Grade__c, Family, Dial_Color__c, Description, Depth_percent__c, Depth__c, De_Identified_Serial_Number__c,  Crystal__c, CreatedDate, CreatedById, Country_of_Origin__c,  Cost_Price__c, Condition__c, Color__c, Clarity__c, Center_Inclusion__c, Case_Width__c, Case_Shape__c, Case_Primary_Metal__c, Case_Height__c, Carats__c, Brand__c, Bezel_Type__c, Band_Type__c, Aftermarket_Components__c From Product2 WHERE isActive=true AND RecordType.Name = \'WPS Single Stone\' AND Total_Quantity__c >0 AND '+filter+'  AND isActive=true order by createdDate limit 100');
                for(Product2 p:objProductsList){
                    objProducts.add(new CertDiamondProduct(false,p,false));
                }
                return objProducts;
            }else{
                return getCertifiedDiamonds();
            }
        }catch(Exception ex){
            throw new WPDCustomException('Error: Server Error - '+ex.getMessage()+' at Line # '+ex.getLineNumber());
        }
        return null;
    }
    
    
    /*
     @Description: To Get 999 Jewelry products.  
    */
    public static list<Product2> getJewelry(){
        try{
            list<Product2> objProducts = new list<Product2>();
            objProducts.addAll([Select Item_No__c,Created_Date_Gemini__c,Certified_Number__c ,Product_ID__c,Total_Sell_Price__c,Item_Name__c,Fluorescence__c,Cost_per_item__c,Available_for_Sale__c ,Width__c, White_Pine_Item_No_Old_from_Gemini__c, White_Pine_Item_No_New__c, Watch_Type__c, Watch_Condition__c, WPS_Size__c, Type__c, Treatment__c, Total_Quantity__c, Table_percent__c, SystemModstamp, Symmetry__c, Supplier_Model_Number__c, Style_Number__c, Shape__c, Serial_Number__c, Sell_Price__c, Sell_Price_CloseOut_Jewelry__c,  Report_Number__c, Report_Agency__c, Refurbished__c, RecordTypeId, Quantity_on_Hand__c,   Product__c, ProductCode, Polish__c, Painting__c,Owner__c,Original_piece__c, Original_Papers__c, Original_Buckle__c, Original_Box__c, Original_Band__c,  Name, Movement_Type__c, Model_Name__c, Long_Description__c, Length__c, LastModifiedDate, LastModifiedById, IsDeleted, IsActive, Id, Gender__c, Fluorescence_Intensity__c, Final_Cut__c, Fancy_Color_Secondary_Tone__c, Fancy_Color_Primary_Tone__c, Fancy_Color_Grade__c, Family, Dial_Color__c, Description, Depth_percent__c, Depth__c, De_Identified_Serial_Number__c,  Crystal__c, CreatedDate, CreatedById, Country_of_Origin__c,  Cost_Price__c, Condition__c, Color__c, Clarity__c, Center_Inclusion__c, Case_Width__c, Case_Shape__c, Case_Primary_Metal__c, Case_Height__c, Carats__c, Brand__c, Bezel_Type__c, Band_Type__c, Aftermarket_Components__c From Product2 WHERE RecordType.Name = 'Jewelry' AND isActive=true limit 100]);         
            return objProducts;
        }catch(Exception ex){
            throw new WPDCustomException('Error: '+ex.getMessage()+' at Line # '+ex.getLineNumber());
        }
        return null;
    }
    
    public class CertDiamondProduct{
        public boolean isSelected{get;set;}
        public boolean isSelectedProd{get;set;}
        public Product2 objProd{get;set;}
        public CertDiamondProduct(boolean isSelected,Product2 objProd,boolean isSelectedProd){
            this.isSelected = isSelected;
            this.objProd = objProd;
            this.isSelectedProd = isSelectedProd;
        }
    }
    
}