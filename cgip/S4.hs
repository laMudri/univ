module Main where

-- Using JuicyPixels
import Codec.Picture.Types
import Codec.Picture.Png

import Data.Maybe (mapMaybe)

type Point = (Double, Double, Double)
type Vector = (Double, Double, Double)

infixl 6 >+<, >-<
infixr 7 ><, >.<, *<
(>+<), (>-<), (><) :: Vector -> Vector -> Point
(px,py,pz) >+< (qx,qy,qz) = (px + qx, py + qy, pz + qz)
(px,py,pz) >-< (qx,qy,qz) = (px - qx, py - qy, pz - qz)
(px,py,pz) >< (qx,qy,qz) = (py*qz - pz*qy, pz*qx - px*qz, px*qy - py*qx)

(>.<) :: Vector -> Vector -> Double
(px,py,pz) >.< (qx,qy,qz) = px * qx + py * qy + pz * qz

(*<) :: Double -> Vector -> Vector
l *< (x,y,z) = (l * x, l * y, l * z)

sqNorm, norm :: Vector -> Double
sqNorm x = x >.< x
norm = sqrt . sqNorm

normalize :: Vector -> Vector
normalize x = (1 / norm x) *< x

type Colour = (Double, Double, Double)

black, white, red :: Colour
black = (0,0,0)
white = (1,1,1)
red = (1,0,0)

sumColours :: [Colour] -> Colour
sumColours = foldr (#+#) (0,0,0)

infixl 6 #+#
infixr 7 *#, #*#
(*#) :: Double -> Colour -> Colour
l *# (r,g,b) = (l * r, l * g, l * b)

(#+#), (#*#) :: Colour -> Colour -> Colour
(xr,xg,xb) #+# (yr,yg,yb) = (xr + yr, xg + yg, xb + yb)
(xr,xg,xb) #*# (yr,yg,yb) = (xr * yr, xg * yg, xb * yb)

colourToPixel :: Colour -> PixelRGB8
colourToPixel (r,g,b) = PixelRGB8 (f r) (f g) (f b)
  where
    f :: Double -> Pixel8
    f x = fromInteger (round (255 * x))

data Shape = Sphere Double Point deriving (Show)
data Object = Object { shape :: Shape
                     , ambient :: Colour  -- k_a
                     , diffuse :: Colour  -- k_d
                     , specular :: Colour -- k_s
                     , smoothness :: Int  -- n
                     } deriving (Show)
data Ray = Ray { origin :: Point, direction :: Vector } deriving (Show)
data Light = Light { point :: Point, intensity :: Colour } deriving (Show)
data Camera = Camera { centreRay :: Ray, up :: Vector } deriving (Show)
data Scene = Scene { camera :: Camera
                   , objects :: [Object]
                   , lights :: [Light]
                   , background :: Colour
                   , ambiance :: Colour  -- I_a
                   } deriving (Show)

scene :: Scene
scene =
  let range = [0] in
  Scene { camera = Camera { centreRay = Ray { origin = (0,-3,0)
                                            , direction = (0,1,0)
                                            }
                          , up = (0,0,1)
                          }
        , objects = [ Object { shape = Sphere 1 (0,0,0)
                             , ambient = (1 / 6) *# red
                             , diffuse = (1 / 2) *# red
                             , specular = (1 / 3) *# white
                             , smoothness = 24
                             }
                    | x <- range, y <- range, z <- range
                    ]
        , lights = [Light { point = (6,-6,3), intensity = white }]
        , background = black
        , ambiance = white
        }

data Intersection = Intersection { distance :: Double
                                 , normal :: Vector
                                 , intersectionPoint :: Point
                                 , surfaceAmbient :: Colour
                                 , surfaceDiffuse :: Colour
                                 , surfaceSpecular :: Colour
                                 , surfaceSmoothness :: Int
                                 } deriving (Eq, Ord, Show)

onlyOrCombine :: (a -> a -> a) -> Maybe a -> Maybe a -> Maybe a
onlyOrCombine f Nothing y = y
onlyOrCombine f x Nothing = x
onlyOrCombine f (Just x) (Just y) = Just (f x y)

justIf :: (a -> Bool) -> a -> Maybe a
justIf p x | p x = Just x
           | otherwise = Nothing

intersect :: Ray -> Object -> Maybe Intersection
intersect Ray { origin = o, direction = d }
          Object { shape = Sphere r p
                 , ambient = ka
                 , diffuse = kd
                 , specular = ks
                 , smoothness = s
                 } =
  let p' = p >-< o in
  let a = sqNorm d
      b = negate 2 * (d >.< p')
      c = sqNorm p' - r * r in
  let desc = b * b - 4 * a * c in
  let s1 = justIf (0 <) $ (negate b + sqrt desc) / (2 * a)
      s2 = justIf (0 <) $ (negate b - sqrt desc) / (2 * a) in do
    distance <- onlyOrCombine min s1 s2
    let point = (distance *< d)
    if desc < 0
       then Nothing
       else Just $ Intersection { distance = distance
                                , normal = (1 / r) *< (point >-< p')
                                , intersectionPoint = point >+< o
                                , surfaceAmbient = ka
                                , surfaceDiffuse = kd
                                , surfaceSpecular = ks
                                , surfaceSmoothness = s
                                }

nearestIntersection :: [Object] -> Ray -> Maybe Intersection
nearestIntersection os r =
  case mapMaybe (intersect r) os of
       [] -> Nothing
       is -> Just (minimum is)

lightStats :: Point -> Light -> (Colour, Vector)
lightStats o Light { point = p, intensity = i } = (i, normalize (p >-< o))

trace :: Scene -> Ray -> PixelRGB8
trace scene r =
  colourToPixel $ case nearestIntersection (objects scene) r of
    Nothing -> background scene
    Just Intersection { normal = n
                      , intersectionPoint = p
                      , surfaceAmbient = ka
                      , surfaceDiffuse = kd
                      , surfaceSpecular = ks
                      , surfaceSmoothness = s
                      } ->
      let v = (0, 0, 0) >-< direction r in
      let activeLights = [ l | l <- lights scene, (point l >-< p) >.< n > 0 ] in
      let ils = map (lightStats p) activeLights in
      -- illumination, direction to light, direction of perfect reflection
      let ilrs = map (\(i, l) -> (i, l, (2 * (l >.< n)) *< n >-< l)) ils in
      let ambient = ambiance scene #*# ka
          diffuse =
            sumColours (map (\(i, l, r) -> (l >.< n) *# i #*# kd) ilrs)
          specular =
            sumColours (map (\(i, l, r) -> (r >.< v) ^ s *# i #*# ks) ilrs)
      in
      ambient #+# diffuse #+# specular

drawScene :: Int -> Int -> Scene -> Image PixelRGB8
drawScene halfW halfH s =
  -- The camera can see 45 deg of width to either side. It makes things simpler.
  let adjustedRange h =
       map (\n -> 1 / 2 + fromIntegral n) [negate h .. pred h] in
  let halfWd = fromIntegral halfW in
  let screenOffsets = [ (x / halfWd, y / halfWd)
                      | x <- adjustedRange halfW, y <- adjustedRange halfH
                      ] in
  let d = direction (centreRay (camera scene)) in
  let u = up (camera scene) in
  let screenPlane x y = d >+< x *< (u >< d) >+< y *< u in
  let rays = [ Ray { origin = origin (centreRay (camera scene))
                   , direction = normalize (screenPlane x y) }
             | (x, y) <- screenOffsets
             ] in
  let pixels = map (trace s) rays in
  snd (generateFoldImage f pixels (2 * halfW) (2 * halfH))
  where
    f :: [PixelRGB8] -> Int -> Int -> ([PixelRGB8], PixelRGB8)
    f [] _ _ = ([], PixelRGB8 255 255 255) -- Let's hope it doesn't get to this
    f (c : cs) _ _ = (cs, c)

main :: IO ()
main = do
  let (halfW, halfH) = (250, 250)
  writePng "S4.png" (drawScene halfW halfH scene)
