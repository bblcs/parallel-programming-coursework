= On correctness
== Single-threaded execution guarantees
There is strictly one worker thread at all times. When a new worker is created, the old one is immediately ending it's execution, as could be seen in the `SingleThreadExecutorService.startWorker`

== Deadlock freedom
There is only a single reentrant lock for every `CondVarFuture`, and their acquires never intersect.

== Starvation freedom
Depends on the fairness of the lock in the `CondVarFuture`, as there may be multiple threads `get`ting the same future.

== Visibility
All field writes and reads are synchronized.
