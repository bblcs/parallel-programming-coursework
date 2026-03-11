package org.nsu.syspro.parprog.counters.impls;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.ArrayList;
import java.util.concurrent.ThreadFactory;

class SplitCounterTest {
    class MyThreadFactory implements ThreadFactory {
        @Override
        public Thread newThread(Runnable r) {
            return new Thread(r);
        }

    }

    @Test
    void stress() {
        int threads = 12;
        int iterations = 10000;

        SplitCounter counter = new SplitCounter(threads);
        MyThreadFactory factory = new MyThreadFactory();
        ArrayList<Thread> threadList = new ArrayList<>();

        for (int i = 0; i < threads; i++) {
            Thread t = factory.newThread(() -> {
                for (int j = 0; j < iterations; j++) {
                    counter.increment();
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

        assertEquals(threads * iterations, counter.get());
    }
}
