REBOL [
  Title: {Day 17}
  Date: 17-12-2021
]

data: read %data/17.txt

; --- Part 1 ---
trench: context [
  highest: hits: 0
  use [vertices target launch digits value values] [
    digits: charset {-0123456789}
    values: collect [parse data [some [copy value some digits (keep load value) | skip]]]
    target: context [
      min: as-pair values/1 values/3
      max: as-pair values/2 values/4
    ]
    launch: funct [vel /x-only] [
      pos: 0x0 hit: false vertex: 0
      until [
        pos: pos + vel
        vel: vel - as-pair sign? vel/x 1
        vertex: max vertex pos/y
        all [
          pos/x >= target/min/x pos/x <= target/max/x
          any [x-only all [pos/y >= target/min/y pos/y <= target/max/y]]
          hit: true
        ]
        any [pos/x > target/max/x either x-only [vel/x = 0] [pos/y < target/min/y]]
      ]
      reduce [hit vertex]
    ]
    hits: length? vertices: collect [
      foreach x collect [for x 0 target/max/x 1 [if first launch/x-only as-pair x 0 [keep x]]] [
        for y target/min/y negate target/min/y 1 [all [first value: launch as-pair x y keep value/2]]
      ]
    ]
    highest: first maximum-of vertices
  ]
]

r1: trench/highest
print [{Part 1:} r1]

; --- Part 2 ---
r2: trench/hits
print [{Part 2:} r2]
