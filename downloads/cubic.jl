using Plots

x = range(-2, 2, 101)
y = x.^3 - 2x .+ 1
plot(x, y; title="Cubic", label="")
savefig("cubic.png")
