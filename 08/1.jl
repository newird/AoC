using Printf

f = open("1.in", "r")
lines = readlines(f)
close(f)

m = length(lines)
n = length(lines[1])

mp = Dict{Char,Vector{Tuple{Int,Int}}}()
for i in 1:m
    for j in 1:n
        c = lines[i][j]
    if c == '.'
        continue
    end
        if !haskey(mp, c)
            mp[c] = Vector{Tuple{Int,Int}}()
        end
        push!(mp[c], (i, j))
    end
end

grid = [collect(line) for line in lines]

function check!(x, y,grid)
    if x < 1 || x > m || y < 1 || y > n
        return 0
    end
    if grid[x][y] != '%'
        grid[x][y] = '%'
        return 1
    end
    return 0
end

ans = 0
for (key, value) in mp
    if length(value) == 1
      x , y = value[1]
      global ans += 1
    end
    for i in 1:length(value)
        for j in i+1:length(value)
            x1, y1 = value[i]
            x2, y2 = value[j]
            dx = x2 - x1
            dy = y2 - y1

            global ans += check!(x1 - dx, y1 - dy,grid)
            global ans += check!(x2 + dx, y2 + dy,grid)
        end
    end
end

for line in grid
  for c in line
    print(c)
  end
  println()
end
println(ans)
