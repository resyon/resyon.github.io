---
title: "SICP_Lec_1b"
date: 2023-04-30T19:44:28+08:00
draft: false 
---

# substitution

Some prossible methods to implement operator+. 

## prerequisites

There exists some primitive procedures, which are implemented in other method finally.

```scheme
; 1-
(define (1- x) ...)
; 1+
(define (1+ x) ...)
```

## recursion

```scheme

; provided that x is non-negative integer
(define (+ x y)
    if (= 0 x)
    x
    (+ (1- x) (1+ y)))

```

**eg.1 operator+**
```scheme
(+ 3 4)
```
inspect the compute procedure:

```scheme
(+ 3 4)
(+ (1- 3) (1+ 4))
(+ 2, 5)
(+ (1- 2) (1+ 5))
(+ 1, 6)
(+ (1- 1) (1+ 6))
(+ 0, 7)
7
```



**eg.2 fibonacci**

```scheme
(define (fib x) 
    (if (< x 3)
    1
    (+ (fib (- x 1)) (fib (- x 2)))
    )
)
```
duplicate compute procedure `fib(- x 2)`



