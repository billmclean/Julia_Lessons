s = 0.0
for k = 1:10
    global s += 1/k^2
end
println("The sum equals ", s)
