local file = io.open("1.in", "r")

local content = {}
for line in file:lines() do
	table.insert(content, line)
end
local m = #content
local n = #content[1]

function get(content, x, y)
	return string.sub(content[x], y, y)
end

local xd = { 1, 0, -1, 0 }
local yd = { 0, 1, 0, -1 }

function dfs(content, x, y)
	local current_val = tonumber(get(content, x, y))
	if current_val == 9 then
		return 1
	end

	res = 0
	for k = 1, 4 do
		local dx = x + xd[k]
		local dy = y + yd[k]
		if dx >= 1 and dx <= m and dy >= 1 and dy <= n then
			local next_val = tonumber(get(content, dx, dy))
			if next_val == current_val + 1 then
				res = res + dfs(content, dx, dy, vis, res)
			end
		end
	end
	return res
end

local ans = 0

for x = 1, m do
	for y = 1, n do
		if get(content, x, y) == "0" then
			ans = ans + dfs(content, x, y, vis, res)
		end
	end
end

print(ans)
