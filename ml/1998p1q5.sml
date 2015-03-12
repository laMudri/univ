(* a *)
fun odds [] = []
  | odds [x] = [x]
  | odds (x::y::xs) = x :: odds xs;

(* b *)
datatype 'a lazyList = LNil | LCons of 'a * (unit -> 'a lazyList);
fun oddsl LNil = LNil
  | oddsl (LCons (x,xf)) =
        case xf () of
            LNil => LCons (x,fn () => LNil)
          | LCons (_,yf) => LCons (x,fn () => oddsl (yf ()));

(* c *)
datatype 'a mutableList = MNil | MCons of 'a * 'a mutableList ref;
fun oddsm MNil = ()
  | oddsm (MCons (x,xr)) =
        case !xr of
            MNil => xr := MNil
          | MCons (y,yr) => (oddsm (!yr); xr := !yr);
