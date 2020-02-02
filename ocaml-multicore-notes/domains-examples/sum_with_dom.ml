let rec sum = function
| [] -> 0
| x :: xs -> x + (sum xs)

let rec take n = function
| [] -> []
| x :: xs ->  if n = 0 then [] else x :: (take (n-1) xs)

let rec drop n = function
| [] -> []
| x :: xs -> if n = 0 then (x :: xs) else (drop (n-1) xs)

let slice lst start range = take range (drop start lst)

let total = Atomic.make 0

let add var n = Atomic.set var (Atomic.get var + n)

let number_domains = try int_of_string Sys.argv.(1) with _ -> 4

let rec spawn i lst start incr =
    if i = 0 then [] else
    begin
    Printf.printf "%d %d \n" start (start + incr);
    Domain.spawn (fun _ -> (add total (sum (slice lst start (start + incr))))) ::(spawn (i-1) lst (start + incr) incr)
    end

(*Generate List of n random integers*)
let rec gen n =
  if n = 0 then [] else (Random.int 100) :: (gen (n-1))

let _ = begin
  let lst = gen 100 in
  let domains = spawn number_domains lst 0 ((List.length lst) / number_domains) in
  List.iter Domain.join domains;
  Printf.printf "Original = %d\n" (sum lst);
  Printf.printf "sum = %d\n" (Atomic.get total)
end
