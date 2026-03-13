#set heading(numbering: "1.")

= On correctness
== Deadlock and starvation freedom
We have a thread per every task, they never wait each other(not a single lock used), therefore there can't be deadlocks or starvations.

== Visibility
`thread.start()` is called before the task starts executing, and after initialization of all fields of the future, therefore the new thread sees the `JoinFuture` fully. In `get` we join the worker thread, all writes of the worker thread therefore are visible to the caller thread when `get` returns.
