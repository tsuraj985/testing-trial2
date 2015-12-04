public class newSeriesClass {
    public void surajSeries(integer last){
     integer next=0;
integer first=0;
integer second=1;
for (integer i=0;i<=last;i++){
    last=(first+second)*(first+second);
    first=last;
    system.debug('next number'+last+'<<<');
		}   
    }
}