module s1den where

open import Data.Nat
open import Data.Bool
open import Data.Product
open import Data.Sum
open import Relation.Nullary

infix 4 _+s_
infix 4 _+t_
infix 0 ifs_then_else_
infix 0 ift_then_else_

data Ast : Set where
  nats : ℕ → Ast
  bools : Bool → Ast
  inls : Ast → Ast
  inrs : Ast → Ast
  _+s_ : Ast → Ast → Ast
  ifs_then_else_ : Ast → Ast → Ast → Ast

data Type : Set where
  nat bool : Type
  sum : Type → Type → Type

data TypedAst : Ast → Type → Set where
  natt : (n : ℕ) → TypedAst (nats n) nat
  boolt : (b : Bool) → TypedAst (bools b) bool
  inlt : ∀{a at bt} (p : TypedAst a at) → TypedAst (inls a) (sum at bt)
  inrt : ∀{b at bt} (p : TypedAst b bt) → TypedAst (inrs b) (sum at bt)
  _+t_ : ∀{a b} → TypedAst a nat → TypedAst b nat → TypedAst (a +s b) nat
  ift_then_else_ :
    ∀{cond tr fl trt flt} → TypedAst cond bool → TypedAst tr trt →
    TypedAst fl flt → TypedAst (ifs cond then tr else fl) (sum trt flt)

data Val : ∀{a t} → TypedAst a t → Set where
  natv : (n : ℕ) → Val (natt n)
  boolv : (b : Bool) → Val (boolt b)
  inlv : ∀{a at bt} {p : TypedAst a at} (v : Val p) → Val (inlt {a} {at} {bt} p)
  inrv : ∀{b at bt} {p : TypedAst b bt} (v : Val p) → Val (inrt {b} {at} {bt} p)

Val? : ∀{a t} (p : TypedAst a t) → Dec (Val p)
Val? (natt n) = yes (natv n)
Val? (boolt b) = yes (boolv b)
Val? (inlt p) with Val? p
Val? (inlt p) | yes val = yes (inlv val)
Val? (inlt p) | no ¬val = no (λ { (inlv val) → ¬val val })
Val? (inrt p) with Val? p
Val? (inrt p) | yes val = yes (inrv val)
Val? (inrt p) | no ¬val = no (λ { (inrv val) → ¬val val })
Val? (ap +t bp) = no (λ ())
Val? (ift condp then trp else flp) = no (λ ())

interp : ∀{a t} → TypedAst a t → Σ Ast (λ a' → Σ (TypedAst a' t) Val)
interp (natt n) = nats n , natt n , natv n
interp (boolt b) = bools b , boolt b , boolv b
interp {inls a} {sum at bt} (inlt p) =
  let a' , p' , v' = interp p in inls a' , inlt p' , inlv v'
interp {inrs b} {sum at bt} (inrt p) =
  let b' , p' , v' = interp p in inrs b' , inrt p' , inrv v'
interp (ap +t bp) with interp ap , interp bp
interp (ap +t bp) | (._ , ._ , natv x) , (._ , ._ , natv y) =
  nats (x + y) , natt (x + y) , natv (x + y)
interp (ift condp then trp else flp) with interp condp
interp (ift condp then trp else flp) | ._ , ._ , boolv true with interp trp
... | tr , trp' , trv = inls tr , inlt trp' , inlv trv
interp (ift condp then trp else flp) | ._ , ._ , boolv false with interp flp
... | fl , flp' , flv = inrs fl , inrt flp' , inrv flv
