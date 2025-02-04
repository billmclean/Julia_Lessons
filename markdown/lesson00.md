---
title: Lesson 0\. Using Julia
---

## What is Julia?

[Julia](https://julialang.org/) is a programming language designed for 
scientific and mathematical applications.  Its development dates from 2009 
at MIT, with the first public release in 2012.  The language reached v1.0 
in 2018, and in 2019 three of its lead developers were awarded the 
[Wilkinson Prize for Numerical Software](https://news.mit.edu/2018/julia-language-co-creators-win-james-wilkinson-prize-numerical-software-1226).

## Objectives

This lesson introduces two software applications for running and creating 
Julia programs.  By the end of this lesson, you should be able to

* start (and quit from) Julia's interactive shell and the VSCode integrated 
development environment (IDE);
* run simple commands from the Julia prompt;
* access help and documentation about Julia;
* run a simple Julia program;
* open or create a Julia source file in VSCode.

## Instructions

To learn the content of this and subsequent lessons, you should try out the 
examples and exercises while reading.

The lessons aim to provide the minimum necessary information for you to make 
effective use of Julia in your courses.  At the end of each lesson, we 
provide suggestions for further reading. The Linux version of Julia is 
available on the PCs in the Maths & Stats computer labs.  To run Julia and
VSCode on your own computer, you can download the installers for your
operating system (Windows, MacOS or Linux) from
[https://julialang.org](https://julialang.org) and 
[https://code.visualstudio.com/download](
https://code.visualstudio.com/download).
Windows users can also install Julia and VSCode from the Windows store.
After installing both applications, follow
[these instructions](https://code.visualstudio.com/docs/languages/julia) to
install the Julia extension for VSCode.

* * *

## The Julia REPL

The term *REPL* is an acronym for *Read-Evaluate-Print-Loop*, and describes 
the simplest kind of text-based method for interacting with a computer via 
a terminal.  The REPL displays a prompt, which, in the case of Julia looks 
like

```
julia>
```

and indicates that the system is ready to receive input from the user.  
After the user types a statement and presses the Enter key, the REPL *reads* 
this input, *evaluates* the expression, *prints* the value obtained (or an 
error message if expression was invalid in some way), and then prints the 
prompt ready to repeat these steps again.  Usually, after pressing Enter the 
prompt will reappear at once, but if the statement initiated a long-running 
computation then a noticeable delay will occur.

If you are using a PC in one of the Maths & Stats computer labs, then you 
need to boot into Linux and start the *Konsole* application to open a 
terminal running *Bash*, the default Unix shell.  At the $ prompt, type 
`julia` and press Enter.  You should see something similar to the image 
below.

![The Julia REPL](../resources/REPL.png)

On Windows, you should be able to find a graphical launcher that opens the 
Julia REPL in a command window.  On MacOS, you should be able to run Julia 
from a Bash terminal just as on Linux.

At the Julia prompt, try typing

```
x = 2
y = x/2 + 1/x
```

The first statement creates a variable `x` and assigns it the value `2`. The 
second statement creates a second variable `y` and assigns it the value of 
the expression `x/2 + 1/x`, which in this case equals `2/2 + 1/2`, that is, 
`1.5`.  Notice that Julia prints these values in the REPL as you type the 
commands. 

The REPL maintains a command history that you can access using the up and 
down arrow keys.  Try pressing the up arrow key once to recall
`y = x/2 + 1/x` and use the backspace key to delete `1/x`, then replace it 
by `3/x` and press Enter.  Now `y` will take the new value `2.5`.  Using the 
command history in this way can save a lot of typing.

## Getting Help

Typing a question mark `?` in the REPL changes the prompt from `julia>` to 
`help?>`, after which you can see a help message about any Julia object by 
typing its name and pressing Enter.  Try typing `?hypot` to see an 
explanation of the `hypot` function. Notice that the `julia>` prompt returns 
after the message is printed, so you can now try doing

```
hypot(3, 4)
```

The REPL supports *tab completion* in many contexts.  For example, if you 
are not sure about the name of a Julia object you can try typing the first 
few letters and then hitting TAB twice.

**Exercise.** Type `?sin` followed by TAB-TAB.  You should see a list of 
several functions.  Look up the help messages for some of them.

## Quitting from the REPL

You can quit the REPL by typing Ctrl-D as the first character following the
`julia>` or `help>` prompt.

## VSCode

VSCode is an *Integrated Development Environment*, or *IDE*, that supports 
the use of *extensions* for a wide variety of programming languages 
including Julia.  You should be able to find a launcher with the following 
logo.

![VSCode logo](../resources/vscode.png){width=20%}

To use VSCode on your own computer, download the 
[installer](https://code.visualstudio.com/download).  When you start VSCode,
either from a terminal or via the launcher, a window should open that looks 
something like the screenshot below.

![VSCode window](../resources/VSCode-welcome.png)

On Linux you can start VSCode from the Bash terminal by typing `code`.

Open the VSCode *command palette* by typing Ctrl+Shift+P or by selecting 
this option from the View menu.  In the text box, type `start REPL`.  
Assuming that the Jula extension is installed, you should see "Julia env:v1.9" 
and "Julia: Starting Language Server" on the bottom bar of the VSCode window,
and soon one of the panes should display the `julia>` prompt.  VSCode will 
start downloading some cache files, but you can start using the REPL 
immediately.

## Running .jl Files

Download the file [`fibonacci.jl`](../downloads/fibonacci.jl) and save it to a 
convenient folder.  In VSCode, click on the Explorer icon (the top one in 
the left bar) or type Ctrl+Shift+E, and then click on the blue "Open Folder" 
button and navigate to the folder containing `fibonacci.jl`.  Alternatively,
select the "Open Folder ..." option from the File menu. A popup will ask 
"Do you trust the authors of the files in this folder?".  Click on 
"Yes, I trust the authors".

You should see `fibonacci.jl` listed in the Explorer pane.  Click on the file 
name to open it in an editor pane, which should look like the screenshot 
below.

![editor_pane.png](../resources/editor_pane.png)

Hover your mouse over the triangle in the top right of the editor pane (the 
one shaped like a Play button).  The pop-up text should read 
"Julia: execute active File in REPL".  Click on the triangle.  You should 
see the output below appear in the REPL pane.

![](../resources/fibonacci_output.png)

When you are finished, close VSCode by selecting "Exit" from the File menu.

## Summary

In this lesson you have seen how to

* start and close the Julia REPL;
* execute simple commands at the `julia>` prompt;
* use the up- and down-arrow keys to go forwards and backwards in the 
command history;
* display a help message about a Julia object;
* open a file in a VSCode editor pane;
* execute code from a Julia source file.

* * *

## Further Reading

The [Julia website](https://julialang.org) provides many resources for
learning about the language.  In particular, you can find the
[official documentation](https://docs.julialang.org/en/v1/), which can be
intimidating at first but should become more accessible as you complete
these lessons.

Similarly, the [VSCode website](https://code.visualstudio.com/) provides the
[official documentation](https://code.visualstudio.com/docs) about using 
this IDE.  

[**Back to All Lessons**](../index.html)
