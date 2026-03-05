public class First {
    public static void main(String... args) throws Exception {
        System.out.println(ProcessHandle.current().pid());
        Thread.currentThread().join();
    }
}
