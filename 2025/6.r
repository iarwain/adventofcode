REBOL [
  Title: {Day 6}
  Date: 06-12-2025
]

data: read/lines %data/6.txt

; --- Part 1 ---
r1: 0
repeat column length? first worksheet: load data [
  value: worksheet/1/:column
  for line 2 (length? worksheet) - 1 1 [
    value: do reduce [value pick last worksheet column worksheet/:line/:column]
  ]
  r1: r1 + value
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
foreach value collect [
  operands: copy []
  for column length? data/1 1 -1 [
    append operands load rejoin collect [
      repeat line (length? data) - 1 [
        keep data/:line/:column
      ]
    ]
    unless empty? op: trim to-string pick last data column [
      value: take operands
      foreach operand operands [value: do reduce [value load op operand]]
      keep value
      clear operands
    ]
  ]
] [r2: r2 + value]
print [{Part 2:} r2]
