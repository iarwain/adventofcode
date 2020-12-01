REBOL [
  Title: {Day 22}
  Date: 22-12-2018
]

; [WIP]: Never completely ported from the C version (which was used due to performance reasons)

data: replace/all read %data/22.txt "," "x"

; --- Part 1 ---
cave: context [
  danger: 0
  use [grid goal erosion?] [
    grid: make hash! [] goal: context load data
    erosion?: funct [pos] [
      unless result: select grid pos [
        index: case [
          any [
            0x0 = pos
            goal/target = pos
          ]                     [0]
          pos/x = 0             [pos/y * 48271]
          pos/y = 0             [pos/x * 16807]
          true                  [(erosion? pos - 1x0) * (erosion? pos - 0x1)]
        ]
        repend grid [pos result: (index + goal/depth) // 20183]
      ]
      result
    ]
    do process: does [
      for y 0 goal/target/y 1 [
        for x 0 goal/target/x 1 [
          danger: danger + ((erosion? as-pair x y) // 3)
        ]
      ]
    ]
  ]
]
r1: cave/danger
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
print [{Part 2:} r2]
