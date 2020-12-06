REBOL [
  Title: {Day 5}
  Date: 05-12-2020
]

data: read/lines %data/5.txt

; --- Part 1 ---
r1: last seats: sort collect [
  foreach line data [
    use [pos range] [
      parse line [
        (pos: 0x0 range: 128x8)
        some [
          [(range/x: range/x / 2) {F} | {B} (pos/x: pos/x + range/x)]
        | [(range/y: range/y / 2) {L} | {R} (pos/y: pos/y + range/y)]
        ]
      ]
      keep pos/x * 8 + pos/y
    ]
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: forall seats [if seats/2 - seats/1 != 1 [break/return seats/1 + 1]]
print [{Part 2:} r2]
