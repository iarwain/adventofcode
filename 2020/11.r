REBOL [
  Title: {Day 11}
  Date: 11-12-2020
]

; This one requires REBOL View, for image manipulation / colors

data: read/lines %data/11.txt

; --- Part 1 ---
plane: context [
  process: none use [empty occupied floor plan] [
    empty: 0.255.0.0 occupied: 255.0.0.0 floor: 0.0.0.0
    plan: make image! append/only reduce [as-pair length? data/1 length? data] reduce collect [
      foreach line data [foreach seat line [keep switch seat [#"L" [empty] #"#" [occupied] #"." [floor]]]]
    ]
    process: funct [/sight] [
      dirs: [0x1 0x-1 1x0 -1x0 -1x-1 -1x1 1x-1 1x1]
      threshold: either sight [5] [4]
      count-adj: either sight [
        funct [bitmap coord] [
          count: 0 foreach dir dirs [
            check: coord forever [
              check: check + dir
              either all [check/x >= 0 check/y >= 0 check/x < bitmap/size/x check/y < bitmap/size/y] [
                switch bitmap/:check compose [(occupied) [count: count + 1 break] (empty) [break]]
              ] [
                break
              ]
            ]
          ]
          count
        ]
      ] [
        funct [bitmap coord] [
          count: 0 foreach dir dirs [
            check: coord + dir
            all [check/x >= 0 check/y >= 0 check/x < bitmap/size/x check/y < bitmap/size/y bitmap/:check = occupied count: count + 1]
          ]
          count
        ]
      ]
      current: plan until [
        new: make image! current/size
        repeat y current/size/y [
          repeat x current/size/x [
            new/(coord: as-pair x - 1 y - 1): switch current/:coord compose [
              (empty)     [pick reduce[occupied empty] 0 = count-adj current coord]
              (occupied)  [pick reduce [empty occupied] threshold <= count-adj current coord]
              (floor)     [floor]
            ]
          ]
        ]
        also current = new current: new
      ]
      count: 0 forall current [if current/1 = occupied [count: count + 1]] count
    ]
  ]
]

r1: plane/process
print [{Part 1:} r1]

; --- Part 2 ---
r2: plane/process/sight
print [{Part 2:} r2]
