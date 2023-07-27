---
title: Lesson 9\. Files
---

# Lesson 9. Files

## Input and Output of Data

Only small amounts of data can be input by typing commands in a shell or a
source file.  Large amounts of data need to be stored in files.  Also, some
programs require *configuration files* to provide a large number of 
settings like font size, window size, background colour etc.

## Objectives

The aim of this lesson is to learn how to read from and write to files.
At the end of the lesson, you should know how to

* open an stream to read from or write to a text file;
* close such a stream;
* access a file via a do-construct;
* read lines from a text file;
* write lines to a text file;
* read an array from or write and array to a text file;
* save data to a binary file, and load it again.

* * *

## Reading from a Text File

The file [quote.txt](../downloads/quote.txt) is a text file containing an 
extract from the book *Progress and Poverty*, by Henry George.  Use the
link to download this file to your VSCode working folder so that it appears 
in the Explorer pane.  Start a Julia REPL and type the command
```
io = open("quote.txt", "r")
```
which opens the file and creates an `IOStream` object `io`.  The *mode*
argument "r" means that the file is opened for reading only.

The `readline` function reads one line of a text file, so the commands
```
line1 = readline(io);
line2 = readline(io);
print(line1, '\n', line2)
```
will read the first two lines of the file and print them:
```
Thus wages and interest do not depend upon the produce of labor and capital, 
but upon what is left after rent is taken out; or, upon the produce which
```

The `seek` function causes `io` to read from the offset provided.  For example,
```
seek(io, 11)
readline(io)
```
reads a line of text starting from just after the 11th byte in the file,
displaying
```
"and interest do not depend upon the produce of labor and capital, "
```
(The characters in the file are all ASCII, and so each takes up only one
code unit, that is, one byte.)  The most common usage of the `seek` function
is `seek(io, 0)` that rewinds to the start of the file.

The `eachline` function returns an iterator that allows the file to be 
processed line-by-line in a for-loop.  For example,
```
seek(io, 0)
for line in eachline(io)
    println(line)
end
```
rewinds the file and then prints the whole contents.  We could print the
first word in each line as follows.
```
seek(io, 0)
for line in eachline(io)
    word_list = split(line)
    if length(word_list) == 0
        println()
    else
        println(word_list[1])
    end
end
```
Here, the `split` function splits the string `line` at the spaces, returning
a vector whose kth element is the kth word in the line.  We have to allow
for blank lines for which the vector is `[]` that has length zero.

When finished reading from a file, you must close the IO stream with the 
command
```
close(io)
```
You can also pass a function to `open`: the single statement
```
x = open(f, "somefile.txt", "r")
```
is equivalent to
```
io = open("somfile.txt", "r")
x = f(io)
close(io)
```
This usage has the advantage that you do not risk forgetting to close the
IO stream.  Typically, we do not create a named function but just use a
do-construct.  For example,
```
number_of_words = open("quote.txt", "r") do io
    n = 0
    for line in eachline(io)
        n += length(split(line))
    end
    return n
end
```
will count the number of words in the file `quote.txt`.

The `readlines` function reads the whole file and returns a vector whose
kth element is the kth line of the file.  Thus,
```
open("quote.txt", "r") do io
    lines = readlines(io)
    print(lines[end])
end
```
prints the last line of the file:
```
Henry George, Progress and Poverty, Book III, Chapter 3
```

## Writing to a Text File

We can create a new file with the `open` function by setting the mode
argument to `"w"` for "writing".  Try typing the lines
```
open("practice.txt", "w") do io
    write(io, "This is the first line.\n")
    write(io, "This is the second line.\n")
end
```
You should see a file `practice.txt` appear in your working folder.  Open
the file in VSCode and check that it consists of
```
This is the first line.
This is the second line.
```

## Text Files and Arrays

We can quickly save a matrix to a text file using the `writedlm` function
from the `DelimitedFiles` module.  Try the following.
```
using DelimitedFiles
A = [ 3  -2  5  7
      0   4  4  9 
      1   3  8  2 ]
writedlm("backup.txt", A)
```
You should see a file `A.txt` that contains the lines
```
3       -2      5       7
0       4       4       9
1       3       8       2
```
If you restart Julia by doing Ctrl+Shift+P and 'Julia: Restart REPL' so 
that `A` is undefined, then the `readdlm` function can be used to retrieve
the matrix entries:
```
using DelimitedFiles
A = readdlm("backup.txt")
```
Note, however, that the new `A` has `Float64` entries instead of `Int64`
entries.

## Saving and Loading Floating-Point Data

The `writedlm` and `readdlm` function are simple and convenient for
dealing with small matrices, but are inefficient for large floating-point
matrices because each matrix entry has to be converted from a `Float64` to a
character string when writing to a file, and from a string to a `Float64` when
reading from a file.  Also, whereas the `Float64` representation of π uses 
8 bytes, the text representation `3.141592653589793` uses 17 ASCII 
characters which take up 17 bytes in a text file.

The [`FileIO`](https://juliaio.github.io/FileIO.jl/stable/) package supports 
a wide range of standard data file types.  A native Julia data file type
is `.jld2`, which requires the 
[`JLD2`](https://docs.juliahub.com/JLD2/O1EyT/0.1.13/) package.  The `@save`
macro provides an easy way to save Julia data to a `.jld2` file.  For
example, the commands
```
using JLD2, DelimitedFiles
A = [ exp((-i+2j)/10) * i^2 for i = 1:100, j = 1:500 ]
@save "big_matrix.jld2" A
writedlm("big_matrix.txt", A)
```
create a 392K binary file `big_matrix.jld2` and a 1022K text file 
`big_matrix.txt`.  In a new Julia session, we can recover the matrix `A`
using the `@load` macro.
```
@load big_matrix.jld2 A
```
You can also save and load multiple variables: after
```
@save "matrices.jld2" A B C
```
we can do
```
@load "matrices.jld2" A B C
```

## Summary

This lesson introduced techniques for file processing in Julia:

* reading from a text file;
* writing to a text file;
* using `writedlm` to save a matrix to a text file;
* using `readdlm` to load the matrix from the text file;
* using `@save` to save a matrix to a `.jld2` file;
* using `@load` to load the matrix from the `.jld2` file.

## Further Reading

The [Networking and Streams](https://docs.julialang.org/en/v1/manual/networking-and-streams/) section of the Julia documentation covers file IO.  The `FileIO`
documentation includes a 
[Registry table](https://juliaio.github.io/FileIO.jl/stable/registry/#Registry-table) that lists the different binary data file formats that are supported
by various Julia packages.  These will be useful if you ever need to use
data generated with another programming language.  For example, the
[RData](https://github.com/JuliaData/RData.jl) package lets you load `.rda`
files that are commonly used in statistics.

[**Back to All Lessons**](../index.html)
