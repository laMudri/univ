module lambdaPi where

open import Data.Nat
open import Data.Bool
open import Data.Maybe
open import Data.Product
open import Relation.Nullary
open import Relation.Binary.PropositionalEquality
open import Data.Empty
open import Data.Fin

data Term : ℕ → Set
data TypedTerm : (n : ℕ) → Term n → Term n → Set

data Term where
  u : ∀{n} → ℕ → Term n
  nat : ∀{n} → Term n
  Πs : ∀{n} → Term n → Term (suc n) → Term n
  ℕs : ∀{n} → ℕ → Term n
  var : ∀{n} → Fin n → Term n
  λs : ∀{n} → Term (suc n) → Term n

infixr 0 _$s_

apply : ∀{n m} → Fin (suc n) → Term (suc n) → Term m → Term n
apply v (u x) b = u x
apply v nat b = nat
apply v (Πs σ τ) b = Πs (apply v σ b) (apply (suc v) τ b)
apply v (ℕs x) b = ℕs x
apply v (var zero) b = {!!}
apply v (var (suc x)) b = {!!}
apply v (λs a) b = {!!}

_$s_ : ∀{n} → Term (suc n) → Term n → Term n
_$s_ = apply zero

data TypedTerm where
  ut : ∀{n} → (l : ℕ) → TypedTerm n (u l) (u (suc l))
  usuc : ∀{n l s} → TypedTerm n s (u l) → TypedTerm n s (u (suc l))
  ℕt : ∀{n} (x : ℕ) → TypedTerm n (ℕs x) nat
  --λt : ∀{n s σ τ} → TypedTerm (suc n) s  → TypedTerm n (λs s) (Πs σ τ)
