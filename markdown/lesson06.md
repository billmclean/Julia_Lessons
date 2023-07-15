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
numbers of rows and columns; in our case, `(4, 3)`.  Also, `size(A, 1)`
returns the number of rows, and `size(A, 2)` the number of columns.

Here are some other functions.

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

Indexing also allows the construction of a matrix via a comprehension when
a simple formula defines every entry.  For example, doing
```
B = [ 1//(2i + j) for i=1:4, j=1:4 ]
```
creates the following matrix `H`.
```
4×4 Matrix{Rational{Int64}}:
 1//3  1//4   1//5   1//6
 1//5  1//6   1//7   1//8
 1//7  1//8   1//9   1//10
 1//9  1//10  1//11  1//12
```

The `reshape` function changes the dimensions of a matrix or vector. For
example, if we define the vector
```
v = collect(1:12)
```
of length 12, then
```
A = reshape(v, 3, 4)
```
then `A` is
```
3×4 Matrix{Int64}:
 1  4  7  10
 2  5  8  11
 3  6  9  12
```
Here, the vector `v` and the matrix `A` reference the same storage locations
in the computer memory.  Thus, changing an element of `v` will change the
corresponding element of `A`, and vice versa.  Also, we can access the
elements of `A` using a single index, instead of a row and column index,
with `A[k]` equal to `v[k]` for all `k`.

**Exercise.** Construct `v` and `A` as above.  Try changing `v[4]` to `-4`
and verify that `A[1,2]` also changes to `-4`.

This example also shows that Julia stores the entries of a matrix in
*column-major order*, that is, Julia stores the first column, followed by
the second column, and so on.  

## Matrix Arithmetic

Addition of matrices is defined elementwise, consistent with the usual
definition from linear algebra: if `C = A + B` then `C[i,j] = A[i,j] + B[i,j]`
for all `i` and `j`.  Of course, this operation makes sense only if
`size(A)` equals `size(B)`; otherwise, Julia will raise a `DimensionMismatch`
error.  The usual mixed-mode arithmetic works, so if `A` is an `Int64` matrix
and `B` is a `Float64` matrix, then `A + B` will be a `Float64` matrix.

Multiplication of a scalar times a matrix is also defined as expected.
If `B = α * A` then `B[i,j] = α * A[i,j]` for all `i` and `j`.  Similarly,
the matrix product `C = A * B` is defined as in linear algebra, so if
`A` is $m\times n$, and `B` is $n\times p$, then
$$
\mathtt{C[i,j]}=\sum_{k=1}^n\mathtt{A[i,k]}\,\mathtt{B[k,j]}
\quad\text{for $1\le i\le m$ and $1\le j\le p$.}
$$
If the inner dimensions do not agree, that is, if the number of columns of `A`
differs from the number of rows of `B`, then `A * B` is not defined and
Julia will raise a `DimensionMismatch` error.  A vector is treated like
a with one column, so the matrix-vector product `A * v` will be defined
if and only if `size(A, 2)` equals `length(v)`.

If `size(A)` equals `size(B)` then `C = A .* B` assigns `C` the 
*elementwise product* of `A` and `B`, that is `C[i,j] = A[i,j] * B[i,j]`
for all `i` and `j`.  This operation does not arise in linear algebra, but
can be useful when the matrices are used to store elements of a two-dimensional
data array of some kind.

**Exercise.** Compute `C * D` and `C .* D` by hand, if
$$
\mathbf{C} = \begin{bmatrix}3&-2\\ 5& 1\end{bmatrix}
\quad\text{and}\quad
\mathbf{D} = \begin{bmatrix}1&0\\ 7&-4\end{bmatrix}.
$$
Check your answers using the REPL.

## Linear Systems

Consider the $3\times3$ linear system $\mathbf{A}\mathbf{x}=\mathbf{b}$
where
$$
\mathbf{A}=\begin{bmatrix}5 & 1& 2\\ -2 & 9 & 4\\  3 & 1 & 8\end{bmatrix},
\qquad
\mathbf{x}=\begin{bmatrix}x_1\\ x_2\\ x_3\end{bmatrix},\qquad
\mathbf{b}=\begin{bmatrix}17\\ -11\\ 43\end{bmatrix}.
$$
If we do
```
A = [ 5  1  2
     -2  9  4
      3  1  8 ]
b = [17, -11, 43]
x = A \ b
```
then `x` holds the solution vector `[2.0, -3.0, 5.0]`.  The 
*backslash operator* '\' performs a *left division*, that is, `A \ b`
evaluates $\mathbf{A}^{-1}\mathbf{b}$.  The inverse matrix $\mathbf{A}^{-1}$
is not computed explicitly; instead a more computationally efficient 
algorithm is used, based on an *LU factorisation* of $A$.  

## Eigenproblems

The `LinearAlgebra` module provides many functions for solving problems
in linear algebra.  In particular, `eigen` computes the eigenvalues and
eigenvectors of a give square matrix.  If we define
```
B = [ 3 -1  4
      5  2  6
     -9  1  7 ]
```
then doing
```
using LinearAlgebra
F = eigen(B)
```
creates an `Eigen` object `F` consisting of `F.values`, the vector of
eigenvalues,
```
3-element Vector{ComplexF64}:
 3.499999999999994 - 5.361902647381801im
 3.499999999999994 + 5.361902647381801im
               5.0 + 0.0im
```
and `F.vectors`, the matrix of eigenvectors,
```
3×3 Matrix{ComplexF64}:
 -0.337783+0.241488im  -0.337783-0.241488im  0.174593+0.0im
 -0.765641-0.0im       -0.765641+0.0im       0.931162+0.0im
 0.0900755+0.482976im  0.0900755-0.482976im  0.320087+0.0im
```
Here, the kth column `F.vector[:,k]` is the eigenvector corresponding to the
eigenvalue F.value[k].

**Exercise.** Verify for the example above that 
```
B * F.vector[:,k] - F.value[k] * F.vector[:,k]
```
is close to the zero vector for all `k`.

## Dot Syntax

Given a matrix `A`, the assignment
```
B = A
```
creates a matrix `B` that with the same size and sharing the same storage 
as `A`.  If we instead do
```
C = copy(A)
```
then `C` has its own copy of the elements of `A`.  Thus, changing an element
of `B` will change the corresponding element of `A`, but changes to `C`
have no effect on `A`.

Another possibility is that we have already constructed a matrix `D` with 
the same size and the same element type of `A`, for example by doing
```
D = similar(A)
```
In this case, the values of the elements of `D` are unpredictable: Julia just
allocates storage to hold the elements, without worrying about the current
contents of that storage.  If we now do
```
D .= A
```
then the contents of `A` are copied to `D`.  Since `A` and `D` do not
share storage, changes to one have no effect on the other.

* * *

## Summary

This lesson taught you how to

* create an array by listing its elements between square brackets;
* use `zeros`, `ones`, `fill`, `rand` and `randn` to create matrix;
* reference a matrix element using its row and column indices;
* reference a row or column of a matrix;
* perform common arithmetic operations on matrices;
* solve a system of linear equations;
* compute the eigenvalues and eigenvectors of a square matrix.

## Further Reading

The documentation for the 
[`LinearAlgebra`](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/)
describes many other functions that arise in matrix applications.  These
functions are often designed to exploit any special structure that a matrix
posesses, such as symmetry or positive-definiteness.
