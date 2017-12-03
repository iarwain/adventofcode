REBOL [
  Title: {Day 3}
  Date: 03-12-2017
]

data: 289326

; --- Part 1 ---
if even? l: to-integer square-root data - 1 [l - 1]
pos: to-pair reduce [h: l - 1 / 2 + 1 h]
rem: data - (l * l)
repeat a [0x-1 -1x0 0x1 1x0] [
  m: min rem (l + 1)
  rem: rem - m
  pos: pos + (m * a)
]
print [{Part 1:} r1: (abs pos/x) + (abs pos/y)]

; --- Part 2 ---
grid: reduce [pos: 0x0 1]
axes: [1x0 0x-1 -1x0 0x1]
l: 0 t: false
until [
  if t: not t [++ l]
  for i 1 l 1 [
    pos: pos + axes/1 v: 0
    for j (pos/x - 1) (pos/x + 1) 1 [
      for k (pos/y - 1) (pos/y + 1) 1 [
        if c: select grid to-pair reduce [j k] [v: v + c]
      ]
    ]
    repend grid [pos v]
    if v > data [break]
  ]
  if tail? axes: next axes [axes: head axes]
  v > data
]
print [{Part 2:} r2: v]
