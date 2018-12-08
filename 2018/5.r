REBOL [
  Title: {Day 5}
  Date: 05-12-2018
]

data: trim/all read %data/5.txt

; --- Part 1 ---
reduction: context [
  simple: best: none
  use [polymer react] [
    polymer: copy data
    react: func [poly] [
      until [
        poly: either all [poly/2 32 = (poly/1 xor poly/2)] [
          back remove/part poly 2
        ] [
          next poly
        ]
        tail? poly
      ]
      length? head poly
    ]
    simple: does [
      react polymer
    ]
    best: does [
      first minimum-of collect [
        foreach unit unique polymer [
          keep react replace/all copy polymer unit {}
        ]
      ]
    ]
  ]
]
r1: reduction/simple
print [{Part 1:} r1]

; --- Part 2 ---
r2: reduction/best
print [{Part 2:} r2]
