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
