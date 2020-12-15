REBOL [
  Title: {Day 15}
  Date: 15-12-2020
]

data: load replace/all read %data/15.txt {,} { }

; --- Part 1 ---
; --- Brute force: filling the buffer ---
mem: copy data
r1: last loop 2020 - length? mem [
  append mem either pos: find/reverse back tail mem last mem [(length? mem) - (index? pos)] [0]
]
print [{Part 1:} r1]

; --- Part 2 ---
; --- Optimization: tracking indices only, still very slow in Rebol ---
index: array size: 30'000'000
repeat i (length? data) - 1 [index/(data/:i + 1): i]
current: reduce [last data length? data]
r2: first loop size - length? data [
  new: either check: index/(current/1 + 1) [current/2 - check] [0]
  current: reduce [new (index/(current/1 + 1): current/2) + 1]
]
print [{Part 2:} r2]
