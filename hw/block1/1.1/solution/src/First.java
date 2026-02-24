public class First {
    public static void main(String[] args) throws Exception {
        Thread b = new Thread(() -> {
            System.out.println("in thread b");
            throw new RuntimeException("uncaught exception from b");
        });

        Thread a = new Thread(() -> {
            System.out.println("in thread a");
            b.start();
            try {
                b.join();
            } catch (InterruptedException e) {

            }
            ;
        });

        a.start();
        a.join();
    }
}
