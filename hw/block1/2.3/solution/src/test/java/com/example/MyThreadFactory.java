package com.example;

import java.util.concurrent.ThreadFactory;

class MyThreadFactory implements ThreadFactory {

    @Override
    public Thread newThread(Runnable r) {
        return new Thread(r);
    }

}
