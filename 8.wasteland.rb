def parse_turns(turns_input)
  turns_input.map do |line|
    node, turns_str = line.chomp.split(" = ")
    turns_str.split(/, +|\b/) => "(", *turns, ")"

    [node, 'L' => turns[0], 'R' => turns[1]]
  end.to_h
end

def parse_input(input_lines)
  input_lines => instructions, "\n", *turns

  { instructions: instructions.chomp,
    turns: parse_turns(turns) }
end

def count_steps(instructions:, turns:)
  begin_nodes = turns.keys.select { _1.end_with?("A") }.first
  end_nodes   = turns.keys.select { _1.end_with?("Z") }.first

  instructions_iterator = instructions.each_char.cycle

  current_node = begin_node
  steps = 0
  while current_node != end_node
    instruction = instructions_iterator.next
    
    current_node = turns[current_node][instruction]

    steps += 1
  end
  steps
end
puts count_steps(**parse_input(ARGF.readlines))
