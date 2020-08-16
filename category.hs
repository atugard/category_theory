--------------------------------------------------------------------
----------------------------Partial----------------------------

import Data.Char(toUpper)

type Partial a = (Bool, a) -- a Functor on Hask. 

(>=>) :: (a -> Partial b) -> (b -> Partial c) -> (a -> Partial c)  --composition, as defined for Kleisli Category
m1 >=> m2 = \x ->
            let (b1, v1) = m1 x
            in
              if b1 == False
              then (False, undefined)
              else
                  let (b2, v2) = m2 v1 --v2 will be undefined by assumption if b2 is false. 
                  in
                    (b1 && b2, v2)

ret :: a -> Partial a
ret x = (True, x)

safe_root :: Double -> Partial Double
safe_root x = if (x >= 0) then (True, sqrt(x)) else (False, undefined)
          
safe_reciprocal :: Double -> Partial Double
safe_reciprocal x = if x /= 0 then (True, 1/x) else (False, undefined)

safe_root_reciprocal :: Double -> Partial Double
safe_root_reciprocal = safe_reciprocal >=> safe_root                    



--------------------------------------------------------------------
----------------------------Isomorphisms----------------------------
--These two give that Maybe a is isomorphic to Either () a
maybeToEither :: Maybe a -> Either () a
eitherToMaybe :: Either () a -> Maybe a               

maybeToEither a  =
    case a of
      Nothing -> Left ()
      Just a -> Right a

eitherToMaybe a =
    case a of
      Left () -> Nothing
      Right a -> Just a

                
data Shape = Circle Float | Rect Float Float

area :: Shape -> Float
area (Circle r) = pi * r * r
area (Rect d h) = d * h

--These two give that Either a a is isomorphic to (Bool, a),
--Or that a + a is isomorphic to 2 x a, where we see 2 as Bool.
eitherToPair :: Either a a -> (Bool, a)
pairToEither :: (Bool, a) -> Either a a

eitherToPair Either a = 
    case a of
      Left a -> (False, a)
      Right a -> (True, a) 
                
pairToEither (b,a) =
    case b of
      False -> Left a
      True -> Right a
      
--------------------------------------------------------------------
