---
title: Lesson 7\. Strings
date: 2023-07-16
---

# Lesson 7. Strings

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
and the eigth digits following the `0x` given the hexadecimal representation
of `n`.  Thus, `n` has the decimal value $4\times16+7=71$, as you can
verify by typing `Int64(n)`.  Conversely, doing
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
in the REPL, but is obvious when running a `.jl` file.

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
They dance like sirens, hoping the sun would come out again
And I was born in the fog of that day
Can they hear a babe over all the faith,
Or have they forgot what it was that they made"""
```
then `print(s3)` produces
```
They dance like sirens, hoping the sun would come out again
And I was born in the fog of that day
Can they hear a babe over all the faith,
Or have they forgot what it was that they made
```

## Indexing for Strings

Indexing works as you would expect for a string that contains only ASCII
characters, since each character then requires only one code unit.  Thus,
if 
```
s = "The Website of Dreadful Night"
```
then `s[1]` equal `'T'`, `s[5]` equals `'W'` and `s[end]` equals `'t'`.
Similarly, we can easily extract a *substring*: `s[5:11]` equals `"Website"`.
Note that `s[16]` is the character `'D'`, whereas `s[16:16]` is the 
string `"D"`.

Like a tuples, a string is immutable.  If you try to do
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
q = "∀ ϵ > 0 ∃ > 0"
```
We find that `length(q)` returns `13`, the number of characters, but
`ncodeunits(q)` returns `18`, because some of the characters require more
than one code unit.  In particular, `'∀'` uses three code units, and we
find that `q[1]` gives `'∀'`, but `q[2]` and `q[3]` each raise a
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
['∀', ' ', 'ϵ', ' ', '>', ' ', '0', ' ', '∃', ' ', '>', ' ', '0']
```
You can see the vector of valid indices by typing `collect(i)`.

## Operations on Strings

## Formatted Output

## Docstrings

* * *

## Summary

## Further Reading
