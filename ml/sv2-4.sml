(* 1997-1-5 *)
datatype square = Empty | O | X;
type position = int -> square;
datatype tree = Tree of position * tree list;
datatype 'a maybe = Nothing | Just of 'a;

fun mapMaybe _ [] = []
  | mapMaybe f (x::xs) =
        case f x of
            Nothing => mapMaybe f xs
          | Just y => y :: mapMaybe f xs;

fun curry f x y = f (x,y);
infixr 0 $
fun f $ x = f x;

fun any p [] = false
  | any p (x::xs) = p x orelse any p xs;
fun all p [] = true
  | all p (x::xs) = p x andalso all p xs;

fun empty _ = Empty
fun otherPlayer O = X
  | otherPlayer X = O
  | otherPlayer Empty = Empty;

val positions = [1,2,3,4,5,6,7,8,9];
val lines = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]];
fun hasWon player board = any (all (fn i => board i = player)) lines;
fun isFull board = not $ any (fn i => board i = Empty) $ positions;

fun play player board pos =
    if board pos = Empty
        then Just (fn i => if i = pos then player else board i)
        else Nothing;

fun mktreeFrom player board =
    let
        val other = otherPlayer player
    in
        curry Tree board (if hasWon other board orelse isFull board
            then []
            else map (mktreeFrom other) $ mapMaybe (play player board) positions)
    end;
fun mktree () = mktreeFrom O empty;

fun sum [] = 0
  | sum (x::xs) = x + sum xs;

fun Owins (Tree (board,[])) = if hasWon O board then 1 else 0
  | Owins (Tree (_,ts)) = sum $ map Owins ts;
(* 131184; Wikipedia agrees *)
