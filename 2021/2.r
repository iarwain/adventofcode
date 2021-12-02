REBOL [
  Title: {Day 2}
  Date: 02-12-2021
]

data: load %data/2.txt

; --- Part 1 ---
forward:  func [val] [pos/x: pos/x + val]
down:     func [val] [pos/y: pos/y + val]
up:       func [val] [pos/y: pos/y - val]

pos: 0x0
foreach [ins val] data [
  do ins val
]

r1: pos/x * pos/y
print [{Part 1:} r1]

; --- Part 2 ---
forward:  func [val] [pos: pos + as-pair val aim * val]
down:     func [val] [aim: aim + val]
up:       func [val] [aim: aim - val]

pos: 0x0 aim: 0
foreach [ins val] data [
  do ins val
]

r2: pos/x * pos/y
print [{Part 2:} r2]
