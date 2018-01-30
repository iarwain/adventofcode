REBOL [
  Title: {Day 3}
  Date: 28-01-2018
]

data: read %data/3.txt

; --- Part 1 ---
delivery: reduce [pos: 0x0 1]
parse data [
  some [
    [
      {^^} (pos: pos + 0x1)
    | {<}  (pos: pos - 1x0)
    | {>}  (pos: pos + 1x0)
    | {v}  (pos: pos - 0x1)
    ] (either find delivery pos [delivery/:pos: delivery/:pos + 1] [repend delivery [pos 1]])
  ]
]
r1: divide length? delivery 2
print [{Part 1:} r1]

; --- Part 2 ---
robo-delivery: reduce [pos: robo-pos: 0x0 2]
current: 'pos
parse data [
  some [
    [
      {^^} (move: 0x1)
    | {<}  (move: -1x0)
    | {>}  (move: 1x0)
    | {v}  (move: 0x-1)
    ] (
      set current add get current move
      current: pick ['pos 'robo-pos] current != 'pos
      either find robo-delivery house: get current [robo-delivery/:house: robo-delivery/:house + 1] [repend robo-delivery [house 1]]
    )
  ]
]
r2: divide length? robo-delivery 2
print [{Part 2:} r2]
