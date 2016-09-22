{-# LANGUAGE ExistentialQuantification #-}

class Expr a where
  eval :: a -> Int

data Lit = MkLit Int
instance Expr Lit where
  eval (MkLit x) = x

data BinOp a b = MkPlus a b | MkSub a b
instance (Expr a, Expr b) => Expr (BinOp a b) where
  eval (MkPlus x y) = eval x + eval y
  eval (MkSub x y) = eval x - eval y

data AnyExpr = forall a. Expr a => MkExpr a
evalAnyExpr (MkExpr e) = eval e

main :: IO ()
main = do
  let expressions =
       [ MkExpr $ MkPlus (MkSub (MkLit 3) (MkLit 4)) (MkLit 7)
       , MkExpr $ MkLit 5
       ]
  mapM_ (putStrLn . show . evalAnyExpr) expressions
