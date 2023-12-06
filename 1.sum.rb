# frozen_string_literal: true

SPELLED_DIGITS = {one: 1, two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7,
                  eight: 8, nine: 9}.freeze
VALID_DIGIT = /\d|#{SPELLED_DIGITS.keys.join("|")}/
FIRST_DIGIT = /.*?(#{VALID_DIGIT}).*/
LAST_DIGIT = /.*(#{VALID_DIGIT}).*/

def digit_from_string(str)
  return str.to_i if str in "0".."9"

  SPELLED_DIGITS[str.to_sym]
end

ARGF.reduce(0) do |sum, line|
  first_digit = line.match(FIRST_DIGIT)[1].then { digit_from_string(_1) }
  last_digit = line.match(LAST_DIGIT)[1].then { digit_from_string(_1) }
  sum + first_digit * 10 + last_digit
end.display
