REBOL [
  Title: {Day 1}
  Date: 01-12-2018
]

data: load %data/1.txt

; --- Part 1 ---
r1: 0 foreach v data [r1: r1 + v]
print [{Part 1:} r1]

; --- Part 2 ---
r2: none s: 0 h: make hash! []
until [
  foreach v data [
    if find h s: s + v [
      r2: s break
    ]
    append h s
  ]
  r2
]
print [{Part 2:} r2]
