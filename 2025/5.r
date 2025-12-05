REBOL [
  Title: {Day 5}
  Date: 05-12-2025
]

data: read/lines %data/5.txt
digits: charset {0123456789}
fresh: collect [
  forall data [
    if empty? data/1 [ingredients: next data break]
    parse data/1 [copy start some digits {-} copy stop some digits]
    keep load reduce [start stop]
  ]
]

; --- Part 1 ---
r1: 0
foreach ingredient ingredients [
  ingredient: load ingredient
  foreach [start stop] fresh [
    all [
      ingredient >= start
      ingredient <= stop
      ++ r1
      break
    ]
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
fresh: collect [
  until [
    range: take/part fresh 2
    until [
      merged: false fresh: collect [
        foreach [start stop] fresh [
          either any [
            range/1 > stop
            range/2 < start
          ] [
            keep reduce [start stop]
          ] [
            range/1: min range/1 start
            range/2: max range/2 stop
            merged: true
          ]
        ]
      ]
      not merged
    ]
    keep range
    empty? fresh
  ]
]
r2: 0
foreach [start stop] fresh [
  r2: r2 + stop - start + 1
]
print [{Part 2:} r2]
