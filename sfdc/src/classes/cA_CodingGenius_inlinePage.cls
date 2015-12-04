public with sharing class cA_CodingGenius_inlinePage{
public string op{get;set;}
public boolean flag{get;set;}
public cA_CodingGenius_inlinePage(apexPages.StandardController controller){
      opportunity oppObj=[SELECT ID,CloseDate FROM Opportunity WHERE id=:op];
         if(oppObj.CloseDate>Date.Today() && oppObj.CloseDate<=Date.Today()+5)
         flag=true;
         else
         flag=false;
      }
   }