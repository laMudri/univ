(*datatype tr = N of int * (unit -> tr) * (unit -> tr);

(* a *)
fun ndeep 0 (N (x,lf,rf)) = [x]
  | ndeep n (N (x,lf,rf)) = ndeep (n - 1) (lf ()) @ ndeep (n - 1) (rf ());
(* Reaching the desired level takes O n time. Then, appending the various lists
   together takes O (2^n) time, giving a total time of order O (2^n). *)

exception Result of int;
fun find t =
    let
        fun findIn [] = () (* not found on this level *)
          | findIn (x :: xs) =
            if x > 100
            then raise Result x (* found; raise exception *)
            else findIn xs; (* try next item *)
        fun findAtLevel n t = (
            findIn (ndeep n t); (* try all values at given level *)
            findAtLevel (1 + n) t (* then, try next level *)
        );
    in
        findAtLevel 0 t (* start search at level 0 *)
    end
    handle Result x => x; (* catch the exception, and return the value *)*)

(* --- *)

datatype PRI = E | N of int * (unit -> PRI);
fun intfromto (i,j) =
  if i <= j
  then N (i,(fn () => intfromto (i + 1,j)))
  else E;

fun first (N (x,f)) = x;
fun rest (N (x,f)) = f ();

fun ins (x,E) = N (x,(fn () => E))
  | ins (x,N (y,f)) =
    if x <= y
    then N (x,(fn () => N (y,f)))
    else N (y,(fn () => ins (x,f ())));

print (Int.toString (first (rest (intfromto (20,1000000)))));

datatype 'a lazylist = Nil | Cons of 'a * (unit -> 'a lazylist);
fun addone Nil = Nil
  | addone (Cons (x,xf)) = Cons (x + 1,(fn () => addone (xf ())));

datatype 'a lazytree = Leaf
                     | Node of 'a * (unit -> 'a lazytree) *
                               (unit -> 'a lazytree);
val allIntTree =
  let
      fun f n () = Node (n,f (n - 1),f (n + 1));
  in
      f 0 ()
  end;

fun treeToList t =
    let
        fun f [] () = Nil
          | f (Leaf :: ts) () = f ts ()
          | f (Node (x,lf,rf) :: ts) () = Cons (x,f (ts @ [lf (),rf ()]))
    in
        f [t] ()
    end;

(* testing *)
fun lazyPrint 0 xs = ()
  | lazyPrint n Nil = ()
  | lazyPrint n (Cons (x,xf)) =
    (print (" " ^ Int.toString x); lazyPrint (n - 1) (xf ()));

lazyPrint 30 (treeToList allIntTree);
