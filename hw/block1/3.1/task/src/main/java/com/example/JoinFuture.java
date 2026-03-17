package com.example;

import java.util.concurrent.ExecutionException;

class JoinFuture<V> {
    Thread thread;
    V result;
    Exception exception;

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
        try {
            while (true) {
                try {
                    thread.join();
                    break;
                } catch (InterruptedException e) {
                    wasInterrupted = true;
                }
            }
        } finally {
            if (wasInterrupted) {
                Thread.currentThread().interrupt();
            }
        }

        if (exception != null) {
            throw new ExecutionException(exception);
        }

        return result;
    }

    /**
     * Returns `true` if this task completed. Completion may be due to normal
     * termination or
     * an exception -- in all of these cases, this method will return true.
     */
    public boolean isDone() {
        return !thread.isAlive();
    }
}
