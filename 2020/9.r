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
r2: forall data [
  acc: 0 value: data range: collect [
    until [r1 <= acc: acc + keep (first+ value)]
  ]
  if acc = r1 [break/return (first sort range) + (last range)]
]
print [{Part 2:} r2]
