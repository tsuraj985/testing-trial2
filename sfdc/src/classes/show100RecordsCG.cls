public with sharing class show100RecordsCG{
    public show100RecordsCG(ApexPages.StandardSetController controller)
    {
    controller.setPageSize(10);
    } 
}