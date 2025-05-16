---
title: Lesson 10\. More on Graphics
---

## Visualisation of Multidimensional Functions

The `plot` function suffices for graphing simple curves of the form $y=f(x)$.
For more complex plots involving functions of several variables or 
vector-valued functions, the `Plots` package provides additional functions.

## Objectives

This final lesson describes a range of additional plot types provided by
`Plots`.  By the end of this lesson, you will be able to create

* a parametric plot;
* a plot with a log scale on the x- or y-axis, or both;
* a contour plot or a surface plot of a scalar-valued function of 
two variables;
* a quiver plot of a two-dimensional vector field;

Recall that the `savefig` function is used to save a figure to a graphics
file, such as a `.png` or `.jpg` file.

* * *

## Parametric Plots

In this and the following section, our examples will assume that the 
command
```
using Plots, LaTeXStrings
```
has been executed beforehand so that the necessary graphics functions are
available, as well as support for LaTeX.

The basic `plot` command can be used to plot a parametric curve, as in the
following example that plots an ellipse.
```
t = range(-1, 1, 301)
x = 3 * cospi.(t)
y = sinpi.(t)
plot(x, y; xlabel="x", ylabel="y", 
     label="ellipse", aspect_ratio=:equal)
```
The output is shown below.

![Parametric plot of an ellipse](../resources/ellipse.png)

By setting `aspect_ratio=:equal` we ensure that the scale on the x-axis
is the same as the scale on the y-axis.

## Logarithmic Scales

If the y-values of a plot vary over several orders of magnitude, then a log
scale on the y-axis will often allow the behaviour of the curve to be seen
more clearly.  In the next example, we set `yscale=:log10` in the lower
subplot.  Note also the `L"..."` syntax for a LaTeX string.
```
x = range(0, 200, 301)
y1 = 1 ./ (1 .+ x).^2
y2 = 1 ./ (1 .+ x).^4
p1 = plot(x, [y1 y2]; label=[L"(1+x)^{-2}"  L"(1+x)^{-4}"])
p2 = plot(x, [y1 y2]; yscale=:log10, xlabel=L"x",
          label=[L"(1+x)^{-2}"  L"(1+x)^{-4}"])
plot(p1, p2; layout=(2, 1))
```
The output is as follows.

![Plotting with a log scale](../resources/semilogy.png)

We can also set `xscale=:log10` to use a log scale on the x-axis.

## Contour Plots

Recall that a *contour* or *level set* of a real-valued function $f(x,y)$ is a
curve of the form $f(x,y)=c$ for some constant $c$.  A standard way of
visualising $f$ is to plot the family of contours determined by a sequence
of values for $c$.

If $f(x,y)=x^3-3x+y^2$ then we can create a contour plot of $f$ as follows.
```
f(x, y) = x^3 - 3x + y^2
x = range(-3, 3, 250)
y = range(-4, 4, 200)
z = f.(x', y)
contour(x, y, z; xlabel=L"x", ylabel=L"y", levels=20)
```
Here, `z` is a $200\times250$ matrix with `z[i,j] = f(x[j], y[i])`, since 
`x'` is $1\times250$ and `y` has length $200$.  The output is shown below.

![A contour plot](../resources/contour.png)

Replacing `contour` with `contourf` produces a *filled* contour plot.

![A filled contour plot](../resources/contourf.png)

## Surface Plots

Another way to visualise a real-valued function $f(x, y)$ is to plot
the graph, $z=f(x,y)$, in xyz-space.  With the vectors `x`, `y` and `z` 
defined as in the contour plot example above,
```
surface(x, y, z; xlabel=L"x", ylabel=L"y", zlabel=L"z")
```
produces the following output.

![A surface plot](../resources/surface.png)

The `view_angle` attribute is a tuple consisting to two angles, the
*azimumth* and *elevation*, that define the direction from which the
plot is viewed.  Azimuth is measured counterclockwise from the 
negative y-axis in the xy-plane.  Elevation is the angle above the
xy-plane.  Both are measured in degrees, and the default `view_angle` is
`(30,30)`.  In the command
```
surface(x, y, z; xlabel=L"x", ylabel=L"y", zlabel=L"z",
        view_angle=(135,10))
```
we change the azimuth to $135$ degrees and the elevation to $10$ degrees,
resulting in the following plot.

![View from another angle](../resources/surface_view_angle.png)

## Quiver Plots

A *quiver plot* is used to visualise a 2D vector field, that is, a
vector valued function 
$$
f(x, y)=\begin{bmatrix}u(x,y)\\ v(x,y)\end{bmatrix}.
$$
In the example below, $u=\sin y$ and $v=-x$.
```
x = range(-1, 1, 15)
y = range(-π, π, 15)
X = [ x[j] for i = 1:15, j=1:15 ]
Y = [ y[i] for i = 1:15, j=1:15 ]
U = sin.(Y)
V = -X
scale = 0.1
sU = scale * U
sV = scale * V
quiver(X, Y; quiver=(sU, sV))
```
At each point `(X[i,j], Y[i,j])`, an arrow is drawn from this point
to `(X[i,j] + sU[i,j], Y[i,j] + sV[i,j])`.

![A quiver plot](../resources/quiverplot.png)

## Alternative Graphics Backends

The `Plots` package relies on a software *backend* to create its graphical
output.  The default backend is called [`GR`](https://gr-framework.org/) and 
is the one most likely to work reliably out of the box.  Usually the output 
looks pretty much the same for any choice of backend, but sometimes a 
particular backend might offer extra features.  For example, the 
[`Plotly`](https://plotly.com/graphing-libraries/) backend supports mouse 
interaction to change the viewing angle in a 3D plot.  If you install the 
`Plotly` package, do
```
using Plots
plotly()
```
and then create a surface plot as described above, then the plot should open 
in your default web browser, and you will be able to adjust the viewing angle 
with your mouse.  The [`PythonPlot`](https://github.com/JuliaPy/PythonPlot.jl)
backend relies on [matplotlib](https://matplotlib.org/), the well-known
Python graphics library.  Doing
```
using Plots
pythonplot()
```
changes the backend to `PythonPlot`, which also supports mouse interaction
for 3D plots.

* * *

## Summary

In this lesson, we have seen how the `Plots` package is used to produce a

* parametric plot;
* log scale plot;
* contour plot;
* surface plot;
* quiver plot.

## Further Reading

The [`Plots` documentation](https://docs.juliaplots.org/latest/) includes a
[gallery](https://docs.juliaplots.org/latest/gallery/gr/) of examples that
you can look through if you are not sure how to go about creating a
particular kind of plot or achieving a particular effect.  The different
[backends](https://docs.juliaplots.org/stable/backends/) are also discussed.

[**Back to All Lessons**](../index.html)
