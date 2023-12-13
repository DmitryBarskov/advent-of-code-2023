def parse_patterns(input)
  input_lines = input.is_a?(Enumerable) ? input : input.lines
  input_lines.join.split("\n\n").map do |pattern|
    pattern.lines.map(&:chomp)
  end
end

def horizontal_reflection(pattern)
  (1...pattern.size).each do |line_number|
    return line_number if horizontal_reflection_smudges(pattern, line_number).one?
  end
  nil
end

def horizontal_reflection_smudges(pattern, center)
  i = center - 1
  j = center
  smudges = []

  while i >= 0 && j < pattern.size
    smudges += row_difference(pattern[i], pattern[j]).map { [_1, i, j] }

    i -= 1
    j += 1
  end

  smudges
end

def row_difference(row1, row2)
  smudges = []
  row1.each_char.zip(row2.each_char).each_with_index do |chars, index|
    c1, c2 = chars
    smudges.push(index) if c1 != c2
  end
  smudges
end

def vertical_reflection(pattern)
  (1...pattern[0].length).each do |column_number|
    return column_number if vertical_reflection_smudges(pattern, column_number).one?
  end
  nil
end

def vertical_reflection_smudges(pattern, center)
  i = center - 1
  j = center
  smudges = []

  while i >= 0 && j < pattern[0].size
    diff = column_difference(pattern, i, j)
    smudges += diff

    i -= 1
    j += 1
  end

  smudges
end

def column_difference(matrix, i, j)
  smudges = []

  matrix.each_with_index do |row, row_index|
    if row[i] != row[j]
      smudges.push([row_index, i, j])
    end
  end

  smudges
end

def summarize(pattern)
  vertical_reflection(pattern) || horizontal_reflection(pattern)&.*(100)
end

input = ARGF.readlines

parse_patterns(input).map { summarize(_1) }.sum.display
