;;1. Implement the identity function
(define (id a)
  a)

;;2. Implement the composition function
(define (comp g f)
  (lambda (x) (g (f x))))

;;3. Write a program that tries to test that your composition function respects identity
(define (test f)
  (define (local_test x) 
    (eq? ((comp f id) x) ((comp id f) x)))
  (define (iter x)
    (cond ((< x 100)
           (if (eq? (local_test x) true)
               (iter (+ x 1))
               false))
          (else true)))
  (iter 0))
(define (square x)
  (* x x))


        
;;Reader functor
;;Next we consider something of the form \hom(a,-), which we can define by giving the binary operator -> one argument,
;;hom a = r -> a
;;In this case we have
;;fmap :: (a -> b) -> (r -> a) -> (r -> b)
;;Which can be implemented as follows, g: r->a, f: a->b =>
;;instance Functor ((->) r) where
;;    fmap f g = f . g
;;We could also just write
;;instance Functor ((->) r) where
;;    fmap = (.)
(: reader (All (a) (-> r a)))
(define (->r a)
  (-> r a))
(: reader-map (All (a b) (-> (-> a b) (-> (-> r a) (-> r b)))))
(define (->r a->b)
  (-> (-> r a) (-> r b)))
