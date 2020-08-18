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

eitherToPair a = 
    case a of
      Left a -> (False, a)
      Right a -> (True, a) 
                
pairToEither (b,a) =
    case b of
      False -> Left a
      True -> Right a
      
-----------------------------------------------------------------------
----------------------------Typeclasses--------------------------------
--typeclass defines a family of types that support a common interface
--class Eqq a where --a is of the class Eq if it supports (==)
--    (=*=) :: a -> a -> Bool
--an example, we define a 2D Point:
--data Point = Pt Float Float

--now we can define equality of points:
--instance Eqq Point where
--    (Pt x y) =*= (Pt x' y') = x == x' && y == y' --definition of Point equality in terms of Float equality.

--typeclass also defines a family of mappings of types (type constructors).
--class Functor f where
--    fmap :: (a -> b) -> f a -> f b
--Thus we have an fmap for each endofunctor. In the case of Maybe, we implement the following (weird names to avoid name conflict with Prelude defined Maybe
--instance Functor Maybee where
--    fmap _ Nothing = Nothing
--    fmap f (Just x) = Just (f x)

--List functor
data List a = Nil | Cons a (List a) -- Cons :: a -> List a -> List a, so Cons is a bifunctor. Nil is a 0-ary functor.
fmap :: (a -> b) -> (List a -> List b)

--We have the following implementation of fmap:        
--Instance Functor List where
--    fmap _ Nil = Nil
--    (fmap f) Cons x t = Cons (f x) ((fmap f) t)

--Next we consider something of the form \hom(a,-), which we can define by giving the binary operator -> one argument,
hom a = r -> a
--In this case we have
fmap :: (a -> b) -> (r -> a) -> (r -> b)
--Which can be implemented as follows, g: r->a, f: a->b =>
instance Functor ((->) r) where
    fmap f g = f . g
--We could also just write
instance Functor ((->) r) where
    fmap = (.)

--Also, we have the functor Const c -, where Const c a = Const c. It's fmap is of type:
fmap :: (a -> b) -> Const c a -> Const c b
--With the following implementation:
instance Functor (Const c) where
    fmap _ (Const x) = Const x


-----------------------------------------------------------------------
----------------------------Composition--------------------------------

maybeTail :: [a] -> Maybe [a] --This is a composition of functors, the built-in haskell list constructor functor, then Maybe.
maybeTail [] = Nothing        --Note: Cons is replaced by the infix : and Nil is replaced by [], so we get Cons 5 (Cons 6 Nil) = 5 : 6 : [] = [5, 6]
maybeTail (x:xs) = Just xs               

             


