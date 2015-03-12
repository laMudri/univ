(* 2005-1-6 *)
datatype 'a tree' = Twig of 'a
                  | Br of 'a * 'a tree' * 'a tree';
exception NotFound;

(* a *)
fun find_path p (Twig x) = if p x then [x] else raise NotFound
  | find_path p (Br (x,l,r)) =
        let
            val p' = p o (fn k => x + k)
        in
            x :: find_path p' l handle NotFound =>
            x :: find_path p' r
        end;

(* b *)
fun all_paths p (Twig x) = if p x then [[x]] else []
  | all_paths p (Br (x,l,r)) =
        let
            val p' = p o (fn k => x + k)
        in
            foldr op@ [] (map (map (fn xs => x :: xs) o all_paths p') [l,r])
        end;

(* c *)
datatype 'a stream = Nil | Cons of 'a * (unit -> 'a stream);

fun appendq (Nil,yq) = yq
  | appendq (Cons (x,xf),yq) = Cons (x,fn () => appendq (xf (),yq));
fun mapq _ Nil = Nil
  | mapq f (Cons (x,xf)) = Cons (f x,fn () => mapq f (xf ()));

fun all_pathsq p (Twig x) : int list stream = if p x then Cons ([x],fn () => Nil) else Nil
  | all_pathsq p (Br (x,l,r)) =
        let
            val p' = p o (fn k => x + k)
        in
            mapq (fn xs => x :: xs) (appendq (all_pathsq p' l,all_pathsq p' r))
        end;

(* 2005-1-5 *)
(* b *)
fun med (x,y,z) =
    if x < y then
        if y < z then y
        else if x < z then z
        else x
    else (* y < x *)
        if z < y then y
        else if z < x then z
        else x;

(* c *)
fun nthRest (0,x::xs) = (x,xs)
  | nthRest (n,_::xs) = nthRest (n - 1,xs);
fun split3 (_,[]) = ([],[],[])
  | split3 (x,y::ys) =
    let
        val (s,e,l) = split3 (x,ys)
    in
        if y = x then (s,y::e,l)
        else if y < x then (y::s,e,l)
        else (s,e,y::l)
    end;

fun qs [] = []
  | qs [x] = [x]
  | qs (allxs as x::xs) =
        let
            val l = length xs
            val (mid,rest) = nthRest (l div 2,allxs)
            val pivot = med (x,mid,List.last rest)
            val (smaller,equal,larger) = split3 (pivot,allxs)
        in
            qs smaller @ equal @ qs larger
        end;

(* 2004-1-6 *)
(* a *)
datatype 'a tree = Leaf | Node of 'a tree * 'a * 'a tree;
exception InsufficientPrecedingElements;

fun foldl _ acc [] = acc
  | foldl f acc (x::xs) = foldl f (f (acc,x)) xs;
(* Space: O(1)
   Time: O(n) *)

fun snd (_,y) = y;

fun updateArray (Node (l,_,r),1,y) = Node (l,y,r)
  | updateArray (Leaf,1,y) = Node (Leaf,y,Leaf)
  | updateArray (Node (l,x,r),i,y) =
        if i mod 2 = 0
            then Node (updateArray (l,i div 2,y),x,r)
            else Node (l,x,updateArray (r,i div 2,y))
  | updateArray (Leaf,i,y) = raise InsufficientPrecedingElements
(* Space: O(ln n)
   Time: O(ln n) *)

fun createArray xs = snd (foldl (fn ((i,t),x) => (i + 1,updateArray (t,i,x))) (1,Leaf) xs);
(* Space: O(n * ln n)
   Time: O(n * ln n) *)

fun indexArray (1,Node (_,x,_)) = x
  | indexArray (i,Node (l,_,r)) =
        if i mod 2 = 0
            then indexArray (i div 2,l)
            else indexArray (i div 2,r)
(* Space: O(1)
   Time: O(ln n) *)

(* b *)
(* a : int -> int *)
fun update a n v i = if i = n then v else a i
(* Update has space & time complexity O(1).
   After n updates, space & time complexity of access will be O(n). *)
