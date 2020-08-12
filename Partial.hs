module Partial (Partial, (>=>), ret, safe_root, safe_reciprocal, safe_root_reciprocal) where

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

                    
