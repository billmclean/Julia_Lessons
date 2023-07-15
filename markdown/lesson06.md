---
title: Lesson 6\. Matrices
date: 2023-07-14
---

# Lesson 6. Matrices

## Numerical Linear Algebra

Many scientific and statistical application give rise to large-scale 
problems in linear algebra which are amenable to numerical solution
thanks to modern computer hardware and software.  For instance, an
average desktop computer can solves a $5,000\times5,000$ linear system
in around a second, and find all of the eigenvalues and eigenvectors
of a $5,000\times5,000$ real symmetric matrix in around 10 seconds.
These and similar capabilities have opened up many new application
areas for mathematical modelling and analysis.

## Objectives

In this lesson, you will learn how to work with matrices in Julia.  By 
the end, you should know

* some methods for creating a matrix;
* indexing techniques to access an individual element, or row, or column,
or sub-matrix;
* how to perform matrix operations;
* how to solve a square linear system.

* * *

## Creating Matrices

To illustrate the syntax for creating a (reasonably small) matrix, consider
the $3\times4$ example
$$
\mathbf{A}=\begin{bmatrix}
 2& 0&-7& 1\\
 5& 9& 3&-1\\
 4& 1& 0&-6\end{bmatrix}.
$$
In Julia, the statement
```
A = [ 2  0  -7   1
      5  9   3  -1
      4  1   0  -6 ]
```
creates an object `A` of type `Matrix{Int64}`.  Alternatively, you can
define `A` on one line by doing
```
A = [2 0 -7 1; 5 9 3 -1; 4 1 0 -6]
```
We will see that many of the functions we met in the lesson on vectors can 
also be used to handle matrices.  The `length` function returns the number
of elements in a matrix, so in our example `length(A)` will return `12`.
Perhaps more useful is `size(A)`, which returns a tuple consisting of the 
numbers of rows and columns; in our case, `(4, 3)`.  Here are some other
functions.

* `zeros(m, n)` or `zeros((m, n))` create an $m\times n$ matrix with every
element equal to `0.0`;
* `ones(m, n)` or `ones((m, n))` create an $m\times n$ matrix with every
element equal to `1.0`;
* `fill(x, m, n)` or `fill(x, (m, n)) creates an $m\times n$ matrix with
every element equal to `x`;
* `rand(m, n)` creates an $m\times n$ matrix of (pseudo-)random numbers,
uniformly distributed in interval `[0,1]`;
* `randn(m, n)` creates an $m\times n$ matrix of (pseudo-)random numbers,
normally distributed with mean 0 and variance 1.

We can also build a new matrix by combining some existing matrices. For example,
doing
```
B = ones(3, 3)
C = [A B]
```
produces 
```
3×7 Matrix{Float64}:
 2.0  0.0  -7.0   1.0  1.0  1.0  1.0
 5.0  9.0   3.0  -1.0  1.0  1.0  1.0
 4.0  1.0   0.0  -6.0  1.0  1.0  1.0
```
Notice that because the elements of `B` are `Float64` numbers, Julia has
converted the `Int64` elements of `A`, since all elements of a matrix must
share a common type.

**Exercise.** How would you construct the matrix
$$
\textbf{D}=\begin{bmatrix}
 2& 0&-7& 1\\
 5& 9& 3&-1\\
 4& 1& 0&-6\\
 1& 1& 1& 1\\
 1& 1& 1& 1\\
 1& 1& 1& 1\end{bmatrix}?
$$

Julia treats the `Vector` type as a *column vector*, with both
```
v = [2, -1, 9, 7]
```
and 
```
v = [2; -1; 9; 7]
```
producing the same result.  However,
```
v = [2 -1 9 7]
```
creates a $1\times4$ matrix, or if you like a *row vector*.

## Indexing

The indexing conventions for vectors generalise to matrices in a natural way.
The element of `A` in row `i` and column `j` is referenced as `A[i,j]`,
and is said to have *row index* `i` and *column index* `j`.  For example, if
```
E = [ 9   2   5   0  -4 
      7   0   1  -3   8
      1   4  -6   2   2
      6  -3  -4   1   1 ]
```
then `E[3,4]` equals `2`, and `E[2,5]` equals `8`.  We can also extract a
sub-matrix using index ranges.  Thus, typing `E[2:4,3:4]` gives
```
3×2 Matrix{Int64}:
  1  -3
 -6   2
 -4   1
```
In particular, `E[:,j]` returns the `j`th column of `E`, and
`E[i,:]` returns the `i`th row of `E`.  Note that both have the same type
`Vector{Int64}`, even though mathematically one is a column vector and the
other a row vector.


