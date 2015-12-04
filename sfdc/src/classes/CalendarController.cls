public class CalendarController {
    
    public Boolean includeMyEvents {get;set;}
    public list<list<calEventForWithoutRoom>> listForRoomWithNoClasses{get;set;}
    public transient list<calEventForWithoutRoom> wrapperEventList{get;set;}
    public boolean isRoomWithoutClasses{get;set;}
    public boolean isCheck{get;set;}
    public String selectOptionValue{get;set;}
    public list<selectOption> classlist{get;set;}
    public transient List< WrapperForMapping> finalWrapperList{get;set;}
    
    public set<String>  d2 {get;set;}
    public List<wrapperForCheckBoxWithMonths> skippedMonthsList1{get;set;}
    public List<wrapperForCheckBoxWithMonths> skippedMonthsList2{get;set;}
    public List<wrapperForCheckBoxWithMonths> skippedMonthsList3{get;set;}
    public list<Mailer_Campaign__c> mailerList{set;get;}
    date i;
    
    public Integer countThreshold{get;set;}
    public Integer volumeThreshold{get;set;}
     
    public boolean showCalendarAndCampaigns{get;set;}
    public boolean showNewCampaignWindow{get;set;}
    public boolean showCampaignDetailsWithDrops{get;set;}
    
    // Properties for Drop List View
    public list<Drop__c> dropList{get;set;}
   
   
    // Properties for Campaign New Records
    public List<SelectOption> campaignOptions{get;set;}
    public String selectedStatus{get;set;}
    public Mailer_Campaign__c campaignObj{get;set;}
   
   
    // Properties for List Campaigns 
     
    private integer counter=0;  //keeps track of the offset
    private integer list_size=3; //sets the page size or number of rows
    public integer total_size;  //used to show user the total size of the list
    public list<Mailer_Campaign__c> campaignList{get;set;}
    
    
    //
    public CalendarController(ApexPages.StandardController controller){
        init();
        
    }
    
    //constructor
    public CalendarController () {
        init();
        
    }
    public void init(){
    commonConstructor();    
    d2 =new set<String>();
        mailerList = new list<Mailer_Campaign__c>();
        skippedMonthsList1 =  new List<wrapperForCheckBoxWithMonths>();
        skippedMonthsList2 =  new List<wrapperForCheckBoxWithMonths>();
        skippedMonthsList3 =  new List<wrapperForCheckBoxWithMonths>();
        if(ApexPages.currentPage().getParameters().get('isFalse')=='true'){
            showNewCampaignWindow=true;
            system.debug('*****IsFalse Constructor----');
        }
        else{
        showCalendarAndCampaigns=true;
        showNewCampaignWindow=false;
        showCampaignDetailsWithDrops=false;
        
        isCheck =false;
        classlist = new list<selectOption>();
        
        classList.add(new SelectOption('RoomWith','Room with Classes'));
        classList.add(new SelectOption('RommWithout','Classes with no Room'));
        classList.add(new SelectOption('RoomAvailable','Rooms Available'));
        //selectOptionValue ='';
        //Default showing my events to on
        includeMyEvents = true;
        isRoomWithoutClasses = false;
        String str;
        if(ApexPages.currentPage().getParameters().get('xyz')!= null && ApexPages.currentPage().getParameters().get('xyz')!= ''){
             str = ApexPages.currentPage().getParameters().get('xyz');
              selectOptionValue = str;
        }
       
        // For List Campaigns
        total_size = [select count() from Mailer_Campaign__c]; //set the total size in the constructor
        campaignList = new list<Mailer_Campaign__c>();
        campaignList = [SELECT id,Name FROM Mailer_Campaign__c];
        
        //For list of Drops 
        dropList = new list<Drop__c>();
        dropList = [SELECT id,Drop_Date__c,Drop_Volume__c,SeededRecieved__c FROM Drop__c where Mailer_Campaign__c =:apexpages.currentpage().getparameters().get('id')];
        }
        i=date.today(); 
        integer k,l;
        for(integer x=0;x<24;x++){   
            Map<Integer, String> m = new Map<Integer, String>();
            m.put(1, 'Jan');
            m.put(2, 'Feb');
            m.put(3, 'Mar');
            m.put(4, 'Apr');
            m.put(5, 'May');
            m.put(6, 'Jun');
            m.put(7, 'Jul');
            m.put(8, 'Aug');
            m.put(9, 'Sep');
            m.put(10, 'Oct');
            m.put(11, 'Nov');
            m.put(12, 'Dec');   
            k=i.month();
            l=i.year();                     
            if(x<=7){
                boolean isChecked=checkForSkippedMonth(m.get(k)+' '+l);
                //skippedMonthsList1.add(new wrapperForCheckBoxWithMonths(m.get(k)+' '+l , isChecked)) ;
                
                skippedMonthsList1.add(new wrapperForCheckBoxWithMonths(m.get(k)+' '+l , isChecked)) ;
            }else if(x<=15){
                boolean isChecked=checkForSkippedMonth(m.get(k)+' '+l);
                //skippedMonthsList1.add(new wrapperForCheckBoxWithMonths(m.get(k)+' '+l , isChecked)) ;
                
                skippedMonthsList2.add(new wrapperForCheckBoxWithMonths(m.get(k)+' '+l , isChecked)) ;
            }else{
                boolean isChecked=checkForSkippedMonth(m.get(k)+' '+l);
                //skippedMonthsList1.add(new wrapperForCheckBoxWithMonths(m.get(k)+' '+l , isChecked)) ;
                
                skippedMonthsList3.add(new wrapperForCheckBoxWithMonths(m.get(k)+' '+l , isChecked)) ;
            }
            i=i.addMonths(1);
        }
            
     pageLoad();
    }
    public void commonConstructor(){
        
        countThreshold = Integer.valueOf(Label.Count_Threshold);
        volumeThreshold = Integer.valueOf(Label.Volume_Threshold);
        
        //For New Campaign Record
        campaignOptions = new List<SelectOption>();
        campaignObj = new Mailer_Campaign__c();
        finalWrapperList = new List<WrapperForMapping>();
        
        Schema.DescribeFieldResult fieldResult = Mailer_Campaign__c.Campaign_Status__c.getDescribe();
        
        for(Schema.PicklistEntry f  :  fieldResult.getPicklistValues() )
          {
            campaignOptions.add(new SelectOption(f.getLabel(), f.getValue()));
          }
    }
    
    /********************************** For New Drops**************************************/
    public PageReference createNewDrops(){
        PageReference pgRef;
        if(ApexPages.currentPage().getParameters().get('Id')!=null && ApexPages.currentPage().getParameters().get('Id')!=''){
            pgRef = new PageReference('/apex/CampaignNewDrop?CampaignId='+ApexPages.currentPage().getParameters().get('Id'));
            pgRef.setRedirect(true);
            return pgRef;
        }
     return null;
    }
      
    /**********************************End of Drop **************************************/
    
    
    /********************************** For New Campaign **************************************/
    
    public PageReference createNewCampaign(){
        showCalendarAndCampaigns = false;
        showNewCampaignWindow = true;
        showCampaignDetailsWithDrops = false;
        PageReference pgRef = new PageReference('/apex/NewCampaign');
        pgRef.setRedirect(true);
     return pgRef;
    }
    public PageReference onCancelCampaign(){
        showCalendarAndCampaigns = true;
        showNewCampaignWindow = false;
        showCampaignDetailsWithDrops = false;
        PageReference pgRef = new PageReference('/apex/calendarPage');
        pgRef.setRedirect(true);
     return pgRef;
    }
    public PageReference onCampaignSave(){
        showCalendarAndCampaigns = true;
        showNewCampaignWindow = false;
        showCampaignDetailsWithDrops = false;
        system.Debug('****Inside Campaign **********'+campaignObj);
        if(campaignObj!=null ){
            try{
                insert campaignObj;
            }catch(Exception excepObj){
                system.Debug('****** Exception in inserting Campaign record'+excepObj.getMessage());
            }
        }
        displaySkipMonths();
        PageReference pgRef = new PageReference('/apex/calendarPage');
        pgRef.setRedirect(true);
     return pgRef;
    }
    public PageReference onCampaignSaveAndNew(){
        showCalendarAndCampaigns = true;
        showNewCampaignWindow = false;
        showCampaignDetailsWithDrops = false;
        if(campaignObj!=null){
            try{
                insert campaignObj;
            }catch(Exception excepObj){
                system.Debug('****** Exception in inserting Campaign record'+excepObj.getMessage());
            }
        }
        displaySkipMonths();
        PageReference pgRef = new PageReference('/apex/NewCampaign');
        pgRef.setRedirect(true);
     return pgRef;
    }
    
     /********************************** End Of New Campaign **************************************/
     
     
     
    /******************************* Start for List of Campaigns ******************************/
        
    public Mailer_Campaign__c[] getCampaigns() {
        try {
         Mailer_Campaign__c[] campaigns= [select Id, Name, Active__c, Suspended_By_Client__c, Campaign_Start__c,
                                          Account_Executive__r.Name,Manager__r.Name,Print_Vendor__c
                                          from Mailer_Campaign__c
                                          limit :list_size
                                          offset :counter];
 
         return campaigns;
      } catch (QueryException e) {
         ApexPages.addMessages(e);   
         return null;
      }     
    }
    
    public PageReference Beginning() { //user clicked beginning
      counter = 0;
      return null;
    }
 
    public PageReference Previous() { //user clicked previous button
      counter -= list_size;
      return null;
    }
 
    public PageReference Next() { //user clicked next button
      counter += list_size;
      return null;
    }
 
    public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      return null;
    }
 
    public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
    }
 
    public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
    }
 
    public Integer getTotal_size() {
      return total_size;
    }
 
    public Integer getPageNumber() {
      return counter/list_size + 1;
    }
 
    public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
    }
    
  /************************************ End of List Campaign *******************************/
  
    //The calendar plugin is expecting dates is a certain format. We can use this string to get it formated correctly
    String dtFormat = 'EEE, d MMM yyyy HH:mm:ss z';
    
    
    public PageReference onChange() {/*
        pageReference page;
        if(selectOptionValue.equalsIgnoreCase('RommWithout')){
             page = new pageReference('/apex/CalendarViewRoomWithout?xyz='+selectOptionValue);
             page.setRedirect(true);
        }else if(selectOptionValue.equalsIgnoreCase('RoomAvailable')){
                 page = new pageReference('/apex/CalendarPageWithRoomAvailable?xyz='+selectOptionValue);
                 page.setRedirect(true);
        }*/
        return null;
    }
    
    public void pageLoad(){
         isCheck = false;
              listForRoomWithNoClasses = new list<list<calEventForWithoutRoom>>();
             wrapperEventList = new list<calEventForWithoutRoom>();
             system.debug('I ma gere');
            
            system.debug('###########RoomWithout#############');
            isCheck = false;
            
          /********************************************************************************/
          
         // for(Drop__c dropObj:[SELECT id,Drop_Date__c,Drop_Volume__c,End_date__c,Start_Date__c,Mailer_Campaign__c,Mailer_Campaign__r.Name,Mailer_Campaign__r.Contact__r.Name,Mailer_Campaign__r.Campaign_Unique_Color_Code__c From Drop__c Where Mailer_Campaign__c != null AND Drop_Date__c!=NULL ]){
        list<Daily_Mail_Drops__c> dailyDropList = new list<Daily_Mail_Drops__c>([Select Id,Name,
                                                                                        Is_Holiday__c,
                                                                                        Drop_Date__c,
                                                                                        Total_Count_of_Each_Day1__c,
                                                                                        Total_Volume_Of_Each_Day1__c,
                                                                                        Maximum_Count__c,
                                                                                        Maximum_Volume__c,  
                                                                                        (Select Id,Drop_Date__c,Drop_Volume__c,End_date__c,Start_Date__c,Mailer_Campaign__c,Mailer_Campaign__r.Name,Mailer_Campaign__r.Contact__r.Name,Mailer_Campaign__r.Campaign_Unique_Color_Code__c From Drops__r Where Mailer_Campaign__c != null AND Drop_Date__c!=NULL) From Daily_Mail_Drops__c]);
            for(Daily_Mail_Drops__c ddObj : dailyDropList){
                for(Drop__c dropObj:ddObj.Drops__r){
                    DateTime startDT = datetime.newInstance(dropObj.Drop_Date__c.year(), dropObj.Drop_Date__c.month(),dropObj.Drop_Date__c.day());
                    calEventForWithoutRoom wrapperCalEventObj = new calEventForWithoutRoom();
                        wrapperCalEventObj.allDay = true;
                        wrapperCalEventObj.urlFor =dropObj.Mailer_Campaign__c;
                        wrapperCalEventObj.startString =startDT.format(dtFormat);
                        wrapperCalEventObj.endString = startDT.format(dtFormat);    //string.valueof(dt);
                        wrapperCalEventObj.url = dropObj.Id;
                        wrapperCalEventObj.roomName = dropObj.Mailer_Campaign__r.Campaign_Unique_Color_Code__c;
                        wrapperCalEventObj.title = dropObj.Mailer_Campaign__r.Contact__r.Name;
                        wrapperCalEventObj.dropObj = dropObj;
                        wrapperCalEventObj.totalCount = ddObj.Total_Count_of_Each_Day1__c ;
                        wrapperCalEventObj.totalVolume = ddObj.Total_Volume_Of_Each_Day1__c ;
                        
                        if(ddObj.Total_Count_of_Each_Day1__c >= ddObj.Maximum_Count__c){
                            wrapperCalEventObj.countOriginalColor = true;
                        }else{
                            wrapperCalEventObj.countOriginalColor = false;
                        }
                        if(ddObj.Total_Volume_Of_Each_Day1__c >= ddObj.Maximum_Volume__c){
                            wrapperCalEventObj.volumeOriginalColor = true;
                        }else{
                            wrapperCalEventObj.volumeOriginalColor = false;
                        }
                       
                        wrapperEventList.add(wrapperCalEventObj);
                       
                  }
            }
            if(!wrapperEventList.isEmpty()){
                finalWrapperList.add(new  WrapperForMapping(wrapperEventList));
            }
            
            if(!wrapperEventList.isEmpty()){
                //listForRoomWithNoClasses.add(wrapperEventList);
                    system.debug('***** listForRoomWithNoClasses'+wrapperEventList.size());
                    system.debug('***** final wrapper '+finalWrapperList);
                    system.debug('***** final wrapper '+finalWrapperList[0].calEventList.size());
          }
          integer countCamp1;
          decimal dropVol1;
          system.debug('******** wrapperEventList.size'+wrapperEventList.size());
          //list<calEventForWithoutRoom>  wrapperEventList=
         
    }
   
  
    public class calEventForWithoutRoom{
        public String title {get;set;}
        public String urlFor{get;set;}
        public Boolean allDay {get;set;}
        public String startString {get;set;}
        public String endString {get;set;}
        public String url {get;set;}
        public String roomName {get;set;}
        public Drop__c dropObj{get;set;}
        public boolean countOriginalColor{get;set;}
        public boolean volumeOriginalColor{get;set;}
        public decimal totalCount{get;set;}
        public decimal totalVolume{get;set;}
    }
    
   public Class WrapperForMapping{
    public List<calEventForWithoutRoom> calEventList{get;set;}
    public calEventForWithoutRoom calEventObj{get;set;}
    public Integer countCampaigns{get;set;}
    public decimal dropVolume{get;set;}
    
    public WrapperForMapping(List<calEventForWithoutRoom> calEventObj){
        this.calEventList = calEventObj;
    } 
    public WrapperForMapping(List<calEventForWithoutRoom> calEventList,Integer countCampaigns, decimal dropVolume){
        this.calEventList = calEventList;
        this.countCampaigns = countCampaigns;
        this.dropVolume = dropVolume;
    }
    
    public WrapperForMapping(calEventForWithoutRoom calEventObj,Integer countCampaigns, decimal dropVolume){
        this.calEventObj = calEventObj;
        this.countCampaigns = countCampaigns;
        this.dropVolume = dropVolume;
    }
   }
   
   //*************Skip months***************//
   
   public boolean checkForSkippedMonth(String monthInfo){
        system.Debug('@@@@@@@@@@@@@@@ Inside check');
        String skippedMonths = system.label.Skipped_Months;
        list<String> listOfSkippedMonths = new list<String>();
            listOfSkippedMonths =  skippedMonths.split(',');
            
            for(String tempMonth :listOfSkippedMonths ){
                if(tempMonth.contains(monthInfo)){
                    d2.add(monthInfo);
                    return true;
                }
            }
    return false;
    
    }
    
    public void displaySkipMonths(){
        system.debug('inside display');
        system.debug('d2: '+d2);
        for(Mailer_Campaign__c mcObj : [select id,name,Skipped_Months__c from Mailer_Campaign__c where id=: campaignObj.id] ){
            //mcObj.Skipped_Months__c = '';         
            for(String d: d2){
                mcObj.Skipped_Months__c = mcObj.Skipped_Months__c+','+d;
                mailerList.add(mcObj);
            }
        }
        update mailerList[0];
    }
    
    public void prin(){   
        system.debug('inside prin');
        for(wrapperForCheckBoxWithMonths nn:skippedMonthsList1){
            system.debug(nn.monthWithYear); 
        }
    }
   
    public void ProcessSelect(){
        system.debug('inside process--'+d2.size());
        for(wrapperForCheckBoxWithMonths nn: skippedMonthsList1){
            if(nn.isSelected==true){
                d2.add(nn.monthWithYear);      
            }
        }          
        for(wrapperForCheckBoxWithMonths mm:skippedMonthsList2){
            if(mm.isSelected==true){
                d2.add(mm.monthWithYear);      
            }
        }
        for(wrapperForCheckBoxWithMonths pp:skippedMonthsList3){
            if(pp.isSelected==true){
                d2.add(pp.monthWithYear);      
            }
        }
        system.debug('inside process--'+d2.size() + '  ***d2--'+d2);
    }         
    public class wrapperForCheckBoxWithMonths{
        public String monthWithYear{get;set;}
        public boolean isSelected{get;set;}
        
        public wrapperForCheckBoxWithMonths(String monthWithYear,boolean isSelected){
            this.monthWithYear = monthWithYear ;
            this.isSelected = isSelected;
        }
    }   
}