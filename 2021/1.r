REBOL [
  Title: {Day 1}
  Date: 01-12-2021
]

data: load %data/1.txt

; --- Part 1 ---
r1: 0 data: next data
forall data [
  if data/1 > data/-1 [
    r1: r1 + 1
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
until [
  if (data/1 + data/2 + data/3) > (data/-1 + data/1 + data/2) [
    r2: r2 + 1
  ]
  3 > length? data: next data
]
print [{Part 2:} r2]
