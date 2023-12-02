#!/usr/bin/env ruby
# frozen_string_literal: true

puts(ARGF.reduce(0) do |sum, line|
  next sum if line.empty?

  first_digit = line.match(/.*?(\d).*/)[1]
  last_digit = line.match(/.*(\d).*/)[1]
  sum + (first_digit + last_digit).to_i
end)
