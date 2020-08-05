(require "mutable.rkt")

(define (memoize f)
  (lambda x
    (let ((table null))
      (if (contains? x table)
          (get-val x table) 
          (let ((ans (apply f x)))
            (set! table (cons ans table))
            ans)))))
