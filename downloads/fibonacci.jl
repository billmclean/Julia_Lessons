N = 20
F = Vector{Int64}(undef, N)
F[1] = F[2] = 1
for n = 3:N
    F[n] = F[n-1] + F[n-2]
end
println("The first $N Fibbonaci numbers:")
display(F)