---
title: Lesson 1\. Arithmetic
date: 2023-07-08
---

# Lesson 1. Arithmetic

## Using Julia as a Scientific Calculator

We can use the Julia REPL as a scientific calculator to perform simple
arithmetic.  Although this kind of interactive use employs only a small
fraction of Julia's capabilities, it is the natural place to start before
considering more advanced topics on vectors, functions and plotting in later
lessons.

## Objectives

In this lesson, you will learn to evaluate arithmetic expressions in Julia
and to understand the output, particularly when scientific notation, 
complex numbers and inifinite or undefined answers are involved.

After completing the lesson, you should know

* the order of precedence for different arithmetic operations;
* when brackets are required, or are helpful for readability;
* the distinction between integer and floating-point data types;
* how to find the largest and smallest numbers of a given type;
* how to type numbers in scientific notation;
* how to work with complex numbers and rational numbers;
* the meaning of `Inf` (infinity) and `NaN` (not-a-number).

Although Julia's arithmetic is reasonably intuitive, certain intrinsic
limitations of digital computer lead to some subtleties that can be
confusing at first.  Consequently, this lesson is quite long.

* * *

## Basic Operations and Order of Precedence

The Julia symbol for each of the five main arithmetic operations is shown
in the following table.  

|       Operator | Symbol |
|----------------|--------|
|       Addition | +      |
|    Subtraction | -      |
| Multiplication | *      |
|       Division | /      |
| Exponentiation | ^      |

In an arithmetic expression, the order of precedence is as follows.

1. Parentheses
2. Exponentiation
3. Multiplication and Division
4. Addition and Subtraction

Operations with the same precedence are evaluated from left to right, *except*
for exponentiation (`^`).  For example, `a / b * c` evaluates as `(a/b)*c`,
whereas `a^b^c` evaluates as `a^(b^c)`.

## Examples

Try out the following examples. In each case, first apply the precedence
rules to calculate the answer yourself, and then type the expression in
the Julia REPL to check if you are correct.
```
1 + 2*3
(1+2)*3

4/2 + 1
1 + 4/2
4/(2+1)

8^2 / 3
8^(2/3)

12/2/3
12/(2*3)

4^3^2
4^(3^2)
(4^3)^2

2*-3
2^-3
```
In the last two expressions, the minus sign is interpreted as a *unary* rather
than a *binary* operator.  The unary minus has a higher precedence than `*`
and `**` so the results are `2*(-3)` and `2^(-3)`.

In practice, if you are unsure about how Julia will evaluate an expression,
it is best to use explicit parentheses.  Doing so will make your code
easier to read.

**Exercise.** Type a command to evaluate the fraction with numerator `17.1+20.3`
and denominator `36.5+41.8`.  Hint: the answer is **not**
`17.1 + 20.3/36.5 + 41.8`.

## Julia's Type System

Every Julia object has a *type* that can be found using the `typeof` function.
For example,
```
typeof(3)
```
returns the value `Int64`, whereas
```
typeof(3.0)
```
return the value `Float64`.  On any 64-bit system, these are the default 
integer and floating-point data types that the arithmetic registers in the 
CPU operate upon.  Julia has a rich hierarchy of types.  The most general
type is `Any`, which forms the root of the tree of types, that is, every 
other type is a subtype of `Any`.  For example, the `Number` type is an
immediate subtype of `Any`, and is a supertype of every kind of number in
Julia, as shown below.  

![Numbers](../resources/number_types-crop.png)

In these lessons, we will mostly deal just with `Int64` and `Float64`
numbers, and occasionally with `Complex`, `Rational` and `Irrational`
numbers.

**Exercise.** Use the `subtype` and `supertype` functions to explore the
type hierarchy.

## Integers

As the name suggest, an `Int64` is stored using 64~bits, or equivalently,
using 8~bytes.  The `typemax` and `typemin` functions give the largest and
smallest numbers that can be stored in a given data type.  The commands
```
typemax(Int64)
typemin(Int64)
```
show that the largest and smallest `Int64` numbers are
$$
9223372036854775807=\sum_{k=0}^{62}2^k=2^{63}-1
$$
and
$$
-9223372036854775808=-2^{63}.
$$

**Exercise.** What are the largest and smallest `Int8` numbers?

**Exercise.** The `bitstring` function returns a string of zeros and ones 
showing the binary representation of given number.  Look at the output of
`bitstring(n)` if `n` is `typemin(Int8)`, `typemax(Int8)`, `Int8(-1)`,
`Int8(0)` and `Int8(1)`.

The arithmetic registers in the CPU actually perform integer arithmetic
modulo $2^{64}$ with the result in the interval $[-2^{63},2^{63-1}]$.  Thus,
the result of
```
typemax(Int64) + 1
```
is the negative number `typemin(Int64)`. 

## Floating-point Numbers

For any real number, we can "float" the decimal point $n$ places to the
left or right by incorporating a factor of $10^n$ or $10^{-n}$.  For example,
$$
2,347.10293=2.347\,102\,93\times10^3
    =234,710,293\times10^{-5}.
$$
Any positive real number has a unique representation as a *normalised* 
floating-point number, that is, as a product $m\times10^e$ where
$1\le m<10$ and $e$ is an integer.  The number $m$ is called the 
*mantissa* (or *significand*), and $e$ is called the *exponent*.

We can use *exponential format*, also called *scientific format*,
when entering or displaying floating-point numbers.  For example,
Julie will display $2.3\times10^{17}$ as `2.3e17`, and display 
$7.5\times10^{-8}$ as `7.5e-8`.  This format is useful whenever you
have to deal with very large or very small numbers.

For human convenience, programming languages like Julia display
floating-point numbers in base 10, but the computer hardware works in
binary, so the actual floating-point representation is $m\times2^e$
with $1\le m<2$.  A standard known as 
[IEEE 754](https://en.wikipedia.org/wiki/IEEE_754) defines the binary
format for 64-bit floating-point numbers: first is the sign bit ($0$
for positive and $1$ for negative), next are the 11 bits for storing
the exponent, and finally the 52 bits for storing the mantissa. A
*machine number* is one that can be represented exactly in this format.

The function `floatmax` and `floatmin` return the largest and smallest 
positive (finite) numbers for any subtype `T` of `AbstractFloat`.  Try
the following examples.
```
floatmax(Float64)
floatmin(Float64)
floatmax(Float32)
floatmin(Float32)
```
Strictly speaking, `floatmin()` gives the smallest *normalised*
positive number.  It is possible to represent smaller values by allowing 
*denormalised* numbers, that is, by allowing a mantissa smaller than $1$.

Of particular importance is the `eps` function that returns the
*machine epsilon*, defined as the smallest positive number $\epsilon$
such that the rounded value of $1+\epsilon$ is strictly greater than $1$.
Thus, if $x$ is any positive machine number *strictly less than* $\epsilon$,
then Julia will evaluate $1+x$ as $1$.  You can verify that
`eps(Float64)` is $2^{-52}\approx2.22\times10^{-16}$.  The practical 
consequence is that for the result of any floating-point calculation we 
should not expect accuracy better than *about 15 correct significant 
decimal figures*.

## Inf and NaN

The function call `typemax(Float64)` returns `Inf`, a special value that
represents 'infinity'.  Likewise, `typemain(Float64)` returns `-Inf`.  
Julia evaluates the expression
```
1.0/0.0
```
as `Inf`, and similarly evaluates `-1.0/0.0` as `-Inf`.  More interesting
perhaps, is that expressions involving `Inf` can yield a finite results.
For example, try the following.
```
atan(Inf)
tahn(-Inf)
cos(1/Inf)
```
However, there are some arithmetic expression that cannot be given any
meaningful value, either finite or infinte.  For example, try the following.
```
0.0/0.0
Inf - 2*Inf
sin(Inf)
log(-1.0)
```
In each case, the result is `NaN`, which stands for `Not-a-Number`.
There is nothing magical about `Inf` and `NaN`: they are just special bit 
patterns that you can look at by calling `bitstring(Inf)` and 
`bitstring(NaN)`.

## Mixed-Mode Arithmetic

The binary representation of an integer is different from the binary
representation of the equivalent floating-point number, as you can
easily observe by comparing `bitstring(5)` with `bitstring(5.0)`.
Nevertheless, if you combine integer and floating-point values in an
arithmetic expression, then Julia will *promote* each `Int64` to its
corresponding `Float64` value to obtain a purely floating-point
expression.  For example, `3 + 1/2` becomes `3.0 + 1.0/2.0` which evaluates
to `3.5`.

Notice that division is unusual as a binary operation, because the result
`a/b` can have a different type from the operands `a` and `b`.  If `a` and
`b` are of type `Int64`, then `a/b` is of type `Float64` even if `a/b` is
a whole number.  Julia provides a function `div` for *integer division*.
For example,
```
div(7, 2)
```
returns `3`.  The `divrem` function return both the quotient and remainder;
thus,
```
q, r = divrem(7, 2)
```
give `q=3` and `r=1`.

## Rational Numbers

The `//` operator is used to construct `Rational` numbers.  Doing
```
x = 3//4
```
creates a number `x` of type `Rational{Int64}`, which is really just a
pair of integers, the numerator and denominator, that can be accessed as
`x.num` and `x.den`, respectively.  Julia automatically cancels any 
common factors, so for instance after doing
```
y = 7 // 21
```
we find that `y` equals `1//3`.  Rational arithmetic works as expected; thus,
```
5//13 - 19//2 + 7
```
evaluates to `-55//26`.

## Complex Numbers

Just as a `Rational` number consists of a numerator and denominator, a
`Complex` consists of a real and an imaginary part.  For example, if
```
z = 3.2 - 7.2im
```
then the real part `z.re` is `3.2`, and the imaginary part `z.im` is
`-7.2`.  You could also construct `z` using the `complex` function:
```
z = complex(3.2, 7.2)
```
The `abs` and `angle` functions give the modulus and argument (phase)
of a complex number.  Note that doing
```
w = 3 + 5im
```
makes `w` of type `Complex{Int64}`, that is, a complex number with integer
real and imaginary parts.

**Exercise.** What type is `im`?  What type is `im^2`?

## Summary

In this lesson, you have learned about

* the syntax and order of precedence of arithmetic operators;
* the differences between integer and floating-point numbers;
* the special floating-point numbers `Inf` and `NaN`;
* exponential format, useful for very large or very small numbers;
* why the accuracy of floating-point numbers is generally limited to
about 15 significant (decimal) figures;
* how to construct rational and complex numbers.

* * *

## Further Reading

The Julia documentation includes a section on 
[Integers and Floating-Point Numbers](https://docs.julialang.org/en/v1/manual/integers-and-floating-point-numbers/).
A classic paper is David Golberg, [*What every computer scientist should
know about floating-point arithmetic*](https://doi.org/10.1145/103162.103163),
ACM Computing Surveys, Volume 23, pp 5-48, 1991.
