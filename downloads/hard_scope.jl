s = 0.0

function add_it_up(n)
    for k = 1:n
	s += 1/k^2
    end
end

add_it_up(10)
println("The sum equals ", s)
