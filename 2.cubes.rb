# frozen_string_literal: true

CUBES = { 'red' => 12, 'green' => 13, 'blue' => 14 }.freeze

ARGF.reduce(0) do |game_ids_sum, line|
  game_id, *reaches = line.split(/: |, |; /)
  impossible_move = reaches.map(&:split).find { |cubes, color| cubes.to_i > CUBES[color] }
  next game_ids_sum if impossible_move

  game_ids_sum + game_id.split.last.to_i
end.display
