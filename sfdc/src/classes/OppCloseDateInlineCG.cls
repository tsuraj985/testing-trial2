public with sharing class OppCloseDateInlineCG{
        public string oppString{get;set;}
        public boolean flag{get;set;}
            public OppCloseDateInlineCG(ApexPages.StandardController st){
                string oppString=st.getId();
                opportunity op=[SELECT CloseDate FROM Opportunity WHERE Id=:oppString];
                if (op.CloseDate>=Date.Today() && op.CloseDate<=Date.Today().addDays(4))
                {
                flag=true;
                }
                else{
                flag=false;
                }
            }
}