# Concurrency Definitions

Source: The Art of Multiprocessor Programming, Maurice Herlihy & Nir Shavit

This file contains a list of definitions that are scattered around the book. For now, this covers the
first part of the book (Principles)

## Threads

* **Critical Section:** A block of code that can be executed by only one thread at a time.

* **Mutual Exclusion:** Critical sections of threads do not overlap.

## Progress Conditions

* **Blocking:** Delay of one thread can delay others.

* **Non-Blocking:** Delay of a thread can not delay other threads.

* **Deadlock-Free:** If thread A is waiting for thread B to release resource, then thread B should not wait for thread A to release resources.

* **Obstruction-Free:** A method is obstruction-free if, from any point after which it executes in isolation, it finishes in a finite number of steps.

* **Starvation-Free or Lockout-Free:** A thread that wants to enter the critical section will eventually succeed.

* **Wait-Free:** A method is wait-free if it guarantees that every call finishes its execution in a finite number of steps.

* **Bounded Wait-Free:** A method is bounded wait-free if there is a bound on the number of steps a method call can take. The bound may depend on the number of threads.

* **Wait-Free Population Oblivious:** A wait-free method whose performance does not depend on the number of threads.

* **Lock-Free:** A method is lock-free if it guarantees that infinitely often some thread calling this method finishes in a finite number of steps. In other words, at least some thread is making progress. A wait-free method is also lock-free but not the other way round.

## Consistency

* **Quiscent:** An object is quiscent if it has no pending calls.

* **Quiscent Consistency:** any time an object becomes qui-escent, then the execution so far is equivalent to some sequential execution of the completed calls.

* **Sequential Consistency:** the result of any execution is the same as if the operations of all the processors were executed in some sequential order, and the operations of each individual processor appear in this sequence in the order specified by its program.

* **Consensus Number:** Maximum Number of threads for which the concurrent object can solve consensus problem.

* **Universality:** A class C is universal if one can construct a wait-free implementation of any object from some number of objects of C and some number of read-write registers.

* **Atomic:** A set of operations are atomic if it is linearizable to some sequential execution or at the very least sequentially consistent.

* **Contention:** occurs when multiple threads try to acquire a lock at the same time.
