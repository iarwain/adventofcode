REBOL [
  Title: {Day 5}
  Date: 05-12-2017
]

data: load %data/5.txt

; --- Part 1 ---
r1: 0
mem: copy data
until [
  r1: r1 + 1
  mem/1: (j: mem/1) + 1
  mem: skip mem j
  tail? mem
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
mem: copy data
until [
  r2: r2 + 1
  mem/1: (j: mem/1) + either j >= 3 [-1] [1]
  mem: skip mem j
  tail? mem
]
print [{Part 2:} r2]
