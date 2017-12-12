REBOL [
  Title: {Day 11}
  Date: 11-12-2017
]

data: parse read %data/11.txt {,}

; --- Part 1 ---
hex: context [
  dirs: [{n} 0x-1 {ne} 1x-1 {se} 1x0 {s} 0x1 {sw} -1x1 {nw} -1x0]
  distance: func [pos [pair!]] [max abs pos/x max abs pos/y abs pos/x + pos/y]
  walk: funct [path [block!]] [
    pos: 0x0 current: farthest: 0
    foreach step path [
      pos: pos + dirs/:step
      farthest: max farthest current: distance pos
    ]
    reduce [current farthest]
  ]
]

set [r1 r2] hex/walk data
print [{Part 1:} r1]

; --- Part 2 ---
print [{Part 2:} r2]
