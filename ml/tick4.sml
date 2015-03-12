type color = int * int * int;
type xy = int * int;
type image = color array array;

(* 1 *)
fun image (w,h) c = Array.tabulate (h,fn _ => Array.tabulate (w,fn _ => c));
fun size im = (Array.length (Array.sub (im,0)),Array.length im);
fun drawPixel im c (x,y) = Array.update (Array.sub (im,y),x,c);

(* 2 *)
fun format4 i = StringCvt.padLeft #" " 4 (Int.toString i);

fun toPPM im filename =
    let
        val oc = TextIO.openOut filename
        val (w,h) = size im
        fun appendLines (xs,ys) = xs ^ "\n" ^ ys
        val makeLine : color array -> string =
            Array.foldr (fn ((r,g,b),y) =>
                            format4 r ^ format4 g ^ format4 b ^ y) ""
    in
        TextIO.output (oc,"P3\n" ^ Int.toString w ^
                          " " ^ Int.toString h ^ "\n255\n");
        TextIO.output (oc,Array.foldr (fn (x,y) =>
                                          appendLines (makeLine x,y)) "" im);
        TextIO.closeOut oc
    end;

(* 3 *)
fun drawThing (w,h) (c0,c1) =
    Array.tabulate (h,fn i => Array.tabulate (w,fn j => if j mod 12 < 6 then
                                                            c0
                                                        else
                                                            c1));
