def parse_graph(input_lines)
  graph = {}
  input_lines.each_with_index do |line, i|
    line.chomp.each_char.each_with_index do |cell, j|
      case cell
      when "|"
        connected_cells = [
          [i - 1, j],
          [i + 1, j]
        ]
      when "-"
        connected_cells = [
          [i, j - 1],
          [i, j + 1]
        ]
      when "L"
        connected_cells = [
          [i - 1, j],
          [i, j + 1]
        ]
      when "J"
        connected_cells = [
          [i - 1, j],
          [i, j - 1]
        ]
      when "7"
        connected_cells = [
          [i + 1, j],
          [i, j - 1]
        ]
      when "F"
        connected_cells = [
          [i + 1, j],
          [i, j + 1]
        ]
      when "S"
        connected_cells = [
          [i + 1, j],
          [i - 1, j],
          [i, j + 1],
          [i, j - 1]
        ]
        graph[:start] = [i, j]
      when "."
        connected_cells = []
      end

      graph[[i, j]] ||= []
      graph[[i, j]].push(*connected_cells)
    end
  end
  graph
end

def replace_start_in_maze!(maze, graph)
  start = graph[:start]
  start => [start_y, start_x]
  if [graph[[start_y - 1, start_x]], graph[[start_y + 1, start_x]]].all? { _1&.include?(start) }
    maze[start_y][start_x] = "|"
    graph[start] = [graph[[start_y - 1, start_x]], graph[[start_y + 1, start_x]]]
  elsif [graph[[start_y, start_x - 1]], graph[[start_y, start_x + 1]]].all? { _1&.include?(start) }
    maze[start_y][start_x] = "-"
    graph[start] = [graph[[start_y, start_x - 1]], graph[[start_y, start_x + 1]]]
  elsif [graph[[start_y, start_x - 1]], graph[[start_y - 1, start_x]]].all? { _1&.include?(start) }
    maze[start_y][start_x] = "J"
    graph[start] = [graph[[start_y, start_x - 1]], graph[[start_y - 1, start_x]]]
  elsif [graph[[start_y, start_x + 1]], graph[[start_y + 1, start_x]]].all? { _1&.include?(start) }
    maze[start_y][start_x] = "F"
    graph[start] = [graph[[start_y, start_x + 1]], graph[[start_y + 1, start_x]]]
  elsif [graph[[start_y, start_x + 1]], graph[[start_y - 1, start_x]]].all? { _1&.include?(start) }
    maze[start_y][start_x] = "L"
    graph[start] = [graph[[start_y, start_x + 1]], graph[[start_y + 1, start_x]]]
  elsif [graph[[start_y, start_x - 1]], graph[[start_y + 1, start_x]]].all? { _1&.include?(start) }
    maze[start_y][start_x] = "7"
    graph[start] = [graph[[start_y, start_x - 1]], graph[[start_y + 1, start_x]]]
  end
end

def find_cycles(graph)
  cycles = []
  stack = []
  graph[graph[:start]].each { stack.push([_1, [graph[:start]]]) }
  until stack.empty?
    current_node, path = stack.pop
    if current_node == graph[:start]
      cycle = [*path, current_node]
      p("New cycle found! #{cycle.length}")
      cycles.push(cycle)
      next
    end
    next if path.include?(current_node)

    graph.fetch(current_node, []).each do |adjacent|
      stack.push([adjacent, [*path, current_node]])
    end
  end

  cycles
end

def opposite_corners?(corner1, corner2)
  return false if corner1.nil? || corner2.nil?

  case [corner1, corner2]
  when %w[F J] then true
  when %w[L 7] then true
  else false
  end
end

PIPES = %w[L J 7 F |].freeze

def count_points_inside_cycle(cycle, maze)
  borders = cycle.group_by { |y, x| y }.transform_values { |points| points.map { |y, x| x } }
  points_inside = 0

  borders.each do |y, x_borders|
    inside = false
    previous_border = nil
    (0...maze[y].chomp.size).each do |x|
      if x_borders.include?(x) && PIPES.include?(maze[y][x])
        inside = !inside
        if opposite_corners?(previous_border, maze[y][x])
          inside = !inside
        end
        previous_border = maze[y][x]
      elsif x_borders.include?(x)
        # travelling along horizontal pipe
      elsif inside
        points_inside += 1
      end
    end
  end

  points_inside
end

def find_largest_cycle(graph)
  cycles = find_cycles(graph)
  p cycles
  cycles.max_by(&:length)
end

maze = ARGF.readlines
graph = parse_graph(maze)
largest_cycle = find_largest_cycle(graph)
puts largest_cycle.length

replace_start_in_maze!(maze, graph)

puts count_points_inside_cycle(largest_cycle, maze)
