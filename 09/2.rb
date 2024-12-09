content = File.open('2.in') { |f| f.readline.strip }
# puts content.length
file = []
hole = []
memory = []
is_file = true
start = 0
index = 0

content.split('').each do |ch|
  n = Integer(ch)
  if is_file
    file.push([index, n])
    n.times do
      memory.push(start)
      index += 1
    end
    start += 1
  else
    hole.push([index, n])
    n.times do
      memory.push(-1)
      index += 1
    end
  end
  is_file = !is_file
end

(file.length - 1).downto(0).each do |j|
  file_index = file[j][0]
  file_size = file[j][1]
  hole.each_with_index do |s, i|
    index = s[0]
    size = s[1]
    next unless file_size <= size && file_index > index

    fc = memory[file_index]
    file_size.times do |m|
      memory[file_index + m] = -1
      memory[index + m] = fc
    end
    if size == file_size
      hole.delete_at(i)
    else
      hole[i] = [index + file_size, size - file_size]
    end
    break
  end
end

ans = 0

memory.each_with_index do |w, i|
  # puts "#{w} , #{i}"
  ans += w * i if w >= 0
end

puts ans
