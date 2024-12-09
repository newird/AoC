f = File.open('1.in')
content = f.readline.strip
a = []
start = 0
dot = false
content.split('').each do |ch|
  for _ in 1..Integer(ch) do
    if dot
      a.push(-1)
    else
      a.push(start) end
  end
  if dot
    dot = false
  else
    dot = true
    start += 1
  end
end

i = 0
j = a.length - 1

while i < j
  i += 1 while a[i] != -1 && i < j
  j -= 1 while a[j] == -1 && i < j
  t = a[i]
  a[i] = a[j]
  a[j] = t
end

ans = 0

a.each_with_index do |c, i|
  ans += c * i if c != -1
end

puts ans
