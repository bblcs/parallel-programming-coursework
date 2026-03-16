package com.example;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.concurrent.Callable;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.ExecutionException;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class SingleThreadExecutorServiceTest {
    private SingleThreadExecutorService executor;

    @BeforeEach
    void setup() {
        this.executor = new SingleThreadExecutorService(Thread::new);
    }

    @Test
    void baseCase() throws ExecutionException {
        var future = executor.submit(() -> 119);
        var res = future.get();
        assertEquals(119, res);
        assertTrue(future.isDone());
    }

    @Test
    void checkedException() throws ExecutionException {
        var future = executor.submit(() -> {
            throw new Exception("exception");
        });
        var f = executor.submit(() -> 119);
        assertThrows(ExecutionException.class, () -> future.get());
        try {
            future.get();
        } catch (ExecutionException e) {
            assertEquals(e.getCause().getClass(), Exception.class);
            assertEquals(e.getCause().getMessage(), "exception");
        }

        var res = f.get();
        assertEquals(119, res);
    }

    @Test
    void uncheckedException() throws ExecutionException {
        var future = executor.submit(() -> {
            throw new RuntimeException("exception");
        });
        var f = executor.submit(() -> 119);
        assertThrows(ExecutionException.class, () -> future.get());
        try {
            future.get();
        } catch (ExecutionException e) {
            assertEquals(e.getCause().getClass(), RuntimeException.class);
            assertEquals(e.getCause().getMessage(), "exception");
        }
        var res = f.get();
        assertEquals(119, res);
    }

    @Test
    void sequentialExecution() throws ExecutionException, InterruptedException {
        class Timer {
            long start, end;

            Timer(long s, long e) {
                this.start = s;
                this.end = e;
            }
        }
        Callable<Timer> timeTask = () -> {
            long start = System.currentTimeMillis();
            Thread.sleep(100);
            long end = System.currentTimeMillis();
            return new Timer(start, end);
        };
        var task1 = executor.submit(timeTask);
        var task2 = executor.submit(timeTask);
        var task3 = executor.submit(timeTask);
        var time1 = task1.get();
        var time2 = task2.get();
        var time3 = task3.get();

        assertTrue(time1.end <= time2.start && time2.end <= time3.start);
    }

    @Test
    void concurrentGets() throws InterruptedException {
        ConcurrentLinkedQueue<Integer> q = new ConcurrentLinkedQueue<>();
        var f = executor.submit(() -> {
            Thread.sleep(400);
            return 119;
        });

        Thread t1 = new Thread(() -> {
            try {
                q.add(f.get());
            } catch (ExecutionException e) {

            }
        });
        Thread t2 = new Thread(() -> {
            try {
                q.add(f.get());
            } catch (ExecutionException e) {
            }
        });
        Thread t3 = new Thread(() -> {
            try {
                q.add(f.get());
            } catch (ExecutionException e) {

            }
        });
        t1.start();
        t2.start();
        t3.start();
        t1.join();
        t2.join();
        t3.join();

        assertEquals(3, q.size());
        assertEquals(119, q.poll());
        assertEquals(119, q.poll());
        assertEquals(119, q.poll());
    }
}
