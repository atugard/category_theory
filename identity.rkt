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


        
