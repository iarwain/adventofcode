REBOL [
  Title: {Day 6}
  Date: 06-12-2017
]

data: [0 5 10 0 11 14 13 4 11 8 8 7 1 4 12 11]

; --- Part 1 ---
r1: 0
mem: copy []
until [
  append/only mem copy data
  m: maximum-of data
  v: m/1 m/1: 0
  for i 1 v 1 [
    m: next m if tail? m [m: head m]
    m/1: m/1 + 1
  ]
  find/only mem data
]
print [{Part 1:} r1: length? mem]

; --- Part 2 ---
print [{Part 2:} r2: length? find/only mem data]
