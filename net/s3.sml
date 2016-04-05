type ('k, 'v) map = ('k * 'v) list;
datatype ('k, 'v) prefixTree =
  MkPt of 'v option * ('k, (('k, 'v) prefixTree)) map;

fun mapLookup _ [] = NONE
  | mapLookup l ((k, v) :: kvs) = if l = k then SOME v else mapLookup l kvs

fun prefixMatch [] (MkPt (v, m)) = v  (*A complete match*)
  | prefixMatch (k :: ks) (MkPt (v, m)) =
    case mapLookup k m of
        NONE => v  (*Reached a dead end; return what we found*)
      | SOME t =>
          (*Try to find a longer matching prefix*)
          case prefixMatch ks t of
              NONE => v  (*None found; return what's here*)
            | v' => v'  (*Longer prefix found; return the value there*)
