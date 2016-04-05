datatype 'v prop = VAR of 'v | LIT of bool
                 | AND of 'v prop * 'v prop
                 | OR of 'v prop * 'v prop
                 | NOT of 'v prop

type 'v interpretation = 'v -> bool

(* holds : 'v interpretation -> 'v prop -> bool *)
fun holds i (VAR v) = i v
  | holds i (LIT b) = b
  | holds i (AND (p, q)) = holds i p andalso holds i q
  | holds i (OR (p, q)) = holds i p orelse holds i q
  | holds i (NOT p) = not (holds i p)

(* negate : 'v prop -> 'v prop *)
fun negate (VAR v) = NOT (VAR v)
  | negate (LIT b) = LIT (not b)
  | negate (AND (p, q)) = OR (negate p, negate q)
  | negate (OR (p, q)) = AND (negate p, negate q)
  | negate (NOT p) = nnf p
(* nnf : 'v prop -> 'v prop *)
and nnf (NOT p) = negate p
  | nnf (AND (p, q)) = AND (nnf p, nnf q)
  | nnf (OR (p, q)) = OR (nnf p, nnf q)
  | nnf x = x
