(* James Wood    jdw74    Robinson*)

use "tick4.sml";

fun drawAll f im =
    let
        val (w,h) = size im
        fun g x y =
            if x = w then
                g 0 (y + 1)
            else if y = h then
                ()
            else (
                drawPixel im (f (x,y)) (x,y);
                g (x + 1) y
            )
    in
        g 0 0
    end;

(* Returns unit because it modifies the given image. *)

fun gradient (x,y) = (((x div 30) * 30) mod 256, 0, ((y div 30) * 30) mod 256);

fun gradImage () =
    let
        val im = image (640,480) (0,0,0)
    in
        drawAll gradient im;
        toPPM im "gradient.ppm"
    end;

fun mandelbrot maxIter (x,y) =
    let fun solve (a,b) c =
            if c = maxIter then
                1.0
            else
                if (a * a + b * b <= 4.0) then
                    solve (a * a - b * b + x,2.0 * a * b + y) (c+1)
                else
                    (real c)/(real maxIter)
    in
        solve (x,y) 0
    end;

fun chooseColour n =
    let
        val r = round (Math.cos n * 255.0)
        val g = round (Math.cos n * 255.0)
        val b = round (Math.sin n * 255.0)
    in
        (r,g,b)
    end;

fun rescale (w,h) (cx,cy,s) (x,y) =
    let
        val p = s * (real x / real w - 0.5) + cx
        val q = s * ~(real y / real h - 0.5) + cy
    in
        (p,q)
    end;

fun compute a =
    let
        val wh = (640,640)
        val maxIter = 240
        val im = image wh (0,0,0)
    in
        drawAll (chooseColour o mandelbrot maxIter o rescale wh a) im;
        toPPM im "mandelbrot.ppm"
    end;

(* Took about 2 hours *)
