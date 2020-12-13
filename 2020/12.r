REBOL [
  Title: {Day 12}
  Date: 12-12-2020
]

data: read/lines %data/12.txt

; --- Part 1 ---
ferry: context [
  navigate: funct [rules [block!]] [
    L: [N W S E N] R: [N E S W N] dirs: [N 0x-1 S 0x1 W -1x0 E 1x0]
    dir: 'E pos: 0x0 waypoint: 10x-1
    foreach step data [
      parse step [copy inst [{N} | {W} | {S} | {E} | {L} | {R} | {F}] (inst: to-word inst) copy value to end (value: load value)]
      switch inst bind rules 'pos
    ]
    (abs pos/x) + (abs pos/y)
  ]
]
r1: ferry/navigate [
  N W S E [pos: pos + (value * dirs/:inst)]
  L [until [dir: L/:dir 0 = value: value - 90]]
  R [until [dir: R/:dir 0 = value: value - 90]]
  F [pos: pos + (value * dirs/:dir)]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: ferry/navigate [
  N W S E [waypoint: waypoint + (value * dirs/:inst)]
  L [until [waypoint: as-pair waypoint/y negate waypoint/x 0 = value: value - 90]]
  R [until [waypoint: as-pair negate waypoint/y waypoint/x 0 = value: value - 90]]
  F [pos: pos + (value * waypoint)]
]
print [{Part 2:} r2]
