---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.14.5
  kernelspec:
    display_name: Python 3 (ipykernel)
    language: python
    name: python3
---

# Lesson 0. Using Julia

## What is Julia?

[Julia](https://julialang.org/) is a programming language designed for scientific and other mathematical applications.  Its development dates from 2009 at MIT, with the first public release in 2012.  The language reached v1.0 in 2018, and in 2019 three of its lead developers were awarded the Wilkinson Prize for Numerical Software.

## Objectives

This lesson introduces two software applications for running and creating Julia programs.  By the end of this lesson, you should be able to

* start (and quit from) Julia's interactive shell and the VSCode integrated development environment (IDE);
* run simple commands from the Julia prompt;
* access help and documentation about Julia;
* start (and quit from) the VSCode integrated development environment;
* run a simple Julia program;
* open or create a Julia source file in VSCode.

## Instructions

To learn the content of this and subsequent lessons, you should try out the examples while reading.

The lessons aim to provide the minimum necessary information for you to make effective use of Julia in your courses.  At the end of each lesson, we provide suggestions for further reading.


---
# The Julia REPL

*REPL* is an acronym for *Read-Evaluate-Print-Loop*, and describes the simplest kind of text-based method for interacting with a computer via a terminal.  The REPL displays a prompt, which, in the case of Julia looks like

```
julia>
```
to indicate that the system is ready to receive input from the user.  After the user types an expression and presses the "Enter" key, the REPL *reads* this input, *evaluates* the expression, *prints* the value obtained (or an error message if expression was invalid in some way), and then prints the prompt.  Usually, this process happens quickly, but if the expression was a command to run a non-trivial program, the user might be waiting some time before the prompt reappears.

```python

```
