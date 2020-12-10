REBOL [
  Title: {Day 9}
  Date: 09-12-2020
]

data: load %data/9.txt

; --- Part 1 ---
queue: copy/part data data: skip data 25
r1: foreach value data [
  lookup: copy []
  either foreach entry queue [
    if find lookup (value - entry) [break/return false]
    append lookup entry
  ] [break/return value] [append remove queue value]
]
print [{Part 1:} r1]

; --- Part 2 ---
value: 0 begin: end: data
until [r1 = value: either value < r1 [value + first+ end] [value - first+ begin]]
r2: (first range: sort copy/part begin end) + last range
print [{Part 2:} r2]
