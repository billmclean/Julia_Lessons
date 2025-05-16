---
title: Lesson 5\. Plotting
---

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
* incorporate axis labels, a title, a grid and a legend;
* create some more specialised plots such a polar plots and histograms.

A later lesson will cover more advanced plotting techniques.

* * *

## The `plot` Command

Start VSCode, do Ctrl+Shift+P to access the Command Palette and type
`Start REPL`.  At the `julia>` prompt, type
```
using Plots
```
If `Plots` is not yet installed on your PC, type `y` so that Julia will
download and install the package and its dependencies.  (`Plots` has quite
a lot of dependencies, so the installation might take some time.)  

Type the following commands to create a simple plot of the sine function.
```
x = range(0, 2π, 201)
y = sin.(x)
plot(x, y)
```
You should see a plotting pane open in VSCode, looking like the following
screenshot.  If you are running Julia in a terminal instead of in VSCode,
then you might have to type the command
```
gui()
```
before the plot window opens.

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
polygonal arc looks like a smooth cure to the naked eye.  Keep in mind that
your computer's display has a limited resolution: using more x-values
will produce a smoother graph, but there is no benefit in having
more x-values than the number of pixels across the width of the plot window.

**Exercise.** Plot $y=\sin(x)$ again, but this time use only $11$ points
instead of $201$.

You can modify the plot style using keyword arguments. For example,
```
plot(x, y; linestyle=:dash)
```
produces a dashed curve instead of a solid one.  Other possible line styles
include `:solid` (the default), `:dot`, `:dashdot` and `:dashdotdot`.  

The `plotattr` function is useful for looking up plot attributes.  For 
example,
```
plotattr("linestyle")
```
lists the available line styles, and also lists the accepted abbreviations
`ls`, `s` and `style`.  For instance, to save typing we could do
```
plot(x, y; ls=:dash)
```

If we call `plotattr` with no argument,
```
plotattr()
```
then `julia>` prompt changes to `>`, and you can search for possible
attributes.  Try typing `line` to get a list including `linecolor`. 
Type Enter to get back to the `julia>` prompt, and then try
```
plot(x, y; linecolor=:red)
```

As well as plotting curves, you can also plot discrete data using a variety
of different marker symbols using the `scatter` function.  For example,
```
x = range(1, 5, 9)
y = exp.(-x/2) + 2sin.(40x)
scatter(x, y; markershape=:circle, markercolor=:green)
```

## Plot Annotations

When creating more elaborate plots with Julia, you will usually want to 
type commands into a `.jl` file rather than directly in the REPL.  Open
a new editor pane in VSCode, type the following lines of code and save to 
a file `sine_plot.jl`.
```
using Plots
x = range(0, 2π, 201)
y = sin.(x)
plot(x, y;
     xlabel="x", ylabel="y", 
     title="The Graph of y = sin(x)",
     legend=false)
```
Running this program produces the plot shown below.

![Plot annotations](../resources/annotated_plot.png)

We see effect of the keyword arguments `xlabel`, `ylabel`, `title` and `legend` 
on the output of the `plot` function.  The code would work if you omitted
the first line (`using Plots`) because `Plots` was loaded earlier in the
same REPL session.  However, this line is needed if you want to ensure the 
code will work in any future REPL session (when you might not have already
loaded `Plots`).

## Multiple Plots

The `Plots` documentation uses the term *series* to describe a set of $(x,y)$
data values.  You can use the `plot!` function (with an exclamation mark) to 
add an additional series to an existing plot.  Try typing the following
in the REPL, and observe how the figure changes after each line.
```
x = range(0, π, 201)
y1 = sin.(3x)
plot(x, y1)
y2 = cos.(2x .- π)
plot!(x, y2)
y3 = 0.5 * sin.(2x .+ π/4)
plot!(x, y3)
```
The final version of the plot should be as shown below.

![Multiple series](../resources/multiple_series.png)

## Saving to a File

The `savefig` function lets you save a copy of your plot as `.png`
or `.pdf` file:
```
savefig("myplot.png")
```
or
```
savefig("myplot.pdf")
```

## Subplots

We have seen how to plot multiple series on a single pair of axes.  It is
also possible to display several *subplots*, that is, to display several
series on different pairs of axes.  Type the following lines into a file
`my_subplots.jl` and then run the code.
```
using Plots
x1 = range(-4, 4, 201)
y1 = exp.(-x1.^2)
p1 = plot(x1, y1; legend=false)
x2 = range(0, 10, 201)
y2 = log.(x2) .* sinpi.(x2)
p2 = plot(x2, y2; legend=false)
plot(p1, p2; layout=(2, 1), size=(750,500))
```
Here, we create two `Plot` objects `p1` and `p2`, and then plot them
using the `plot` command with the `layout` keyword argument.  In this case,
the `(2,1)` layout means that the subplots appear in a $2\times1$ grid,
as shown below.  Also, we used the `size` keyword to increase the size of 
the plot by 25% from the default of $600\times400$ to $750\times500$.

![Subplots](../resources/my_subplots.png)

## Axis Tweaks

We can adjust the location and labels of the tick marks on an axis using
the `xticks` and `yticks` keyword arguments.  For example,
```
x = range(0, 2π, 201)
y = sin.(x)
plot(x, y; legend=false,
     xticks = ([0, π/2, π, 3π/2, 2π], ["0", "π/2", "π", "3π/2", "2π"]))
```
produces

![Adjusting ticks marks and labels](../resources/xticks_example.png)

Manual adjustment of axis limits is also possible, using the `xlims` and
`ylims` keywords.  Consider
```
x = range(0, 2, 201)
y = 1 .+ 0.1 * cospi.(x)
p1 = plot(x, y; legend=false)
p2 = plot(x, y; ylims=(0, 1.5), legend=false)
plot(p1, p2; layout=(1, 2))
```
which produces

![Adjusting the limits on the y-axis](../resources/ylims_example.png)

## Polar Plots and Histograms

Let $r$ and $\theta$ denote the usual polar coordinates so that
$$
x=r\cos\theta\quad\text{and}\quad y=r\sin\theta.
$$
We can plot the curve $r=1+\cos\theta$ for $-\pi\le\theta\le\pi$ as follows.
```
θ = range(-π, π, 201)
r = 1 .+ cos.(θ)
plot(θ, r, projections=:polar, legend=false)
```
The output looks like

![A polar plot](../resources/polar_example.png)

A histogram is often useful when investigating statistical data.  For
example, suppose we take 1,000 random numbers from a standard normal 
distribution.
```
x = randn(1000)
histogram(x, bins=range(-4, 4, length=17))
```
You can also normalise the histogram so that its area equals 1 and is
therefore a probability distribution: the commands
```
normal_pdf(x) = exp(-x.^2/2) / sqrt(2π)
sample = randn(1000)
histogram(sample, bins=range(-4, 4, length=17), 
               normalized=:pdf, label="Sample PDF")
plot!(normal_pdf, label="Std Normal PDF", linewidth=2)
```
produce the following output.

![A histogram](../resources/histogram_example.png)

* * *

## Summary

In this lesson, we saw how to

* use the `range` function to generate a range of $x$-values in a 
chosen interval;
* use the `plot` command to display a curve;
* use the `scatter` command to display discrete data values;
* modify the line style and colour of a plot;
* annotate a plot with axis labels and a title;
* draw multiple plot curves on the same axes;
* save a plot to a file;
* draw multiple subplots in the plot window;
* draw polar plots and histograms.

## Further Reading

The `Plots` package has
[many other features](https://docs.juliaplots.org/stable/), some of which 
we will cover in a later lesson.  A variety of specialised plot types can
be generated using the 
[`StatsPlots`](https://docs.juliaplots.org/stable/generated/statsplots/)
package.

[**Back to All Lessons**](../index.html)
