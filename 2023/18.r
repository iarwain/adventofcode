REBOL [
  Title: {Day 18}
  Date: 18-12-2023
]

data: read/string %data/18.txt

lagoon: context [
  lava?: use [plan] [
    plan: map-each [letter number hex] split data whitespace [
      dirs: [{R} 1x0 {D} 0x1 {L} -1x0 {U} 0x-1]
      context [
        dir: dirs/:letter
        length: load number
        new-dir: dirs/(1 + (load to-string take back back tail hex) * 2)
        new-length: to-integer do hex
      ]
    ]
    funct [/swap] [
      points: collect [
        keep pos: 0x0
        foreach instr plan [
          keep pos: pos + do pick [[instr/new-length * instr/new-dir] [instr/length * instr/dir]] to-logic swap
        ]
      ]
      res: 0 current: first+ points
      ; total area = shoelace area + 1/2 perimeter + origin (1)
      foreach point points [
        to: current - point
        res: point/y + current/y * (to/x) + (abs to/x + to/y) / 2 + res
        current: point
      ]
      to-integer res + 1
    ]
  ]
]

; --- Part 1 ---
r1: lagoon/lava?
print [{Part 1:} r1]

; --- Part 2 ---
r2: lagoon/lava?/swap
print [{Part 2:} r2]
