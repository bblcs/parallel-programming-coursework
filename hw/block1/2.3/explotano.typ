#set heading(numbering: "1.")
#let statement(body) = block[*Statement.* #body]
#let proof(body) = [*Proof.* #body #align(right, $square$)]
#let st(head, body) = [#statement(head)#proof(body)]

= On correctness
== Mutual Exclusion
#st([
  No two threads can hold `MyReentrantLock` at the same time.
],
[
  To become an `owner`, a thread must observe `owner == null`, which is not possible to happen for two threads simultaneously, since the first thread to take the inner `lock` will own the reentrant lock before unlocking.
])

== Reentrancy
#st([
  A thread holding the lock can acquire it again safely.
],
[
  If a thread is already the owner, we just increment the `count` in a synchronized manner.
])
