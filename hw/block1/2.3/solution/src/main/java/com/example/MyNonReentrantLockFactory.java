package com.example;

class MyNonReentrantLockFactory implements NonReentrantLockFactory {
    @Override
    public NonReentrantLock create() {
        return new MyNonReentrantLock();
    }

}
