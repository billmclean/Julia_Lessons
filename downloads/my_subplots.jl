using Plots
x1 = range(-4, 4, length=201)
y1 = exp.(-x1.^2)
p1 = plot(x1, y1, legend=false)
x2 = range(0, 10, length=201)
y2 = log.(x2) .* sinpi.(x2)
p2 = plot(x2, y2, legend=false)
plot(p1, p2, layout=(2, 1), size=(750,500))
savefig("my_subplots.png")


