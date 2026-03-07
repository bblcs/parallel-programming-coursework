package com.example;

class MyReentrantLock {
    private Thread owner;
    private int count;
    private NonReentrantLock lock;

    public MyReentrantLock(NonReentrantLockFactory factory) {
        this.owner = null;
        this.count = 0;
        lock = factory.create();
    }

    boolean tryLock() {
        lock.lock();
        try {
            if (owner == null) {
                owner = Thread.currentThread();
                count++;
                return true;
            }
            if (owner == Thread.currentThread()) {
                count++;
                return true;
            }

            return false;
        } finally {
            lock.unlock();
        }
    }

    public void lock() {
        int time = 2;
        while (true) {
            if (tryLock()) {
                break;
            }
            try {
                Thread.sleep(time);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            time = time * 2;
        }
    }

    public void unlock() {
        lock.lock();
        try {
            if (count == 0 || owner != Thread.currentThread()) {
                throw new IllegalMonitorStateException();
            }
            count -= 1;
            if (count == 0) {
                owner = null;
            }
        } finally {
            lock.unlock();
        }
    }
}
