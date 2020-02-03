open Printf

let add_atom atom = Atomic.incr atom

let add_ref my_ref = begin
  my_ref := !my_ref + 1
end
let a = Atomic.make 0
let b = ref 0

let rec spawn n =
  if (n = 0) then []
  else begin
  Domain.spawn (fun _ -> for _ = 0 to (try int_of_string Sys.argv.(1) with _ -> 1000) do
    add_atom a;
    add_ref b;
  done;) :: (spawn (n-1))
  end

let number_domains = try int_of_string Sys.argv.(2) with _ -> 4

let _ =
  begin
  let domains = spawn number_domains
  in List.iter Domain.join domains;
  printf "a = %d\nb = %d\n" (Atomic.get a) (!b)
  end
(*
  begin
    Domain.spawn (fun _ -> for _ = 0 to (int_of_string Sys.argv.(1)) do
      add_atom a;
      add_ref b;
    done;) |> Domain.join;
    printf "a = %d\nb = %d\n" (Atomic.get a) (!b)
  end *)
