public with sharing class testButtonCG{
    public boolean testButton{get;set;}
    public Opportunity oppTest{get;set;}
        public testButtonCG(ApexPages.StandardController controller){
        testButton = false;
        oppTest = (Opportunity)controller.getRecord();
        }
            public void Check(){
                if(oppTest.StageName=='Closed Won'){
                testButton= true;
                }
                else{
                testButton=false;
            }
        }
}