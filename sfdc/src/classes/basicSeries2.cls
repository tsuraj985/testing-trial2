public class basicSeries2 {
    public void suraj1 (integer n){
        double b = 1.0;
        for(integer i=1;i<=n;i++){
            if(math.mod(i, 2)==0){
                b = b+(math.pow(10, -i));
            } 
            else{
                b = b+(3*(math.pow(10, -i)));
            }
            system.debug(b);
        }
    }
}