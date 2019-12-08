REBOL [
  Title: {Day 6}
  Date: 06-12-2019
]

data: make map! parse read %data/6.txt {)}

; --- Part 1 ---
get-orbits: func [object] [
  collect [
    until [none? attempt [keep object: first back find/skip next data object 2]]
  ]
]

r1: 0
foreach object unique data [
  r1: r1 + length? get-orbits object
]
print [{Part 1:} r1]

; --- Part 2 ---
parent: first intersect you: get-orbits {YOU} santa: get-orbits {SAN}

r2: (index? find you parent) + (index? find santa parent) - 2
print [{Part 2:} r2]
