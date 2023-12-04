# frozen_string_literal: true

def with_adjacent(enumerable)
  Enumerator.new do |enumerator|
    previous_items = [nil]
    enumerable.each do |item|
      previous_items.push(item)
      previous_items = previous_items.last(3)
      enumerator.yield(*previous_items) if previous_items.size > 2
    end
    previous_items.push(nil)
    enumerator.yield(*previous_items.last(3))
  end
end

def symbol?(str, idx)
  !str.nil? && !str[idx].nil? && str[idx] != '.' && str[idx].match?(/\D/)
end

def count_numbers(str, index)
  return 1 if str[index].match?(/\d/)

  count = 0
  count += 1 if index.positive? && str[index - 1].match?(/\d/)
  count += 1 if str[index + 1]&.match?(/\d/)
  count
end

def find_numbers(str, index)
  return [find_number(str, index)] if str[index].match?(/\d/)

  numbers = []
  numbers.push(find_number(str, index - 1)) if index.positive? && str[index - 1].match?(/\d/)
  numbers.push(find_number(str, index + 1)) if index.positive? && str[index + 1].match?(/\d/)
  numbers
end

def find_number(str, index)
  l = index
  r = index
  l -= 1 while l >= 0 && str[l].match?(/\d/)
  l += 1
  r += 1 while r < str.length && str[r].match?(/\d/)
  r -= 1

  str[l..r].to_i
end

with_adjacent(ARGF).flat_map do |prev_line, curr_line, next_line|
  next [] if curr_line.index('*').nil?

  star_indices = []
  star_index = 0
  while star_index
    star_index = curr_line.index('*', star_index + 1)
    break if star_index.nil?

    numbers_around = [prev_line, curr_line, next_line].reduce(0) do |sum, line|
      next sum if line.nil?

      sum + count_numbers(line, star_index)
    end
    star_indices.push(star_index) if numbers_around == 2
  end

  star_indices.map do |star|
    part_numbers = [prev_line, curr_line, next_line].compact.flat_map { find_numbers(_1, star) }
    puts part_numbers.join('*')
    part_numbers.inject(:*)
  end
end.sum.display
puts
