Public with sharing class ActionSupFunController {

    public PageReference actionSupMethod() {
        return null;
    }


    public PageReference actionFunMethod1() {
        return null;
    }

Public string Display_This_String{get;set;}
public boolean isTrue{get;set;}
    Public ActionSupFunController (){
        Display_This_String = 'value set in constructor';
        isTrue =  false; 
    }
    
    Public void actionFunMethod(){
        if(isTrue)
            Display_This_String = 'value set in action function method';
        else
            Display_This_String = 'I am in false'; 
            
            
    }
    
  //  Public void actionSupMethod(){
  //    Display_This_String = 'value set in action Support method';
  //  }
}