datatype 'a stream = Cons of ('a * (unit -> 'a stream))

fun smap f (Cons (x, xf)) = Cons (f x, fn () => smap f (xf ()))

fun swap 0 = 1
  | swap _ = 0

val flip =
    let fun f x n =
        if x < n then
            f (2 * x) n
        else
            x - n
    in f 1
    end

fun thueMorse 0 = 0
  | thueMorse n = swap (thueMorse (flip n))

fun take 0 _ = []
  | take n (Cons (x, xf)) = x :: take (n - 1) (xf ())

fun iterate f x = Cons (x, fn () => iterate f (f x))

fun succ x = 1 + x
val nats = iterate succ 0
