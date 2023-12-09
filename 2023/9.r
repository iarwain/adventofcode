REBOL [
  Title: {Day 9}
  Date: 09-12-2023
]

data: load read/lines %data/9.txt

oasis: context [
  extrapolate:
  use [report] [
    report: copy/deep data
    funct [/front] [
      res: 0 data: report
      until [
        history: reduce [copy first+ data]
        until [
          empty? last append/only history deltas: collect [
            values: last history
            forall values [try [keep values/2 - values/1]]
          ]
        ]
        reverse history
        forall history [
          try [
            either front [
              insert history/2 subtract first history/2 first history/1
            ] [
              append history/2 add last history/2 last history/1
            ]
          ]
        ]
        res: res + do pick [first last] to-logic front last history
        empty? data
      ]
      res
    ]
  ]
]

; --- Part 1 ---
r1: oasis/extrapolate
print [{Part 1:} r1]

; --- Part 2 ---
r2: oasis/extrapolate/front
print [{Part 2:} r2]
