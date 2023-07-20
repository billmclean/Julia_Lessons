---
title: Lesson 3\. Vectors
---

# Lesson 3. Vectors

## Objectives

Any programming language that deals with mathematical problems mush provide
a convenient and efficient way to store and manipulate vector data. In this
lesson you will learn about Julia's `Vector` type.  In particular, you will
learn how to

* create a vector;
* find the number of elements in a vector;
* reference individual elements of a vector;
* perform common operations on vectors.

For now, we limit our attention to one-dimensional arrays, but a later lesson
with treat two-dimensional arrays, which are used to represent matrices.

* * *

## Indexing 

A small vector can be created simply by listing its elements between square
brackets, and separated by commas, as in the following example.
```
a = [2, -1, 9, 7]
```
In this case, `typeof(a)` will return `Vector{Int64}` since each element of
`a` is an integer.  

In Julia, array indices start at `1`, and elements are referenced using 
square brackets: `v[1]` is the first element, `v[2]` is the
second element, and so on.  The `length` function returns the number of 
elements in a vector.  Julia throws a `BoundsError` if you attempt to 
reference `v[i]` for an index `i` outside the range from `1` to `length(v)`.
The last element in a vector `v` can be referenced as
```
v[end]
```
that is, `v[end]` equals `v[n]` if `n = length(v)`.

For the vector `a` defined above, `a[1]` equals `2`, `a[2]` equals `-1`,
`a[3]` equals `9` and finally `a[4]` equals `7`.  Also, `length(a)` equals `4`.

Suppose that the vector `v` has length `n`.  If `i` and `j` satisfy
$1\le i\le j\le n$, then `v[i:j]` is the vector
```
[ v[i], v[i+1], v[i+2], ..., v[j] ]
```
If $i>j$, then `v[i:j]` is the *empty vector* `[]`.  

The syntax `v[i:j]` is a special case of the more general construct `v[i:s:j]` 
which equals the vector
```
[ v[i], v[i+s], v[i+2*s], ..., v[i+p*s] ]
```
where the *stride* `s` is a positive integer and `p` is the largest integer such 
that `i + p*n` is less than or equal to `j`.  For example, if
```
b = [1, 2, 3, 4, 5, 6, 7, 8, 9]
```
then `b[1:2:8]` is the vector `[1, 3, 5, 7]`.  

If $1\le j\le i\le n$ and the stride `s` is *negative*, then `v[i:s:j]` is again
given by
```
[ v[i], v[i+s], v[i+2*s], ..., v[i+p*s] ]
```
but now `p` is the *largest* integer such that `i+p*s` is *greater* than or
equal to `j`.  For example, `b[8:-2:2]` is the vector `[8, 6, 4, 2]`.

Instead of `v[1:j]` you can type `v[:j]`, and instead of `v[i:end]` you can
just type `v[i:]`.


**Exercise.** For the vector `b` given above, write out by hand each of the 
following vectors, and then check your answers using the REPL.
```
b[2:3:9]
b[:4]
b[7:-2:1]
```

## Vector Arithmetic

The vector space operations work as expected.  Suppose `v` and `w` are both
vectors of length `n`.  The sum `v + w` is the vector of length `n` whose `k`th
element is `v[k] + w[k]`.  Similarly, if α is a scalar then the product `α * v` 
is the vector of length `n` whose `k`th element is `α * v[k]`.   For example,
if
```
c = [1, -1, 3] 
d = [0, 5, 9]
```
then `c + d` is `[1, 4, 12]` and `3 * c`  is `[3, -3, 9]`.

Julia also defines an operation `.*` of *elementwise multiplication*, whereby
`v .* w` is the vector of length `n` whose `k`th element is `v[k] * w[k]`.
The operation `.+` is used to add a scalar to every element of a vector, that is,
`v .+ α` is the vector whose `k`th component is `v[k] + α`.
For `c` and `d` as above, 
```
c .* d = [0, -5, 27]
d .+ 4 = [4, 9, 13]
```
Similarly, `d ./ c` equals `[0.0, -5.0, 3.0]` and `d .- 3` equals `[1, 6, 10]`.

## Handy Functions for Creating Arrays

Julia provides several functions that are frequently used to create a vector.

* `zeros(n)` creates a vector of length `n` with every element equal to `0.0`.
* `ones(n)` creates a vector of length `n` with every element equal to `1.0`.
* `fill(x, n)` creates a vector of length `n` with every element equal to `x`.
* `rand(n)` creates a vector of `n` (pseudo-)random numbers, *uniformly*
distributed in the interval $[0,1]$.
* `randn(n)` creates a vector of `n` (pseudo-)random numbers, *normally*
distributed with mean $0$ and variance $1$.

A more general method is to construct a vector using a *comprehension*.
For example,
```
[ k^2-1 for k = -1:4 ]
```
creates the vector `[0, -1, 1, 3, 8, 15]`.  You can create this vector with
floating-point entries instead of integers by doing
```
Float64[ k^2-1 for k = -1:4 ]
```
or
```
[ float(k^2-1) for k = -1:4 ]
```

You can *concatentate* two vectors using a semicolon syntax, as follows: if
`u = [1, 2, 3]` and `v = [4, 5, 6]`, then `[u; v]` is the vector
`[1, 2, 3, 4, 5, 6]`.

**Exercise.** Think of at least three ways to create the vector 
`[1, -1, 1, -1, 1, -1]`.  What about a similar vector of length 100?

## Mutability and Assignment

A `Vector` is an example of a *container type* in Julia: it is an object
that contains other objects.  A *mutable container* is one whose members
can be changed.  A `Vector` is mutable; for example, if we define
```
x = [3, -6, 0, 4, 2]
```
then by doing
```
x[3] = 7
```
the vector `x` will change to `[3, -6, 7, 4, 2]`.  

If we then do
```
y = x
```
then the vector `y` will reference the same storage as `x`.  This means
that any change to `y` also affects `x`.  For example, 
```
y[4] = 1
```
changes both `x` and `y` to become `[3, -6, 7, 1, 2]`.  If you do not 
want this behavious, then you must define `y` to be *copy* of `x`.  One
way is to use the `copy` function,
```
y = copy(x)
```
Note that range indexing always creates a copy.  For instance,
```
z = x[2:4]
```
makes `z` a new vector `[-6, 7, 1]` with its own storage (so changing `z`
will not change `x`).  In particular, `y = x[1:5]` or `y = x[:]` have
the same effect as `y = copy(x)` if `x` is as above.

Another example of a container type is a `Tuple`.  Like a vector, a tuple is
an ordered collection.  The syntax for creating a tuple is like that for a
vector, except using round brackets instead of square brackets.  For example,
```
t = (2, -1, 9, 7)
```
defines a tuple with `length(t)` equal to `4`, and indexing works in the same
way as for vectors: `t[1]` equals `2`, `t[2]` equals `-1`, `t[3]` equals `9`
and `t[4]` equals `7`.  

However, unlike a vector, a tuple is *immutable*.  Thus, although an
assignment like `a = t[3]` is perfectly fine, attempting to do something
like `t[3] = 5` will throw an error.  The only way to change `t[3]` is to
create a new tuple and assign it to `t`:
```
t = (2, -1, 5, 7)
```
Also, the vector arithmetic operations are not defined for tuples.  Tuples
can be useful in managing function arguments and return values, a topic we
cover in the next lesson.

* * *

## Summary

In this lesson, we have seen how to

* construct a vector by listing its elements;
* reference individual elements of a vector;
* extract regularly space elements of a vector to create a new vector;
* perform arithmetic operations on vectors;
* construct vectors using functions such as `zeros` provided by Julia;
* use concatenation to combine vectors;
* assign a vector or a copy of a vector.

[**Back to All Lessons**](../index.html)

