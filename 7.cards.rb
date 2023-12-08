class Hand
  CARDS = %w[A K Q T 9 8 7 6 5 4 3 2 J].freeze

  # @param {String} cards is five chars of
  # A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, or 2
  def initialize(cards)
    @cards = cards
  end

  def <=>(other)
    (combination_rank <=> other.combination_rank).nonzero? ||
      (card_ranks <=> other.card_ranks)
  end

  def to_s = @cards

  protected

  def combination_rank
    case combination
    when :five_of_a_kind then 10
    when :four_of_a_kind then 9
    when :full_house then 8
    when :three_of_a_kind then 7
    when :two_pair then 6
    when :one_pair then 5
    when :high_card then 4
    else
      raise "Handle combination #{combination}!"
    end
  end

  # Five of a kind, where all five cards have the same label: AAAAA
  # Four of a kind, where four cards have the same label and one card has a different label: AA8AA
  # Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
  # Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
  # Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
  # One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
  # High card, where all cards' labels are distinct: 23456
  def combination
    cards_count = count_cards.values
    return :five_of_a_kind if cards_count.include?(5)
    return :four_of_a_kind if cards_count.include?(4)
    return :full_house if cards_count.include?(3) && cards_count.include?(2)
    return :three_of_a_kind if cards_count.include?(3)
    return :two_pair if cards_count.count(2) == 2
    return :one_pair if cards_count.include?(2)

    :high_card
  end

  def card_ranks
    @card_ranks ||= @cards.each_char.map { card_to_i(_1) }
  end

  def count_cards
    counts = @cards.each_char.each_with_object(Hash.new(0)) { |card, c| c[card] += 1 }
    return counts unless counts.key?("J")
    return counts if counts.keys == ["J"]

    top_card, = counts.max_by { |card, count| card == 'J' ? 0 : count }
    counts[top_card] += counts.delete("J")
    counts
  end

  def card_to_i(card)
    20 - CARDS.index(card)
  end
end

ARGF
  .map do |line|
    line.chomp.split => cards, bid
    [Hand.new(cards), bid.to_i]
  end
  .sort_by { |a| a[0] }
  .zip(1..)
  .map { |hand_and_bid, rank| hand_and_bid[1] * rank }
  .sum
  .display
