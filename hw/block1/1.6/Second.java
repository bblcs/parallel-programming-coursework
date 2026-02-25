public class Second {
    static volatile Runnable lambda = null;
    public static void main(String... args) throws Exception {
        System.out.println(ProcessHandle.current().pid());
        Thread A = new Thread(() -> { lambda.run(); });
        Thread B = new Thread(() -> {
            try {
            A.join();
            } catch (Exception e) {}});
        lambda = () -> {
            try {
            B.join();
            } catch (Exception e) {}};
        A.start(); B.start();
        A.join(); B.join();
    }
}
