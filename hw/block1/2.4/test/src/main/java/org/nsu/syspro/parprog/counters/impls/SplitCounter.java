package org.nsu.syspro.parprog.counters.impls;

import java.util.concurrent.locks.ReentrantLock;

public class SplitCounter implements Counter {
    private final int PADDING;
    private final int GRANULARITY;
    private final ReentrantLock[] locks;
    private long[] counters;

    public SplitCounter(int GRANULARITY) {
        this(GRANULARITY, 1);
    }

    public SplitCounter(int GRANULARITY, int PADDING) {
        this.PADDING = PADDING;
        this.locks = new ReentrantLock[GRANULARITY];
        for (int i = 0; i < GRANULARITY; i++) {
            this.locks[i] = new ReentrantLock();
        }
        this.counters = new long[GRANULARITY * PADDING];
        this.GRANULARITY = GRANULARITY;
    }

    @Override
    public void increment() {
        int idx = (int) Thread.currentThread().getId() % GRANULARITY;
        ReentrantLock lock = locks[idx];
        lock.lock();
        try {
            counters[idx * PADDING]++;
        } finally {
            lock.unlock();
        }
    }

    @Override
    public long get() {
        try {
            for (ReentrantLock lock : locks) {
                lock.lock();
            }
            long sum = 0;
            for (int i = 0; i < GRANULARITY; i++) {
                sum += counters[i * PADDING];
            }
            return sum;
        } finally {
            for (int i = 0; i < GRANULARITY; i++) {
                if (locks[i].isHeldByCurrentThread()) {
                    locks[i].unlock();
                }
            }
        }
    }
}
