trigger showErrorLastDateCG on Opportunity (before insert, before update) {
    if (trigger.isbefore){
        for (Opportunity oppClose: trigger.new){
            if (oppClose.CloseDate < Date.Today()){
                oppClose.addError('Please enter a future close date');
                }
        }
    }
}