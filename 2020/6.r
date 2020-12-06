REBOL [
  Title: {Day 6}
  Date: 06-12-2020
]

data: append read/lines %data/6.txt {}

; --- Part 1 ---
groups: collect [
  answers: copy {} size: 0
  foreach line data [
    either empty? line [
      keep reduce [answers size]
      answers: copy {} size: 0
    ] [
      append answers line
      size: size + 1
    ]
  ]
]
r1: 0 foreach [group size] groups [
  r1: r1 + length? unique group
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0 foreach [group size] groups [
  counters: array/initial to-integer #"z" 0
  foreach char as-binary group [counters/:char: counters/:char + 1]
  r2: r2 + length? remove-each value counters [value != size]
]
print [{Part 2:} r2]
