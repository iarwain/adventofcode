REBOL [
  Title: {Day 9}
  Date: 09-12-2025
]

data: read/string %data/9.txt

floor: context [
  largest?: none
  use [largest tiles edges valid] [
    largest: [0 0] tiles: load replace/all data {,} {x}
    edges: collect [
      points: append copy tiles tiles/1
      forall points [
        unless last? points [
          keep/only reduce [min points/2 points/1 max points/2 points/1]
        ]
      ]
    ]
    foreach [area rectangle] sort/skip/reverse collect [
      forall tiles [
        others: next tiles
        forall others [
          largest/2: max largest/2 area: to-integer ((abs tiles/1/x - others/1/x) + 1)
                                    * ((abs tiles/1/y - others/1/y) + 1)
          keep reduce [area reduce [min others/1 tiles/1 max others/1 tiles/1]]
        ]
      ]
    ] 2 [
      valid: true
      foreach edge edges [
        unless any [
          edge/2/x <= rectangle/1/x
          edge/1/x >= rectangle/2/x
          edge/2/y <= rectangle/1/y
          edge/1/y >= rectangle/2/y
        ] [
          valid: false
          break
        ]
      ]
      all [
        valid
        largest/1: to-integer (rectangle/2/x - rectangle/1/x + 1)
                            * (rectangle/2/y - rectangle/1/y + 1)
        break
      ]
    ]
    largest?: function [/red-green] [
      pick largest to-logic red-green
    ]
  ]
]

; --- Part 1 ---
r1: floor/largest?
print [{Part 1:} r1]

; --- Part 2 ---
r2: floor/largest?/red-green
print [{Part 2:} r2]
