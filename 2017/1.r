REBOL [
  Title: {Day 1}
  Date: 01-12-2017
]

data: read %data/1.txt

; --- Part 1 ---
r1: 0 values: append copy data data/1
repeat i l: length? data [
  all [
    first+ values == v: values/1
    r1: r1 + v - #"0"
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0 h: l / 2 values: append copy data data
repeat i l [
  all [
    first+ values == v: values/:h
    r2: r2 + v - #"0"
  ]
]
print [{Part 2:} r2]
