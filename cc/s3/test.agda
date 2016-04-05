module test where

open import Data.Empty
open import Data.Integer
open import Data.List
open import Data.Maybe
open import Data.Nat using (ℕ; zero; suc)
open import Relation.Binary.PropositionalEquality using (_≡_; _≢_; refl)

data Expr : Set where
  Val : ℤ → Expr
  Plus : Expr → Expr → Expr

eval              : Expr → ℤ
eval (Val n)      = n
eval (Plus e₀ e₁) = eval e₀ + eval e₁

data Instr : Set where
  ADD : Instr
  PUSH : (n : ℤ) → Instr

Program : Set
Program = List Instr

exec : Program → List ℤ → Maybe (List ℤ)
exec [] s = just s
exec (ADD ∷ p) [] = nothing
exec (ADD ∷ p) (x ∷ []) = nothing
exec (ADD ∷ p) (x ∷ y ∷ s) = exec p ((x + y) ∷ s)
exec (PUSH n ∷ p) s = exec p (n ∷ s)

comp : Expr → Program
comp (Val n) = [ PUSH n ]
comp (Plus e₀ e₁) = comp e₀ ++ comp e₁ ++ [ ADD ]

-- Proof

Exec : Program → List ℤ → ℤ → Set
Exec p s n = exec p s ≡ just [ n ]

--exec-compose :
--  ∀ {p₀ p₁ s m n} → Exec p₀ s m → Exec p₁ (m ∷ s) n → Exec (p₀ ++ p₁) s n
--exec-compose {[]} {[]} refl ()
--exec-compose {[]} {ADD ∷ p₁} refl y = {!!}
--exec-compose {[]} {PUSH n ∷ p₁} refl y = {!!}
--exec-compose {x ∷ p₀} x₁ y = {!!}

exec-compose : ∀ p q {s s'} → just s' ≡ exec p s → exec q s' ≡ exec (p ++ q) s
exec-compose [] _ refl = refl
exec-compose (ADD ∷ p) _ {s = []} ()
exec-compose (ADD ∷ p) _ {s = x ∷ []} ()
exec-compose (ADD ∷ p) q {s = m ∷ n ∷ s} eq =
  exec-compose p q eq
exec-compose {PUSH n ∷ p} {q} eq =
  exec-compose p q eq

-- just (eval e0 + eval e1) ≡ exec (p0 ++ p1) s →

program-not-empty : ∀ e → comp e ≢ []
program-not-empty (Val n) ()
program-not-empty (Plus e₀ e₁) p with comp e₀
program-not-empty (Plus e₀ e₁) p | [] with comp e₁
program-not-empty (Plus e₀ e₁) () | [] | []
program-not-empty (Plus e₀ e₁) () | [] | i ∷ is
program-not-empty (Plus e₀ e₁) () | i ∷ is

correct : ∀ e s → just (eval e ∷ s) ≡ exec (comp e) s
correct (Val n) s = refl
correct (Plus e₀ e₁) s with exec (comp e₀) s
correct (Plus e₀ e₁) s | just s' = {!!}
  --{!exec-compose {p = comp e₀} {q = comp e₁ ++ [ ADD ]} {s = s} {s' = s'} refl!}
correct (Plus e₀ e₁) s | nothing = {!!}
