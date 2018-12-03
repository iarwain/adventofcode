REBOL [
  Title: {Day 3}
  Date: 03-12-2018
]

data: read/lines %data/3.txt

; --- Part 1 ---
claims: map-each line data [
  parse line [
    "#" copy label integer! "@" copy x integer! "," copy y integer! ":" size:
  ]
  context [
    id: load label
    tl: as-pair load x load y
    br: load size
  ]
]
fabric: make image! 1000x1000
foreach claim claims [
  patch: copy/part origin: at fabric claim/tl claim/br
  forall patch [patch/1: patch/1 + 1]
  change origin patch
]
r1: 0
forall fabric [
  if fabric/1 > 1.1.1.1 [
    r1: r1 + 1
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
foreach claim claims [
  found: true patch: copy/part at fabric claim/tl claim/br
  forall patch [
    if patch/1 != 1.1.1.1 [
      found: false break
    ]
  ]
  if found [
    r2: claim/id break
  ]
]
print [{Part 2:} r2]
