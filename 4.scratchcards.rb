# frozen_string_literal: true

ARGF.reduce(0) do |score, card|
  _, winning_numbers, card_numbers = card.chomp.split(/: *|\| */)
  winning_numbers = Set.new(winning_numbers.split(/ +/))
  card_winning_numbers = card_numbers.split(/ +/).count { winning_numbers.include?(_1) }

  score + (1 << card_winning_numbers).div(2)
end.display
