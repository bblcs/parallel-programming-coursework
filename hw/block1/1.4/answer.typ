= Amdahl's law
$S = frac(1, (1 - t_"opt") + frac(t_"opt", s_"opt"))$,
where:
+ $S$ - represents the total speedup of a program
+ $s_"opt"$ - represents the extent of the improvement
+ $t_"opt"$ - represents the proportion of time spent on the portion of the code where improvements are made


= Problem 1
Programmer enhances a part of the code that represents 10% of the total execution time. This part starts to work 10 000 times faster. What is total speedup of a program?

=== Solution
+ $s_"opt" = 10000$
+ $t_"opt" = 0.10$
+ $S = frac(1, (1 - 0.10) + frac(0.10, 10000)) = frac(1, 0.9 + 10^(-5)) = 1 / 0.90001 = 1.1110987655692715$


=== Answer

1.1110987655692715
 
= Problem 2
Problem could be split into two parts: A and B. A is serial, B is parallel. On single CPU, A takes 50 minutes, B takes 250 minutes. How many CPUs do you need to solve the problem in 100 minutes (achieve 3x speed-up)?
 
=== Solution
Let
- $A$ - time A takes.
- $B$ - time B takes on a single CPU.
- $n$ - number of CPU's.
- $S$ - total speedup

Then, by the Amdahl's law
$S = frac(1, (1 - B / (A + B)) + frac(B / (A + B), n)) => 3 = frac(1, (1 - 5 / 6 ) + frac(5, 6n)) => 1/3 = (1 - 5/6) + 5/(6n) => 2 = 1 + 5 /n => 5/n = 1 => 1/n = 1/5 => n= 5$.

=== Answer
5

= Problem 3
Prepare an example where 10x speed-up could be achieved by using 100 CPUs only.

=== Solution
Let's use the formula from the previous problem. Then
- $A = ?$
- $B = ?$
- $n = 100$
- $S = 10$

We can find the $frac(B, A + B)$, the time proportion of the parallelable task related to the $A + B$. Let's denote it as $q$. Then

$10 = frac(1, (1 - q) + frac(q, 100)) => 10 = 1/(1 - q + q/100) => 1/10 = 1 - q + q/100 => 10 = 100 - 99q => 99q = 90 => q = 90/99$

=== Answer
A takes 9 minutes, and B takes 90 minutes on a single CPU.
