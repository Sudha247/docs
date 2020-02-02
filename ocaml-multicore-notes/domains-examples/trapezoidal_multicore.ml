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
