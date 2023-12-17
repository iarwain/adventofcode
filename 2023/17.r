REBOL [
  Title: {Day 17}
  Date: 17-12-2023
]

; This is far too slow, probably due to the lack of any efficient sorting data structure in Rebol
; It runs on the sample input in ~65ms, however it takes ~30 minutes to complete with the real input...
data: read/lines %data/17.txt

solve: funct [range] [
  it: 0
  grid: map-each line data [
    make vector! compose/only [
      integer! 32 (collect [foreach char line [keep load to-string char]])
    ]
  ]
  end: as-pair length? grid/1 length? grid
  costs: map [] queue: compose/deep [[[1x1 (none)] 0]]
  while [end != first first state: take head queue] [
    foreach dir reduce pick [[1x0 0x1] [dir: as-pair state/1/2/y state/1/2/x negate dir]] none? state/1/2 [
      pos: state/1/1 cost: state/2
      repeat i range/2 [
        new: reduce [pos: pos + dir dir]
        try [
          cost: grid/(pos/y)/(pos/x) + cost
          if i >= range/1 [
            unless attempt [cost >= costs/:new] [
              ++ it
              costs/(new): cost
              loop length? here: queue [either here/1/2 >= cost [break] [here: next here]]
              insert/only here compose/deep [[(pos) (dir)] (cost)]
            ]
          ]
        ]
      ]
    ]
  ]
  print it
  state/2
]

; --- Part 1 ---
r1: solve [1 3]
print [{Part 1:} r1]

; --- Part 2 ---
r2: solve [4 10]
print [{Part 2:} r2]
