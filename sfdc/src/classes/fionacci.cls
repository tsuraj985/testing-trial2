public class fionacci{   
public void fcci(integer n){
        integer next=0;
        integer first = 0;
        integer second = 1;
        for (integer i=0;i<=n;i++){
            system.debug('next number'+next+'<<<<');
            first=second;
            second=next;
            next=first+second;
        }
    }
}