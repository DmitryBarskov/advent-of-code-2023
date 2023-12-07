# frozen_string_literal: true

# @param {[String]} input
# [
#   "Time:      7  15   30",
#   "Distance:  9  40  200"
# ]
def race_records(lines)
  lines.map { _1.split(/\s+/) } => [
    [/Time:/, *time_records],
    [/Distance:/, *distance_records]
  ]

  { time: time_records.join.to_i, distance: distance_records.join.to_i }
end

def ways_to_win(time:, distance:)
  first_record = (0..time).bsearch { |hold_time| (time - hold_time) * hold_time > distance }
  return 0 if first_record.nil?

  last_record = (0..time).bsearch { |hold_time| hold_time > first_record && (time - hold_time) * hold_time <= distance }
  last_record ||= time
  last_record - first_record
end

race_records(ARGF.readlines).then do |record|
  ways_to_win(**record)
end.display
