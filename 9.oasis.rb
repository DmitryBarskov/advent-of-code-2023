_input = "0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45"

def next_in_sequence(seq)
  return 0 if seq.all?(&:zero?)

  diff_seq = seq.each_cons(2).map { |a, b| b - a }
  diff = next_in_sequence(diff_seq)
  seq.last + diff
end

def parse_sequence(line) = line.split.map(&:to_i)

ARGF.readlines
  .map { parse_sequence(_1) }
  .map { next_in_sequence(_1) }
  .tap { p(_1) }
  .sum
  .display
