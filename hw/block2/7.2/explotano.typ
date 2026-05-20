Consider following lock algorithm:
```java
class Filter implements Lock {
  int[] level;
  int[] victim;

  public Filter(int n) {
    level = new int[n];
    victim = new int[n]; // use 1..n-1
    for (int i = 0; i < n; i++) {
      level[i] = 0;
    }
  }

  public void lock() {
    int me = ThreadID.get();
    for (int i = 1; i < n; i++) { //attempt level 1
      level[me] = i;
      victim[i] = me;
      // spin while conflicts exist
      while ((∃k != me) (level[k] >= i && victim[i] == me)) {};
    }
  }

  public void unlock() {
    int me = ThreadID.get();
    level[me] = 0;
  }
}
```

== 7.2.1
Prove that Filter Lock algorithm satisfies mutual exclusion.


$triangle.r$


Let's use Lemma 2.4.1 from 'The Art of Multiprocessor Programming', which states: For `j` between `0` and `n − 1`, there are at most `n − j` threads at level `j`.

The last level, `j = n - 1`, is the critical section. Therefore, by Lemma 2.4.1, the critical section level will have at most `n - (n - 1) = 1` threads.

Hard way - getting a contradiction, assuming that two threads entered level `n - 1`.

Let threads `A` and `B` both are on the level `n - 1`. Let `A` be the one that last wrote to `victim[n - 1]`.

Then, both must have set level to `n - 1` and completed the loop on `i = n - 1`. Then, the order of operations is:

```
B.write(level[B] = n - 1) -> B.write(victim[n - 1] = B) -> A.write(victim[n - 1] = A) -> A.read(level[B])
```
Therefore, when spinning, `A` sees `level[B] >= n-1` and `victim[n-1] == A`, and it should keep spinning. Contradiction.

$triangle.l$

#pagebreak()

== 7.2.2
Prove that Filter Lock algorithm is starvation-free.


$triangle.r$

Induction with levels, starting from level `n - 1`.

Base case: trivial.

Transition:
Assume all threads that reach level `j + 1` or higher eventually enter the critical section.

Let thread `A` is stuck at level `j`.
By the induction hypothesis, eventually no thread will remain at levels `> j`.
Once `A` sets `level[A] = j` any thread from lower levels wont enter `j`.

Now induction on number of threads:
Base case is trivial.
if there are many threads stuck on a level, only one of them is spinning, and other ones will advance. The number of stuck threads therefore decreases for at least one, eventually reaching 1, base case.

$triangle.l$
