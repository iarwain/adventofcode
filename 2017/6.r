REBOL [
  Title: {Day 6}
  Date: 06-12-2017
]

data: load %data/6.txt

; --- Part 1 ---
r1: 0
mem: copy []
until [
  append/only mem copy data
  m: maximum-of data
  v: m/1 m/1: 0
  repeat i v [
    if tail? m: next m [m: head m]
    m/1: m/1 + 1
  ]
  find/only mem data
]
print [{Part 1:} r1: length? mem]

; --- Part 2 ---
print [{Part 2:} r2: length? find/only mem data]
