package com.example;

import static org.junit.jupiter.api.Assertions.assertThrows;

import org.junit.jupiter.api.Test;

public class MyNonReentrantLockTest {

    private void reentering() {
        MyNonReentrantLock lock = new MyNonReentrantLock();
        lock.lock();
        lock.lock();
    }

    @Test
    public void shouldBeNonReentrant() {
        assertThrows(IllegalMonitorStateException.class, () -> reentering());
    }
}
