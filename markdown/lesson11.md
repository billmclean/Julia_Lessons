---
title: Lesson 11\. Modules and Projects
---

## Objectives

The lesson deals with a more advanced topic that might not be needed for
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
convenient.  In addition, we frequently want to call the same function 
in more than one program.  

By placing functions or type definitions in a *module*, we can access them
conveniently from the REPL or a program or another module.  The simplest
way to manage a module is to incorporate it in a Julia *project*.  To
explain the workflow, we will use a dummy example.

## Creating a Project

Start Julia from a convenient directory, or open a convenient directory if
using VSCode, and press `]` to obtain the package manager prompt.  Next, do

```
(@v1.11) pkg> generate Dummy
```

which causes Julia to *generate* a skeleton project called 'Dummy' in a 
directory of the same name that contains two files:

```
Dummy/Project.toml
Dummy/src/Dummy.jl
```

We will discuss `Project.toml` later.  The actual module is in the
source file `Dummy.jl` which looks like

---

```
module Dummy

greet() = print("Hello World!")

end # module Dummy
```
---

## Activating a Project

To run the `greet` function, we first *activate* the project by doing

```
(@v1.11) pkg> activate Dummy
```

after which the `(@v1.11)` prefix to the package prompt changes to `(Dummy)`,
indicating that the package *environment* has changed from the default
`Julia v1.11` to `Dummy`.  Note that the `Dummy` in the generate command
is the path of the directory relative to Julia's working directory; if you
run the `activate` command from another directory then you need to give the
absolute or relative path to `Dummy`.  Packages (like `Revise`) already 
installed in the 'Julia v1.11' environment are still available in the REPL, 
but see below for the `Dummy` module itself.

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

then save the file.  For the change to take effect, Julia needs to 
recompile the module.  You can do this by restarting Julia, activating
the project and importing the module.  (Try it.)  Having to go
through these steps after every change quickly becomes tedious however.
Instead, we will install the `Revise` package in the `@v1.11` environment.

Restart Julia and type `]` to get the package prompt `(@v1.11 ) pkg>`, then do
```
(@v1.11) pkg> add Revise
```
Hit the backspace key to exit the package manager, and type
```
julia> using Revise
```
then go back to the package manager and activate the `Dummy` project again.
Exit the package manager and do

```
julia> import Dummy
julia> Dummy.greet("Fred")
```
to recompile the module and run the function to produce the output
`Hello Fred!`.  

## Exporting Names from a Module

Edit `Dummy.jl` again so that it looks like

---

```
module Dummy

export greet, dismiss

greet(name) = print("Hello $(name)!")
dismiss(name) = print("Goodbye $(name)!")

end # module Dummy
```

---

The `export` statement means that the names `greet` and `dismiss` are
automatically imported by doing

```
julia> using Dummy
```

For example, the command

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

Here, `greet` uses the `@printf` macro instead of the standard `print`
function.  If you now type `using Dummy` you will get an
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
You will also notice that Julia has created a new file `Dummy/Manifest.toml`.
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
[registering](https://julialang.org/contribute/developing_package/) a project 
it becomes a Julia package that anyone can install using the `add` command
in the package manager, which is able to install the dependencies by looking
in the `Project.toml` and `Manifest.toml` files.  

The exact version of each dependency is recorded in `Manifest.toml`.  In this 
way, you can recreate a working environment even if, years later, some of the 
current versions of the dependencies are no longer backwards compatible with 
the ones needed in the project  (assuming that Julia's cloud infrastructure 
retains access to the old versions.)

If you are using the Visual Studio Code IDE, and open the `Dummy`
directory using the 'File > Open Folder' menu then you should see, in
the bottom left, 'Julia env: Dummy'.  If not, you might see a notification
asking if you want to change the environment.  Alternatively, type 
'Julia: Change Current Environment' in the Command Palette and select 'Dummy'.
Once `Dummy` is the current environment, you can type
'Julia: Start REPL' in the Command Palette to get the `julia>` prompt. 
You can then try running the `greet` function as explained above.  If you
look in the settings for the VSCode Julia Extension you will see an option
```
Julia: Use Revise
```

that loads the Revise module on startup of the REPL.  It seems this 
option is active by default.

Another useful package command is *instantiate*.  If you download the source
code for a Julia project and activate its environment, then doing
```
pkg> instantiate
```
will cause Julia to install all of the package's dependencies.  

# Further Reading

The Julia manual has a section on 
[Code Loading](https://docs.julialang.org/en/v1/manual/code-loading/) that
goes into much more detail about the package loading.  The web site
[Modern Julia Workflows](https://modernjuliaworkflows.org/) has useful advice
for managing a Julia codebase.
