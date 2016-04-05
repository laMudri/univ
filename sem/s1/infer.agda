module infer where

open import Data.Nat
open import Data.Bool
open import Data.Maybe
open import Data.Product
open import Relation.Nullary
open import Relation.Binary.PropositionalEquality
open import Data.Empty

infix 5 _+s_
infix 4 ifs_then_else_
infix 5 _+t_
infix 4 ift_then_else_

data Type : Set where
  nat bool : Type

data Ast : Set where
  nats : ℕ → Ast
  bools : Bool → Ast
  _+s_ : Ast → Ast → Ast
  ifs_then_else_ : Ast → Ast → Ast → Ast

data TypedAst : Ast → Type → Set where
  natt : (n : ℕ) → TypedAst (nats n) nat
  boolt : (b : Bool) → TypedAst (bools b) bool
  _+t_ : ∀{a b} → TypedAst a nat → TypedAst b nat → TypedAst (a +s b) nat
  ift_then_else_ : ∀{cond tr fl t} → TypedAst cond bool → TypedAst tr t →
                   TypedAst fl t → TypedAst (ifs cond then tr else fl) t

infix 4 _≡?_

_≡?_ : (s t : Type) → Dec (s ≡ t)
_≡?_ nat nat = yes refl
_≡?_ nat bool = no (λ ())
_≡?_ bool nat = no (λ ())
_≡?_ bool bool = yes refl

unique : ∀{a t t'} → TypedAst a t → TypedAst a t' → t ≡ t'
unique (natt n) (natt .n) = refl
unique (boolt b) (boolt .b) = refl
unique (p +t p₁) (p' +t p'') = refl
unique (ift condp then trp else flp)
       (ift condp' then trp' else flp') = unique flp flp'

check : (a : Ast) → (t : Type) → Dec (TypedAst a t)
check (nats x) t with t ≡? nat
check (nats x) .nat | yes refl = yes (natt x)
check (nats x) t | no ¬nat = no (λ p → ¬nat (unique p (natt x)))
check (bools x) t with t ≡? bool
check (bools x) .bool | yes refl = yes (boolt x)
check (bools x) t | no ¬bool = no (λ p → ¬bool (unique p (boolt x)))
check (a +s b) nat with check a nat
check (a +s b) nat | yes ap with check b nat
check (a +s b) nat | yes ap | yes bp = yes (ap +t bp)
check (a +s b) nat | yes ap | no ¬bp = no (λ { (_ +t bp) → ¬bp bp })
check (a +s b) nat | no ¬ap = no (λ { (ap +t _) → ¬ap ap })
check (a +s b) bool = no (λ ())
check (ifs cond then tr else fl) t with check cond bool
check (ifs cond then tr else fl) t | yes condp with check tr t
check (ifs cond then tr else fl) t | yes condp | yes trp with check fl t
check (ifs cond then tr else fl) t | yes condp | yes trp | yes flp =
  yes (ift condp then trp else flp)
check (ifs cond then tr else fl) t | yes condp | yes trp | no ¬flp =
  no (λ { (ift _ then _ else flp) → ¬flp flp })
check (ifs cond then tr else fl) t | yes condp | no ¬trp =
  no (λ { (ift _ then trp else _) → ¬trp trp })
check (ifs cond then tr else fl) t | no ¬condp =
  no (λ { (ift condp then _ else _) → ¬condp condp })

infer : (a : Ast) → Dec (Σ Type (TypedAst a))

infer (nats x) = yes (nat , natt x)
infer (bools x) = yes (bool , boolt x)

infer (a +s b) with infer a
infer (a +s b) | yes (at , ap) with at ≡? nat
infer (a +s b) | yes (.nat , ap) | yes refl with infer b
infer (a +s b) | yes (.nat , ap) | yes refl | yes (bt , bp) with bt ≡? nat
infer (a +s b) | yes (.nat , ap) | yes refl | yes (.nat , bp) | yes refl =
  yes (nat , ap +t bp)  -- Success!
infer (a +s b) | yes (.nat , ap) | yes refl | yes (bt , bp) | no ¬bnat =
  no (λ { (.nat , _ +t bp') → ¬bnat (unique bp bp') })
infer (a +s b) | yes (.nat , ap) | yes refl | no ¬bi =
  no (λ { (.nat , _ +t bp) → ¬bi (nat , bp) })
infer (a +s b) | yes (at , ap) | no ¬anat =
  no (λ { (.nat , ap' +t _) → ¬anat (unique ap ap') })
infer (a +s b) | no ¬ai = no (λ { (.nat , ap +t _) → ¬ai (nat , ap) })

infer (ifs cond then tr else fl) with infer cond
infer (ifs cond then tr else fl) | yes (condt , condp) with condt ≡? bool
infer (ifs cond then tr else fl) | yes (.bool , condp) | yes refl with infer tr
infer (ifs cond then tr else fl)
  | yes (.bool , condp) | yes refl | yes tri with infer fl
infer (ifs cond then tr else fl)
  | yes (.bool , condp) | yes refl
  | yes (trt , trp) | yes (flt , flp) with trt ≡? flt
infer (ifs cond then tr else fl)
  | yes (.bool , condp) | yes refl
  | yes (trt , trp) | yes (.trt , flp) | yes refl =
  yes (trt , (ift condp then trp else flp))  -- Success!
infer (ifs cond then tr else fl)
  | yes (.bool , condp) | yes refl | yes (trt , trp) | yes (flt , flp) | no ¬p =
  no (λ { (t , (ift _ then trp' else flp')) →
          ¬p (trans (unique trp trp') (unique flp' flp)) })
infer (ifs cond then tr else fl)
  | yes (.bool , condp) | yes refl | yes tri | no ¬fli =
  no (λ { (t , (ift _ then _ else flp)) → ¬fli (t , flp) })
infer (ifs cond then tr else fl) | yes (.bool , condp) | yes refl | no ¬tri =
  no (λ { (t , (ift _ then trp else _)) → ¬tri (t , trp) })
infer (ifs cond then tr else fl) | yes (condt , condp) | no ¬condbool =
  no (λ { (t , (ift condp' then _ else _)) → ¬condbool (unique condp condp') })
infer (ifs _ then _ else _) | no ¬condi =
  no (λ { (_ , (ift condp then _ else _)) → ¬condi (bool , condp) })

get-inference : ∀{a} → Dec (Σ Type (TypedAst a)) → Maybe Type
get-inference (yes (t , _)) = just t
get-inference (no _) = nothing

test : let a = ifs bools true then nats 4 +s nats 8 else nats 23 in
       get-inference (infer a) ≡ just nat
test = refl
