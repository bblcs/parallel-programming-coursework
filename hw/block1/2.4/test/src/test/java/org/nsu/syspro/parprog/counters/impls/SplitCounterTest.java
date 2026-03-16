package org.nsu.syspro.parprog.counters.impls;

import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

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

    @ParameterizedTest
    @CsvSource({ "1,10", "1,10000", "2,10", "2,10000", "4,10", "4,10000", "8,10", "8,10000", "12,10", "12,10000",
            "12, 100000", "24,10", "24,10000"

    })

    void stress(int threads, int iterations) {

        SplitCounter counter = new SplitCounter(threads, 8);
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
