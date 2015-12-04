global class GanttChart {
    public string initialData { get; set; }
    public String dataInJSON { get; set; }
    public ProjectWrapper projectData { get; set; }
    public list<Data> projects  { get; set; }
    public list<Links> projectLinks  { get; set; }
    
    //constructor
    public GanttChart(){
       customizedata();
    }

    public void fetchData() {
        Data dataDeserialized = (Data) JSON.deserialize(dataInJSON, Data.class);
        list<Project__c> projectsToUpdate = new list<Project__c>();
        for(Project__c Data : [Select ID, Name, Id__c, Duration__c,Parent__c,Type__c, Open__c, Order__c, Progress__c, Start_Date__c,(Select Id__c, Source__c, Target__c,Type__c from projectLinks__r) from Project__c where Id__c =:String.valueOf(dataDeserialized.id)]){
            Data.Name = dataDeserialized.text;
            Data.Start_Date__c = DateTime.valueOf(dataDeserialized.start_date.replace('.000Z','').replace('T',' ')).addDays(1);
            Data.Open__c =null !=  dataDeserialized.open?dataDeserialized.open: false;
            Data.Duration__c = dataDeserialized.duration;
            Data.Progress__c =dataDeserialized.progress;
            Data.Order__c = dataDeserialized.order;
            Data.Type__c = dataDeserialized.type;
            projectsToUpdate.add(Data);
        }
        
        update projectsToUpdate;
        
        customizedata();
    }
    // To add link
    public void addLink() {
        Links linkDeserialized = (Links) JSON.deserialize(DataInJSON, Links.class);
        customizedata();
    }
    
    // To delete link
    public void deleteLink() {
    	Links linkDeserialized = (Links) JSON.deserialize(DataInJSON, Links.class);
    	delete [Select Id from projectLink__c where Id__c =: String.valueOf(linkDeserialized.id) limit 1];
    	customizedata();
    }
    
    // To Add a Task
    public pageReference addTask() {
        Data dataDeserialized = (Data) JSON.deserialize(dataInJSON, Data.class);
        Project__c task = new Project__c();
        task.Name = dataDeserialized.text;
        task.Start_Date__c = DateTime.valueOf(dataDeserialized.start_date.replace('.000Z','').replace('T',' ')).addDays(1);
        if(null != dataDeserialized.open){
            task.Open__c = dataDeserialized.open;
        }
        
        if(String.isNotBlank(dataDeserialized.parent) && dataDeserialized.parent != '0'){
            list<Project__C> tempProjectList = [Select Id from Project__C where Id__c =: String.valueOf(dataDeserialized.parent) limit 1];
            if(null != tempProjectList && !tempProjectList.isEmpty()){
                task.Task__c = tempProjectList.get(0).Id;
            }
        }
        
        task.Duration__c = dataDeserialized.duration;
        task.Progress__c =dataDeserialized.progress;
        task.Order__c = dataDeserialized.order;
        task.Type__c = dataDeserialized.type;
        insert task;
        return new pageReference('/apex/GanttChart');
    }
    
    // To delete The Task
    public void deleteTask() {
        Data dataDeserialized = (Data) JSON.deserialize(dataInJSON, Data.class);
        delete [select Id from Project__c where Id__c =: String.valueOf(dataDeserialized.id) Limit 1];        
    }
    
    //To retrieve Updated Data
    public void customizedata(){
        projectData =  new ProjectWrapper();
        projects = new list<Data>();
        projectLinks = new list<Links>();
        
        for(project__c project : [Select ID, Name, Id__c, Duration__c,Parent__c,Type__c, Open__c, Order__c, Progress__c, Start_Date__c,(Select Id__c, Source__c, Target__c,Type__c from projectLinks__r) from Project__c ] ){
            Data dataObj = new Data();
            dataObj.id = Integer.valueOf(project.Id__c);
            dataObj.order = Integer.valueOf(project.Order__c);
            dataObj.duration = Integer.valueOf(project.Duration__c);
            dataObj.open = project.Open__c;
            dataObj.progress = project.Progress__c;
            dataObj.start_date = project.Start_Date__c.format('dd-MM-yyyy');
            dataObj.text = project.Name;
            dataObj.parent = project.Parent__c;
            dataObj.type = project.Type__c;
            
            projects.add(dataObj);
            
            for(projectLink__c projectlinkObject :project.projectLinks__r ){
                links linlksObj = new links();
                linlksObj.id = Integer.valueOf(projectlinkObject.Id__c);
                linlksObj.source =  Integer.valueOf(projectlinkObject.Source__c);
                linlksObj.target =  Integer.valueOf(projectlinkObject.Target__c);
                linlksObj.type =  Integer.valueOf(projectlinkObject.Type__c);
                projectLinks.add(linlksObj);
             }
        }
        projectData.data = projects;
        projectData.links = projectLinks;
        initialData = JSON.serialize(projectData);
    }
    
    // Remote Action Function For add Task
   @RemoteAction
    global static sTRING getInitialData(String jsonString ) {
    Data dataDeserialized = (Data) JSON.deserialize(jsonString, Data.class);
        Project__c task = new Project__c();
        task.Name = dataDeserialized.text;
        task.Start_Date__c = DateTime.valueOf(dataDeserialized.start_date.replace('.000Z','').replace('T',' ')).addDays(1);
        if(null != dataDeserialized.open){
            task.Open__c = dataDeserialized.open;
        }
        
        if(String.isNotBlank(dataDeserialized.parent) && dataDeserialized.parent != '0'){
            list<Project__C> tempProjectList = [Select Id from Project__C where Id__c =: String.valueOf(dataDeserialized.parent) limit 1];
            if(null != tempProjectList && !tempProjectList.isEmpty()){
                task.Task__c = tempProjectList.get(0).Id;
            }
        }
        
        task.Duration__c = dataDeserialized.duration;
        task.Progress__c =dataDeserialized.progress;
        task.Order__c = dataDeserialized.order;
        task.Type__c = dataDeserialized.type;
        insert task;
        task = [SELECT id__c,Task__c FROM Project__C WHERE ID = : task.id];
        return task.id__c;  
    } 
    
     // Remote Action Function For add Link
     @RemoteAction
     global static sTRING getInitiallinks(String jsonString ) {
        Links dataDeserialized = (Links) JSON.deserialize(jsonString, Links.class);
        projectLink__c link = new projectLink__c();
        
        link.Type__c = String.valueOf(dataDeserialized.type);
        list<Project__C> tempProjectListforsource = [Select Id,name from Project__C where Id__c =: String.valueOf(dataDeserialized.source) limit 1];
        if(null != tempProjectListforsource && !tempProjectListforsource.isEmpty()){
            link.SourceProject__c = tempProjectListforsource.get(0).Id;
        }
        list<Project__C> tempProjectListforTarget = [Select Id,name from Project__C where Id__c =: String.valueOf(dataDeserialized.target) limit 1];
        if(null != tempProjectListforTarget && !tempProjectListforTarget.isEmpty()){
            link.TargetProject__c = tempProjectListforTarget.get(0).Id;
        }
        link.name = tempProjectListforsource.get(0).name+'To'+tempProjectListforTarget.get(0).name;
        insert link;
        link = [SELECT id__c FROM projectLink__C WHERE ID = : link.id];
        return link.id__c;
     }
}