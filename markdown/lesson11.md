---
title: Lesson 11\. Modules and Projects
---

## Objectives

This lesson deals with a more advanced topic that might not be needed for
your course.  If in doubt, check with your lecturer.  By following the
worked examples below, you will learn about

* how a module is used to share code;
* how to generate and activate a project;
* the role of the `Revise` package;
* the `export` statement;
* how Julia uses the `Project.toml` file to manage project dependencies;

* * *

## Organising Code

Consider a short program whose source code resides in a file `myprog.jl`.
We can compile and run this program from the Julia REPL by doing

```
julia> include("myprog.jl")
```

This assumes that `myprog.jl` lies in Julia's working directory; if not,
then we need to give the `include` function the full or relative path of
the source file.

Keeping all of the source code in a single file becomes unworkable once
a program grows beyond a moderate size.  Distributing the source code 
across multiple files, often in more than one directory, is more 
convenient.  In addition, we frequently want to make use of the same function 
in more than one program.  

By placing functions or type definitions in a *module*, we can access them
conveniently from the REPL or a program or another module.  The simplest
way to manage a module is to incorporate it in a Julia *project*.  To
explain the workflow, we will use a dummy example.  

## Creating a Project


Start VSCode, open a convenient directory and the start the REPL in the usual
way.  Press `]` to obtain the package manager prompt, and do

```
(@v1.11) pkg> generate Dummy.jl
```

which causes Julia to *generate* a skeleton project 'Dummy.jl' in a 
directory of the same name that contains two files:

```
Dummy.jl/Project.toml
Dummy.jl/src/Dummy.jl
```

We will discuss `Project.toml` later.  The actual module is in the
source file `Dummy.jl/src/Dummy.jl`.  Open the file `Dummy.jl` in a VSCode 
editor pane; you should see the following.

---

```
module Dummy

greet() = print("Hello World!")

end # module Dummy
```
---

## Activating a Project

To run the `greet` function, we must first *activate* the project.  One way 
is to right-click on the `Dummy.jl` project directory (*not* the module file 
`Dummy.jl/src/Dummy.jl`) in the VSCode explorer pane and select
the option "Julia: Activate This Environment" from the drop-down menu.
At the bottom of the VSCode window you should see "Julia env: v1.11"
change to "Julia env: Dummy.jl".  Also, if you type `]` in REPL to switch
to the package manager, you should see that the prompt now says
```
(Dummy) pkg> 
```
Instead of using the VSCode gui, you could have activated the project by
doing
```
(@v1.11) pkg> activate Dummy.jl
```
Again, this assumes that `Dummy.jl` is a sub-directory of VSCode's current
directory; otherwise the `activate` command needs the full absolute or 
relative path to the project directory.

We can now do

```
julia> import Dummy: greet
```

causing Julia to compile the module and make the `greet` function available
in the REPL, so that

```
julia> greet()
```

produces the output `Hello World!`.

## Updating a Project

Edit `Dummy.jl` by changing the `greet` function to

```
greet(name) = print("Hello $(name)!")
```

then save the file.  The command

```
julia> greet("Fred")
```
will recompile the module and run the function to produce the output
`Hello Fred!`.  

## Exporting Names from a Module

Edit `Dummy.jl` again by adding a second function `dismiss` and an `export`
statement, as follows.

---

```
module Dummy

export greet, dismiss

greet(name) = print("Hello $(name)!")
dismiss(name) = print("Goodbye $(name)!")

end # module Dummy
```

---

After saving the file, restart the REPL and type the command
```
greet("Fred")
```
You should get an `UndefVarError` even though the Julia environment is still
set to `Dummy.jl`.  It is only after doing
```
import Dummy: greet, dismiss
```
that the module is recompiled and the two functions become available.
Alternatively, because we added the `export` statement to the module, we
can import the names `greet` and `dismiss` to the REPL by just doing

```
julia> using Dummy
```

Either way, the command

```
julia> dismiss("Spiro")
```

should then produce the output `Goodbye Spiro!`.

## Project Dependencies

Next, edit `Dummy.jl` again so that it reads

---

```
module Dummy

import Printf: @printf

export greet, dismiss

greet(name) = @printf("Hello %s!\n", name)
dismiss(name) = print("Goodbye $(name)!")

end # module Dummy
```

---

and save the file.  Here, `greet` uses the `@printf` macro instead of the 
standard `print` function.  If you now type `using Dummy` you will get an
error message that includes the line

```
ArgumentError: Package Dummy does not have Printf in its dependencies:
```

To fix this problem, you must add the `Printf` module to the project 
environment (even if it was already installed in the Julia v1.11
environment):

```
(Dummy) pkg> add Printf
```

You should see some output concluding with a line like
```
  1 dependency successfully precompiled in 1 seconds
```
You will also notice that Julia has created a new file `Dummy.jl/Manifest.toml`.
Although `Project.toml` and `Manifest.toml` are just plain text files, they
are not meant to be edited.  You can still read these files with any text 
editor, and observe that `Project.toml` contains an entry like

```
[deps]
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"
```
and `Manifest.toml` contains an entry like
```
[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
```
The latter shows that the `Printf` module depends on `Unicode`.

The job of `Project.toml` is to keep a complete list of all 
*direct dependencies* of the project, that is, of all modules that the 
`Dummy` module (directly) depends on.  In this example, the `Printf` module 
is part of Julia's standard library, but dependencies can also be third-party
packages.  The other file `Manifest.toml` records the dependencies
of the direct direct dependencies, and so on recursively as necessary.
The dependencies recorded in `Project.toml` and `Manifest.toml` define the 
*project environment*.  By 
[*registering*](https://julialang.org/contribute/developing_package/) a project 
it becomes a Julia *package* that anyone can install using the `add` command
in the package manager, which is able to install the dependencies by looking
in the `Project.toml` and `Manifest.toml` files.  

The exact version of each dependency is recorded in `Manifest.toml`.  In this 
way, you can recreate a working environment even if, years later, some of the 
current versions of the dependencies are no longer backwards compatible with 
the ones needed in the project  (assuming that Julia's cloud infrastructure 
retains access to the old versions.)

## The Revise Package

When you activate a project in VSCode, the IDE implicitly executes the command
```
using Revise
```
If you are not using VSCode, but just running the Julia REPL from the
command shell, then you should type the above command before activating a
project.  Otherwise, Julia will not recompile the module each time you
save changes to the source code.

Some changes to a module are too difficult for `Revise` to cope with, and 
will result in a warning that `The running code does not match the saved
version`.  In such cases, you need to restart the REPL before you can use
the module.

Another useful package command is *instantiate*.  If you download the source
code for a Julia project and activate its environment, then doing
```
pkg> instantiate
```
will cause Julia to install all of the package's dependencies.  

## Accessing a Module Function from a Script

Create a folder `Dummy.jl/scripts` and, in the explorer pane, right-click
on `scripts` and from the drop-down menu select `Julia: Change to This 
Directory`. Use the VSCode editor to create a source file 
`Dummy.jl/scripts/example.jl` containing the following code.

---

```
using Dummy

greet("Wally")
println("Did you know that exp(iπ) = -1?")
dismiss("Wally")
```

---

You should be able to run this script in the VSCode REPL, either by 
clicking on the triangular icon ("play" button) at the top right of the
editor pane, or by typing `include("example.jl")` in the REPL itself.

Now close VSCode and copy the `example.jl` to another directory away from
the `Dummy.jl` project.  Restart VSCode, open the file and try to run it
as before.  You will get an `ArgumentError: Package Dummy not found in 
current path.`  One solution to this problem is to do
```
julia> push!(LOAD_PATH, "path/to/Dummy.jl/src")
```
which tells Julia to add `path/to/Dummy.jl/src` to the list of directories
where is looks for modules.  You should now be able to run the `example.jl`
script.

A better alternative is to add the `Dummy.jl` project to the `v1.11`
environment, but to do this you must first make the project folder into a
[Git repository](https://swcarpentry.github.io/git-novice/), something that 
is beyond the scope of this lesson.

## Further Reading

The Julia manual has a section on 
[Code Loading](https://docs.julialang.org/en/v1/manual/code-loading/) that
goes into much more detail about the package loading.  The web site
[Modern Julia Workflows](https://modernjuliaworkflows.org/) has useful advice
for managing a Julia codebase.

[**Back to All Lessons**](../index.html)

