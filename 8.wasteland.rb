def parse_turns(turns_input)
  turns_input.map do |line|
    node, turns_str = line.chomp.split(" = ")
    turns_str.split(/, +|\b/) => "(", *turns, ")"

    [node, "L" => turns[0], "R" => turns[1]]
  end.to_h
end

def parse_input(input_lines)
  input_lines => instructions, "\n", *turns

  {instructions: instructions.chomp, turns: parse_turns(turns)}
end

def count_steps(instructions:, turns:, begin_node:)
  instructions_iterator = instructions.each_char.cycle
  current_node = begin_node
  steps = 0
  path = [current_node:, steps:]
  loop do
    instruction = instructions_iterator.next

    path.push(current_node:, steps:) if current_node.end_with?("Z")

    current_node = turns[current_node][instruction]
    steps += 1

    break if path.any? { _1[:current_node] == current_node }
  end
  path.last[:steps]
end

input = parse_input(ARGF.readlines)
input[:turns].keys
  .filter { _1.end_with?("A") }
  .map { |begin_node| count_steps(**input, begin_node:) }
  .reduce(&:lcm)
  .display
