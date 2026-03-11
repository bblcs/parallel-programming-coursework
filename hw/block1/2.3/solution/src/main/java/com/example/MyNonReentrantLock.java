package com.example;

import java.util.concurrent.locks.ReentrantLock;

class MyNonReentrantLock implements NonReentrantLock {
    private final ReentrantLock lock = new ReentrantLock();

    @Override
    public void lock() {
        if (lock.isHeldByCurrentThread()) {
            throw new IllegalMonitorStateException();
        }
        lock.lock();
    }

    @Override
    public void unlock() {
        lock.unlock();
    }
}
