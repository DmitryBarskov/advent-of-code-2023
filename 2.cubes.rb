# frozen_string_literal: true

ARGF.reduce(0) do |power_sum, line|
  game_id, *reaches = line.split(/: |, |; /)
  minimal_bag = reaches.each_with_object('red' => 0, 'green' => 0, 'blue' => 0) do |cubes, bag|
    amount, color = cubes.split
    bag[color] = [amount.to_i, bag[color]].max
  end
  power_sum + minimal_bag.values.reduce(:*)
end.display
