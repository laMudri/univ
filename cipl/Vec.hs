{-# LANGUAGE GADTs #-}
{-# LANGUAGE EmptyDataDecls #-}

module Vec where

data Z
data S n

data Vec a n where
  Nil :: Vec a Z
  Cons :: a -> Vec a n -> Vec a (S n)

zipV :: Vec a n -> Vec b n -> Vec (a , b) n
zipV Nil Nil = Nil
zipV (Cons x xs) (Cons y ys) = Cons (x , y) (zipV xs ys)
