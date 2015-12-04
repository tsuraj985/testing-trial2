@IsTest
public class OpportunityAlertController_test {

    testmethod public static void testOpportunityAlertController() {
        List<Opportunity> opps = OpportunityAlertController.getOpportunities(0, 'Prospecting', false);
        opps = OpportunityAlertController.getOpportunities(0, 'Prospecting', true);
        System.assertEquals(opps.size(),0);
        Opportunity o1=new opportunity(Name='suraj', CloseDate=Date.today()+4 , StageName='Prospectimg');
         Opportunity o2=new opportunity(Name='suraj3', CloseDate=Date.today()+2 , StageName='Prospecting');
          opps.add(o1);
         opps.add(o2);
        Test.startTest();
         insert opps;
   List<task> t = new List<task>{ new task(
        WhatID = opps[0].id,
        Subject='Donni',
        Status='New',
        Priority='Normal')};
        insert t; 
        
        Test.stopTest();
    }
    
}