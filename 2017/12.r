REBOL [
  Title: {Day 12}
  Date: 12-12-2017
]

data: read/lines %data/12.txt

; --- Part 1 ---
village: context [
  graph: collect [
    foreach line data [
      keep first line: load replace/all line {,} {} keep/only skip line 2
    ]
  ]
  connect: func [node [integer!] /into output [block!]] [
    any [output output: copy []]
    unless find output node [
      append output node
      foreach neighbor select graph node [
        connect/into neighbor output
      ]
    ]
    output
  ]
  groups: has [result ids neighbors]
  [
    result: copy [] ids: extract graph 2
    until [
      append/only result neighbors: connect ids/1
      empty? ids: exclude ids neighbors
    ]
    result
  ]
]

r1: length? village/connect 0
print [{Part 1:} r1]

; --- Part 2 ---
r2: length? village/groups
print [{Part 2:} r2]
