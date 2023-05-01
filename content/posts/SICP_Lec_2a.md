---
title: "SICP_Lec_2a"
date: 2023-04-30T20:21:15+08:00
tags : ["scheme", "LISP", "SICP"]
math : true
draft: false 
---

# High-Order Procedure(Iterative)


## eg.1 sum of integer
$$ \sum\nolimits_{i=a} ^{b}{i} $$


```scheme
; primitive procedure 1+ 1-
(define (soi a b)
    (if (> a b)
    0
    (+ (soi (1+ a) b) a)
    )
)
```

## eg.2 sum of square

$$ \sum\nolimits_{i=a}^{b}{i^2} $$

```scheme

(define (soq a b)
    (define (square x)(* x x))
    (if (> a b)
    0
    (+ (soi (1+ a) b) (square a)))
)
```

## eg.3 Leibnitz's formula

Following formula is designed to find value of 

$$ 
\frac{\pi}{8} = 

\lim_{b\to+\infty}\sum\nolimits_{i=a;by4}^{b}\frac{1}{{i(i+1)}}
$$

```scheme
(define (pi-sum a b)
    (if (> a b)
    0
    (+ (pi-sum (+ 4 a) b)
        (/ 1 (* a (+1 a)))
    ))
)
```

## general pattern of above example

```scheme
(define (<name> a b)
    (if (> a b)
    0
    (+ (<name> (<next> a) b) 
        (<handle> a))
    )
)
```

```scheme
(define (sum a identity next b)
    (if (> a b)
    0
    (+ (sum (next a) b) 
        (identity a))
    )
)

(define (soi a b)
    (define (identity x) x)
    (sum identity a 1+ b)
)

(define (soq a b)
    (define (identity x) (* x x))
    (sum identity a 1+ b)
)
```
## Iterative

```scheme
(define (sum term a next)
    (define (iter j ans)
        (if (> j b)
            ans
            (iter (next j)
                (+ (term j)   
                    ans))))
    (iter a 0))
```

## eg.4 Heron of Alexandria's method

> It is used to compute square roots.

It can be viewed as a iterative procedure finding a fixed point.

Abstraction of this method:

```scheme
(define (sqrt x )
    (fixed-point 
        (lambda (y)
            (average (/ x y) y)) 1)
)
```

Details of it:

```scheme
; f: method to get close to fixed-point

(define (fixed-point f start)
    (define (iter old new)
        (if (close_enough? old new)
            new
            (iter new (f new)))
    )
    (iter start (f start))
)
```

## eg.5 Average Damp

```scheme
(define (sqrt x)
    (fixed-point 
        (average_damp 
            (lambda (y))
            (/ x y))
    1)
)
```
```scheme
(define average_damp
    (lambda (f)
        (lambda (x) 
            (average (f x) x)
        )
    )
)
```

the same as below

```scheme
(define (average-damp f)
    (define (foo x)
        (average (f x) x))
    foo)
```

## eg.6 Newton's method

To find a `y` to such that
$$
f(y) = 0
$$
start with a guess `y0`

$$
y_{n+1} = y_{n} - {\frac{f(y_{n})}{\frac{\mathrm{d} f}{\mathrm{d} y}|_{y=y_n}}}
$$

Apply this method to compute a sqrt root of x: 

```scheme
(define (sqrt x)
    (newton (lambda (y) 
            (- x (square y))
             )
    1)
)
```
Details:
```scheme
(define (newton f guess)
    (define df (deriv f))
    (fixed-point
        (lambda (x) (- x (/ (f x) (df x)))) 
        guess
    )
)
```
How to define `deriv`?

$$
f'(x) = \frac{f(x+{\mathrm{d x}})-f(x)}{\mathrm{d} x}
$$

```scheme
(define deriv
    (lambda (f)
        (lambda (x)
            (/ (- (f (+ x dx))
                  (f x))
                dx)))
)
```
$$
{\mathrm{d} x}?
$$

```scheme
; an ugly but simple method
(define dx 0.0000001)
```