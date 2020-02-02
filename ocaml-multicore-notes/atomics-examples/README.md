# Atomics

The examples in this directory try to illustrate the behaviour of atomic variables versus their non atomic counterparts. The files present in this are listed below.

Atomic types are the building blocks of concurrent data structures. What atomic types ensure is there is only on thread performing read-modify-write (RMW in short) operation at one time effectively avoiding any inconsistencies.

## C

To execute the file type in `gcc -o <executable-name> <file-name>.c -pthread`

1. `atomic_int_example.c`. 

In this example we create an integer and an atomic integer each and try to increment them 10,000 times in ten different threads, making the total number of increments 100,000. Ideally the value of both variables should be 100,000. Let us try to find the results.

Running this 5 times on gave out the following output.

```
the value of acnt is 100000
the value of cnt is 29228

the value of acnt is 100000
the value of cnt is 55338

the value of acnt is 100000
the value of cnt is 63851

the value of acnt is 100000
the value of cnt is 42845

the value of acnt is 100000
the value of cnt is 64851
```


## Go

To execute go files `go run <file-name>.go`

1. `atomic-counters.go`

We can observe similar results in this.

