---
title: "SICP_Lec_2b"
date: 2023-05-02T13:58:20+08:00
draft: false 
---

# Compound Data

## eg.1 Add Method for Relational Number

Every realational number can be expressed by  a fractional number.

$$
x=\frac{m}{n},y=\frac{p}{q}, (x,y \in R;m,n,p,q\in Z)
$$
$$
x+y=\frac{mq+pn}{nq}
$$

```scheme
(define (+rat x y)
    (make-rat
        (+ (* (numer x) (denom y))
           (* (numer y) (denom x))
        )
        (* (denom x) (denom y))
    )
)
```
## List Structure 

The feature can be used to implement make-rat.

```scheme
; constructs a pair whose first part is x and whose second part is y.
(cons x y) ; => [x, y]

; selects the first part of the pair p
(car p) ; => [x, y][0], aka x

; selects the second part of the pair p
(cdr p) ; => [x, y][1], aka y
```

**ATTENTION**
`cons` can constructs a pair no matter what the type of x, y

```scheme
(define (make-rat n d)
    (cons n d)
)
(define (numer x)
    (car x)
)
(define (denam x)
    (cdr x)
)
```

## `let` 

use `let` to define a local variable.


