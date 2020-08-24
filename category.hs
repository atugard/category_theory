{-# LANGUAGE DeriveFunctor #-}
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
--maybeToEither :: Maybe a -> Either () a
--eitherToMaybe :: Either () a -> Maybe a               
--
--maybeToEither a  =
--    case a of
--      Nothing -> Left ()
--      Just a -> Right a
--
--eitherToMaybe a =
--    case a of
--      Left () -> Nothing
--      Right a -> Just a
--
--                
--data Shape = Circle Float | Rect Float Float
--
--area :: Shape -> Float
--area (Circle r) = pi * r * r
--area (Rect d h) = d * h

--These two give that Either a a is isomorphic to (Bool, a),
--Or that a + a is isomorphic to 2 x a, where we see 2 as Bool.
--eitherToPair :: Either a a -> (Bool, a)
--pairToEither :: (Bool, a) -> Either a a
--
--eitherToPair a = 
--    case a of
--      Left a -> (False, a)
--      Right a -> (True, a) 
--                
--pairToEither (b,a) =
--    case b of
--      False -> Left a
--      True -> Right a
      
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
--data List a = Nil | Cons a (List a) -- Cons :: a -> List a -> List a, so Cons is a bifunctor. Nil is a 0-ary functor.
--fmap :: (a -> b) -> (List a -> List b)

--We have the following implementation of fmap:        
--Instance Functor List where
--    fmap _ Nil = Nil
--    (fmap f) Cons x t = Cons (f x) ((fmap f) t)


--Reader functor
--Next we consider something of the form \hom(a,-), which we can define by giving the binary operator -> one argument,
--hom a = r -> a
--In this case we have
--fmap :: (a -> b) -> (r -> a) -> (r -> b)
--Which can be implemented as follows, g: r->a, f: a->b =>
--instance Functor ((->) r) where
--    fmap f g = f . g
--We could also just write
--instance Functor ((->) r) where
--    fmap = (.)

--Also, we have the functor Const c -, where Const c a = Const c. It's fmap is of type:
--fmap :: (a -> b) -> const c a -> const c b
--With the following implementation:
--instance Functor (const c) where
--    fmap _ (Const x) = Const x


-----------------------------------------------------------------------
----------------------------Bifunctor----------------------------------
data Either a b = Left a | Right b
instance (Show a, Show b) => Show (Main.Either a b) where
  show (Main.Left a) = "Left " ++ show a                        
  show (Main.Right b) = "Right " ++ show b                        

data Const a b = Const a
instance Functor (Const c) where
    fmap _ (Const v) = Const v
instance Show a => Show (Const a b) where
    show (Const a) = "Const " ++ show a


data Identity a = Identity a
instance Show a => Show (Identity a) where
    show (Identity a) = "Identity " ++ show a

class Bifunctor f where
    bimap :: (a -> c) -> (b -> d) -> f a b -> f c d
    bimap g h = first g . second h
    first :: (a -> c) -> f a b -> f c b 
    first g = bimap g id
    second :: (b -> d) -> f a b -> f a d
    second h = bimap id h

instance Bifunctor (,) where
    bimap f g (x, y) = (f x, g y)
instance Bifunctor Main.Either where --coproduct
    bimap f _ (Main.Left x) = Main.Left (f x)
    bimap _ g (Main.Right y) = Main.Right (g y)

newtype BiComp bf fu gu a b = BiComp (bf (fu a) (gu b)) --we lift bf . (fu, gu) by first lifting a by fu, b by gu, and then (fu a), (gu b) by bf.
instance (Bifunctor bf, Functor fu, Functor gu) =>
    Bifunctor (BiComp bf fu gu) where
        bimap f1 f2 (BiComp x) = BiComp ((bimap (fmap f1) (fmap f2)) x)

   
             


