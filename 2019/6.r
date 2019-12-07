REBOL [
  Title: {Day 6}
  Date: 06-12-2019
]

data: parse read %data/6.txt {)}

; --- Part 1 ---
objects: unique data
get-orbits: func [object] [
  collect [
    until [none? attempt [keep object: first back find/skip next data object 2]]
  ]
]

r1: 0
foreach object objects [
  r1: r1 + length? get-orbits object
]
print [{Part 1:} r1]

; --- Part 2 ---
you: get-orbits {YOU}
santa: get-orbits {SAN}
common: first intersect you santa

r2: (index? find you common) + (index? find santa common) - 2
print [{Part 2:} r2]
