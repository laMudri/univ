(* definitions *)
datatype 'a stream = Cons of 'a * (unit -> 'a stream);
fun from n = Cons (n,fn () => from (n + 1))
fun mapq f (Cons (x,xf)) = Cons (f x,fn () => mapq f (xf ()))
fun map2 f (Cons (x,xf)) (Cons (y,yf)) = Cons (f x y,fn () => map2 f (xf ()) (yf ()));
fun get (0,_) = []
  | get (n,Cons (x,xf)) = x :: get (n - 1,xf ());
fun tail (Cons (_,xf)) = xf ();
fun plus x y = x + y;
fun nth (Cons (x,_),1) = x
  | nth (Cons (_,xf),n) = nth (xf (),n - 1);

(* 1 *)
fun fibs () = Cons (1,fn () => Cons (1,fn () => map2 plus (fibs ()) (tail (fibs ()))));

(* 2 *)
fun merge (xs as Cons (x,xf),ys as Cons (y,yf)) =
    if x = y then
        Cons (x,fn () => merge (xf (),yf ()))
    else if x < y then
        Cons (x,fn () => merge (xf (),ys))
    else
        Cons (y,fn () => merge (xs,yf ()));

(* 3 *)
fun mult x y = x * y;
fun multiplesOf2And3 () = Cons (1,fn () => merge (mapq (mult 2) (multiplesOf2And3 ()),
                                                  mapq (mult 3) (multiplesOf2And3 ())));
(* 4 *)
fun hammingNumbers () =
    Cons (1,fn () => merge (merge (mapq (mult 2) (hammingNumbers ()),
                                   mapq (mult 3) (hammingNumbers ())),
                            mapq (mult 5) (hammingNumbers ())));
