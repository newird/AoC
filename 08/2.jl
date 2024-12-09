using Base: allindices!

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


function check!(x1, x2, y1, y2)
  dx = x2 - x1
  dy = y2 - y1

  x = x1
  y = y1
  while x >= 1 && x <= m && y >= 1 && y <= n
    if grid[x][y] != '%'
      grid[x][y] = '%'
      global ans += 1
    end
    x -= dx
    y -= dy
  end

  x = x2
  y = y2
  while x >= 1 && x <= m && y >= 1 && y <= n
    if grid[x][y] != '%'
      grid[x][y] = '%'
      global ans += 1
    end
    x += dx
    y += dy
  end
end


ans = 0
for (key, value) in mp
  if length(value) == 1
    x, y = value[1]
    global ans += 1
  end
  for i in 1:length(value)
    for j in i+1:length(value)
      x1, y1 = value[i]
      x2, y2 = value[j]
      check!(x1, x2, y1, y2)
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
