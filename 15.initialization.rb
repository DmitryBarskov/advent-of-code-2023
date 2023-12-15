def hash_from_string(string)
  string.codepoints.reduce(0) do |current_value, code|
    (current_value + code) * 17 % 256
  end
end

def parse_input(lines)
  return parse_input(lines.lines) if lines.is_a?(String)

  lines.map(&:chomp).reject(&:empty?).first.split(",")
end

def initialize_boxes(sequences)
  sequences.reduce(Hash.new({})) do |boxes, sequence|
    sequence.match(/(\w+)([-=])(\d+)?/) => label, operation, focal_length
    box = hash_from_string(label)
    if operation == "="
      boxes.merge(box => boxes[box].merge(label => focal_length.to_i))
    else
      boxes.merge(box => boxes[box].except(label))
    end
  end
end

def focusing_power(boxes)
  boxes.flat_map do |box_number, lenses|
    lenses.values.each_with_index.map do |focal_length, slot|
      focal_length * (slot + 1)
    end * (box_number + 1)
  end.sum
end

input = ARGF.readlines
puts parse_input(input).then { initialize_boxes(_1) }.then { focusing_power(_1) }
