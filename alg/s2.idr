module s1
  data Counted a = MkCounted Nat a
  instance Functor Counted where
    map m (MkCounted k x) = MkCounted k (m x)
  instance Applicative Counted where
    pure x = MkCounted 0 x
    (<$>) (MkCounted k x) (MkCounted j y) = MkCounted (S k + j) (x y)

  fibC : Nat -> Counted Nat
  fibC Z         = [| 1 |]
  fibC (S Z)     = [| 1 |]
  fibC (S (S k)) = [| fibC k + fibC (S k) |]

  fibN : Nat -> Nat
  fibN Z = 0
  fibN (S Z) = 0
  fibN (S (S k)) = S (fibN k) + S (fibN (S k))

  fibC' : Nat -> Nat
  fibC' = f (0,0)
    where
      f : (Nat,Nat) -> Nat -> Nat
      f (a,b) Z = a
      f (a,b) (S k) = f (b,2 + a + b) k

  fibC'' : Nat -> Integer
  fibC'' = f (0,0)
    where
      f : (Integer,Integer) -> Nat -> Integer
      f (a,b) Z = a
      f (a,b) (S k) = f (b,2 + a + b) k
