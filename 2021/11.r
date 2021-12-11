REBOL [
  Title: {Day 11}
  Date: 11-12-2021
]

data: read/lines %data/11.txt

; --- Part 1 ---
octopuses: context [
  flashes: sync-step: 0
  use [levels flash step size sync flashed] [
    levels: map-each line data [collect [foreach char line [keep to-integer char - #"0"]]]
    flash: func [pos /local neighbor value] [
      flashed/(pos/y)/(pos/x): true
      all [step <= 100 flashes: flashes + 1]
      foreach offset [-1x-1 -1x0 -1x1 0x-1 0x0 0x1 1x-1 1x0 1x1] [
        neighbor: pos + offset
        all [
          neighbor/x > 0
          neighbor/x <= size/x
          neighbor/y > 0
          neighbor/y <= size/y
          value: levels/(neighbor/y)/(neighbor/x): levels/(neighbor/y)/(neighbor/x) + 1
          all [value > 9 not flashed/(neighbor/y)/(neighbor/x) flash neighbor]
        ]
      ]
    ]
    step: 0 size: as-pair length? levels/1 length? levels
    forever [
      step: step + 1 sync: true flashed: array/initial reduce [size/y size/x] false
      foreach action [
        [levels/:y/:x: levels/:y/:x + 1]
        [all [levels/:y/:x > 9 not flashed/:y/:x flash as-pair x y]]
        [all [flashed/:y/:x levels/:y/:x: 0]]
        [sync: sync and flashed/:y/:x]
      ] [
        repeat y size/y [
          repeat x size/x [
            do bind bind action 'x 'y
          ]
        ]
      ]
      all [sync sync-step: step break]
    ]
  ]
]

r1: octopuses/flashes
print [{Part 1:} r1]

; --- Part 2 ---
r2: octopuses/sync-step
print [{Part 2:} r2]
