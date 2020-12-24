REBOL [
  Title: {Day 24}
  Date: 24-12-2020
]

data: read/lines %data/24.txt

; --- Very similar to Day 17, especially part 2 ---

; --- Part 1 ---
grid: context [
  black: copy [] init: live: none
  use [step steps] [
    steps: ["e" 1x0 "se" 0x1 "sw" -1x1 "w" -1x0 "nw" 0x-1 "ne" 1x-1]
    init: funct [] [
      foreach line data [
        pos: 0x0 parse line [some [copy step ["se"|"sw"|"nw"|"ne"|"e"|"w"] (pos: pos + steps/:step)]]
        alter black pos
      ]
      length? black
    ]
    live: funct [days] [
      loop days [
        set 'black make hash! collect [
          neighbors: copy [] foreach tile black [
            count: 0 foreach [name step] steps [
              either find black new: tile + step [
                count: count + 1
              ] [
                any [attempt [neighbors/:new: neighbors/:new + 1] append neighbors reduce [new 1]]
              ]
            ]
            if any [count = 1 count = 2] [keep tile]
          ]
          foreach [neighbor count] neighbors [all [count = 2 keep neighbor]]
        ]
      ]
      length? black
    ]
  ]
]
r1: grid/init
print [{Part 1:} r1]

; --- Part 2 ---
r2: grid/live 100
print [{Part 2:} r2]
