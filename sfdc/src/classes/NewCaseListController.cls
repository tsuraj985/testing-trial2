Public with sharing class NewCaseListController 
{
List<Case> results = new List<Case>();
public List<Case> getNewCases() 
{
results = [SELECT Id, CaseNumber FROM Case WHERE status = 'new'];
return results;
}
}