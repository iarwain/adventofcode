REBOL [
  Title: {Day 1}
  Date: 01-12-2018
]

data: load %data/1.txt

; --- Part 1 ---
r1: 0 foreach v data [r1: r1 + v]
print [{Part 1:} r1]

; --- Part 2 ---
r2: none r: 0 history: make hash! []
until [
  foreach v data [
    either find history r: r + v [
      r2: r break
    ] [
      append history r
    ]
  ]
  r2
]
print [{Part 2:} r2]
