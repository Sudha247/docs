# Porting Cubicle to Multicore OCaml

## Introduction

Cubicle is a model checker for verifying safety properties of array based
systems. Cubicle is written in OCaml, it uses a version of `Alt-Ergo` SMT
solver and `Functory` library for parallelisation.

Building and running cubicle with Multicore OCaml compiler helped us to find
and fix issues in weak reference addressed in
[ocaml-multicore/ocaml-multicore#315](https://github.com/ocaml-multicore/ocaml-multicore/pull/315)
[ocaml-multicore/ocaml-multicore#316](https://github.com/ocaml-multicore/ocaml-multicore/pull/316)
and [ocaml-multicore/ocaml-multicore#317](https://github.com/ocaml-multicore/ocaml-multicore/pull/317)

## Benchmarks

Couple of sequential cubicle example code have been added to our
benchmarking suite sandmark [ocaml-bench/sandmark#125](https://github.com/ocaml-bench/sandmark/pull/125).
This will be useful for performance testing and fine tuning the Multicore OCaml
compiler. The results for these cubicle benchmarks can be viewed [here](https://gist.github.com/Sudha247/cb977c9754955ccc6064482b83029f87).

## Parallelisation

Cubicle uses the library `Functory` for parallelisation. Functory is a
distributed computing library for OCaml with support to perform computations on
multiple cores and on a network of machines. Functory follows Google's MapReduce
approach to execute code in parallel.

`Functory.Cores` - module runs tasks on multiple cores on the same machine. It
is implemented with `Unix` processes, using `fork` and `wait` and communication
happens through marshaling. [2]

## Porting to Multicore OCaml

A straightforward way to port Cubicle to use Multicore OCaml would be to make an
interface similar to `Functory` that uses Multicore OCaml. Cubicle uses only
the `compute` function from `Functory.Cores` module. An attempt to do that is
[here](https://github.com/Sudha247/cubicle/blob/wip-multicore/bwd.ml#L279-L312),
embedded into this branch of cubicle itself. This has the
`Functory.Cores.compute` rewritten in Multicore OCaml using Domains and
Channels.

### Observations

We modified cubicle to use the multicore interface of functory, the code is
available in this [branch](https://github.com/Sudha247/cubicle/tree/wip-multicore).

It was causing segmentation faults while executing on multiple domains,
possibly due to multiple domains altering the same objects simultaneously.
Segfaults have been resolved in 4.10.0+multicore compiler variant(parallel
minor GC) and we are able to obtain the backtrace of the failures.

For instance this is the backtrace for `german_pfs` while executing on 4 cores:

```
$ ./cubicle.opt examples/german_pfs.cub -j 4
cores: 4

node 1: unsafe[1]
                                                                                                    39 (24+15) remaining


Not_found
Fatal error: Not_found
Raised at file "common/vec.ml", line 74, characters 23-38
Called from file "common/iheap.ml", line 73, characters 44-63
Called from file "common/iheap.ml", line 102, characters 9-22
Called from file "list.ml", line 110, characters 12-15
Called from file "list.ml", line 110, characters 12-15
Called from file "smt/solver.ml", line 945, characters 2-123
Called from file "smt/alt_ergo.ml", line 538, characters 6-27
Called from file "prover.ml", line 215, characters 2-61
Called from file "prover.ml", line 226, characters 2-24
Called from file "fixpoint.ml", line 336, characters 4-18
Called from file "fixpoint.ml", line 390, characters 6-28
Called from file "bwd.ml", line 199, characters 15-47
Called from file "bwd.ml" (inlined), line 332, characters 18-37
Called from file "bwd.ml", line 300, characters 29-39
Called from file "bwd.ml", line 307, characters 6-26
```

### Problem

The backward reachability algorithm uses the same instance of the SMT solver
for the entire search. This doesn't go well with Multicore OCaml because all
domains operate on the same major heap, with possible operations on objects by
multiple domains (analogous to threads) simultaneously.

One solution to this is to have a separate instance of the SMT solver
for each domain. This way one domain does not meddle with data of another
domain.

>Cubicle’s integration with the SMT solver at the API level is crucial for
efficient treatment of the subsumption check. For any such check, a single
context for the SMT solver is used; it just gets incremented and repeatedly
verified. To support the efficient (symmetry-reduced) and exhaustive
application of the inexpensive redundancy and subset checks, cubes are
maintained in normal form where variables are renamed and implied literals
removed at construction time.

-- [1]

This statement although poses the question whether the correctness of the BRAB
algorithm still holds if a separate instance of SMT solver is used by every
domain.

### Alternative approach

An alternative approach would be to code a concurrent version of the breadth
first search using Multicore primitives. This will need some synchronisations
in the algorithm to ensure its correctness and might warrant some amount of
code reorganisation.

---

#### References

[1] Conchon, Sylvain, Amit Goel, Sava Krstić, Alain Mebsout, and Fatiha Zaïdi.
**"Cubicle: A parallel SMT-based model checker for parameterized systems."** In
International Conference on Computer Aided Verification, pp. 718-724. Springer,
Berlin, Heidelberg, 2012.


[2] Filliâtre, Jean-Christophe, and K. Kalyanasundaram. **"Functory: A
distributed computing library for Objective Caml."** In International Symposium
on Trends in Functional Programming, pp. 65-81. Springer, Berlin, Heidelberg,
2011.
