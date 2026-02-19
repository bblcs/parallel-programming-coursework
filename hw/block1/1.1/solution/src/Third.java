public class Third {
    public static void main(String[] args) throws Exception {
        Thread b = new Thread(() -> {
            System.out.println("in thread b");
            throw new RuntimeException("uncaught exception from b");
        });

        Thread c = new Thread(() -> {
            System.out.println("in thread c");
            try {
                b.join();
            } catch (InterruptedException e) {

            }
        });

        Thread a = new Thread(() -> {
            System.out.println("in thread a");
            b.start();
            try {
                b.join();
            } catch (InterruptedException e) {

            };
        });

        Thread d = new Thread(() -> {
            System.out.println("in thread d");
            try {
                a.join();
            } catch (InterruptedException e) {

            }
        });

        d.start();
        a.start();
        c.start();
        c.join();
        d.join();

        System.out.println("done");
    }
}
