= Example 1

We have
```java
public class First {
    public static void main(String... args) throws Exception {
        System.out.println(ProcessHandle.current().pid());
        Thread.currentThread().join(); // l
    }
}
```
`jstack` gives us
```
"main" #1 [24559] prio=5 os_prio=0 cpu=279.10ms elapsed=10.38s tid=0x00007fedc002b1a0 nid=24559 in Object.wait()  [0x00007fedc7ffe000]
   java.lang.Thread.State: WAITING (on object monitor)
	at java.lang.Object.wait0(java.base@21.0.8/Native Method)
	- waiting on <0x0000000719a02040> (a java.lang.Thread)
```
...
```
	at First.main(First.java:4)
```

We can see that the main thread is waiting on itself. Deadlock.

= Example 2
We have
```java
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
```
`jstack` gives us
```
"Thread-0" #20 [30707] prio=5 os_prio=0 cpu=0.13ms elapsed=11.43s tid=0x00007fdfa853f040 nid=30707 in Object.wait()  [0x00007fdf32942000]
   java.lang.Thread.State: WAITING (on object monitor)
	at java.lang.Object.wait0(java.base@21.0.8/Native Method)
	- waiting on <0x00000007186a6778> (a java.lang.Thread)
```
...
```
	at Second.lambda$main$0(Second.java:5)
```
and
```
"Thread-1" #21 [30708] prio=5 os_prio=0 cpu=0.33ms elapsed=11.43s tid=0x00007fdfa859b1c0 nid=30708 in Object.wait()  [0x00007fdf32842000]
   java.lang.Thread.State: WAITING (on object monitor)
	at java.lang.Object.wait0(java.base@21.0.8/Native Method)
	- waiting on <0x00000007186a48f8> (a java.lang.Thread)
```
...
```
	at Second.lambda$main$1(Second.java:8)
```
We can see that "Thread-0" is A, waiting for the `lambda` to stop, and "Thread-1" is B - waiting for A to die in the `lambda`. Deadlock.
