; Example: procedure definition
  (define (square x)
    (* x x)
  )


; Example: conditionals
  ;   => basic conditionals are sort of like switch statements, with else as default
  (define (abs x)
    (cond ((> x 0) x)
      ((= x 0) 0)
      ((< x 0) (- x))
    )
  )

  (define (abs x)
    (cond ((< x 0) (- x))
      (else x)
    )
  )

  ;   => if is a special conditional that acts like ternary operator
  (define (abs x)
    (if (< x 0) 
      (- x)
      x
    )
  )


; Example: logical composition operations
  ;   => allow for compound predicates
  (and (= 1 1) (> 2 4)) ; #f

  (or (= 1 2) (= 1 1)) ; #t
  ;   => and / or are special forms rather than procedures since they can short circuit
  ;   => (in procedures, all subexpressions are evaluated)

  (not (= 1 1)) ; #f


; Exercise 1.1.  Below is a sequence of expressions. What is the result printed by the interpreter in response
; to each expression? Assume that the sequence is to be evaluated in the order in which it is presented.
  10 ; 10
  (+ 5 3 4) ; 12
  (- 9 1) ; 8
  (/ 6 2) ; 3
  (+ (* 2 4) (- 4 6)) ; 6
  (define a 3) ; 
  (define b (+ a 1)) ; 
  (+ a b (* a b)) ; 19
  (= a b) ; #f
  (if (and (> b a) (< b (* a b)))
      b
      a) ; 4
  (cond ((= a 4) 6)
        ((= b 4) (+ 6 7 a)) ; 16
        (else 25))
  (+ 2 (if (> b a) b a)) ; 6
  (* (cond ((> a b) a)
          ((< a b) b) ; 4
          (else -1))
    (+ a 1)) ; 16


; Exercise 1.2.  Translate the following expression into prefix form: 
; https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-10.html#%_thm_1.2
  (/
    (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5)))))
    (* 3 (- 6 2) (- 2 7))
  ) ; -0.2466


; Exercise 1.3.  Define a procedure that takes three numbers as arguments and returns the sum of
; the squares of the two larger numbers.
  ; pseudocode:
  ; if x is lowest return y^2 + z^2
  ; if y is lowest return z^2 + x^2
  ; else return x^2 + y^2

  (define (square x)
    (* x x)
  )

  (define (sum-of-squares x y)
    (+ (square x) (square y))
  )

  (define (sum-of-top-squares x y z)
    (cond ((and (<= x y) (<= x z)) (sum-of-squares y z))
          ((and (<= y x) (<= y z)) (sum-of-squares x z))
          (else (sum-of-squares x y))
    )
  )


; Exercise 1.4.  Observe that our model of evaluation allows for combinations whose operators are
; compound expressions. Use this observation to describe the behavior of the following procedure:
  (define (a-plus-abs-b a b)
    ((if (> b 0) + -) a b))
  ; If b is negative it will be subtracted from a, cancelling the negative.
  ; If b is positive it will just be added.


; Exercise 1.5.  Ben Bitdiddle has invented a test to determine whether the interpreter he is faced
; with is using applicative-order evaluation or normal-order evaluation. He defines the following two procedures:
  (define (p) (p))

  (define (test x y)
    (if (= x 0)
        0
        y))

  ; Then he evaluates the expression

  (test 0 (p))

  ; What behavior will Ben observe with an interpreter that uses applicative-order evaluation? What behavior will
  ; he observe with an interpreter that uses normal-order evaluation? Explain your answer. (Assume that the
  ; evaluation rule for the special form if is the same whether the interpreter is using normal or applicative order:
  ; The predicate expression is evaluated first, and the result determines whether to evaluate the consequent or
  ; the alternative expression.)

  ; Answer: In an interpreter based on applicative-order evaluation, Ben would observe an error or infinite loop type
  ; situation since evaluating p with a reference to itself will cause an issue.
  ; On the other hand, in a normal-order language, the procedure p would never get called since x would equal 0, making
  ; test return 0 before ever needing to use p. That's why normal-order is also known as lazy evaluation.


; Exercise 1.6.  Alyssa P. Hacker doesn't see why if needs to be provided as a special form. ``Why can't I just define it
; as an ordinary procedure in terms of cond?'' she asks. Alyssa's friend Eva Lu Ator claims this can indeed be done, and
; she defines a new version of if:

    (define (new-if predicate then-clause else-clause)
    (cond (predicate then-clause)
            (else else-clause)))

    ; Eva demonstrates the program for Alyssa:

    (new-if (= 2 3) 0 5)
    5

    (new-if (= 1 1) 0 5)
    0

    ; Delighted, Alyssa uses new-if to rewrite the square-root program:

    (define (sqrt-iter guess x)
    (new-if (good-enough? guess x)
            guess
            (sqrt-iter (improve guess x)
                        x)))

    ; What happens when Alyssa attempts to use this to compute square roots? Explain.

    ; Answer: This will likely result in an infinite recursion and stack overflow type situation, since when written as
    ; a procedure, the new-if will evaluate each of the clauses regardless of if the guess was good enough.


; Exercise 1.7.  The good-enough? test used in computing square roots will not be very effective for finding the square
; roots of very small numbers. Also, in real computers, arithmetic operations are almost always performed with limited
; precision. This makes our test inadequate for very large numbers. 

    ; Original code:
    (define (square x)
        (* x x)
    )

    (define (improve guess x)
        (average guess (/ x guess))
    )

    (define (average x y)
        (/ (+ x y) 2)
    )

    (define (good-enough? guess x)
        (< (abs (- (square guess) x)) 0.001)
    )

    (define (sqrt-iter guess x)
        (if (good-enough? guess x)
            guess
            (sqrt-iter (improve guess x) x)
        )
    )

    (define (sqrt x)
        (sqrt-iter 1.0 x)
    )

    ; Explain these statements, with examples showing how the test fails for small and large numbers. An alternative strategy
    ; for implementing good-enough? is to watch how guess changes from one iteration to the next and to stop when the change
    ; is a very small fraction of the guess. 

    ; Design a square-root procedure that uses this kind of end test. Does this work better for small and large numbers?

    ; Answer: with really small numbers, the good-enough? metric of 0.001 will be much less precise than it would be for larger or whole
    ; numbers since it is relatively much larger. For large numbers, this could use a lot more computing power than it should since it would
    ; be trying to get down to a very precise fraction when we likely don't need that much precision with huge numbers.

    
    ; Alternative code:
    (define (square x)
        (* x x)
    )

    (define (improve guess x)
        (average guess (/ x guess))
    )

    (define (average x y)
        (/ (+ x y) 2)
    )

    (define (relative-difference x y)
        (/ (abs (- x y))
           (/ (+ x y) 2)
        )
    )

    (define (good-enough? guess last-guess)
        (< (relative-difference guess last-guess) 0.01)
    )

    (define (sqrt-iter guess x last-guess)
        (if (good-enough? guess last-guess)
            guess
            (sqrt-iter (improve guess x) x guess)
        )
    )

    (define (sqrt x)
        (if (= x 0)
            1
            (sqrt-iter 1.0 x 2.0)
        )
    )

    ; This formula seems to make much more sense, as it scales with the input size

    ; Better written answer to part one from online answer book:

    ; The absolute tolerance of 0.001 is significantly large when computing the square root of a small value. For example, on the system I am
    ; using, (sqrt 0.0001) yields 0.03230844833048122 instead of the expected 0.01 (an error of over 200%).
    ; On the other hand, for very large values of the radicand, the machine precision is unable to represent small differences between large
    ; numbers. The algorithm might never terminate because the square of the best guess will not be within 0.001 of the radicand and trying to
    ; improve it will keep on yielding the same guess [i.e. (improve guess x) will equal guess]. Try (sqrt 1000000000000) [that's with 12 zeroes],
    ; then try (sqrt 10000000000000) [13 zeroes]. On my 64-bit intel machine, the 12 zeroes yields an answer almost immediately whereas the 13
    ; zeroes enters an endless loop. The algorithm gets stuck because (improve guess x) keeps on yielding 4472135.954999579 but (good-enough? guess x)
    ; keeps returning #f.


; Exercise 1.8.  Newton's method for cube roots is based on the fact that if y is an approximation to the cube root of x, then a better
; approximation is given by the value

; Use this formula to implement a cube-root procedure analogous to the square-root procedure. (In section 1.3.4 we will see how to implement
; Newton's method in general as an abstraction of these square-root and cube-root procedures.)
; https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-10.html#%_thm_1.8

    ; same helpers:
    (define (square x)
        (* x x)
    )

    (define (average x y)
        (/ (+ x y) 2)
    )

    (define (relative-difference x y)
        (/ (abs (- x y))
           (/ (+ x y) 2)
        )
    )

    (define (good-enough? guess last-guess)
        (< (relative-difference guess last-guess) 0.01)
    )

    ; different code / newtons method for cube roots:
    (define (improve-cubert guess x)
        (/
            (+
                (/ x (square guess))
                (* 2 guess)
            )
            3
        )
    )

    (define (cubert-iter guess x last-guess)
        (if (good-enough? guess last-guess)
            guess
            (cubert-iter (improve-cubert guess x) x guess)
        )
    )

    (define (cubert x)
        (if (= x 0)
            0
            (cubert-iter 1.0 x 2.0)
        )
    )