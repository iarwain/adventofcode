REBOL [
  Title: {Day 1}
  Date: 28-01-2018
]

data: read %data/1.txt

; --- Part 1 ---
floor: 0
parse data [
  some [
    {(} (floor: floor + 1)
  | {)} (floor: floor - 1)
  ]
]
print [{Part 1:} r1: floor]

; --- Part 2 ---
floor: r2: 0
parse data [
  some [
    {(} (floor: floor + 1)
  | position: {)} (floor: floor - 1 all [r2 = 0 floor = -1 r2: index? position])
  ]
]
print [{Part 2:} r2]
