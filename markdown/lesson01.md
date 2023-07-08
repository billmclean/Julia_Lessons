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
confusing at first.

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

## Mixed-Mode Arithmetic

## Rational Numbers

## Complex Numbers

## Summary

## Further Reading
