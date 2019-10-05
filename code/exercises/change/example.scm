(import (rnrs))

(define (change amount coins)
  (cond ((< amount 0) (error 'change "can't make change" amount coins))
        (else
         (letrec ((amounts (make-eq-hashtable))
                  (queue '(0))
                  (get-coins (lambda (total)
                               (hashtable-ref amounts total #f)))
                  (record-coins! (lambda (total change)
                                   (hashtable-set! amounts total change))))
           (record-coins! 0 '())
           (let bfs ()
             (when (null? queue)
               (error 'change "can't make change" amount coins))
             (let* ((curr (car queue))
                    (path (get-coins curr)))
               (cond ((eq? curr amount) path)
                     (else
                      (let ((additions '()))
                        (for-each (lambda (coin)
                                    (let ((next (+ coin curr)))
                                      (unless (or (> next amount) (get-coins next))
                                        (set! additions (cons next additions))
                                        (record-coins! next (cons coin path)))))
                                  coins)
                        (set! queue `(,@(cdr queue) ,@additions))
                        (bfs))))))))))
