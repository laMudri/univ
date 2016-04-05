module Main where

gcd_cps :: Int -> Int -> (Int -> a) -> a
gcd_cps m n k
  | m == n = k m
  | m < n = gcd_cps m (n - m) k
  | otherwise = gcd_cps (m - n) n k
