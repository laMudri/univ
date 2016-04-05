datatype 'a llist = Nil | Cons of (unit -> 'a * 'a llist)

fun interleave Nil ys = ys
  | interleave (Cons f) ys =
    let val (x, xs) = f ()
    in Cons (fn () => (x, interleave ys xs))
    end

fun lmap f Nil = Nil
  | lmap f (Cons g) =
    let val (x, xs) = g ()
    in Cons (fn () => (f x, lmap f xs))
    end

fun iterates f x = Cons (fn () => (x, iterates f (f x)))

fun append Nil ys = ys
 |  append (Cons xf) ys =
    let val (x, xs) = xf ()
    in Cons (fn () => (x, append xs ys))
    end

fun iterates2 (f, g) (x, y) =
    let fun prod xu yu (Cons xf) (Cons yf) =
            let val (x, xs) = xf ()
                val (y, ys) = yf ()
                val corner = (x, y)
                val fside = lmap (fn z => (x, z)) yu
                val gside = lmap (fn z => (z, y)) xu
                val xu' = Cons (fn () => (x, xu))
                val yu' = Cons (fn () => (y, yu))
            in Cons (fn () => (corner, append (interleave fside gside)
                                              (prod xu' yu' xs ys)))
            end
    in prod Nil Nil (iterates f x) (iterates g y)
    end

fun take 0 xs = []
  | take _ Nil = []
  | take n (Cons xf) =
    let val (x, xs) = xf ()
    in x :: take (n - 1) xs
    end
