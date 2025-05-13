---
title: Lesson 2\. Names
---

> There are only two hard things in Computer Science: cache invalidation and
> naming things. [Phil Karlton](https://quotesondesign.com/phil-karlton/)

## Objectives
The aim of this lesson is to understand the use of variables and functions.
We have already made informal use of both in previous lessons, but will now 
take a more systematic and precise approach.  How to write your own functions 
is the topic of another lesson; for now, our concern is just with using 
functions available from existing Julia modules.

After the lesson, you should know

* what is a valid name for a variable or a function;
* that Julia is case sensitive, e.g., `M` is not interchangable with `m`;
* how to use `=` to assign a value to a variable;
* some useful constants like `pi`; 
* different ways for importing a module, or an individual function from a 
module.

* * *

## Variable Names

In Julia, an *identifier*, such as a *variable name*, consists of a sequence of 
characters that may include any upper- or lower-case letter 
(`A`-`Z`, `a`-`z`), any digit (`0`-`9`), an underscore (`_`) and an 
exclamation mark (`!`).  However, the first character in an identifier must 
not be a digit or `!`.  In addition, many Unicode characters can be used 
in a variable name, such as Greek letters like `α`.  At a `julia>` prompt, 
try typing
```
7up = 5.2
```
Julia prints an error message because `7` is not permitted as the first
character in a variable name.  Underscores are useful mainly in longer names
that require more than one word, as in the next example.
```
escape_velocity = 11.2 
```
This example also illustrates the fact that underscores can be used to 
make a long number easier to read by separating the digits into groups.  
(Julia just ignores the underscores, so `40_270` is interpreted as `40270`.)

A variable name consisting *only* of underscores has a special status: such
a variable can be assigned a value, which is immediately discarded and
cannot be used in a subsequent expression.  For example, if a function 
`f(x, y)` returns two values, and we want to assign `a` to the second
of these but do not care about the first, then we could do the following.
```
_, a = f(x, y)
```

Another special variable is `ans`, which takes the value of the most recent
result in a REPL.  For example, after the statements
```
julia> 1 + 1
julia> x = 3 * ans
```
the variable `x` will have the value `6`.

Julia has certain *reserved words* that have special meanings in the 
language and so are not available for use as identifiers.  These reserved
words include `begin`, `while`, `if`, `for`, `try`, `catch`, `return`, `break`, 
`continue`, `function`, `macro`, `quote`, `let`, `local`, `global`, 
`const`, `do`, `struct`, `module`, `baremodule`, `using`, `import`, `export`.

Since Julia names are case sensitive, we could use `For` and `Against` in,
say, a program to count votes for a proposal, even though `for` (all lower
case) is a reserved word.  Nevertheless, to avoid confusion a better choice 
would be `Yes` and `No` (or `Yea` and `Nay`).

## Assigning Values

We have seen already that the equal sign `=` is used to assign a value to 
a variable. The value can be a literal constant, as in the `escape_velocity` 
example above, or an expression. Consider the following statements.
```
x = 4
x = x + 1/x
```
The first statement assigns the value `4` to `x`, after which the second
statement evaluates the expression `x + 1/x`, that is, `4 + 1/4`, which
equals `4.25`, and assigns this value to `x`.  Note that the second statement
is *not* asserting that `x` *equals* `x + 1/x`.  In fact, the mathematical
equation $x=x+1/x$ is not satisfied by *any* number $x$.  You should therefore
read the second statement as "`x` is assigned the value `x + 1/x`" or
"update `x` to the value `x + 1/x`" or, more succinctly, "`x` gets `x + 1/x`".

Another thing to note about this example is that `x` was assigned to
an `Int64` number in the first statement, but then assigned to a `Float64`
number in the second statement.  

In any assignment statement, *all* variables appearing on the right-hand 
side must have previously been assigned a value. For example, if you have
not already defined z then the statement
```
x = z^2 + 3
```
will result in an `UndefVarError`.

Julia defines `+=`, `-=`, `*=` and `/=` for updating a variable.  For example,
the statement
```
x += 1/x
```
is a shorthand for
```
x = x + 1/x
```
Similarly, `x *= 2` is a shorthand for `x = x * 2`, and so on for the others.

You will have noticed that Julia displays the result of an assignment 
statement when typed in the REPL.  You can suppress this behaviour by 
finishing the line with a semicolon.  Thus, 
```
x = 3 * 5.2e7;
```
will not echo the value of `x`, namely `1.56e8`, in the REPL.  However,
Julia does *not* display the value of an assignment occuring in a `.jl` file,
so there is no point in appending a semicolon in this case.

A semicolon can also be used to separate two statements typed on the same 
line, whether in the REPL or a file. Thus,
```
x = 5; y = x^2
```
assigns the value `25` to `y`.  

**Exercise.** Solve the quadratic equation $x^2-x-2=0$ using the
standard formula
$$
x_\pm=\frac{-b\pm\sqrt{b^2-4ac}}{2a}.
$$
Assign the appropriate values to variables called `a`, `b`, `c` and
`sqrt_dscr` (square root of discriminant), `x_plus` and `x_minus`.

## Juxtaposition

The `*` may be omitted following a numeric literal coefficient so that,
for example, Julia interprets `2x` as `2 * x`, and `5(a+3)` as `5 * (a+3)`.
There are a few exceptions.  In particular, `3.2e-5` is always interpreted
as the floating-point number $3.2\times 10^{-5}$, and not the
expression `3.2 * e - 5`.  Note, however, that no space is permitted 
immediately following the coefficient.  Thus, `2 x` will throw an error.

**Exercise.** Perform some experiments to determine if `2x^2` is interpreted
as `(2x)^2` or `2(x^2)`.  What about `2^2x`?

Parenthesised expressions can also be used as coefficients to variables, so
that `(2x+3)y` is interpreted as `(2x+3) * y`.  However, `y(2x+3)` will
be interpreted as a function `y` being called with actual argument `2x+3`.

## Unicode

Julia identifiers may include many Unicode characters.  In particular, all
letters from the Greek alphabet are permitted.  For example, in the REPL
you can assign the value `3.1` to a variable called α by typing `\alpha` 
followed by TAB, and then ` = 3.1`.
```
julia> α = 3.1
```
After that, you can use α like any other variable.  The other Greek letters
can be generated in the same way using the standard LaTeX commands; for 
example, `\beta` followed by TAB gives β.  The same method works in a VSCode
editor pane, provided the Julia extension is installed.

## Constants

Julia defines some important special constants.  In particular, `pi` is
predefined, and is also available as the Unicode identifier π.  If you 
type
```
typeof(pi)
```
at the `julia>` prompt, you will discover that `pi` is not a `Float64`
number; instead, it is of type `Irrational{:π}`.  Also, typing
```
pi
```
or `\pi` then TAB, produces the output
```
π = 3.1415926535897...
```
The trailing ellipsis `...` is a clue that π is special.  In an expression,
Julia correctly rounds π to a floating-point value based on the types of
the other variables and constants in the expression.  Practically speaking,
in most cases this means that Julia replaces π with `3.141592653589793`.
(Strictly speaking, π is actually rounded to 52 *binary* digits.)  However,
```
π + Float32(3)
```
gives the `Float32` result `6.141593f0`.  

**Exercise.** Try typing `big(π)` to see the `BigFloat` value of π.

## Modules and Names

Julia has a large standard library organised into *modules*.  For example,
what day of the week was 19 June, 1956?  The standard library includes a `Dates`
module that provides functions useful for any computations involving dates 
and times.  Before we can use these functions, we first need to tell Julia to 
make them available by typing the command
```
using Dates
```
To answer our question, we can then do
```
t = Date(1956, 6, 19)
dayname(t)
```
to learn that 19 June, 1956, was a Tuesday.

Start a new Julia REPL.  You can do this in VSCode by typing `Restart REPL`
in the command palette. Type
```
import Dates
```
which makes the name `Dates` available but not the names that the module 
*exports*.  Thus, you will find that `t = Date(1956, 6, 19)` no longer works; 
Julia throws an `UndefVarError`.  Instead, you must use the *qualified name*,
as follows
```
t = Dates.Date(1956, 6, 19)
Dates.dayname(t)
```

Another alternative is to import names from a module selectively.  For example,
after
```
import Dates: Date, dayofweek
```
we can do
```
t = Date(1956, 6, 19)
dayname(t)
```

The help prompt can be used to find out information about a module.  Try doing
```
?Dates
```
to get a summary of what this module provides.  You can also use tab completion
to see a list of the objects in a module.  Try typing `Dates.` followed by a
double TAB.

**Exercise.** What happens if you type `Dates.day` followed by a double TAB?

Each module constitutes a distinct *namespace*, which means that there is
nothing to stop programmers from using the same name for different objects
provided that the name is unique to each module.  Thus, although `using`
a module will generally be the most convenient way to access its contents,
sometimes a *name clash* can occur between different modules.

For example, consider two modules called `Votes` and `Census`.  The first
might define a function `count` for counting the number of votes for a
given candidate in a given electorate, and the second might define a 
function `count` for counting the number of people in a given census district.  
A programmer wanting to use both functions in the same program could distinguish
between them by doing
```
import Votes
import Census
```
and using the qualified names `Votes.count(...)` and `Census.count(...)`.
Alternatively, it is possible to import both functions but assign an alias
to each.  After doing
```
import Votes: count as v_count
import Census: count as c_count
```
we can use `v_count(...)` and `c_count(...)`.

Julia has a special module called `Base`, whose contents are always available
by default, that is, Julia implicitly executes `using Base` each time it 
starts.  The `Base` module is where commonly used functions like `sin` and
`exp` are defined.

## Summary

We have seen

* what counts as a valid name for a Julia identifier;
* how to assign a value to a variable and use the variable in an expression;
* that, in the REPL, a semicolon at the end of an assigment suppresses the 
usual printing of the assigned value;
* how to type unicode characters in the REPL or in a VSCode editor pane;
* how to import a function from a module.

* * *

## Further Reading

The Julia documentation has a section on 
[Variables](https://docs.julialang.org/en/v1/manual/variables/), including
some 
[Stylistic Conventions](https://docs.julialang.org/en/v1/manual/variables/#Stylistic-Conventions)

[**Back to All Lessons**](../index.html)
