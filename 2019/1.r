REBOL [
  Title: {Day 1}
  Date: 01-12-2019
]

data: load %data/1.txt

; --- Part 1 ---
r1: 0
foreach value data [r1: r1 + round/floor value / 3 - 2]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
foreach value data [
  until [
    value: round/floor value / 3 - 2
    r2: r2 + max value 0
    value <= 0
  ]
]
print [{Part 2:} r2]
