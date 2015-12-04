public class stopRecursion {
    private static boolean run = true;
    public static boolean checkRec() {
        if(run) {
            run = false;
            return true;
        } else {
            return run;
        }
    }
}