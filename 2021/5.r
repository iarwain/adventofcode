REBOL [
  Title: {Day 5}
  Date: 05-12-2021
]

data: map-each entry load replace/all replace/all read %data/5.txt {,} {x} {->} {} [entry + 1x1]

; --- Part 1 ---
; Using a flat 2D array as it's ~6x faster than a hash!, which is ~60x faster than a block in this particular case
count: funct [/all] [
  bound: 0x0 foreach pos data [bound: max pos bound]
  grid: array/initial reduce [bound/x bound/y] 0
  foreach [begin end] data [
    delta: end - begin
    if any [
      all
      delta/x = 0
      delta/y = 0
    ] [
      pos: begin - inc: as-pair sign? delta/x sign? delta/y
      until [
        pos: pos + inc
        grid/(pos/x)/(pos/y): grid/(pos/x)/(pos/y) + 1
        pos = end
      ]
    ]
  ]
  result: 0
  foreach line grid [
    foreach entry line [
      if entry > 1 [
        result: result + 1
      ]
    ]
  ]
  result
]

r1: count
print [{Part 1:} r1]

; --- Part 2 ---
r2: count/all
print [{Part 2:} r2]
