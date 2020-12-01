REBOL [
  Title: {Day 15}
  Date: 15-12-2018
]

; [WIP]: Never optimized (C version was used due to performance reasons)

data: read/lines %data/15.txt

directions: [0x-1 -1x0 1x0 0x1]
map: array reduce [size: length? data/1 length? data]
units: collect [
  forall data [
    line: data/1 forall line [
      map/(y: index? data)/(x: index? line): switch line/1 [
        #"#"  ['wall]
        #"."  ['ground]
        #"G"  [keep context [type: 'goblin hp: 200 strength: 3 pos: as-pair x y]]
        #"E"  [keep context [type: 'elf hp: 200 strength: 3 pos: as-pair x y]]
      ]
    ]
  ]
]
killed: copy [elf 0 goblin 0]
distance?: funct [pos1 pos2] [
  vec: abs pos1 - pos2
  vec/x + vec/y
]

find-path: func [src dst] [
  o-set: make hash! reduce [src context [pos: src cost: 0 parent: none]] c-set: make hash! [] paths: copy []
  first-step?: funct [node] [
    while [node/parent/parent] [node: node/parent]
    index? find directions (node/pos - node/parent/pos)
  ]
  while [current: take remove o-set] [
    ;print ["AT" current/pos]
    foreach dir directions [
      all [
        newpos: current/pos + dir
        'ground = tile: map/(newpos/y)/(newpos/x)
        not found? find c-set newpos
        (
          newcost: current/cost + 1
          case [
            newpos = dst [
              ;print ["PATH" newpos newcost]
              append paths context [pos: newpos cost: newcost parent: current]
            ]
            entry: select o-set newpos [
              if ((newcost < entry/cost) or ((newcost = entry/cost) and ((first-step? current) < (first-step? entry)))) [
                entry/cost: newcost
                entry/parent: current
              ]
            ]
            true [
              ;print ["ADD" newpos]
              append o-set reduce [newpos context [pos: newpos cost: newcost parent: current]]
            ]
          ]
        )
      ]
    ]
    append c-set current/pos
  ]
  either empty? paths [
    none
  ] [
    sort/compare paths func [a b] [
      (a/cost < b/cost) or ((a/cost = b/cost) and ((first-step? a) < (first-step? b)))
    ]
    reduce [paths/1/cost pick directions first-step? paths/1]
  ]
]

get-move: funct [unit targets] [
  either empty? moves: collect [
    best-distance: 1'000
    foreach [position entity] targets [
      unless best-distance < distance? unit/pos position [
        if path: find-path unit/pos position [
          keep context [dir: path/2 target: entity cost: path/1 * size * size + position/y * size + position/x]
          best-distance: path/1
        ]
      ]
    ]
  ] [
    none
  ] [
    sort/compare moves func [a b] [a/cost < b/cost]
    reduce [moves/1/dir moves/1/target]
  ]
]

pick-melee-target: funct [unit] [
  either empty? targets: collect [
    foreach dir directions [
      all [
        pos: unit/pos + dir
        object? target: map/(pos/y)/(pos/x)
        target/type != unit/type
        target/hp > 0
        keep reduce [target/hp target]
      ]
    ]
  ] [
    none
  ] [
    first next minimum-of/skip targets 2
  ]
]

pick-target: funct [unit] [
  either target: pick-melee-target unit [
    target: reduce [0x0 target]
  ] [
    targets: collect [
      foreach other units [
        all [
          other/type != unit/type
          other/hp > 0
          foreach dir directions [
            all [
              pos: other/pos + dir
              map/(pos/y)/(pos/x) = 'ground
              keep reduce [pos other]
            ]
          ]
        ]
      ]
    ]
    target: get-move unit targets
  ]
  all [
    target
    ;print [unit/type "at" unit/pos "targets" target/2/type "at" target/2/pos "moving" target/1]
  ]
  target
]

move: funct [unit dir] [
  map/(unit/pos/y)/(unit/pos/x): 'ground
  unit/pos: unit/pos + dir
  map/(unit/pos/y)/(unit/pos/x): unit
]

attack: funct [unit target] [
  target/hp: target/hp - unit/strength
  all [
    target/hp <= 0
    map/(target/pos/y)/(target/pos/x): 'ground
    killed/(target/type): killed/(target/type) + 1
    print [unit/type "at" unit/pos "killed" target/type "at" target/pos]
  ]
]

dump: does [
  foreach line map [
    creatures: copy {}
    foreach tile line [
      case [
        tile = 'ground      [prin "."]
        tile = 'wall        [prin "#"]
        tile/type = 'elf    [prin "E" append creatures rejoin [" E(" tile/hp ")"]]
        tile/type = 'goblin [prin "G" append creatures rejoin [" G(" tile/hp ")"]]
      ]
    ]
    print creatures
  ]
]

tick: does [
  foreach unit sort/compare units func [a b] [(a/pos/y * size + a/pos/x) < (b/pos/y * size + b/pos/x)] [
    if unit/hp > 0 [
      if target: pick-target unit [
        move unit target/1
        all [
          target: pick-melee-target unit
          attack unit target
        ]
      ]
    ]
  ]
  factions: 0
  foreach type [goblin elf] [
    foreach unit units [
      all [
        unit/type = type
        unit/hp > 0
        factions: factions + 1
        break
      ]
    ]
  ]
  factions > 1
]

; --- Part 1 ---

t: 0
while [tick] [
  print ["TICK" t: t + 1]
  ;dump
]

print ["Battle's over!"]

hp: 0 foreach unit units [hp: hp + (max 0 unit/hp)]
r1: t * hp
print [{Part 1:} r1]

; --- Part 2 ---

elf-strength: copy [0 0] cc: 0
results: copy []
r2: forever [
  cc: cc + 1
  test-strength: either elf-strength/1 = max elf-strength/1 elf-strength/2 [elf-strength/1 + 5] [round/floor elf-strength/1 + elf-strength/2 / 2]
  print ["Testing elf's strength:" test-strength]
  map: array reduce [size: length? data/1 length? data]
  units: collect [
    forall data [
      line: data/1 forall line [
        map/(y: index? data)/(x: index? line): switch line/1 [
          #"#"  ['wall]
          #"."  ['ground]
          #"G"  [keep context [type: 'goblin hp: 200 strength: 3 pos: as-pair x y]]
          #"E"  [keep context [type: 'elf hp: 200 strength: test-strength pos: as-pair x y]]
        ]
      ]
    ]
  ]
  killed: copy [elf 0 goblin 0]
  elfcount: 0 t: 0
  until [
    unless any [
      res: not tick
      res: killed/elf > 0
    ] [
      print ["TICK" t: t + 1]
    ]
    res
  ]
  hp: 0 foreach unit units [hp: hp + (max 0 unit/hp)]
  repend results [to-string test-strength t * hp]

  either killed/elf = 0 [
    print ["VICTORY!"]
    elf-strength/2: test-strength
  ] [
    print ["DEFEAT!"]
    elf-strength/1: test-strength
  ]
  if 1 = (elf-strength/2 - elf-strength/1) [
    break/return results/(to-string elf-strength/2)
  ]
]

print [{Part 2:} r2]
