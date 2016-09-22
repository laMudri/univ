module Main where

import Data.Char
import System.Environment

shift :: String -> Int -> String
shift t n = map (charShift n) t
  where
  charShift :: Int -> Char -> Char
  charShift n c
    | 'A' <= c && c <= 'Z' = chr ((ord c - ord 'A' + n) `mod` 26 + ord 'A')
    | otherwise = c

main = do
  cipherText <- concat <$> getArgs
  mapM_ (putStrLn . shift cipherText) [0 .. 25]
