# Domains

[Source]: (https://ocaml.org/meetings/ocaml/2014/ocaml2014_1.pdf)

* Domains are the parallelization mechanism in Multicore OCaml. Each domain runs as a different thread in the same address space.
* Domains have minor heaps of their own and one common major heap.
* Each  domain  has  a  multiple-writer,  single-readermessage queue which it frequently polls for new mes-sages (using the mechanism currently used to handleUnix  signals).

---

### Hello World
Take 1
```
open Printf

let _ =
  begin
    let n = try int_of_string Sys.argv.(1) with _ -> 10 in
    for _ = 1 to n do
      Domain.spawn(fun _ -> printf "Hello World from: %d \n" (Domain.self() :> int)) |> ignore;
      done
  end

```

Take 2
```
open Printf

let _ =
  begin
    let n = try int_of_string Sys.argv.(1) with _ -> 10 in
    let rec spawn n = match n with
    | 0 -> []
    | _ -> Domain.spawn(fun _ -> printf "Hello World from: %d \n" (Domain.self() :> int)) :: (spawn (n - 1)) in
    let domains = spawn n in
    List.iter Domain.join domains
  end
```

The program spawns `n` number of threads and prints Hello World from each of them along with the Domain id which is assigned to it.

``

### Pi Approximation

**Serial Program**

```
open Printf
let factor = ref 1.0

let sum = ref 0.0

let n = 1000000

let _ =
begin
  for i = 0 to n do
    factor := if  (i mod 2 == 0) then 1.0 else -1.0;
    sum := !sum +. (!factor /. (2.0 *. (float_of_int i) +. 1.0));
    (* factor := !factor *. -1.0; *)
  done;
  printf "pi = %.15f\n" (!sum *. 4.0)
end

```

**Parallel Version**

```
open Printf

let sum = Atomic.make 0.0

let n = 1000000

let calc_pi st en =
  let factor = ref 1.0 in
  begin
    for i = st to en do
      factor := if  (i mod 2 == 0) then 1.0 else -1.0;
      Atomic.set sum ((Atomic.get sum) +. ((!factor) /. (2.0 *. (float_of_int i) +. 1.0)));
    done
  end

let _ =
  let first_half = Domain.spawn(fun _ -> calc_pi 0 (n/2)) in
  let second_half = Domain.spawn(fun _ -> calc_pi (n/2) n) in
  Domain.join first_half; Domain.join second_half;
  printf "pi = %f\n" ((Atomic.get sum) *. 4.0);

```

### Trapezoidal Rule

**Serial Version**

```
let rec points i x = if (i <= 0) then [] else ( (float_of_int i) *. x) :: (points (i - 1) x)

let f_of_x x = 1. /. (1. +. x *. x)

let rec integration f a b n =
        let h = (b -. a) /. (float_of_int n) in
        let my_func x = 2. *. (f x) in
        let inner = List.map (my_func) (points (n - 1) h) in
        let innerSum = List.fold_left (+.) 0. inner in
        h *. ( (f a) +. (f b) +. innerSum) /. 2.

let _ = Printf.printf "%f\n" (integration f_of_x 0. 1. 1000);;

```
**Parallel**

```
let rec points i x = if (i <= 0) then [] else ( (float_of_int i) *. x) :: (points (i - 1) x)

let f_of_x x = 1. /. (1. +. x *. x)

let sum = Atomic.make 0.0

let rec integration f a b n =
        let h = (b -. a) /. (float_of_int n) in
        let my_func x = 2. *. (f x) in
        let inner = List.map (my_func) (points (n - 1) h) in
        let inner_sum = List.fold_left (+.) 0. inner in
        Atomic.set sum ( (Atomic.get sum) +. (h *. ( (f a) +. (f b) +. inner_sum) /. 2.) )

let num_domains = 4

let rec spawn n a b num = match n with
| 0 -> []
| _ -> Domain.spawn(fun _ -> integration f_of_x  (float_of_int n) *. (b -. a) /. num_domains (float_of_int (n + 1)) *. (b -. a) /. (num_domains) num) :: (spawn (n - 1))

let _ =
  let domains = spawn num_domains 0 1 10000 in
  List.iter Domain.join domains;
  Printf.printf "%f\n" (Atomic.get sum)

```
