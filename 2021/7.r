REBOL [
  Title: {Day 7}
  Date: 07-12-2021
]

data: sort load replace/all read %data/7.txt {,} { }

; --- Part 1 ---
fuel?: funct [/series] [
  best: to-integer (power 2 31) - 1
  for i first data last data 1 [
    sum: 0
    foreach crab data [
      dist: abs (crab - i)
      sum: sum + either series [
        dist + 1 * dist / 2
      ] [
        dist
      ]
    ]
    best: min best sum
  ]
]

r1: fuel?
print [{Part 1:} r1]

; --- Part 2 ---
r2: fuel?/series
print [{Part 2:} r2]
