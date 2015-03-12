(* b *)
datatype 'a lazyList = Nil | Cons of 'a * (unit -> 'a lazyList);

fun lappend (Nil,ys) = ys
  | lappend (Cons (x,xf),ys) = Cons (x,fn () => lappend (xf(),ys));
(* If the first list is infinite, the result will be the same as the first list. *)

(* c *)
fun interleave (Nil,ys) = ys
  | interleave (xs,Nil) = xs
  | interleave (Cons (x,xf),Cons (y,yf)) = Cons (x,fn () =>
                                           Cons (y,fn () =>
                                           interleave (xf (),yf ())));

(* d *)
fun lmap _ Nil = Nil
  | lmap f (Cons (x,xf)) = Cons (f x,fn () => lmap f (xf ()));

val allBinLists =
    let
        fun f () = Cons ([],fn () =>
                         interleave (lmap (fn xs => 0 :: xs) (f ()),
                                     lmap (fn xs => 1 :: xs) (f ())))
    in
        f ()
    end;

(* e *)
fun lfilter _ Nil = Nil
  | lfilter p (Cons (x,xf)) =
        if p x
            then Cons (x,fn () => lfilter p (xf ()))
            else lfilter p (xf ());

val allBinPalindromeLists = lfilter (fn xs => xs = rev xs) allBinLists;
