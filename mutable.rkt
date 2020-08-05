
(define (mlist . args)
  (if (null? args)
      null
      (mcons (car args) (mlist (cdr args)))))
(define (list->mlist l)
  (apply mlist l))
(define (mlist->list ml)
  (if (null? ml)
      null
      (cons (mcar ml) (mlist->list (mcdr ml)))))

(define (table? t)
  (if (pair? t)
      (eq? (car t) '*table*)
      false))
(define (record->key record)
  (car record))
(define (record->val record)
  (cdr record))
(define (table->record key t)
  (cond [(null? t) false]
        [(equal? x (caar t)) (car t)]
        [else (contains? x (cdr t))]))
(define (get-val? x t)
  (if (contains? x t)
         


