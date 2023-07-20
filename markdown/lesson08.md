---
title: Lesson 8\. Logic and Control
---

## Lesson 8. Logic and Control

## Truth Value

So far in these lessons we have worked with a variety of data types including
`Int64`, `Float64`, `Complex`, `Vector`, `Matrix` and `String`.  The `Bool`
type takes only two values, `true` and `false`, and is useful whenever you want
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
are evaluated from left to right.  In practice, it is often best to use
parentheses so the meaning clear at a glance.

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
throw a `DomainError` because `x` is negative.

## If-Construct

In Julia, the basic *if-construct* has the form
```
if <condition>
    <statements>
end
```
where `<condition>` can be any logical expression, and `<statements>` can
be any sequence of statements.  If `<condition>` evaluates to `true`,
then Julia will execute the `<statements>`.  Otherwise, if `<condition>`
evaluates to `false`, then the `<statements>` are skipped and the thread
of control passes to the statement immediately following the `end` line. 

A longer form of the construct is
```
if <condition1>
    <statements1>
elseif <condition2>
    <statements2>
else
    <statements3>
end
```
In this case,

* `<statements1>` is executed iff `<condition1>` is `true`;
* `<statements2>` is executed iff `<condition1>` is `false` and
`<condition2>` is `true`;
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
a `#` character up to the end of the same line.

**Exercise.** If $|4ac|$ is very small compared to $b^2$, then `dscr` will
be approximately equal to $|b|$ so one of the roots can suffer from loss
of precision due to cancellation of leading digits.  How could you improve
the code to avoid this problem by exploiting the fact that $ax_+x_-=c$?

The `solve_quadratic` function assumes that `a` is not `0`, since otherwise 
we do not have a quadratic equation but just the linear
equation $bx + c = 0$, which has only one solution $x=-c/b$.  Also, our
code assumes that the coefficients are all real.  We could further improve
the function by doing
```
function solve_quadratic(a::Real, b::Real, c::Real)
    if a == 0
        throw( ArgumentError(
              "The coefficient of x^2 must be non-zero") )
    end
    ...
```
Here, we have added a *type assertion* to each argument: if any
of `a`, `b` or `c` is not a subtype of `Real`, then Julia will throw a
`MethodError`.  Also, if `a` is zero (and `b` and `c` are real), then the
function throws an `ArgumentError`, halting execution before the rest of
the function body is reached.  Note that `a == 0` evaluates to `true` when
`a` is zero, regardless whether `a` is an integer or a floating-point type.

If we were to implement, in addition, a
```
function solve_quadratic(a::Complex, b::Complex, c::Complex)
    ...
```
that handles a quadratic with complex coefficients, then the function 
`solve_quadratic` would provide two *methods*.  In any given function 
call, Julia will select the appropriate method based on the types of the
actual arguments, that is, the real method is chosen if `a`, `b`, `c` are all
`Real`, and the complex method is chosen if `a`, `b`, `c` are all `Complex`.
This paradigm, of selecting code based on the sequence of types of all
actual arguments in a function call, is known as *multiple dispatch* and is
a charactistic feature of the Julia programming language.

## For-Loop

In Julia, a *for-loop* has the form
```
for k in <iterator>
    <statements>
```
where `<iterator>` is an *iterable container*.  For example, the loop
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
tuple `(1, 3, 5)` or the range `1:2:5`.  In the the last case, the standard
practice is to use an equivalent form of the for-loop where `=` replaces `in`.
```
for k = 1:2:5
    print(k , ", ")
end
```
    
A for-loop is a scoping unit whereas an if-statement is not.  Thus, 
```
for i = 1:5
    x = i
end
println("x = ", x)
```
will throw an `UndefVarError` because `x` is local to the for-loop, whereas
```
if true
    x = 3
end
print("x = ", x)
```
will print `x = 3`.  The loop counter `i` is also a local variable, so
its value is also not accessible outside the loop.

However, a for-loop defines a *soft scope* in contrast to a function, 
which defines a *hard scope*.  Create a file `soft_scope.jl` containing
```
s = 0.0
for k = 1:10
    global s += 1/k^2
end 
println("The sum equals ", s)
```
and run the file.  The output prints the value of the 
sum $\sum_{k=1}^{10}\frac{1}{k^2}$.  However, if you remove the `global`
declaration in front of `s` in the loop body, you will get a warning:
```
Assignment to `s` in soft scope is ambiguous because a global variable 
by the same name exists: `s` will be treated as a new local. 
Disambiguate by using `local s` to suppress this warning or `global s` 
to assign to the existing global variable.
```
Following the warning, Julia throws an `UndefVarError` since the
statement `s += 1/k^2` is equivalent to `s = s + 1/k^2`, and the 
"new local" `s` is undefined.  However, if you actually type (or copy 
and paste) 
```
s = 0.0
for k = 1:10
    s += 1/k^2
end 
println("The sum equals ", s)
```
into the REPL then Julia will not complain, and given the output
```
The sum equals 1.5497677311665408
```

Contrast this behaviour with the hard scope of the `add_it_up` function:
```
s = 0.0

function add_it_up(n)
    for k = 1:n
        global s += 1/k^2
    end 
end 

add_it_up(10)
println("The sum equals ", s)
```
Removing the `global` declaration leads to an `UndefVarError` whether you
run the code from a file or directly in the REPL.  The `add_it_up` function
is quite unnatural; in practice, you should do
```
function add_it_up(n)
    s = 0.0
    for k = 1:n
        s += 1/k^2
    end
    return s
end

println("The sum equals ", add_it_up(10))
```
We no longer need the `global` declaration because the for-loop is now
in the local scope of the function rather than in the global scope of the
file.

* * *

## Summary

In this lesson, we have seen how to

* form logical expressions in Julia;
* use an if-construct to test a condition and select one of several
alternative code blocks;
* use a for-loop to execute a code block multiple times with the loop 
counter taking successive values in an iterable container.

## Further Reading

The Julia documentation has a section on 
[Control Flow](https://docs.julialang.org/en/v1/manual/control-flow/).

[**Back to All Lessons**](../index.html)
