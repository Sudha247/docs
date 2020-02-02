open Printf

let _ =
  begin
    let num = try int_of_string Sys.argv.(1) with _ -> 10 in
    let rec spawn n = match n with
    | 0 -> []
    | _ -> Domain.spawn(fun _ -> printf "Hello World from: %d \n" (Domain.self() :> int)) :: (spawn (n - 1)) in
    let domains = spawn num in
    List.iter Domain.join domains
  end
