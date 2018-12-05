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
        poly: either 32 = abs subtract to-integer poly/1 to-integer poly/2 [
          remove/part poly 2
          back poly
        ] [
          next poly
        ]
        tail? poly
      ]
      length? head poly
    ]
    simple: does [
      react copy polymer
    ]
    best: has [results] [
      results: collect [
        foreach unit {abcdefghijklmnopqrstuvwxyz} [
          keep react replace/all copy polymer unit {}
        ]
      ]
      first minimum-of results
    ]
  ]
]
r1: reduction/simple
print [{Part 1:} r1]

; --- Part 2 ---
r2: reduction/best
print [{Part 2:} r2]
