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
