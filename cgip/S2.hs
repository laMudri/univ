module S2 where

-- Using JuicyPixels
import Codec.Picture.Types
import Codec.Picture.Png

import Control.Applicative
import Control.Monad
import Control.Monad.Primitive
import Data.Bifunctor
import Data.Tuple

black, white :: PixelRGB8
black = PixelRGB8 0 0 0
white = PixelRGB8 255 255 255

type IPoint = (Int, Int)
type FPoint = (Double, Double)

-- 2-vector operations
-- ===================

dot :: FPoint -> FPoint -> Double
dot (ax, ay) (bx, by) = ax * bx + ay * by
sqNorm :: FPoint -> Double
sqNorm a = dot a a

infixl 6 >+<, >-<
infixr 7 *<
(>+<), (>-<) :: FPoint -> FPoint -> FPoint
(ax, ay) >+< (bx, by) = (ax + bx, ay + by)
(ax, ay) >-< (bx, by) = (ax - bx, ay - by)
(*<) :: Double -> FPoint -> FPoint
l *< (ax, ay) = (l * ax, l * ay)

sqDistanceFromLineSegment :: FPoint -> FPoint -> FPoint -> Double
sqDistanceFromLineSegment a b c =
  if dot (b >-< a) (c >-< a) < 0 then
    -- c is beyond the a end
    sqNorm (c >-< a)
  else if dot (a >-< b) (c >-< b) < 0 then
    -- c is beyond the b end
    sqNorm (c >-< b)
  else
    -- Proportion of distance between a and p of the perpendicular foot
    let s = dot (b >-< a) (c >-< a) / sqNorm (b >-< a) in
    -- Perpendicular foot
    let p = a >+< s *< (b >-< a) in
    sqNorm (c >-< p)

-- Circle
-- ======

-- Points of the first octant (E to NE)
plotOctant :: Int -> [IPoint]
plotOctant r = f (r, 0) (1 - r)
  where
    f :: IPoint -> Int -> [IPoint]
    f (x, y) d = (x, y) : if x < y then [] else
      let y' = y + 1 in
      let (x', d') = if d < 0
                        then (x, d + 2 * y + 3)
                        else (x - 1, d - 2 * x + 2 * y + 5) in
      f (x', y') d'

-- Plots same points as plotOctant,
-- but requires a sqrt calculation at each point. Not used.
plotOctantAlt :: Int -> [IPoint]
plotOctantAlt r = [ (round (sqrt (fromIntegral (r * r - y * y))), y)
                  | y <- [0 .. round (fromIntegral r * sqrt 2 / 2)] ]

-- Horizontal, vertical, and diagonal reflections of a point
reflectH, reflectV, reflectD :: IPoint -> IPoint
reflectH (x, y) = (negate x, y)
reflectV (x, y) = (x, negate y)
reflectD (x, y) = (y, x)

-- All combinations of the above reflections (8 combinations in total)
allReflections :: [IPoint -> IPoint]
allReflections =
  foldr (.) id <$> filterM (const [False, True]) [reflectH, reflectV, reflectD]

drawCircle :: (Pixel c, PrimMonad m) =>
  MutableImage (PrimState m) c -> IPoint -> Int -> c -> m ()
drawCircle mimg (x, y) r c =
  -- Origin-centred points for first octant
  let octant0 = plotOctant r in
  -- All origin-centred points
  let offsets = allReflections <*> octant0 in
  -- All correctly-centred points
  let points = bimap (x +) (y +) <$> offsets in
  mapM_ (\(x, y) -> writePixel mimg x y c) points

-- Line
-- ====

plotLineFirstOctant :: FPoint -> FPoint -> [IPoint]
plotLineFirstOctant (px, py) (qx, qy) =
  f (x0, y0) d0
  where
    a = qy - py
    b = px - qx
    c = qx * py - px * qy
    x0 = round px
    y0 = round ((0 - a * fromIntegral x0 - c) / b)
    x1 = round qx
    d0 = a * (fromIntegral x0 + 1) + b * (fromIntegral y0 + 1 / 2) + c

    f :: IPoint -> Double -> [IPoint]
    f (x, y) d = (x, y) : if x >= x1 then [] else
      let x' = x + 1 in
      let (y', d') = if d < 0
                        then (y, d + a)
                        else (y + 1, d + a + b) in
      f (x', y') d'

-- Get the orientation right for plotLineFirstOctant to draw
plotLine :: FPoint -> FPoint -> [IPoint]
plotLine = f
  [ (\r s -> fst r <= fst s, reflectH, first negate)
  , (\r s -> snd r <= snd s, reflectV, second negate)
  , (\(rx, ry) (sx, sy) -> sy - ry <= sx - rx, reflectD, swap)
  ]
  where
    f :: [(FPoint -> FPoint -> Bool, IPoint -> IPoint, FPoint -> FPoint)] ->
         FPoint -> FPoint -> [IPoint]
    -- All transformations done
    f [] p q = plotLineFirstOctant p q
    -- If the condition c holds, pass to the next stage.
    -- Otherwise, apply transformation t to the endpoints,
    -- pass to the next stage, then do correction transformation r to the line.
    f ((c, r, t) : crts) p q =
      if c p q then f crts p q else r <$> f crts (t p) (t q)

drawLine :: (Pixel c, PrimMonad m) =>
  MutableImage (PrimState m) c -> FPoint -> FPoint -> c -> m ()
drawLine mimg p q c =
  mapM_ (\(x, y) -> writePixel mimg x y c) (plotLine p q)

-- Bézier
-- ======

drawBezier :: (Pixel c, PrimMonad m) => MutableImage (PrimState m) c ->
  Double -> FPoint -> FPoint -> FPoint -> FPoint -> c -> m ()
drawBezier mimg t p0 p1 p2 p3 c = f p0 p1 p2 p3
  where
    sqT = t * t

    f p0 p1 p2 p3 =
      if all (\p -> sqDistanceFromLineSegment p0 p3 p < sqT) [p1, p2] then
        drawLine mimg p0 p3 c
      else do
        f p0 ((1 / 2) *< p0 >+< (1 / 2) *< p1)
          ((1 / 4) *< p0 >+< (1 / 2) *< p1 >+< (1 / 4) *< p2)
          ((1 / 8) *< p0 >+< (3 / 8) *< p1 >+< (3 / 8) *< p2 >+< (1 / 8) *< p3)
        f ((1 / 8) *< p0 >+< (3 / 8) *< p1 >+< (3 / 8) *< p2 >+< (1 / 8) *< p3)
          ((1 / 4) *< p1 >+< (1 / 2) *< p2 >+< (1 / 4) *< p3)
          ((1 / 2) *< p2 >+< (1 / 2) *< p3) p3

drawBezierI :: (Pixel c, PrimMonad m) => MutableImage (PrimState m) c ->
  Double -> IPoint -> IPoint -> IPoint -> IPoint -> c -> m ()
drawBezierI mimg t p0 p1 p2 p3 c =
  drawBezier mimg t (f p0) (f p1) (f p2) (f p3) c
  where
   f = bimap fromIntegral fromIntegral

-- Test
-- ====

main :: IO ()
main = do
  let (w, h) = (360, 270)
  mimg <- createMutableImage w h white
  drawCircle mimg (w `div` 2, h `div` 2) (h `div` 3) black
  drawBezierI mimg 0.33 (1, 1) (2 * w, 1) (negate w, h - 1) (w - 1, h - 1) black
  drawBezierI mimg 0.33
    (1, h `div` 2) (w `div` 4, h `div` 2)
    (w `div` 2, 3 * h `div` 4) (w `div` 2, h - 1) black
  drawBezierI mimg 0.33
    (w - 1, h `div` 2) (3 * w `div` 4, h `div` 2)
    (w `div` 2, h `div` 4) (w `div` 2, 1) black
  drawBezierI mimg 0.33
    (1, 1) (w - 1, h `div` 2) (1, h `div` 2) (w - 1, h - 1) black
  img <- freezeImage mimg
  writePng "S2.png" img
