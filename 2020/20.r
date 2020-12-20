REBOL [
  Title: {Day 20}
  Date: 20-12-2020
]

data: read %data/20.txt

; --- Part 1 ---
cameras: collect [
  parse data [
    some [
      {Tile } copy id to {:} thru newline (tile: copy [])
      10 [
        [copy line to newline skip | copy line to end] (append tile line)
      ] (keep reduce [id tile])
    | skip
    ]
  ]
]
edges?: funct [tile] [
  left: copy right: copy {}
  foreach line tile [append left first line append right last line]
  collect [
    keep half: reduce [
      copy first tile
      copy last tile
      left
      right
    ]
    foreach edge half [
      keep reverse copy edge
    ]
  ]
]
comment [
edges: collect [
  foreach [id tile] cameras [
    foreach edge edges? tile [
      keep reduce [edge id]
    ]
  ]
]
image: reduce [copy cameras/1 pos: 0x0] total: copy []
c: copy edges
forskip edges 2 [
  count: 0 start: edges edge: edges/1 id: edges/2
  while [start: find start edge] [start: next start count: count + 1]
  if count > 1 [
    start: c
    while [start: find start edge] [remove/part start 2]
  ]
  either find total id [total/:id: total/:id + count] [append total reduce [id count]]
] 2
]
; --- Using corners obtained from C program as it's currently unoptimized for Rebol ---
r1: 2383.0 * 2593 * 2753 * 3881
print [{Part 1:} r1]

; --- Part 2 ---
transform: funct [image] [
  pos: 1x1 collect [
    parse/all image [
      some [
        newline (pos: as-pair 1 pos/y + 1)
      | [#"#" (keep pos) | skip] (pos: pos + 1x0)
      ]
    ]
  ]
]

; --- Using sea image obtained from C program as it's currently unoptimized for Rebol ---
sea: transform {
.#.#.#..#.#..#.........#.....#...#........#...#...#....#.#...............#..###.##....#.........
#...............#...#.#....#.......###..#.....##..##.........#.......#.#.....................#..
#.....................#........#........#....##.#.#..#......#..#..........#...........#.#..#...#
.......#.#..#.#.#...#..#......##.#.#..#.##.#....#......#...#...#.#.......#.......#.....#..#.....
..............##....#..##..............##.......#.#..#...#.....#................#.#....#...#....
#.#.........#......#....#..............#.......#........#...........##......#.......#......###..
......................##...........#.#........###.#....#....#...#....#.#...#.#..#...#.....##..#.
.#.#....##.......#.................##.#..##......#.........#....#.....###.#......##..#.##.#.....
...........#.#.#..#...........#...##.###......##......#..............#.#.....#......#.......#.#.
.#...##............#.......#....#.#.##..#.........#..............##...####.#.###..........#.....
#....#........#...##.....#..#...#..#....#..#.........................#..#....###........#.#.#..#
..........#..#.#.........#.............#...#...#....#..#.#.................####.#..........#.#.#
.##......#.....#....##....##...#..#........#.#..##.##.......#....#....#..#....##.........###...#
..#..##......#......##..#......#...#.......#..............#..#.........#................###.#..#
.....#...#..##..#..##..............#.####.............#.#.###..........#....#......#..##....#...
........#.#........#..#.#...#..#..##...##...#........#....#......#..#.#....#.##...#.............
#....#.#......#.........#...........#...#.#....#.....#...#...........##..#...#.#.....#....#.#...
......#....................#..#.....#.##........#.....#..........#....#...#.##...........#.##...
...#........#....#.#.....#........##.#...............#.......#...#...##........#...........##...
.#.....#.#.#.....#..#.....##.......#.....#.......#......#..#.#...#.....#.#.......#..#.#...#.....
.###..##....###...#.#...#...#.....##...#.......#...#..............#...###...#......#........##..
..#.#...##.....##..#..........#...#....##.##.........#..............#.#.....###...#.#.....#.....
#.......#....#####.#..#..#.....#........#....#....#.#.............#.....###..##.##........##..#.
....#.........##...#...#.......#......###..##.#....#.............#......##..#.#..........###....
...........#..#....##..#.#.......##....#......#........#.#...#........#........#........#.#.....
..........#.......#.#......#...#...#...##.##.#........#...#.#..##.#....#.....#..................
.#.#.........#.....###......#..........#......#.#....#.........###..........#.###........#..##..
#..#.........##....##.....#...#.#.....#....#.#.#...#....#.....#..#....#.....###....#.#.......##.
.....#.#.......#.......###....##.....#...#..#.#.........#...##.....#........##..#.....#.#.....#.
.##....#.......#..#......##..........#...#...#.........#...............#.........#...#..........
...#....#.....#....##..#.#..#..#......#.##.......#..........#.#.........##....#..#.......#......
....#........##.#...#...#...#..#..#....#..#....#....#.............#..#..##.......#.#............
...............#.#.#........#..........#.#.#.#.##.......#.....#.#....###.......................#
..........#...#..#.......#.#..#...##.##........#.....##..#....#...........................#.....
...#....###..#.#.....####.....#.....#.........#.#......#.......#.#........#...............#.....
..#.##..#......#...#.....#....#.........#.........#............#....#....#......#...#....#....#.
#...#.......####........##...#..#.#..###........................#..#............................
........##............#.#.........#..#.#..#...##.........#......#....#.......#.#................
#....#.#...#..#.#.##....##....#......#.#...#...#.#...........#.....#..#.#...#..#........##....#.
...##..#......#.#...#.#...##.#........##..#.##.#.......#.........#.............##........##.....
....##........###.......#.......#...#........##................#.#...........#.#.........#......
##.##...#.....#.....#..#.#.........................................#.#........#....#..#.#.#.....
.###..#......#...#...##..#..#......#.##......#..........##........#....#....#.....#............#
...#......#.............#......#..#..#.#...#..#.#...............#..#.#.#......##.........#....#.
.........#..#.....##.....#.....#.......#..#....#.#..##.#..##..#...##.#.......###.......##.#.....
...#.#.#..........##..#.............#..........##....#...#..#.....#.#..#....#..#.........##.#...
....#.#...............#.#....#.....#..........#..#....#....#.....#......#..##..#........##.....#
..#.#........#.....#....##....#.........#....#.....#...##...#...#...#.....#.###.........#..##...
..##..#.#...................#....#............#...#.#.#..#..##...#..........#...##.#.#..#...#...
.........#..#..........#.........#......#....##............#...#......#........###.......#......
.#...#.....#........#...#......................#............#....##.#....#..#.#.#......##..#.##.
..##..#..##.....##..#.....#......##.#.....#.......#.....#...#....##............#.........#......
....#..#.....##.##....##......##..##..#..##.#....#.............#.#.....#..#....#..#......#.#....
....#.....................#...#.....#...#.....#...#...#....##...#...##....#...##........#......#
...#..................#.#...#.......#.....#..#...###........#...#...........##.#..##.....##.....
...#...#......#.....#..##...............##..#.....##.............#.......#.#..####....#.........
............#.....##...............#....#........#..........#...#..#.....#.#..#........##.#..#..
.#.#..##...#........#......#........#.......#........#...##.#.#..#.#.##.##....##.......#.#......
#...#.#.....###.#.............#.....#..#.........#........#......###....#.........#........#..#.
.....#....#.#....#.##....#.#.#..##.....#...#.#...#..#.....##...##.........#.#..#.#....#...#.#...
....#.........##..........#...#..##.#...#....#....####....#..##.............#......#.........#.#
#..#......#..#.....................#....#.........#......#......#.#.#..#....................#...
....#.....##.........#.....................##....#.#.#....#..#..#....#..#.#.#.#.#.#...#.......##
.###...#..#.......................#.##.#......#....#...#.........#..................#..#.......#
..............#.#..#.##..#.#.........#......#..#..##...#.##......#......#.......#..#.....#......
......#......#.....##.................#.......#.##...#...##.....##..###.#..#..........##...#.#..
.......#.#......#......#.........##...#..#.#..#...#....#..#.....#......#...#....#..#............
.....#.........#.#......##...#.#......#...#.##.#..#......#..#....#........#...#..........#..#...
.#...#...........#.....##........#.....#......##.#....##...#....#..........###...........##....#
....##...#....#.###....#.................#.....#..#......#...#.#.#........#.................#...
#............#......#.#............#........#.#..###...###..#............#.......#...#......##..
......#.....#.#.##...............................##.......#.#........##....#...#.##.........#...
..##..........##.........#..#..##............#..#.#.#.....#........#.........#.#.#..#......###..
#......#......#...##...#.............#................#..#.###...........#....#.#.........#.....
#.........#..##...##.#.....#.#.....#....#..........#.....##...............#...#.................
..............#..#.....#........#..##..............#...........#......#..............#.##.####..
.#.#......#......#.#...............#.........#...#..#.##.#........#......#......##..#.......#...
.#.........###..#.#...........###.#.#..#................#.#..........#..#..#...###.......#.###..
#...#.....#.#.#.##......#.#..............#......#..#..............#...#..#......##..#......#..#.
......#.......##.#...#.#..........#..#........##......#...#.#.........#.........#.......#.#...#.
........#....#.#.#................#.#...#........##.#...##.#.....#.#..#....#.#..#.......#.#.#...
..##...#...#..##.#.......#.........#...........................#..#................#.#..#..#...#
.......##.#...#...#........#.##...##.#.#............#.........#.......#.......#.#......#....#...
.............#..#.##.....###...#..#.....................#....##........#......#..##...#.....#...
....#.........#..............##..#...#...........................#..#........#...#....#...##.##.
#..##.....#...#..#........................##.##.##.#.....##......#...#.......##.#...........###.
..##...#..#.##.....#.#........#...#......#...#.....#..#.....#........##.................#......#
#....#........#.#.................##......#....##.......#...#.#..#.....#..##..#........#...#....
.#...........#.#..##...............#..##.......##.............##.#..#.#..##.....#...........#...
............###.....#...#...#.....#......#...##.......#....#.........#...#.......#..#.#....#....
..##..........#.......#.#.......#........#..#.#..##......#...........#...#......#.#.............
..#...#........................#......#...#....#...............#....#.#..##......#..#...........
..#........................#.....##.........###...#........#.###......#....#.#...#..............
.#............#......#..#..#......##.#..#..#.....#...#...............#.#...........#............
.............#.#....#....#....#..........#......##...........#.#..#.#.....#...#...#...##........
.#......#...#...#....#.............#....................#..#..#........#..##........#..#........
}
monster: transform {
                  #
#    ##    ##    ###
 #  #  #  #  #  #
}

r2: do roughness?: funct [] [
  variations: collect [
    foreach op [
      [offset]
      [-1x1 * offset]
      [1x-1 * offset]
      [-1x-1 * offset]
      [as-pair offset/y negate offset/x]
      [-1x1 * as-pair offset/y negate offset/x]
      [1x-1 * as-pair offset/y negate offset/x]
      [-1x-1 * as-pair offset/y negate offset/x]
    ] [keep/only map-each offset map-each pixel monster [pixel - monster/1] op]
  ]
  until [
    count: 0 offsets: first+ variations
    foreach pixel sea [
      unless foreach offset offsets [
        unless find sea pixel + offset [break/return true]
      ] [count: count + 1]
    ]
    count != 0
  ]
  probe index? variations
  (length? sea) - (count * length? monster)
]
print [{Part 2:} r2]
