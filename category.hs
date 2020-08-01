--1. Category: The Essence of Composition
--1.1 Arrows as Functions
--f :: A -> B -- :: means has the type of
--g :: B -> C
--g.f


--1.2 Properties of Composition

--1. Composition is associative:

--f :: A -> B
--g :: B -> C
--h :: C -> D

--the following is pseudo-haskell, as equality is not defined for functions
--h . (g . f) == (h . g) . f == h . g . f  

--2. For every object A in a category C there exists a morphism i_A: A -> A:

--id :: a -> a declaration, names of concrete type is capitalized, names of type variables are lower case, in this case we defined a polymorphic function that takes an object of any type to itself.
--id x = x definition
--f . id == id . f == f

--1.3 Composition is the Essence of Programming

--1.4 Challenges

--First 3 exercises, look in identity.rkt file.

--4. Is the world-wide web a category in any sense? Are links morphisms?

--  We can consider websites as objects, morphisms as links, and see if that holds.
--  i.First, for any link, you can refresh the page, so for any object, there is a link which points to itself.
--  ii.If there is a link between a site to another, and from that other to still another, then there is a link from the first to the third...
--  From ii. we get that the world-wide web is not a category, since links are not morphisms.

--5. Is facebook a category, with people as objects and friendships as morphisms?

-- No. If I am someones friend, and that other friend is someone elses friend, then I am not necessarily that third persons friend. Also, I'm never my own friend on facebook.

--6. When is a directed graph a category? 

--Let us say that for a directed graph G = {V , E}, and for v_1, v_2 in G, that v_1 v_2 are edge related e, and let us write v_1 e v_2, if there exists (v_1, v_2) in E. It is sufficient for the edge relation to be reflexive and transitive. If it is reflexive then for every v in V vev, i.e. (v, v) isin E, but that just represents the identity morphism. If it is transitive then we have v_1ev_2, v_2ev_3 => v_1ev_3, i.e. we have that diagrams commute, as required. Associativity also follows from transitivity of edge relation, as (f_AB . f_BC) . f_CD = f_AC . f_CD = f_AD = f_AB . (f_BD) = f_AB . (f_BC . f_BD). 



