REBOL [
  Title: {Day 3}
  Date: 03-12-2020
]

data: read/lines %data/3.txt

; --- Part 1 ---
r1: offset: 0 length: length? data/1
foreach line next data [
  offset: (offset + 3) // length
  if line/(offset + 1) = #"#" [r1: r1 + 1]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 1.0
foreach slope [1x1 3x1 5x1 7x1 1x2] [
  count: offset: 0 data: head data
  while [not tail? data: skip data slope/y] [
    offset: (offset + slope/x) // length
    if data/1/(offset + 1) = #"#" [count: count + 1]
  ]
  r2: r2 * count
]
print [{Part 2:} copy/part r2: to-string r2 find r2 #"."]
