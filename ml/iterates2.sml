datatype 'a llist = Nil | Cons of 'a * (unit -> 'a llist)

fun interleave Nil ys = ys
  | interleave (Cons (x, xf)) ys = Cons (x, fn () => interleave ys (xf ()))

fun lmap f Nil = Nil
  | lmap f (Cons (x, xf)) = Cons (f x, fn () => lmap f (xf ()))

fun iterates f x = Cons (x, fn () => iterates f (f x))

fun append Nil ys = ys
 |  append (Cons (x, xf)) ys = Cons (x, fn () => append (xf ()) ys)

fun iterates2 (f, g) (x, y) =
    let fun prod xu yu (Cons (x, xf)) (Cons (y, yf)) =
            let val corner = (x, y)
                val fside = lmap (fn z => (x, z)) yu
                val gside = lmap (fn z => (z, y)) xu
                val xu' = Cons (x, fn () => xu)
                val yu' = Cons (y, fn () => yu)
            in Cons (corner, fn () => append (interleave fside gside)
                                             (prod xu' yu' (xf ()) (yf ())))
            end
    in prod Nil Nil (iterates f x) (iterates g y)
    end

fun take 0 xs = []
  | take _ Nil = []
  | take n (Cons (x, xf)) = x :: take (n - 1) (xf ())
