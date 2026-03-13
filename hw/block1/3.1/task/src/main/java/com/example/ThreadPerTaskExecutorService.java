package com.example;

import java.util.concurrent.ThreadFactory;
import java.util.concurrent.Callable;

class ThreadPerTaskExecutorService {
    private ThreadFactory factory;

    public ThreadPerTaskExecutorService(ThreadFactory f) {
        this.factory = f;
    }

    /**
     * Submits a value-returning task for execution and returns a `JoinFuture`
     * representing the pending results of the task.
     * The `JoinFuture`s `get` method will return the task's result upon successful
     * completion.
     */
    <T> JoinFuture<T> submit(Callable<T> task) {
        var future = new JoinFuture<T>();
        future.thread = factory.newThread(() -> {
            try {
                future.result = task.call();
            } catch (Exception e) {
                future.exception = e;
            }
        });
        future.thread.start();
        return future;
    }
}
