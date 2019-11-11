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


; Exercise 1.1.  Below is a sequence of expressions. What is the result printed by the interpreter in response to each expression? Assume that the sequence is to be evaluated in the order in which it is presented.
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


; Exercise 1.2.  Translate the following expression into prefix form: https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-10.html#%_thm_1.2
  (/
    (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5)))))
    (* 3 (- 6 2) (- 2 7))
  ) ; -0.2466


; Exercise 1.3.  Define a procedure that takes three numbers as arguments and returns the sum of the squares of the two larger numbers.
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


; Exercise 1.4.  Observe that our model of evaluation allows for combinations whose operators are compound expressions. Use this observation to describe the behavior of the following procedure:
  (define (a-plus-abs-b a b)
    ((if (> b 0) + -) a b))
  ; If b is negative it will be subtracted from a, cancelling the negative. If b is positive it will just be added.


; Exercise 1.5.  Ben Bitdiddle has invented a test to determine whether the interpreter he is faced with is using applicative-order evaluation or normal-order evaluation. He defines the following two procedures:
  (define (p) (p))

  (define (test x y)
    (if (= x 0)
        0
        y))

  ; Then he evaluates the expression

  (test 0 (p))

  ; What behavior will Ben observe with an interpreter that uses applicative-order evaluation? What behavior will he observe with an interpreter that uses normal-order evaluation? Explain your answer. (Assume that the evaluation rule for the special form if is the same whether the interpreter is using normal or applicative order: The predicate expression is evaluated first, and the result determines whether to evaluate the consequent or the alternative expression.)

  ; In an interpreter based on applicative-order evaluation, Ben would observe an error or infinite loop type situation since evaluating p with a reference to itself will cause an issue.
  ; On the other hand, in a normal-order language, the procedure p would never get called since x would equal 0, making test return 0 before ever needing to use p. That's why normal-order is also known as lazy evaluation.