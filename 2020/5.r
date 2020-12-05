REBOL [
  Title: {Day 5}
  Date: 05-12-2020
]

data: read/lines %data/5.txt

; --- Part 1 ---
r1: 0
seats: sort collect [
  use [row column half] [
    foreach seat data [
      parse seat [
        (row: 0x127 column: 0x7)
        some [
          (half: as-pair (row/y - row/x + 1) / 2 (column/y - column/x + 1) / 2)
          {F} (row/y: row/y - half/x)
        | {B} (row/x: row/x + half/x)
        | {L} (column/y: column/y - half/y)
        | {R} (column/x: column/x + half/y)
        ]
      ]
      r1: max r1 keep row/x * 8 + column/x
    ]
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
for i first seats last seats 1 [
  all [
    not find seats i
    find seats i - 8
    find seats i + 8
    r2: i
    break
  ]
]
print [{Part 2:} r2]
