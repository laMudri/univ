datatype A = Z | Cell of int ref * A ref * A ref;

fun mkrow 0 = Cell (ref 0,ref Z,ref Z)
  | mkrow n = Cell (ref 0,ref (mkrow (n - 1)),ref Z);

fun zip (Z,_) = Z
  | zip (xa,Z) = xa
  | zip (xa as Cell (xr,xrr,xur),ya as Cell (yr,yrr,yur)) = (
        xur := ya;
        xrr := zip (!xrr,!yrr);
        xa);

fun mkarr (0,n) = mkrow n
  | mkarr (m,n) = zip (mkrow n,mkarr (m - 1,n))

datatype dir = Right | Up;

fun inc_path_cells Z _ = ()
  | inc_path_cells (Cell (xr,_,_)) [] = xr := !xr + 1
  | inc_path_cells (Cell (xr,xrr,xur)) (d::ds) = (
        xr := !xr + 1;
        case d of
            Right => inc_path_cells (!xrr) ds
          | Up => inc_path_cells (!xur) ds);
