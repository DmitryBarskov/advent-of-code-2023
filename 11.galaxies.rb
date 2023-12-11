def parse_galaxies(observations)
  empty_rows = []
  empty_columns = Set.new(0...observations.first.chomp.size)
  galaxies = []
  observations.each_with_index do |observation, row|
    row_is_empty = true
    observation.each_char.each_with_index do |symbol, col|
      if symbol == '#'
        row_is_empty = false
        empty_columns.delete(col)
        galaxies.push([row, col])
      end
    end
    empty_rows.push(row) if row_is_empty
  end
  { empty_rows:, empty_columns:, galaxies: }
end

def count_space(galaxies:, empty_rows:, empty_columns:)
  total_space = 0
  galaxies.size.times do |i|
    ((i+1)...galaxies.size).each do |j|
      total_space += space_between(galaxies[i], galaxies[j], empty_rows:, empty_columns:)
    end
  end
  total_space
end

EMPTY_SPACE_EXPANSION_COEFFICIENT = 1_000_000

def space_between(galaxy1, galaxy2, empty_rows:, empty_columns:)
  galaxy1 => [r1, c1]
  galaxy2 => [r2, c2]
  
  [r1, r2].sort => [r1, r2]
  [c1, c2].sort => [c1, c2]

  r2 - r1 + c2 - c1 + (EMPTY_SPACE_EXPANSION_COEFFICIENT - 1) * (empty_rows.count { r1 < _1 && _1 < r2 } + empty_columns.count { c1 < _1 && _1 < c2 })
end

input = '...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....'.lines

input = ARGF.readlines

count_space(**parse_galaxies(input)).display
