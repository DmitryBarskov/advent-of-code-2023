# frozen_string_literal: true


all_cards = ARGF.each_with_object([]) do |card, all_cards|
  card_id, winning_numbers, card_numbers = card.chomp.split(/: *|\| */)
  card_id = card_id.split(/ +/).last.to_i
  winning_numbers = Set.new(winning_numbers.split(/ +/))
  card_winning_numbers = card_numbers.split(/ +/).count { winning_numbers.include?(_1) }

  all_cards[card_id] = card_winning_numbers
end

copies = all_cards.map { _1.nil? ? 0 : 1 }

(0...(all_cards.length)).each do |i|
  next if copies[i].zero?

  all_cards[i].times do |j|
    next if copies[i + j + 1].nil?
    copies[i + j + 1] += copies[i]
  end
end

puts copies.sum
