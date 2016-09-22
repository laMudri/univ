(* General set type *)

signature EQ = sig
  type t
  val eq : t -> t -> bool
end

functor Set (Eq : EQ) = struct
  type t = Eq.t list

  val empty = []

  fun insert x [] = [x]
    | insert x (y :: ys) = if Eq.eq x y then x :: ys else y :: insert x ys

  fun delete x [] = []
    | delete x (y :: ys) = if Eq.eq x y then ys else y :: delete x ys
end

(* Specific set of integers *)

structure IntEq : EQ = struct
  type t = int
  fun eq x y = x = y
end

structure IntSet = Set(IntEq)

(* test *)

val x = IntSet.empty
val x' = IntSet.insert 3 x
val x'' = IntSet.insert 4 x'
val x''' = IntSet.delete 3 x''
