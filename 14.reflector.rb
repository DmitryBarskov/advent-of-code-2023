def parse_input(input)
  if input.is_a?(Enumerable)
    input.map(&:chomp)
  else
    parse_input(input.lines)
  end
end

def north_load(dish)
  dish.zip((dish.size..).step(-1)).map do |line, n_load|
    line.count("O") * n_load
  end.sum
end

def tilt_north!(dish)
  dish.size.times do |i|
    dish[i].size.times do |j|
      move_rock!(dish, i, j, direction: [-1, 0]) if dish[i][j] == "O"
    end
  end
end

def tilt_west!(dish)
  dish.size.times do |i|
    dish[i].size.times do |j|
      move_rock!(dish, i, j, direction: [0, -1]) if dish[i][j] == "O"
    end
  end
end

def tilt_south!(dish)
  dish.size.times.reverse_each do |i|
    dish[i].size.times do |j|
      move_rock!(dish, i, j, direction: [1, 0]) if dish[i][j] == "O"
    end
  end
end

def tilt_east!(dish)
  dish.size.times do |i|
    dish[i].size.times.reverse_each do |j|
      move_rock!(dish, i, j, direction: [0, 1]) if dish[i][j] == "O"
    end
  end
end

def spin!(dish)
  tilt_north!(dish)
  tilt_west!(dish)
  tilt_south!(dish)
  tilt_east!(dish)
end

def move_rock!(lines, row, col, direction:)
  i, j = row, col
  loop do
    i_next, j_next = [i + direction[0], j + direction[1]]

    break if i_next < 0 || j_next < 0
    break if i_next >= lines.size || j_next >= lines[i_next].size
    break if lines[i_next][j_next] != "."

    i, j = i_next, j_next
  end

  new_location = lines[i][j]
  lines[i][j] = lines[row][col]
  lines[row][col] = new_location
end

input = ARGF.readlines

dish = parse_input(input)
memo = {}

CYCLES = 1000000000
CYCLES.times do |i|
  if memo.key?(dish.hash)
    memo[:loop] = dish.hash
    break
  end
  memo[dish.hash] = i
  spin!(dish)
end

loop_start = memo.delete(:loop)
loop_end = memo.keys.last
loop_size = memo[loop_end] - memo[loop_start] + 1
((CYCLES - memo[loop_start]) % loop_size).times do
  spin!(dish)
end
p north_load(dish)
