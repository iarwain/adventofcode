REBOL [
  Title: {Day 6}
  Date: 06-12-2021
]

data: load replace/all read %data/6.txt {,} { }

; --- Part 1 ---
count-fish: func [days] [
  sea: array/initial 9 0.0
  foreach count data [
    sea/(count + 1): sea/(count + 1) + 1
  ]
  loop days [
    append sea born: take sea
    sea/7: sea/7 + born
  ]
  result: 0.0 foreach count sea [result: result + count]
  copy/part result: to-string result find result {.}
]

r1: count-fish 80
print [{Part 1:} r1]

; --- Part 2 ---
r2: count-fish 256
print [{Part 2:} r2]
