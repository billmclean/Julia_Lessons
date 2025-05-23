---
title: Lesson 4\. Functions
---

## Objectives

We have met a few functions in previous lessons, mostly ones provided from
the modules that ship with Julia.  Our aim in this lesson is to learn how to
write simple Julia functions that evaluate mathematical expressions, that is,
we are interested in the kind of function we commonly meet in mathematical
applications, mapping a subset of $\mathbf{R}^n$ into $\mathbf{R}^m$.

By the end of this lesson, you should know

* the syntax for defining a Julia function;
* how arguments are passed to a function;
* how values are returned from a function;
* how to access a function defined in a source file;
* the meaning of *scope* as it applies to the variables in a function body;
* a simple example of a *macro*.

* * *

## Defining a Function

Suppose that we wanted to solve the nonlinear equation $\sin(4x)=\log(x)$.
Algorithms for computing the solution typically require that we first write
the equation in the standard form $f(x)=0$, so in our case we should define
$$
f(x)=\sin(4x)-\log(x).
$$
Start VSCode, do Ctrl+Shift+P to open the Command Palette and there type
`Start REPL`.  At the `julia>` prompt, type
```
f(x) = sin(4x) - log(x)
f(0.5)
f(1.0)
```
The first statement defines a Julia function called `f`, and the next two
show that $f(0.5)\approx 1.6024$ and $f(1.0)\approx-0.7568$.  Since $f$ is
continuous and changes sign, it must have at least one zero in the interval 
$(0.5,1.0)$.  We can compute this zero using a function `find_zero` provided by 
a Julia module called [`Roots`](https://juliamath.github.io/Roots.jl/stable/).

The `Roots` module is not part of Julia's standard library.  Instead, `Roots` 
is a third-party *package* and so is not immediately available when you install
Julia.  In the REPL, type
```
using Roots
```
If you are using one of the PCs in the Maths and Stats computer labs, then
`Roots` might have been installed for you, but otherwise Julia will respond
with a message that 
```
Package Roots not found, but a package named Roots is available from a registry.
```
and ask if you want to install it.  Type `y` and Julia will download and install
`Roots` as well as any of its dependencies, that is, any other packages that 
`Roots` needs.  

`Roots` provides the `find_zero` function that takes as its first argument 
the function `f` whose zero we wish to find, and as its second argument an 
interval bracketing the zero, with `f` positive at one end and negative at 
the other.  Here, the 'interval' is really a vector `[a, b]` or tuple 
`(a, b)` with two elements.  Type
```
z = find_zero(f, [0.5, 1.0])
```
The `find_zero` function returns a zero of $f$, namely
`0.8317259339759461`, which is then assigned to `z`.  We can then confirm from
```
f(z)
```
that the *residual*, that is, the value of `f` at the computed zero, is
close to the machine epsilon.

## Argument Passing

A Julia function can have any number of arguments and any number of return
variables.  Consider the (mathematical) function $g:\textbf{R}^3\to\textbf{R}^2$
defined by
$$
g(x,y,z)=(2x-y+z, x^2+z\cos(xy)).
$$
At the `julia>` prompt, type
```
g(x,y) = (2x - y + z, x^2 + z*cos(x*y))
g(1, 3, -2)
```
and observe that the return value is the tuple `(-3, 2.979984993200891)`.
We could also do
```
t = g(1, 3, -2)
```
in which case `t` gets assigned the tuple `(-3, 2.979984993200891)`,
or alternatively
```
a, b = g(1, 3, -2)
```
so that `a` gets assigned `-3`, and `b` gets assigned `2.979984993200891`.

The *dummy arguments* of a function are the names used in the *definition*
of a function, whereas the *actual arguments* are the values supplied when
we *call* a function.  Thus, in our example, the dummy arguments of `g` are
`x`, `y` and `z`, whereas the actual arguments are `1`, `3` and `-2`.  When the 
function is called, the kth actual argument gets assigned to the kth dummy
argument, then the code that defines the function is executed, and result(s)
are returned.

Note that the *names* of the actual argument are irrelevant.  We could,
if feeling perverse, type
```
x = 3
y = 1
z = -2
g(y, x, z)
```
and the result would be the same as typing `g(1, 3, -2)`.  In practice, to 
avoid confusion, we most often use the same names for actual arguments as those
used for the dummy arguments, except when the former are literal constants
like `1` and `3`.

Returning to our first example of this lesson, type
```
?find_zero
```
to see the help message for this function.  Notice that `find_zero` can actually
take more than two arguments.  It has five *positional arguments* and several
*keyword arguments*.  Only the first two arguments, the function and interval, 
are required.  By doing
```
z = find_zero(f, (0.5, 1.0); verbose=true)
```
we can see that `find_zero` used 51 iterations of the bisection algorithm,
requiring 54 evaluations of `f`, to compute `z`.  If we instead do
```
z = find_zero(f, (0.5, 1.0), Order2(); verbose=true)
```
then the more efficient `Order2()` algorithm uses only 5 iterations
requiring 9 evaluations of `f`.  The positional arguments must come first,
followed by a semicolon, and then any keyword arguments.

It is also possible to provide a *default value* for a dummy argument.  This
default value is used when the corresponding actual argument is omitted from
a function call.  For example, consider the function
```
normal_distribution(x, μ=0.0, σ=1.0) =
    exp(-((x-μ)/σ)^2/2) / (σ*sqrt(2π))
```
Calling `normal_distribution(x)` returns the value at `x` of the *standard* 
normal density (that is, with mean `0.0` and standard deviation `1.0`), but 
we could call `normal_distribution(x, 3.0, 0.5)` for a 
normal distribution with mean `3.0` and standard deviation `0.5`. 

## Local Variables

For the functions `f` and `g` above, the return value(s) could be calculated 
with just a single expression, but often more lines of code are needed.
For example, consider the problem of computing the solutions of a quadratic 
equation $ax^2+bx+c=0$.  From VSCode, open a convenient folder and then open 
a new file called `solve_quadratic.jl`.  Type the following lines in this file.
```
function solve_quadratic(a, b, c)
    sqrt_dscr = sqrt(b^2 - 4a*c)
    x_plus  = ( -b + sqrt_dscr ) / (2a)
    x_minus = ( -b - sqrt_dscr ) / (2a)
    return x_plus, x_minus
end
```
Here, the `function` keyword is followed by the name and dummy arguments
of the function.  The lines between this declaration and the matching `end`
are called the *body* of the function.  The last line of the body is a
*return* statement, which lists the values that the function will return.
We say that `sqrt_dscr`, `x_plus` and `x_minus` are *local variables* in the
*scoping unit* of the function `solve_quadratic`.  The practical significance
is that local variables cannot be referenced outside their smallest enclosing
scoping unit.

After saving the file (Ctrl+S), type at the `julia>` prompt
```
include("solve_quadratic.jl")
xp, xm = solve_quadratic(1, -5, 2)
sqrt_dscr
```
The `include` statement just reads the lines from the file `solve_quadratic.jl`
into the REPL.  The call to `solve_quadratic` returns the zeros of `x^2-5x+2`, 
but attempting to see the value of the local variable `sqrt_dscr` outside the 
body of the function throws an `UndefVarError`.  Similarly, you cannot 
reference the local variables `x_plus` and `x_minus`, although their values are 
available from `xp` and `xm` since the function call effectively results in the
assignments `xp = x_plus` and `xm = x_minus`.  

Limiting the scope of local variables in this way is necessary, because 
otherwise a function call might cause unexpected side effects.  To elaborate, 
consider the function
```
function h1(x)
    a = 3
    return x^2 + a
end
```
If we do
```
a = 7
x = 2
y = h1(x)
```
then following the call to `h1` the value of `a` is still `7` and not `3`.
The `a` with the value `7` is a *global* variable, whereas the `a` with the
value `3` is a *local* variable (with respect to `h1`).
Imagine that `h1` was a long, complicated function and we did not notice
that the body included a line `a = 3`.  We would get a surprise if the value 
of our (global) variable `a` mysteriously changed from `7` to `3` after 
calling `h1`.  To prevent such unwanted surprises, assigning to a variable, 
other than a dummy argument, in the body of a function always creates a new 
local variable, regardless of whether or not a global variable with the same
name exists.

However, the scoping rules *do* allow a function body to *read* the value
of a global variable.  Thus, in the following example,
```
a = 7
function h2(x)
    y = x^2 + a
    return y
end
y = h2(3)
```
the variable `y` gets assigned the value `16`.  Note that changing the value
of `a` will change the result of `h2`, so for example
```
a = 1
w = h2(3)
```
assigns `w` the value `10`.  In fact, we could *define* a function
```
h3(x) = 2x - b
```
even if `b` is not defined, provided we assign `b` a value before we actually
*call* `h3`.

By the way, in the body of the function `solve_quadratic`, we could change
the final line to read simply
```
    x_plus, x_minus
```
that is, we could omit the `return` keyword, because when there is no explicit
return statement the function returns the value of the final line of its
body.  Similarly, we could have defined `h1` as
```
function h1(x)
    a = 3
    x^2 + a
end
```

## Anonymous Functions

In our earlier example solving $\sin(4x)=\log(x)$, instead of first defining
a function with the name `f`, we could have called `find_zero` as
```
z = find_zero(x -> sin(4x)-log(x), [0.5, 1.0])
```
Here, the first argument `x -> sin(4x)-log(x)` is an *anonymous function*,
that is, a function that has no name.  An equivalent alternative syntax is
```
z = find_zero([0.5,1.0]) do x
    sin(4x) - log(x)
end
```
In such a *do-construct*, the lines between `do` and the matching `end`
form the body of an anonymous function that is inserted as the first
argument in the function call that precedes `do`.  By using a do-construct,
we can conveniently pass an anonymous function whose body might require 
several lines of code.

## Dot Syntax

Consider once again the Julia function
```
f(x) = sin(4x) - log(x)
```
Given a vector `v`, the command
```
w = f.(v)
```
evaluates `f` for each element of `v` and assigns the result to the 
corresponding element of a new vector `w`.  For example, if `v` has
length `4`, then `w` will equal `[f(v[1]), f(v[2]), f(v[3]), f(v[4])]`.

In general, we can make any scalar function operate elementwise on a vector 
argument by inserting a dot before the parentheses in a function call.

## Arguments that Mutate!

Consider the following example.
```
function f(x)
    x *= 2
    return x^2
end

z = 3
w = f(z)
```
Here, `w` is assigned the value `36` but the function call does not change
`z`, which retains the value `3`.  That is, the statement
`x *= 2` doubles the value of the dummy argument `x` but has no effect on 
the actual argument `z`, because the function call is equivalent to
```
x = z
x *= 2
w = x^2
```

However, if an actual argument is a mutable container then it can be
modified by a function call, as in the next example.
```
function f!(x)
    x[1] *= 2
    return sum(x)
end
 
z = [1, 2, 3]
w = f!(z)
```
In this case, `w` is assigned the value `7` and the function call also
changes `z` to have the value `[2, 2, 3]`.  Again, this outcome is
consistent with the usual rules for assignment, since the function call
is equivalent to
```
x = z
x[1] *= 2
w = sum(x)
```
and the statement `x = z` means that `x` references the same storage as `z`.
It is a convention in Julia that if a function can mutate any one of its 
arguments then the function name should finish with the exclamation 
character `!` as a visual warning to anyone reading the code.

## Macros

A *macro* is a rule or pattern for transforming a tuple of arguments to a
returned expression that Julia evaluates.  In Julia, the name of every
macro begins with the `@` character.  The creation of macros is beyond the
scope of these lessons, but many useful macros are provided by Julia and
its standard library.  A simple example is `@show`, that is handy for
quickly showing both the *name* and the *value* of a variable in a `.jl` file.  
If we execute a file containing the statements
```
escape_velocity = 11.2
@show escape_velocity
```
then the `@show` macro causes Julia to print the output
```
escape_velocity = 11.2
```
We will meet some other macros in a later lesson.

* * *

## Summary

In this lesson, you have learned how

* to define a function;
* positional and keyword arguments are passed to a function;
* values are returned from a function;
* to assign a default value to an argument;
* the function body is a scoping unit for local variables;
* the dot syntax is used to make a scalar function operate on a vector argument;
* a function name should end in `!` if a call might mutate one of its arguments;
* macro names begin with `@`.

## Further Reading

The section on [Functions](https://docs.julialang.org/en/v1/manual/functions/)
in the Julia documentation discusses the above topics at greater depth.

[**Back to All Lessons**](../index.html)
