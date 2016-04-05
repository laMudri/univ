\documentclass{article}

\usepackage[top=1in, bottom=1in, left=1in, right=1in]{geometry}
\usepackage{enumitem}
\usepackage{mathpartir,amsmath}
%\usepackage{bussproofs}

\usepackage{textgreek}
\usepackage{agda}

\DeclareUnicodeCharacter{8988}{\ensuremath{\ulcorner}}
\DeclareUnicodeCharacter{8989}{\ensuremath{\urcorner}}
\DeclareUnicodeCharacter{8803}{\ensuremath{\overline{\equiv}}}
\DeclareUnicodeCharacter{9001}{\ensuremath{\langle}}
\DeclareUnicodeCharacter{9002}{\ensuremath{\rangle}}
\DeclareUnicodeCharacter{8759}{\ensuremath{\mathbin{::}}}

\newcommand{\defeq}{\overset{\mathit{def}}{=}}

\begin{document}
\title{Semantics of Programming Languages -- supervision 2}
\author{James Wood}
\maketitle

\begin{enumerate}
\item
  \begin{code}
module s2 where

open import Data.Nat
open import Data.Bool
open import Data.Product
open import Data.Plus hiding (Plus) renaming (Plus′ to Plus)
open import Data.Sum
open import Relation.Binary.PropositionalEquality
open import Data.Empty

infix 5 _+s_
infix 4 ifs_then_else_
infix 3 _↝_

-- Convention: no suffix
data Ast : Set where
  nats : ℕ → Ast
  bools : Bool → Ast
  _+s_ : Ast → Ast → Ast
  ifs_then_else_ : Ast → Ast → Ast → Ast

-- Convention: uses the letter ‘r’ (for “reduction”)
data _↝_ : Ast → Ast → Set where
  E-IF : ∀{e0 e0' e1 e2} →
         e0 ↝ e0' → ifs e0 then e1 else e2 ↝ ifs e0' then e1 else e2
  E-IF-TRUE : ∀{e1 e2} → ifs bools true then e1 else e2 ↝ e1
  E-IF-FALSE : ∀{e1 e2} → ifs bools false then e1 else e2 ↝ e2
  E-PLUS : ∀{n0 n1} → nats n0 +s nats n1 ↝ nats (n0 + n1)
  E-PLUS-LEFT : ∀{e0 e0' e1} → e0 ↝ e0' → e0 +s e1 ↝ e0' +s e1
  E-PLUS-RIGHT : ∀{n0 e1 e1'} → e1 ↝ e1' → nats n0 +s e1 ↝ nats n0 +s e1'
  \end{code}

  \begin{enumerate}[label=\roman*]
  \item
    We analyse cases on the possible reduction steps, directed implicitly by the form of the initial expression.

    \begin{code}
deterministic : ∀{e e' e''} → e ↝ e' → e ↝ e'' → e' ≡ e''
deterministic E-PLUS E-PLUS = refl
deterministic E-PLUS (E-PLUS-LEFT ())
deterministic E-PLUS (E-PLUS-RIGHT ())
deterministic (E-PLUS-LEFT ()) E-PLUS
deterministic (E-PLUS-LEFT x') (E-PLUS-LEFT x'')
  rewrite deterministic x' x'' = refl
deterministic (E-PLUS-LEFT ()) (E-PLUS-RIGHT x'')
deterministic (E-PLUS-RIGHT ()) E-PLUS
deterministic (E-PLUS-RIGHT x') (E-PLUS-LEFT ())
deterministic (E-PLUS-RIGHT x') (E-PLUS-RIGHT x'')
  rewrite deterministic x' x'' = refl
deterministic (E-IF x') (E-IF x'')
  rewrite deterministic x' x'' = refl
deterministic (E-IF ()) E-IF-TRUE
deterministic (E-IF ()) E-IF-FALSE
deterministic E-IF-TRUE (E-IF ())
deterministic E-IF-TRUE E-IF-TRUE = refl
deterministic E-IF-FALSE (E-IF ())
deterministic E-IF-FALSE E-IF-FALSE = refl
    \end{code}

  \item
    We need to introduce rules about typing and values.

    \begin{code}
-- Convention: called “τ”
data Type : Set where
  nat bool : Type

data Val : Ast → Set where
  natv : {x : ℕ} → Val (nats x)
  boolv : {x : Bool} → Val (bools x)

-- Convention: names suffixed by ‘t’
infix 3 ⊢_∈_
data ⊢_∈_ : Ast → Type → Set where
  T-NAT : (x : ℕ) → ⊢ nats x ∈ nat
  T-BOOL : (x : Bool) → ⊢ bools x ∈ bool
  T-PLUS : ∀{e0 e1} → ⊢ e0 ∈ nat → ⊢ e1 ∈ nat → ⊢ e0 +s e1 ∈ nat
  T-IF : ∀{e0 e1 e2 τ} →
         ⊢ e0 ∈ bool → ⊢ e1 ∈ τ → ⊢ e2 ∈ τ → ⊢ ifs e0 then e1 else e2 ∈ τ

progress : ∀{e τ} → ⊢ e ∈ τ → Val e ⊎ Σ Ast (λ e' → e ↝ e')
    \end{code}

    Syntactic values are values already, so needn't make progress.

    \begin{code}
progress (T-NAT x) = inj₁ natv
progress (T-BOOL x) = inj₁ boolv
    \end{code}

    Consider the expression $e_0 + e_1$. First, suppose that $e_0$ is a value. If $e_1$ is a value, we use E-PLUS to reduce the whole expression. Otherwise, we use E-PLUS-RIGHT, reducing $e_1$. On the other hand, if $e_0$ reduces, we use E-PLUS-LEFT.

    \begin{code}
progress (T-PLUS at bt) with progress at
progress (T-PLUS () bt) | inj₁ boolv
progress (T-PLUS (T-NAT x) bt) | inj₁ natv with progress bt
progress (T-PLUS (T-NAT x) ()) | inj₁ natv | inj₁ boolv
progress (T-PLUS (T-NAT x) (T-NAT y)) | inj₁ natv | inj₁ natv =
  inj₂ (nats (x + y) , E-PLUS)
progress (T-PLUS (T-NAT x) bt) | inj₁ natv | inj₂ (b , r) =
  inj₂ (nats x +s b , E-PLUS-RIGHT r)
progress (T-PLUS at bt) | inj₂ (a' , r) = inj₂ (a' +s _ , E-PLUS-LEFT r)
    \end{code}

    $\mathbf{if}$ expressions are similar. In $\mathbf{if}~e_0~\mathbf{then}~e_1~\mathbf{else}~e_2$, if $e_0$ is a value, the expression reduces to whichever of $e_1$ and $e_2$. Otherwise, $e_0$ reduces, and we can use E-IF.

    \begin{code}
progress (T-IF ct tt ft) with progress ct
progress (T-IF () tt ft) | inj₁ natv
progress (T-IF (T-BOOL true) tt ft) | inj₁ boolv = inj₂ (_ , E-IF-TRUE)
progress (T-IF (T-BOOL false) tt ft) | inj₁ boolv = inj₂ (_ , E-IF-FALSE)
progress (T-IF ct tt ft) | inj₂ (c' , r) =
  inj₂ ((ifs c' then _ else _) , E-IF r)
    \end{code}

  \item
    This is a mechanical checking of possible reductions.

    \begin{code}
preserve : ∀{e τ e'} → ⊢ e ∈ τ → e ↝ e' → ⊢ e' ∈ τ
preserve (T-PLUS (T-NAT x) (T-NAT y)) E-PLUS = T-NAT (x + y)
preserve (T-PLUS at bt) (E-PLUS-LEFT r) = T-PLUS (preserve at r) bt
preserve (T-PLUS at bt) (E-PLUS-RIGHT r) = T-PLUS at (preserve bt r)
preserve (T-IF ct tt ft) (E-IF r) = T-IF (preserve ct r) tt ft
preserve (T-IF ct tt ft) E-IF-TRUE = tt
preserve (T-IF ct tt ft) E-IF-FALSE = ft
    \end{code}

  \item
    Tying it all together:

    \begin{code}
-- 〈e〉 reduces in 1 or more steps to 〈e'〉
infix 3 _↝⁺_
_↝⁺_ : Ast → Ast → Set
_↝⁺_ = Plus _↝_

safe : ∀{e τ e'} → ⊢ e ∈ τ → e ↝⁺ e' → Val e' ⊎ Σ Ast (λ e'' → e' ↝ e'')
safe et [ r ] = progress (preserve et r)
safe et (r ∷ rs) = safe (preserve et r) rs
    \end{code}

  \item
    The proofs here show that, for this language, any well-typed term is either a value or reduces to some other term. Hence, there can be no occasions where the program is stuck at run time. We haven't proven that all expressions will reduce to a value, though it should be provable for this language. It won't be provable for other languages, including all Turing-equivalent languages, which necessarily have programs which won't terminate.
  \end{enumerate}

\item
  \begin{enumerate}
  \item $i$ and $l$.
  \item
    \begin{enumerate}
    \item Replace $x$ with $y$ using $\alpha$-equivalence.
    \item $\beta$-reduce $(\lambda f.f~x)~g$ to $g~x$, then replace $x$ with $y$ in the main expression by $\alpha$-equivalence.
    \item Replace $f$ by $\lambda y.f~y$ by $\eta$-conversion.
    \item The expressions have different free variables, so can't be converted into one another.
    \end{enumerate}
  \item
    First, define the unary $\mathrm{Val}$ relation as follows:
    \begin{mathpar}
      \inferrule*[right=V-VAR]
      { }
      {\mathrm{Val}~x}
      \and
      \inferrule*[right=V-$\Lambda$]
      {\mathrm{Val}~e}
      {\mathrm{Val}~(\lambda x.e)}
      \and
      \inferrule*[right=V-VAR-APP]
      {\mathrm{Val}~e}
      {\mathrm{Val}~(x~e)}
      \and
      \inferrule*[right=V-APP-APP]
      {\mathrm{Val}~(e_0~e_1) \\ \mathrm{Val}~e_2}
      {\mathrm{Val}~(e_0~e_1~e_2)}
    \end{mathpar}
    Then, the evaluation rules:
    \begin{mathpar}
      \inferrule*[right=E-APP-L]
      {e_0 \longrightarrow e_0'}
      {e_0~e_1 \longrightarrow e_0'~e_1}
      \and
      \inferrule*[right=E-APP-R]
      { \mathrm{Val}~e_0 \\ e_1 \longrightarrow e_1'}
      {e_0~e_1 \longrightarrow e_0~e_1'}
      \and
      \inferrule*[right=E-APP]
      {\mathrm{Val}~e_1}
      {(\lambda x.e_0)~e_1 \longrightarrow [x \mapsto e_1]e_0}
    \end{mathpar}
  \item
    \begin{mathpar}
      \inferrule*[right=E-APP$'$]
      {\mathrm{Val}~e_0}
      {(\lambda x.e_0)~e_1 \longrightarrow [x \mapsto e_1]e_0}
      \and
      \inferrule*[right=E-$\Lambda$]
      {e_0 \longrightarrow e_0'}
      {\lambda x.e_0 \longrightarrow \lambda x.e_0'}
    \end{mathpar}
  \item
    \begin{enumerate}
      \item $PLUS \defeq \lambda m.\lambda n.\lambda f.\lambda x.m~f~(n~f~x)$
      \item $MUL \defeq \lambda m.\lambda n.\lambda f.m~(n~f)$
    \end{enumerate}
  \item
    $SUCC \defeq \lambda n.\lambda f.\lambda x.f~(n~f~x)$

    $INFTY \defeq Y~SUCC~ZERO$
  \item
    We can consider the term $(\lambda x.x~x)~(\lambda x.x~x)$. This is a $\beta$-redex, and reduces to $(\lambda x.x~x)~(\lambda x.x~x)$. By induction, this term will never reduce to a term not containing a $\beta$-redex, so the untyped $\lambda$-calculus is not strongly normalizing.
  \end{enumerate}

\item
  \begin{enumerate}
  \item
    \begin{mathpar}
      \inferrule*[right=T-VAR]
      { }
      {\Gamma \vdash x : \tau}
      \and
      \inferrule*[right=T-$\Lambda$]
      {\Gamma, x : \sigma \vdash e : \tau}
      {\lambda x.e : \sigma \to \tau}
      \and
      \inferrule*[right=E-APP]
      {\Gamma \vdash e_0 : \sigma \to \tau \\ \Gamma \vdash e_1 : \sigma}
      {\Gamma \vdash e_0~e_1 : \tau}
    \end{mathpar}
  \item
    Again, define a $\mathrm{Val}$ relation:
    \begin{mathpar}
      \inferrule*[right=V-VAR]
      { }
      {\mathrm{Val}~x}
      \and
      \inferrule*[right=V-$\Lambda$]
      {\mathrm{Val}~e}
      {\mathrm{Val}~(\lambda x:\tau.e)}
      \and
      \inferrule*[right=V-VAR-APP]
      {\mathrm{Val}~e}
      {\mathrm{Val}~(x~e)}
      \and
      \inferrule*[right=V-APP-APP]
      {\mathrm{Val}~(e_0~e_1) \\ \mathrm{Val}~e_2}
      {\mathrm{Val}~(e_0~e_1~e_2)}
    \end{mathpar}
    Then, the evaluation rules:
    \begin{mathpar}
      \inferrule*[right=E-APP-L]
      {e_0 \longrightarrow e_0'}
      {e_0~e_1 \longrightarrow e_0'~e_1}
      \and
      \inferrule*[right=E-APP-R]
      {\mathrm{Val}~e_0 \\ e_1 \longrightarrow e_1'}
      {e_0~e_1 \longrightarrow e_0~e_1'}
      \and
      \inferrule*[right=E-APP]
      {\mathrm{Val}~e_1}
      {(\lambda x:\tau.e_0)~e_1 \longrightarrow [x \mapsto e_1]e_0}
    \end{mathpar}
  \item
    The $Y$-combinator, as defined previously, can't be typed in $\lambda_\to$. Typing it would require typing $x~x$ (in some context), which is impossible because the type of a function must be strictly greater (structurally) than the type of its argument.
  \item To start with, annotate each variable with a type variable. Then, use the typing rules for application and abstraction to unify some of these variables with each other, and introduce function types. If there are free type variables at the end, assign them to arbitrary distinct elements of $B$.
  \end{enumerate}
\end{enumerate}
\end{document}
