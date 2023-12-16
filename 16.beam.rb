def parse_input(input)
  return parse_input(input.lines) if input.is_a?(String)

  input.map(&:chomp).reject(&:empty?)
end

def add_first_beam(layout, at_y: 0, at_x: 0, direction: RIGHT)
  layout.map { _1.each_char.map { |char| [char, []] } }.tap do
    _1[at_y][at_x].last.push(direction)
  end
end

def add_first_beams(layout)
  [
    *layout[0].each_char.with_index.map do |_, i|
      [add_first_beam(layout, at_y: 0, at_x: i, direction: DOWN), 0, i]
    end,
    *layout.last.each_char.with_index.map do |_, i|
      [add_first_beam(layout, at_y: layout.size - 1, at_x: i, direction: UP), layout.size - 1, i]
    end,
    *layout.each_with_index.map do |_, i|
      [add_first_beam(layout, at_y: i, at_x: 0, direction: RIGHT), i, 0]
    end,
    *layout.each_with_index.map do |row, i|
      [add_first_beam(layout, at_y: i, at_x: row.size - 1, direction: LEFT), i, row.size - 1]
    end
  ]
end

UP = [-1, 0].freeze
DOWN = [1, 0].freeze
LEFT = [0, -1].freeze
RIGHT = [0, 1].freeze

def count_energized(layout)
  layout.map do |row|
    row.count { |_char, beams| !beams.empty? }
  end.sum
end

def simulate_beam!(layout, start_y, start_x)
  beam_locations = [[start_y, start_x]]

  while beam_locations.any?
    new_beams = []
    beam_locations.each do |y, x|
      tile, beams = layout[y][x]

      beams.each do |beam|
        dy, dx = beam
        new_beam = case [tile, [dy, dx]]
        in [".", _] | ["|", UP] | ["|", DOWN] | ["-", LEFT] | ["-", RIGHT]
          [[[y + dy, x + dx], [dy, dx]]]
        in ["/", DOWN] | ["\\", UP]
          [[[y, x - 1], LEFT]]
        in ["/", RIGHT] | ["\\", LEFT]
          [[[y - 1, x], UP]]
        in ["/", UP] | ["\\", DOWN]
          [[[y, x + 1], RIGHT]]
        in ["/", LEFT] | ["\\", RIGHT]
          [[[y + 1, x], DOWN]]
        in ["|", LEFT] | ["|", RIGHT]
          [
            [[y - 1, x], UP],
            [[y + 1, x], DOWN]
          ]
        in ["-", DOWN] | ["-", UP]
          [
            [[y, x - 1], LEFT],
            [[y, x + 1], RIGHT]
          ]
        end
        new_beams.push(*new_beam)
      end
    end

    new_beams.uniq!

    new_beams.select! do |beam_location, _direction|
      y, x = beam_location
      0 <= y && y < layout.size && 0 <= x && x < layout[y].size
    end

    new_beams.reject! do |beam_location, direction|
      y, x = beam_location
      layout[y][x].last.include?(direction)
    end

    new_beams.each do |beam_location, direction|
      y, x = beam_location
      layout[y][x].last.push(direction)
    end

    beam_locations = new_beams.map { |beam, _dir| beam }
  end
  layout
end

input = ARGF.readlines

parse_input(input)
  .then { add_first_beams(_1) }
  .map { simulate_beam!(_1, _2, _3) }
  .map { count_energized(_1) }
  .max
  .display
