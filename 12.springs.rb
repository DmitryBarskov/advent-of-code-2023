def parse_records(line)
  line.chomp.split => records, damaged_blocks
  [records, damaged_blocks.split(",").map(&:to_i)]
end

def unfold(records, damaged_blocks)
  [
    [records].*(5).join("?"),
    damaged_blocks * 5
  ]
end

def match?(records, damaged_block_size, from_index)
  return false if records[from_index + damaged_block_size] == "#"

  damaged_block_size.times do |i|
    next if records[from_index + i] == "#" || records[from_index + i] == "?"

    return false
  end

  true
end

def memoize(func)
  memo = {}

  ->(*args) {
    return memo[args] if memo.key?(args)

    memo[args] = func.call(*args)
  }
end

def arrangements(records, damaged_blocks)
  rec = memoize(->(i, j) {
    if j >= damaged_blocks.length
      return 0 if !records.index("#", i).nil?

      return 1
    end

    if i >= records.length
      return 1 if j >= damaged_blocks.length

      return 0
    end

    if records[i] == "."
      return rec.call(i + 1, j)
    end

    matches = match?(records, damaged_blocks[j], i)

    if records[i] == "#"
      return 0 if !matches

      return rec.call(i + damaged_blocks[j] + 1, j + 1)
    end

    if records[i] == "?"
      return rec.call(i + 1, j) if !matches

      return rec.call(i + damaged_blocks[j] + 1, j + 1) + rec.call(i + 1, j)
    end
  })

  rec.call(0, 0)
end

input = ARGF.each_line

input
  .map { parse_records(_1) }
  .map { unfold(_1, _2) }
  .map { arrangements(_1, _2) }
  .sum
  .display
