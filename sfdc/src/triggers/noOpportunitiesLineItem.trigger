trigger noOpportunitiesLineItem on Opportunity (after update) {
    for (opportunity opp : [SELECT id,StageName,(SELECT id FROM opportunitylineitems) FROM Opportunity WHERE id in : trigger.new]){
        if(opp.StageName != 'Closed Lost' || opp.OpportunityLineItems.size() == 0){
            opp.addError('Opportunity line items are not there.');
        }
    }    
}