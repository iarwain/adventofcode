REBOL [
  Title: {Day 4}
  Date: 04-12-2017
]

data: map-each line read/lines %data/4.txt [load line]

; --- Part 1 ---
r1: 0
foreach row data [
  if row == unique row [++ r1]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
foreach row data [
  if (sorted: map-each word row [sort to-string word]) == unique sorted [
    ++ r2
  ]
]
print [{Part 2:} r2]
