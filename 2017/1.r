REBOL [
  Title: {Day 1}
  Date: 01-12-2017
]

data: read %data/1.txt

; --- Part 1 ---
r1: 0
forall data [
  if tail? n: next data [
    n: head n
  ]
  if (v: n/1) == data/1 [
    r1: r1 + v - #"0"
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
repeat i l: length? data [
  n: either i <= h: l / 2 [i + h] [i - h]
  if (v: data/:i) == data/:n [
    r2: r2 + v - #"0"
  ]
]
print [{Part 2:} r2]
