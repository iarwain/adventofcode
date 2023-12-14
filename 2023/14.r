REBOL [
  Title: {Day 14}
  Date: 14-12-2023
]

data: read/lines %data/14.txt

reflector: context
[
  load?: funct [/full] [
    dish: copy/deep data
    transpose: does [
      dish: collect [
        for x 1 length? dish/1 1 [
          keep reverse rejoin map-each line dish [line/:x]
        ]
      ]
    ]
    tilt: funct [] [
      transpose
      foreach line dish [
        while [here: find line {O.}] [change here {.O}]
      ]
    ]
    either full [
      history: copy []
      while [none? cycle: find/only history dish] [
        append/only history copy/deep dish
        loop 4 [tilt]
      ]
      dish: history/(1 + (cycle: index? cycle) + ((1000000000) // (1 + (length? history) - cycle)))
    ] [
      tilt loop 3 [transpose]
    ]
    res: 0 weight: length? dish
    foreach line dish [
      foreach char line [
        all [char = #"O" res: res + weight]
      ]
      -- weight
    ]
    res
  ]
]

; --- Part 1 ---
r1: reflector/load?
print [{Part 1:} r1]

; --- Part 2 ---
r2: reflector/load?/full
print [{Part 2:} r2]
