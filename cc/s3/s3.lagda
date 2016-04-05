\documentclass{article}

\usepackage[margin=1in]{geometry}
\usepackage{enumitem}
\usepackage{amsmath}

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

module s3 where

open import Data.Nat

data Expr : Set where
  Val : ℕ → Expr
  Plus : ℕ → ℕ → Expr

eval : Expr → ℕ
eval x = {!!}

    \end{code}
\end{enumerate}

\end{document}
