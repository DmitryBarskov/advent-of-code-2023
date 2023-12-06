def parse_seeds(str)
  str.split => "seeds:", *seeds
  seeds.each_slice(2).map do |range_start, length|
    build_range(range_start, length:)
  end
end

def build_range(range_start, length:)
  range_start.to_i..(range_start.to_i + length.to_i - 1)
end

def parse_map(str)
  str.split("\n") => header, *ranges
  header.split.first.split("-") => from, "to", to
  ranges = ranges.map do |range_str|
    range_str.split => dest_start, src_start, length
    [
      build_range(src_start, length:),
      build_range(dest_start, length:)
    ]
  end.to_h
  {from:, to:, ranges:}
end

def get_destination(map, source)
  map[:ranges].each do |sources, destinations|
    next unless sources.include?(source)

    return destinations.first + source - sources.first
  end

  source
end

def find_location(almanac, seed)
  map = almanac["seed"]
  source = seed
  while map[:to] != "location"
    source = get_destination(map, source)
    map = almanac[map[:to]]
  end
  get_destination(map, source)
end

def reverse_map(map)
  {
    from: map[:to],
    to: map[:from],
    ranges: map[:ranges].map do |k, v|
      [v, k]
    end.to_h
  }
end

def reverse_almanac(almanac)
  almanac.map do |_, map|
    [map[:to], reverse_map(map)]
  end.to_h
end

def find_seed(almanac, location)
  map = almanac["location"]
  source = location
  while map[:to] != "seed"
    source = get_destination(map, source)
    map = almanac[map[:to]]
  end
  get_destination(map, source)
end

almanac = {}
seeds = []

ARGF.readlines.join.split("\n\n").each do |paragraph|
  case paragraph
  in /seeds/
    seeds = parse_seeds(paragraph).sort_by { _1.first }
  else
    map = parse_map(paragraph)
    almanac[map[:from]] = map
  end
end

# require 'parallel'

# Parallel.each(seeds) do |seeds_range|
#   seeds_range.reduce(Float::INFINITY) do |minimum_location, seed|
#     location = find_location(almanac, seed)

#     next minimum_location if location > minimum_location

#     p(["New min location!", location])

#     location
#   end
# end

reversed = reverse_almanac(almanac)

(0..77435348).find do |location|
  p location if location % 100_000 == 0
  seed = find_seed(reversed, location)
  seeds.any? { _1.include?(seed) }
end.display
