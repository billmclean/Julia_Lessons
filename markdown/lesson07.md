---
title: Lesson 7\. Strings
---

## Text Processing

In an earlier lesson, we have seen simple examples using strings as labels
and titles in plots.  We will now take a more systematic look at strings
in Julia, emphasising the features that are commonly needed in mathematical 
and scientific computing.

## Objectives

The aim of this lesson is to understand how to create and manipulate strings
in Julia, and how to produce formatted output.  By the end of this lesson,
you should know how to

* create a string;
* index the individual characters in a string;
* compare two strings;
* concatenate two strings;
* format text output;
* provide a *docstring* for a function.

* * *

## Strings and Characters

Unicode provides a standard for encoding character sets for use on a
computer.  Julia supports the most widely used encoding, UTF-8, in which
each character is represented by a valid *code point* consisting of one 
to four *code units*, with each code unit requiring one byte (8 bits).
The first $2^7=128$ code points provide the *ASCII* character set dating
from the 1960s.

Julia characters have type `Char`, and are delimited with single quotes.
You can see the UTF-8 code point for a character by using the `codepoint`
function.  For example,
```
n = codepoint('G')
```
assigns to `n` the code point for an upper-case letter 'G', which turns out 
to be `0x00000047`.  Here, `n` is an *unsigned 32-bit integer*, or `UInt32`,
and the eight digits following the `0x` give the hexadecimal (base 16)
representation of `n`.  Thus, `n` has the decimal value $4\times16+7\times1=71$,
as you can verify by typing `Int64(n)`.  Conversely, doing
```
Char(n)
```
produces the output
```
'G': ASCII/Unicode U+0047 (category Lu: Letter, uppercase)
```

A string is just a sequence of characters.  Julia strings have the type
`String` and are delimited by double or triple quotes.  For example,
```
s1 = "Here is a simple string."
```
If you want to use a double quote character `"` as part of the string itself,
you need to use a backslash `\` as an *escape character*, as in the next
example.
```
s2 = "\"Stealing Mr.  Zubov's oldest whisky,\" said Ossian."
```
The `print` function prints a string, stripping off the string delimiters, 
so `print(s2)` gives
```
"Stealing Mr.  Zubov's oldest whisky," said Ossian.
```

The *new line* character `'\n'` causes the next character to print on a new 
line.  For example, typing
```
print("Here is one line.\nHere is a second line.")
```
produces
```
Here is one line.
Here is a second line.
```
The `println` takes a string and appends a `\n` before printing.  The
difference between `print` and `println` is not immediately apparent
in the REPL, but is obvious when printing from a `.jl` file.

You can *prevent* jumping to a new line by finishing a line with a
backslash `\`.  Thus,
```
print("Here is one line. \
This text appears on the same line.")
```
produces
```
Here is one line. This text appears on the same line.
```

Triple quoted strings allow you to work with several lines of text at once.
Thus, if we define a string
```
s3 = """
    Container types in Julia include
        * Vector,
        * Matrix,
        * Tuple,
        * String."""
```
then `print(s3)` produces
```
Container types in Julia include
    * Vector,
    * Matrix,
    * Tuple,
    * String.
```
Notice how Julia strips out leading whitespace from a triple quoted string,
whereas for a double quoted string we find that
```
print("    Text starts here.")
```
produces
```
    Text starts here.
```

## Indexing for Strings

Indexing works as you would expect for a string that contains only ASCII
characters, since each character then requires only one code unit.  Thus,
if 
```
s = "The Website of Dreadful Night"
```
then `s[1]` equal `'T'`, `s[5]` equals `'W'` and `s[end]` equals `'t'`.
Similarly, we can easily extract a *substring*; for example, `s[5:11]` 
equals `"Website"`.  Note that `s[16]` is the character `'D'`, whereas 
`s[16:16]` is the string `"D"`.

Like a tuple, a string is immutable.  If you try to do
```
s[25] = 'L'
```
then the result is a `MethodError`.  Instead, we have to create a new
string, which we can then assign to `s` if we wish.  For example, if we
use the `replace` function, as follows,
```
s = replace(s, 'N' => 'L')
```
then `s` becomes `"The Website of Dreadful Light"`.

The `length` function returns the number of characters in a string, so
in this example, `length(s)` returns `29`.

Things become more complicated if we allow non-ASCII characters.  Consider,
for instance
```
q = "∀ ϵ > 0 ∃ δ > 0"
```
We find that `length(q)` returns `15`, the number of characters (including
the spaces), but `ncodeunits(q)` returns `21`, because some of the characters 
require more than one code unit.  In particular, `'∀'` uses three code units, 
and we find that `q[1]` gives `'∀'`, but `q[2]` and `q[3]` each throw a
`StringIndexError`.  Putting
```
i = eachindex(q)
```
creates an *iterator* `i` that returns every valid index, so for example,
```
v = [ q[k] for k in i ]
```
creates a `Vector{Char}` from the characters in `q`, and `print(v)` produces
```
['∀', ' ', 'ϵ', ' ', '>', ' ', '0', ' ', '∃', ' ', 'δ', ' ', '>', ' ', '0']
```
You can see the vector of valid indices by typing `collect(i)`.

## Operations on Strings

The multiplication operator `*` is used to concatenate strings.  Thus, if
```
s1 = "Flynne "
s2 = "Fisher"
```
then `s1 * s2` is the string `"Flynne Fisher"`.  The exponentiation operator
`^` is used to repeat a string.  Thus,
```
print("Cayce"^4)
```
produces the output
```
CayceCayceCayceCayce
```

The `lowercase` and `uppercase` functions convert every character in a
string to lower and upper case, respectively.
```
s3 = "Mona Lisa Overdrive"
print(lowercase(s3))
```
produces
```
mona lisa overdrive
```
whereas
```
s4 = "Virtual Light"
print(uppercase(s4))
```
produces
```
VIRTUAL LIGHT
```

The functions `findall` and `findfirst` are used to find the index or range
of indices of a character or substring in a string.  For example,
```
findall('i', s4)
```
returns
```
2-element Vector{Int64}:
  2
 10
```
whereas `findfirst('i', s4)` returns just the index `2`.  Similarly,
```
findfirst("tua", s4)
```
returns
```
4:6
```

## Formatted Output

We often want to create a string that incorporates the values of some 
variables.  For example, recall the example from Lesson 4,
```
xp, xm = solve_quadratic(1, -5, 2)
```
where `xp` and `xm` are the zeros of the quadratic `x^2-5x+2`.  If we do
```
println("The zeros are $xp and $xm.")
```
then we obtain the output
```
The zeros are 4.561552812808831 and 0.4384471871911697.
```
This process is called *string interpolataion*: the character sequences
`$xp` and `$xm` are replaced by the values of the variables `xp` and `xm`.

We can gain fine control over how the value of a variable is formatted by
using the macro `@sprintf` from the `Printf` module.  For example, if
we wanted to show the values of `xp` and `xm` to five decimal places then
we could do
```
using Printf
s = @sprintf("The zeros are %.5f and %.5f.", xp, xm)
print(s)
```
to produce
```
The zeros are 4.56155 and 0.43845.
```
The first argument to `@sprintf` is called the *format string*.  The
*format specifier* `%.5f` says to use a *fixed point* format with five
digits after the decimal point.  The arguments listed after the format
string are matched in order with the format specifiers.

The `@printf` macro works the same way as `@sprintf`, but prints
directly instead of returning a string.  Both are based on corresponding
functions `printf` and `sprintf` from the C programming language.  A 
complete description of all format specifiers is available 
[here](https://cplusplus.com/reference/cstdio/printf/).  In what follows,
we will illustrate a few of the most important cases, using the `|` 
character as a visible delimiter around each string.

Doing
```
name = "Wilf"
age = 32
@printf("|%10s| => |%5d|\n", name, age)
```
produces
```
|      Wilf| => |   32|
```
Here, `%10s` says to print a string variable in a field of width 10, so
`"Wilf"` is padded with 6 spaces.  Similarly, `%5d` says to print an integer
variable in a field of width 5 using decimal digits.  If you omit the field
width from a format descriptor, then the field width will be as small as 
possible, as we saw above when printing the variables `xp` and `xm`.

For floating-point variables we can use fixed point format `f` or exponential
format `e`, that allow us to specify both the field width and the number
of digits following the decimal point, as in the next example.
```
@printf("|%10.4f|\n", π)
@printf("|%12.4e|\n", exp(10))
```
produces
```
|    3.1416|
|  2.2026e+04|
```
Notice that in each case, the output is right-justified, which is useful
when printing tables.  Prepending the field width with a `-` changes the
output to be left-justified.  For example,
```
@printf("|%-10.4f|\n", π)
@printf("|%-12.4e|\n", exp(10))
```
produces
```
|3.1416    |
|2.2026e+04  |
```
Also, note that the format string needs to end with a newline character `\n` 
if we want subsequent output to follow on the next line.

## Docstrings

A *docstring* describes the purpose of, and key information about, a function. 
Recalling our `solve_quadratic` function from Lesson 4, we could do the 
following.
```
"""
    solve_quadratic(a, b, c)

Solve the quadratic equation `ax^2 + bx + c = 0`.

Warning: the coefficients `a`,`b`, `c` must be real, and the discriminant
must be positive, so that two real roots are returned.
"""
function solve_quadratic(a, b, c)
    sqrt_dscr = sqrt(b^2 - 4a*c)
    x_plus = ( -b + sqrt_dscr ) / (2a)
    x_minus = ( -b - sqrt_dscr ) / (2a)
    return x_plus, x_minus
end
```

Thus, the docstring is a triple quoted string placed just before the
`function` statement.  If we type `solve_quadratic` at the `help>` prompt 
(in other words, at the `julia>` prompt type `?` followed by `solve_quadratic`), 
then Julia will print the docstring.  Try it.  Notice that we indent the 
first line of the docstring 4 spaces, and put backticks around any mathematical 
expressions.

* * *

## Summary

This lesson described how

* characters are delimited by single quotes;
* strings are delimited by double or triple quotes;
* the newline and backslash characters can force or inhibit a line break;
* a triple quoted string can preserve the line breaks in a long string
extending over several lines;
* indexing works for strings, but complications can arise if non-ASCII 
characters are present;
* to concatenate or repeat a string;
* to insert the value of a variable into a string;
* to control the formatting of strings and printed output using the `@sprintf` 
and `@printf` macros;
* to provide a docstring for a function.

## Further Reading

More details can be found in the section on 
[Strings](https://docs.julialang.org/en/v1/manual/strings/) in the Julia
documentation.  See also some 
[Guidelines for writing docstrings](https://docs.julialang.org/en/v1/manual/documentation/#Writing-Documentation).

[**Back to All Lessons**](../index.html)

