REBOL [
  Title: {Day 3}
  Date: 03-12-2019
]

data: read/lines %data/3.txt

; --- Part 1 ---
wires: copy []
forall data [
  pos: 0x0
  append/only wires collect [
    parse data/1 [
      some [
        [ "U" (dir: 0x-1)
        | "D" (dir: 0x1)
        | "L" (dir: -1x0)
        | "R" (dir: 1x0)
        ]
        copy steps integer! (loop load steps [keep pos: pos + dir])
        ","
      ]
    ]
  ]
]
r1: first minimum-of map-each node nodes: intersect wires/1 wires/2 [
  (abs node/x) + abs node/y
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: first minimum-of map-each node nodes [
  (index? find wires/1 node) + index? find wires/2 node
]

print [{Part 2:} r2]
