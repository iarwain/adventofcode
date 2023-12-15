REBOL [
  Title: {Day 15}
  Date: 15-12-2023
]

data: read/string %data/15.txt

lenses: context [
  initialize: use [sequence] [
    sequence: split data {,}
    funct [/test] [
      hash: funct [data] [
        res: 0
        foreach char data [
          res: res + char * 17 // 256
        ]
      ]
      res: 0
      either test [
        foreach entry sequence [res: res + hash entry]
      ] [
        boxes: array/initial 256 []
        foreach entry sequence [
          parse entry [
            copy label to [{=} | {-}] (box: 1 + hash label)
            [ {-}                     (remove/part find boxes/:box label 2)
            | {=} copy focal to end   (either here: find boxes/:box label [change next here focal] [repend boxes/:box [label focal]])
            ]
          ]
        ]
        forall boxes [
          index: 1
          foreach [label focal] boxes/1 [
            res: (index? boxes) * (++ index) * (load focal) + res
          ]
        ]
      ]
      res
    ]
  ]
]

; --- Part 1 ---
r1: lenses/initialize/test
print [{Part 1:} r1]

; --- Part 2 ---

r2: lenses/initialize
print [{Part 2:} r2]
