---
title: "SICP_Lec_1a"
date: 2023-04-30T10:01:41+08:00
draft: false 
tags : ["scheme", "LISP", "SICP"]
---

# black_box abstraction

intro to mit-scheme

## primitive objects

### primitive elements

```scheme
; number
3
; operator
-
```

### combination of primitive elements

```scheme
; combination of operands and operator-
(+ 3 17.4 5)
; a more complex combination
(+ 3 (* 5 6) 8 2)
; define a value
(define A (* 5 5)) ; def A=5*5
(* A A); 5*5*5*5
(define B (+ A ( * 5 A)))
(+ A (/ B 5)) ; 65
```

### primitive procedures

> Attention
> define without '()' output a value
> otherwide a proceduce

```scheme

; define a procedure
(define (square x)(* x x))
(square 10) ; 100
; the same as below
; key word `lambda` define a procedure, which is sy
(define square ((lambda (x) (* x x))))

(define (mean-square x y)
    (+ (square x) (square y))
)
```

### branch statement

```scheme
;conditional statement 
(define (abs x)
    (cond ((< x 0) (- x))
          ((= x 0) 0)
          ((> x 0) x)
    )
)
; if-else
(define (abs x)
    (if (< x 0) 
    (- x)
    x)
)
```

### example

```scheme
; a method to compute sqrt of x
(define (average x y) ( / (+ x y) 2))
(define (good_enough? x)
    (< (abs (- (square guess) x) 0.01)))
(define (improve guess x)
    (average guess (/ x guess)))
(define (try guess x)
    (if (good-enough? guess x)
        guess
        (try (improve guess x))
    )
)
```

a more compact method to implement it

```scheme
(define (sqrt x)
    (define (good_enough? guess x)
        (define (abs x)
            (if (< x 0) 
            (- x)
            x)
        )
        (< (abs (- (square guess) x) ) 0.01)
    )
    (define (improve guess)
        (define (average m n) (/ (+ m n) 2))
        (average guess (/ x guess))
    )
    (define ((try guess)
        (if (good_enough? guess x)
            guess
            (try (improve guess))
        ))
    )
    (try 1)
)
```