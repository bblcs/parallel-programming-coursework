package com.example;

import java.util.concurrent.Callable;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadFactory;

/**
 * Creates an ExecutorService that uses a single worker thread operating off an
 * unbounded queue.
 * Note however that if this single thread terminates due to a failure during
 * execution, a new one will take its place
 * if needed to execute subsequent tasks.
 * 
 * Tasks are guaranteed to execute sequentially, and no more than one task will
 * be active at any given time.
 */
class SingleThreadExecutorService {
    private final ThreadFactory factory;
    private final LinkedBlockingQueue<CondVarFuture<?>> queue = new LinkedBlockingQueue<>();

    private void startWorker() {
        Thread worker = factory.newThread(() -> {
            while (true) {
                try {
                    var f = queue.take();
                    try {
                        f.runTask();
                    } catch (RuntimeException e) {
                        startWorker();
                        return;
                    } catch (Exception e) {
                        continue;
                    } catch (Throwable e) {
                        startWorker();
                        return;
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    continue;
                }
            }
        });
        worker.start();

    }

    public SingleThreadExecutorService(ThreadFactory fac) {
        this.factory = fac;
        startWorker();
    }

    /**
     * Submits a value-returning task for execution and returns a `CondVarFuture`
     * representing the pending results of the task.
     * The `CondVarFuture`s `get` method will return the task's result upon
     * successful completion.
     */
    <V> CondVarFuture<V> submit(Callable<V> task) {
        CondVarFuture<V> future = new CondVarFuture<>(task);
        queue.offer(future);
        return future;
    }
}
