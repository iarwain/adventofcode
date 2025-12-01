REBOL [
  Title: {Day 1}
  Date: 01-12-2025
]

data: read/lines %data/1.txt

; --- Part 1 ---
r1: 0 dial: 50
foreach action data [
  rot: load next action
  all [action/1 = #"L" rot: negate rot]
  dial: dial + rot
  all [(dial: dial % 100) = 0 ++ r1]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0 dial: 50
foreach action data [
  previous: dial rot: load next action
  all [action/1 = #"L" rot: negate rot]
  all [(dial: dial + rot) = 0 ++ r2]
  all [previous * dial < 0 ++ r2]
  r2: r2 + abs to-integer (dial / 100)
  dial: dial % 100
]
print [{Part 2:} r2]
