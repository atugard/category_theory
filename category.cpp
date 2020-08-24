#define _USE_MATH_DEFINES
#include <cmath>
#include <cstdio>
#include <functional>
#include <iterator>
#include <iostream>
#include <vector>
using namespace std; 
//6.5 Challenges, exercise 2.
//Haskell implementation of shape.
//data Shape = Circle Float | Rect Float Float
//
//area :: Shape -> Float
//area (Circle r) = pi * r * r
//area (Rect d h) = d * h


class Shape {
public:
  virtual double getArea() = 0;
  virtual double circ() = 0;
};

class Rectangle: public Shape {
private:
  double width;
  double height;
public:
  Rectangle(double w, double h){
    width = w;
    height = h;
  };
  double getArea() {
    return (width * height);
  };
  double circ() {
    return (2 * width) + (2 * height);
  };
};
class Circle: public Shape{
private:
  double radius;
public:
  Circle(double r){
    radius = r;
  };

  double getArea() {
    return (M_PI * radius * radius);
  };
  double circ() {
    return (2 * M_PI * radius);
  };
};
//Either A B
template<typename A,typename B>
struct Either {
  enum { isLeft, isRight } tag;
  union { A left; B right; };
};

// Left: A -> Either A B
template<typename A, typename B>
Either<A,B> Left(A a){
  Either<A, B> e;
  e.tag = e.isLeft;
  e.left = a;
  return e;
};

// Right: B -> Either A B
template<typename A, typename B>
Either<A,B> Right(B b){
  Either<A, B> e;
  e.tag = e.isRight;
  e.right = b;
  return e;
};

int i(int n) {
  if (n < 0) return n;
  return n + 2;
};

Either<int, bool> _m(int n){
  if (n == 0)
    return Right<int, bool>(true);
  else if(n == 1)
    return Right<int, bool>(false);
  else if(n >= 2)
    return Left<int, bool>(n-2);
  else
    return Left<int, bool>(n);
};

      

int j(bool b) {
  return b ? 0: 1;
};

int m(Either<int, bool> const &e){
  if(e.tag == e.isLeft)
    return e.left;
  else
    return e.right ? 0: 1;
};

//implementation of optional, which is the cpp implementation of Haskell's Maybe.
template<class T>
class optional {
  bool _isValid; //the tag
  T _v;
public:
  optional() : _isValid(false) {}          //Nothing
  optional(T x) : _isValid(true), _v(x) {} //Just
  bool isValid() const { return _isValid; }
  T val() const { return _v; }
};

//curried
template<class A, class B>
function<optional<B>(optional<A>)> //lift from A -> B to optional A -> optional B
fmap(function<B(A)> f){
  return [f](optional<A> opt) {
    if (!opt.isValid())
      return optional<B>{ //Nothing
      };
    else
      return optional<B>{ //Just f(opt.val())
	f(opt.val())
      };
  };
}

//uncurried
//template<class A, class B>
//optional<B>
//fmap(function<B(A)> f, optional<A> opt){
//  if(!.opt.isValid()) //Nothing
//    return optional<B>{};
//  else                //Maybe
//    return optional<B>{ f(opt.val()) };
//}

//cpp implementation of Haskell Lisp functor:
template<class A, class B>
vector<B>
fmap(function<B(A)> f, vector<A> v) {
  vector<B> w;
  transform(begin(v), end(v), back_inserter(w), f); //transforms applies f from begin(v) to end(v), and uses back_inserter(w) to store the result in w.
  return w;
}

//cpp implementation of Const c a
template<class C, class A>
struct Const{
  Const(C v) : _v(v) {}
  C _v;
};

//cpp implementation of fmap for Const c a
template<class C, class A, class B>
Const<C, B>
fmap(function<B(A)> f, Const<C, A> c) {
  return Const<C,B>{c._v};
}

//Reader functor
//Next we consider something of the form \hom(a,-), which we can define by giving the binary operator -> one argument,
//hom a = r -> a
//In this case we have
//fmap :: (a -> b) -> (r -> a) -> (r -> b)
//Which can be implemented as follows, g: r->a, f: a->b =>
//instance Functor ((->) r) where
//    fmap f g = f . g
//We could also just write
//instance Functor ((->) r) where
//    fmap = (.)
template<class R, class A>
struct reader{
  reader(A a){
    function<A(R)> f(R r){ //if you give me a value of type a, i'll make a constant function that always returns that value.
      return a;
    }
  }
  reader(function<A(R)> f): _f(f){ //if you give me an implemented function, I'll save it.
  }

 function<A(R)> _f;
};

template<class R, class A, class B>
function<B(R)>
fmap(function<B(A)> f, function<A(R)> g){
  function<B(R)> fg(R r){
    return f(g(r));
  };
  return fg;
}



int main(){
  function<int(bool)> reader(5);
};
