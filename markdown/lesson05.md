---
title: Lesson 5\. Plotting
date: 2023-07-13
---

## Lesson 5. Plotting

Many applications of computational mathematics involve processing large arrays 
of data, and often the best way to make sense of such a volume of numerical 
output is with some appropriate kind of *visualisation*. For this reason, the 
ability to turn numbers into pictures has always played an essential role in 
scientific computing.

## Objectives

This lesson will focus on creating simple, two-dimensional plotting using a
third-party Julia package called `Plots`.  By the end of the lesson, you 
should know how to

* create a simple xy-plot;
* display multiple sub-plots in a single figure window;
* incorporates axis labels, a title, a grid and a legend;
* create some more specialised plots such a polar plots and histograms.

* * *

## The `plot` Command

Start VSCode, do Ctrl+Shift+P to access the Command Palette and type
`Julia: Start REPL`.  At the `julia>` prompt, type
```
using Plots
```
If `Plots` is not yet installed on your PC, type `y` so that Julia will
download and install the package and its dependencies.  (`Plots` has quite
a lot of dependencies, so the installation might take some time.)  

Type the following commands to create a simple plot of the sine function.
```
x = range(0, 2π, length=201)
y = sin.(x)
plot(x, y)
```
You should see a plotting pane open in VSCode, looking like the following
screenshot.

![Sine plot](../resources/sine_plot.png)

The `range` function creates a `StepRangeLen` object `x`.  You can verify
using the `supertype` function that a `StepRangeLen` is a subtype of an
`AbstractRange` which in turn is a subtype of an `AbstractVector`.  The
practical implication is that Julia will treat `x` like a vector in most
contexts.  If necessary, you can create a vector from `x` by doing
```
vecx = collect(x)
```
You will see that the 201 elements of `vecx` increase from $0$ to $2\pi$
with a uniform spacing $2\pi/200=\pi/100$.  However, you can see that the
dot syntax works fine with `x` and creates a vector `y` with `y[k]` equal
to `sin(x[k])` for all `k`.

The `plot` command simply draws straight line segments between consecutive
points `(x[k], y[k])`, but by choosing sufficiently many points the resulting
polygonal arc looks like a smooth cure to the naked eye.

**Exercise.** Plot $y=\sin(x)$ again, but this time use only $11$ points
instead of $201$.

You can modify the plot style using keyword arguments. For example,
```
plot(x, y, linestyle=:dash)
```
produces a dashed curve instead of a solid one.  Other possible line styles
include `:solid` (the defaut), `:dot`, `:dashdot` and `:dashdotdot`.  

The `plotattr` function is useful for looking up plot attributes.  For 
example,
```
plotattr("linestyle")
```
lists the available line styles, and also lists the accepted abbreviations
`ls`, `s` and `style`.  For instance, to save typing we could do
```
plot(x, y, ls=:dash)
```

If we call `plotattr` with no argument,
```
plotattr()
```
then `julia>` prompt changes to `>`, and you can search for possible
attributes.  Try typing `line` to get a list including `linecolor`. 
Type Ctrl-D (as the first character on a new line) to get back to the 
`julia>` prompt, and then try
```
plot(x, y, linecolor=:red)
```

As well as plotting curves, you can also plot discrete data using a variety
of different marker symbols using the `scatter` function.  For example,
```
x = range(1, 5, length=9)
y = exp.(-x/2) + 2 * sin.(40x)
scatter(x, y, markershape=:circle, markercolor=:green)
```

## Plot Annotations

When creating more elaborate plots with Julia, you will usually want to 
type commands into a `.jl` file rather than directly in the REPL.  Open
a new editor pane in VSCode, type the following lines of code and save to 
a file `sine_plot.jl`.
```
x = range(0, 2π, length=201)
y = sin.(x)
plot(x, y, 
     xlabel="x", ylabel="y", 
     title="The Graph of y = sin(x)",
     legend=false)
savefig("annotated_plot.png")
```
Running this program produces the plot shown below.

![Annotated plot](../resources/annotated_plot.png)

We see effect of the keyword arguments `xlabel`, `ylabel`, `title` and `legend` 
on the output of the `plot` function.

## Multiple Plots

The `Plots` documentation uses the term *series* to describe a set of $(x,y)$
data values.  You can use the `plot!` function (with an exclamation mark) to 
add an additional series to an existing plot.  Try typing the following
in the REPL, and observe how the figure changes after each line.
```
x = range(0, π, length=201)
y1 = sin.(3x)
plot(x, y1)
y2 = cos.(2x)
plot!(x, y2)
y3 = 0.5 * sin.(2x .+ π/4)
plot!(x, y3)
```





## Subplots

## Axis Tweaks

## Polar Plots and Histograms

* * *

## Summary

## Further Reading
