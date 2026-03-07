package com.example;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.util.ArrayList;

import org.junit.jupiter.api.Test;

class MyReentrantLockTest {
    private int counter;

    @Test
    void justLocking() {
        MyReentrantLock lock = new MyReentrantLock(new MyNonReentrantLockFactory());
        lock.lock();
        lock.unlock();
    }

    @Test
    void simpleRecursiveLocking() {
        MyReentrantLock lock = new MyReentrantLock(new MyNonReentrantLockFactory());
        lock.lock();
        lock.lock();
        lock.unlock();
        lock.unlock();
        assertThrows(IllegalMonitorStateException.class, () -> lock.unlock());
    }

    @Test
    void wigglyRecursiveLocking() {
        MyReentrantLock lock = new MyReentrantLock(new MyNonReentrantLockFactory());
        lock.lock();
        lock.unlock();
        lock.lock();
        lock.unlock();
    }

    @Test
    void strangerUnlocking() {
        MyReentrantLock lock = new MyReentrantLock(new MyNonReentrantLockFactory());

        Thread a = new Thread(() -> {
            lock.lock();
        });

        a.start();
        try {
            a.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        assertThrows(IllegalMonitorStateException.class, () -> lock.unlock());

    }

    @Test
    void lockLocks() {
        int threads = 12;
        int iterations = 10000;

        MyReentrantLock lock = new MyReentrantLock(new MyNonReentrantLockFactory());
        MyThreadFactory factory = new MyThreadFactory();
        ArrayList<Thread> threadList = new ArrayList<>();
        counter = 0;

        for (int i = 0; i < threads; i++) {
            Thread t = factory.newThread(() -> {
                for (int j = 0; j < iterations; j++) {
                    lock.lock();
                    try {
                        counter++;
                    } finally {
                        lock.unlock();
                    }
                }
            });
            t.start();
            threadList.add(t);
        }

        for (Thread t : threadList) {
            try {
                t.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        assertEquals(threads * iterations, counter);
    }
}
