package org.nsu.syspro.parprog.counters.impls;

import java.util.concurrent.locks.ReentrantLock;

public class LockedCounter implements Counter {

    private long data;
    private ReentrantLock lock;

    public LockedCounter(boolean fair) {
        this.data = 0;
        this.lock = new ReentrantLock(fair);
    }

    @Override
    public void increment() {
        lock.lock();
        try {
            data++;
        } finally {
            lock.unlock();
        }
    }

    @Override
    public long get() {
        lock.lock();
        try {
            return data;
        } finally {
            lock.unlock();
        }
    }
}
