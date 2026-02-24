public class Second {
    public static void main(String[] args) throws Exception {
        Thread b = new Thread(() -> {
            System.out.println("in thread b");
            throw new RuntimeException("uncaught exception from b");
        });

        Thread c = new Thread(() -> {System.out.println("in thread c");
            try {
            b.join();
            } catch (InterruptedException e) {

            }

        }
        );

        Thread a = new Thread(() -> {
            System.out.println("in thread a");
            b.start();
            try {
                b.join();
            } catch (InterruptedException e) {

            };
        });
        a.start();
        a.join();
        c.start();
        c.join();

        System.out.println("done");
    }
}