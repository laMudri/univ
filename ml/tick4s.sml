type color = int * int * int;
type xy = int * int;
type image = color array array;

fun drawPixel im c (x,y) = Array.update (Array.sub (im,y),x,c);

infixr 0 $
fun f $ x = f x;
fun add x y = x + y;
fun subtr x y = y - x;
fun id x = x;

fun drawLine im c (x0,y0) (x1,y1) =
    let val dx = Int.abs (x1 - x0)
        val dy = Int.abs (y1 - y0)
        val sx = if x0 < x1 then 1 else ~1
        val sy = if y0 < y1 then 1 else ~1
        fun f err (x,y) = (
            drawPixel im c (x,y);
            if x = x1 andalso y = y1
                then ()
                else
                    let val e2 = 2 * err
                        val yp = e2 > ~dy
                        val xp = e2 < dx
                        val err' = (if yp then subtr dy else id) $
                                   (if xp then add dx else id) err
                        val x' = (if yp then add sx else id) x
                        val y' = (if xp then add sy else id) y
                    in
                        f err' (x',y')
                    end)
    in
        f (dx - dy) (x0,y0)
    end;
