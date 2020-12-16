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
history: make hash! []
repeat i (length? data) - 1 [insert history reduce [data/:i i]]
r2: last data
for index length? data 30'000'000 - 1 1 [
  either check: find/skip history r2 2 [
    r2: index - check/2
    check/2: index
  ] [
    append history reduce [r2 index]
    r2: 0
  ]
]
print [{Part 2:} r2]
