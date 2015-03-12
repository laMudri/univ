(* 2 *)
fun nfold (f,0) x = x
  | nfold (f,n) x = nfold (f,n - 1) (f x);

(* definitions *)
datatype 'a stream = Cons of 'a * (unit -> 'a stream);
fun from n = Cons (n,fn () => from (n + 1))
fun mapq f (Cons (x,xf)) = Cons (f x,fn () => mapq f (xf ()))
fun get (0,_) = []
  | get (n,Cons (x,xf)) = x :: get (n - 1,xf ());

(* 3 *)
fun nth (Cons (x,_),1) = x
  | nth (Cons (_,xf),n) = nth (xf (),n - 1);

(* 4 *)
val squares = mapq (fn x => x * x) (from 1);

(* 5 *)
fun map2 f (Cons (x,xf)) (Cons (y,yf)) = Cons (f x y,fn () => map2 f (xf ()) (yf ()));

nfold (fn x => nfold (nfold (s,4),x) 0,3) 1;
