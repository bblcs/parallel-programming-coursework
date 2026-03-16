package com.example;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.Callable;
import java.util.concurrent.locks.Condition;;

class CondVarFuture<V> {
    private final ReentrantLock lock;
    private Callable<V> task;
    private Condition cond;
    private V result;
    private Throwable exception;
    private boolean done = false;

    public CondVarFuture(Callable<V> t) {
        this.task = t;
        this.lock = new ReentrantLock();
        this.cond = lock.newCondition();
    }

    /**
     * Waits if necessary for the computation to complete, and then retrieves its
     * result.
     * 
     * Returns:
     * the computed result
     * 
     * Throws:
     * ExecutionException - if the computation threw an exception
     * 
     */
    public V get() throws ExecutionException {
        boolean wasInterrupted = false;
        lock.lock();
        try {
            while (!done) {
                try {
                    cond.await();
                } catch (InterruptedException e) {
                    wasInterrupted = true;
                }
            }
            if (exception != null) {
                throw new ExecutionException(exception);
            }

            return result;
        } finally {
            if (wasInterrupted) {
                Thread.currentThread().interrupt();
            }
            lock.unlock();
        }
    }

    /**
     * Returns `true` if this task completed. Completion may be due to normal
     * termination or
     * an exception -- in all of these cases, this method will return true.
     */
    public boolean isDone() {
        lock.lock();
        try {
            return done;
        } finally {
            lock.unlock();
        }
    }

    public void runTask() throws Throwable {
        try {
            var res = task.call();
            setResult(res);
        } catch (Throwable t) {
            setException(t);
            throw t;
        }
    }

    private void setResult(V v) {
        lock.lock();
        try {
            result = v;
            done = true;
            cond.signalAll();
        } finally {
            lock.unlock();
        }
    }

    private void setException(Throwable t) {
        lock.lock();
        try {
            exception = t;
            done = true;
            cond.signalAll();
        } finally {
            lock.unlock();
        }
    }
}
