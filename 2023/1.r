REBOL [
  Title: {Day 1}
  Date: 01-12-2023
]

data: read/lines %data/1.txt

calibrate: funct [/literal] [
  digits: charset {0123456789}
  literals: [{zero} {one} {two} {three} {four} {five} {six} {seven} {eight} {nine}]
  rules: copy [
    some [
      copy value digits (append values load value)
    | skip
    ]
  ]
  if literal [
    insert back tail rules [
      here: (forall literals [if find/match here literals/1 [append values (index? literals) - 1]])
    ]
  ]
  res: 0
  foreach line data [
    values: copy []
    parse line rules
    res: res + (10 * first values) + last values
  ]
]

; --- Part 1 ---
r1: calibrate
print [{Part 1:} r1]

; --- Part 2 ---
r2: calibrate/literal
print [{Part 2:} r2]
