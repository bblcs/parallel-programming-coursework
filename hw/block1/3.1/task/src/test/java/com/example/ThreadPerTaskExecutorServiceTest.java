package com.example;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.HashSet;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ThreadFactory;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class ThreadPerTaskExecutorServiceTest {
    private ThreadPerTaskExecutorService executor;
    private boolean flag;

    class MyThreadFactory implements ThreadFactory {
        @Override
        public Thread newThread(Runnable r) {
            return new Thread(r);
        }

    }

    @BeforeEach
    void setup() {
        MyThreadFactory f = new MyThreadFactory();
        executor = new ThreadPerTaskExecutorService(f);
    }

    @Test
    void result() throws ExecutionException {
        JoinFuture<Integer> future = executor.submit(() -> 119);

        assertEquals(119, future.get());
        assertTrue(future.isDone());
    }

    @Test
    void exceptionPropagation() {
        JoinFuture<Integer> future = executor.submit(() -> {
            throw new RuntimeException("exception");
        });

        ExecutionException ee = assertThrows(ExecutionException.class, future::get);
        assertInstanceOf(RuntimeException.class, ee.getCause());
        assertEquals("exception", ee.getCause().getMessage());
        assertTrue(future.isDone());
    }

    @Test
    void isDoneWorks() throws InterruptedException, ExecutionException {
        CountDownLatch hold = new CountDownLatch(1);

        JoinFuture<Integer> future = executor.submit(() -> {
            hold.await();
            return 119;
        });

        assertFalse(future.isDone());
        hold.countDown();
        future.get();
        assertTrue(future.isDone());
    }

    @Test
    void getBlocks() throws ExecutionException {
        flag = false;
        JoinFuture<Integer> future = executor.submit(() -> {
            Thread.sleep(500);
            flag = true;
            return 119;
        });
        future.get();
        assertTrue(flag);
    }

    @Test
    void getSurvivesInterrupts() throws InterruptedException {
        flag = false;
        JoinFuture<Integer> future = executor.submit(() -> {
            Thread.sleep(500);
            return 119;
        });

        Thread caller = new Thread(() -> {
            try {
                future.get();
            } catch (ExecutionException e) {
                flag = true;
            }
        });

        caller.start();
        caller.interrupt();
        caller.join();
        assertFalse(flag);
        assertTrue(future.isDone());
    }

    @Test
    void eachTaskInSeparateThread() throws ExecutionException {
        HashSet<JoinFuture<Boolean>> fs = new HashSet<>();
        ConcurrentLinkedQueue<Thread> q = new ConcurrentLinkedQueue<>();
        for (int i = 0; i < 12; i++) {
            fs.add(executor.submit(() -> {
                return q.add(Thread.currentThread());
            }));
        }

        for (JoinFuture<Boolean> f : fs) {
            assertTrue(f.get());
        }

        assertEquals(12, (new HashSet<>(q).size()));
    }
}
