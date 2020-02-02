(*Integration by means of trapezoidal rule.*)

let rec points i x = if (i <= 0) then [] else ( (float_of_int i) *. x) :: (points (i - 1) x)

let f_of_x x = 1. /. (1. +. x *. x)

let rec integration f a b n =
        let h = (b -. a) /. (float_of_int n) in
        let my_func x = 2. *. (f x) in
        let inner = List.map (my_func) (points (n - 1) h) in
        let innerSum = List.fold_left (+.) 0. inner in
        h *. ( (f a) +. (f b) +. innerSum) /. 2.

let _ = Printf.printf "%f\n" (integration f_of_x 0. 1. 1000);;
