# Atomics

* Atomic step is one indivisible hardware step performed by the CPU.

* Atomic behaviour can be guaranteed in software by making sure that only one
thread executes the read and write at a time.


## Atomic primitives provided by Multicore OCaml

The mutable data types available in OCaml are refs, mutable fields,
arrays and data structures built on top of this. Atomic variables are one another
form of mutable varaibles which are capable of performing atomic RMW operations.

Atomic operations form the basis for lock-free programming, helping us to get rid of
potential issues such as race-conditions and deadlocks [source](https://www.infoq.com/news/2014/10/cpp-lock-free-programming/)

### Create

To create an atomic varaible

```
let x = Atomic.make 0
```

This creates an atomic variable with current value zero. An atomic value in OCaml is
mutable.

### Compare and Swap (CAS)

Compare and Swap (otherwise known as compare and set) operation is a low level primitive
provided by the hardware.

```
Atomic.compare_and_set x v_old v_new
```

This operation compares the value of x with v_old and if it is equal to v_old
then it updates the value of x to v_new and returns `true`. As we shall see in the
later sections, CAS operation is a synchronization primitive for lock-free programming.

### Fetch and add

```
Atomic.fetch_and_add x add_val
```

Fetches the current value in x and adds `add_val` to it and return the new value.

### Exchange

```
Atomic.exchange x obj
```

This sets the value of `obj` to `x`.

### Increment and decrement

`Atomic.incr x` incerements the value of x by one and `Atomic.decr x` decrements it by one.

### Set

```
Atomic.set x val
```

sets the value of x to the given value of `val`.

Note: All these operations are performed as atomic steps, if they are seperated,
atomicity is not guaranteed.
