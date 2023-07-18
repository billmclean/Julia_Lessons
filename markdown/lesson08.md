---
title: Lesson 8\. Logic and Control
date: 2023-07-18
---

## Lesson 8. Logic and Control

## Truth Value

So far in these lessons we have worked with a variety of data types including
`Int64`, `Float64`, `Complex`, `Vector`, `Matrix` and `String`.  The `Bool`
type takes only two values `true` and `false`, and is useful whenever you want
to execute a group of statements selectively, based on whether or not a
condition is true.

## Objectives

The aim of this lesson is to learn the basic logical operations that Julia
provides for `Bool` variables, and to use them in some simple control flow
constructions.  By the end of this lesson, you should know how to

* use relational operators (for example, `<`) to compare values;
* create logical expressions using logical operators;
* use an if-construct for conditional execution of a code block;
* use a for-loop to execute a code block multiple times.

* * *

## Relations and Logical Operations

The table below lists the *comparison operators* in Julia.

| Relation    | Description           | Example             |
|-------------|-----------------------|---------------------|
| `<`         | strictly less than    | `2 < 3` is `true`   |
| `<=` or `≤` | less than or equal to | `2 ≤ 3` is `true`   |
| `>`         | strictly greater than | `2 > 3` is `false`  |
| `==`        | equal to              | `2 == 3` is `false` |
| `!=` or `≠` | not equal to          | `2 ≠ 3` is `true`   |

The following *truth table* defines the *Boolean "and" operator* `&&`, 
following the usual rules of logic.

| `A`     | `B`     | `A && B` |
|---------|---------|----------|
| `true`  | `true`  | `true`   |
| `true`  | `false` | `false`  |
| `false` | `true`  | `false`  |
| `false` | `false` | `false`  |

Likewise, the *Boolean "or" operator* `||` has its usual meaning.

| `A`     | `B`     | `A || B` |
|---------|---------|----------|
| `true`  | `true`  | `true`   |
| `true`  | `false` | `true`   |
| `false` | `true`  | `true`   |
| `false` | `false` | `false`  |

The *Boolean "not" operator* `!` is defined in the obvious way.

| `A`     | `!A`    |
|---------|---------|
| `true`  | `false` |
| `false` | `true`  |

We can use these operators in combinations with the comparison operators
to build up logical expressions.  The comparison operators have the highest
priority, followed by `!`, and finally by `&&` and `||`.  The expressions
are evaluated from left to right.  In practice, it is best to use
parentheses to the meaning clear at a glance.

**Exercise.** Work out the truth value for each of the following expressions,
and check your answers by typing them in the REPL.
```
(7 < 5) || !(6 > 2)
(2 > 1) && ( rem(16, 2) == 0 )
( 1 + 1 == 2 ) && ( !( rem(9, 4) == 1 ) || ( exp(1) < π ) )
```

Both `&&` and `||` are *short-circuit operators*: the right operand is
never evaluated if the truth value can be determined from only the left
operand.  For example, if `A` if `false`, then `A && B` must be `false`,
regardless of whether `B` is `true` or `false`, so there is not point in
evaluating `B`.  Similarly, if `A` is `true`, then `A || B` must be `true`,
regardless of whether `B` is `true` or `false`, so again there is no point
in evaluating `B`.  Thus, after the statements
```
x = -2.0
y = NaN
(x > 0) && ( y = log(x) )
```
the value of `y` will be `NaN`.  If `log(x)` were evaluated, Julia would
raise a `DomainError` because `x` is negative.

## If-Construct

In Julia, the basic *if-construct* has the form
```
if <condition>
    <statements>
end
```
where `<condition>` can be any logical expression, and `<statements>` can
be any sequence of statements.  If `<condition>` evaluates to `true`,
the Julia will execute the `<statements>`.  Otherwise, if `<condition>`
evaluates to `false`, then the `<statements>` are skipped and the thread
of control passes the next statement following the `end` line. 

A longer form of the construct is
```
if <condition1>
    <statements1>
elseif <condition2>
    <statements2>
else
    <statemetns3>
end
```
In this case,

* `<statements1>` is executed iff `<condition1>` is `true`;
* `<statements2>` is executed iff `<condition1>` is `false` and
`<condition2>` is `true;
* `<statements3>` is executed iff `<condition1>` is `false` and
`<condition2>` is `false`.

Multiple `elseif` clauses are also permitted.  Recall our earlier example using
the `&&` operator to assign the value `log(x)` to `y` provided `x>0`, and the
value `NaN` otherwise.  The same effect can be achieved by
```
if x > 0
    y = log(x)
else
    y = NaN
end
```
A third alternative is
```
y = (x>0) ? log(x) : NaN
```
In general, the value the expression `a ? b : c` equals `b` if `a` is `true`,
and equals `c` otherwise.

In Lesson 4, we defined a function `solve_quadratic`. By using if-constructs,
we can improve this function so that it handles the case when the
discriminant turns out to be negative, leading to complex conjugate roots.
```
function solve_quadratic(a, b, c)
    dscr = b^2 - 4*a*c
    if dscr > 0     # Distinct real roots
        sqrt_dscr = sqrt(dscr)
        x_plus  = ( -b + sqrt_dscr ) / (2a)
        x_minus = ( -b - sqrt_dscr ) / (2a)
    elseif dscr < 0 # Complex conjugate roots
        sqrt_abs_dscr = sqrt(-dscr)
        x_plus  = complex(-b,  sqrt_abs_dscr) / (2a)
        x_minus = complex(-b, -sqrt_abs_dscr) / (2a)
    else            # Equal real roots
        x_plus = x_minus = -b / (2a)
    end
    return x_plus, x_minus
end
```
Notice that we have inserted comments in the source code to help the reader
follow the steps in the code.  Julia will ignore any text you insert following
a `#` character.

**Exercise.** If $|4ac|$ is very small compared to $b^2$, then `dscr` will
be approximately equal to $|b|$ so one of the roots can suffer from loss
of precision due to cancellation of leading digits.  How could you improve
the code to avoid this problem by exploiting the fact that $x_+x_-=c/a$?

The `solve_quadratic` function assumes that `a` is not `0`, since otherwise 
we do not have a quadratic equation but just the linear
equation $bx + c = 0$, which has only one solution $x=-c/b$.  Also, our
code assumes that the coefficients are all real.  We could further improve
the function by doing
```
function solve_quadratic(a::Real, b::Real, c::Real)
    if a == 0
        throw( ArgumentError("The coefficient of x^2 must be non-zero") )
    end
```
Here, we have added a *type assertion* to each argument: if any
of `a`, `b` or `c` is not a subtype of `Real`, then Julia will raise a
`MethodError`.  Also, if `a` is zero (and `b` and `c` are real), then the
function raises an `ArgumentError`, halting execution before the rest of
the function body is reached.  Note that `a == 0` evalutes to `true` when
`a` is zero, regardless whether `a` is an integer a floating-point type.

## For-Loop

In Julia, a *for-loop* has the form
```
for k in <iterator>
    <statements>
```
where `<iterator>` is an *iteratble container*.  For example, the loop
```
for k in [1, 3, 5]
    print(k, ", ")
end
```
produces the output
```
1, 3, 5, 
```
Instead of the vector `[1, 3, 5]` we could just as well have used the
tuple `(1, 3, 5)` or the range `1:2:5`.  In the the last case, the usual
practice is to use an equivalent form of the for-loop where `=` replaces `in`.
```
for k = 1:2:5
    print(k , ", ")
end
```
    


