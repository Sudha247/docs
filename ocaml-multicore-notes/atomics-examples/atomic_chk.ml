open Printf

let add_atom atom = Atomic.set atom ((Atomic.get atom)+1)
;;

let add_ref my_ref = begin
  my_ref := !my_ref + 1
end
;;

(* let add_val_atom atom = Domain.spawn(fun _ -> add_atom atom) |> ignore
;;

let add_val_ref my_ref = Domain.spawn(fun _ -> add_ref my_ref) |> ignore
;; *)

let add_val_atom atom = Domain.spawn(fun _ -> add_atom atom) |> ignore;;

let add_val_ref my_ref = Domain.spawn(fun _ -> add_ref my_ref) |> ignore;;

let _ =
  let a = Atomic.make 0 in
  let b = ref 0 in
  begin
    (* Domain.spawn(fun _ -> Atomic.set a ((Atomic.get a)+5)) |> ignore;
    Domain.spawn(fun _ -> Atomic.set a ((Atomic.get a) + 10)) |> ignore;
    Domain.spawn(fun _ -> b := !b + 5) |> ignore;
    Domain.spawn(fun _ -> b := !b + 10) |> Domain.join; *)

    (* for i = 0 to (int_of_string Sys.argv.(1)) do
      add_val_atom a;
      add_val_ref b;
    done; *)
    Domain.spawn (fun _ -> for _ = 0 to (int_of_string Sys.argv.(1)) do
      add_atom a;
      add_ref b;
    done;) |> Domain.join;

    printf "a = %d\nb = %d\n" (Atomic.get a) (!b)
  end
