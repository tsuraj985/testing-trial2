public class basicSeries {
    public void suraj1 (integer n){
        integer a = 1;
        system.debug(a);
        	for(integer i=1;i<=n;i++){
                if(math.mod(i, 2)==0){
                 a = a*2; 
                    system.debug(a);
                }
                else{
                    a = a*4;
                    system.debug(a);
                }
        
        }
    }
}