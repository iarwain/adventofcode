REBOL [
  Title: {Day 2}
  Date: 02-12-2018
]

data: map-each id load %data/2.txt [to-string id]

; --- Part 1 ---
c2: c3: 0
foreach id data [
  histogram: copy []
  foreach letter id [
    either find histogram letter [
      histogram/:letter: histogram/:letter + 1
    ] [
      repend histogram [letter 1]
    ]
  ]
  case/all [
    find histogram 2 [c2: c2 + 1]
    find histogram 3 [c3: c3 + 1]
  ]
]
r1: c2 * c3
print [{Part 1:} r1]

; --- Part 2 ---
r2: none length: length? data/1
until [
  id: data/1
  foreach other data: next data [
    diff: pos: 0
    repeat i length [
      if id/:i != other/:i [
        diff: diff + 1
        pos: i
      ]
    ]
    if diff = 1 [
      r2: head remove at copy id pos
    ]
  ]
  r2
]
print [{Part 2:} r2]
