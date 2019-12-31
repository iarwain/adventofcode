REBOL [
  Title: {Day 12}
  Date: 12-12-2019
]

data: read %data/12.txt

; --- Part 1 ---
n-body: context [
  moons: collect [
    use [x y z] [
      parse data [
        some [
          {<x=} copy x to {,} skip
          {y=} copy y to {,} skip
          {z=} copy z to {>} skip (keep/only reduce [load x load y load z])
        | skip
        ]
      ]
    ]
  ]
  compute: funct [/energy steps] [
    init: does [
      current-moons: copy/deep moons
      velocities: array/initial length? moons copy [0 0 0]
    ]
    step: funct [/state axis] [
      forall current-moons [
        index: index? current-moons
        foreach test head current-moons [
          if current-moons/1 != test [
            repeat i 3 [
              velocities/:index/:i: velocities/:index/:i + case [
                current-moons/1/:i < test/:i [1]
                current-moons/1/:i > test/:i [-1]
                true [0]
              ]
            ]
          ]
        ]
      ]
      forall current-moons [
        repeat i 3 [
          current-moons/1/:i: current-moons/1/:i + velocities/(index? current-moons)/:i
        ]
      ]
      if state [
        collect [
          repeat i length? moons [
            keep reduce [current-moons/:i/:axis velocities/:i/:axis]
          ]
        ]
      ]
    ]
    either energy [
      init
      loop steps [
        step
      ]
      energy: 0
      forall current-moons [
        potential: kinetic: 0 index: index? current-moons
        repeat i 3 [
          potential: potential + abs current-moons/1/:i
          kinetic: kinetic + abs velocities/:index/:i
        ]
        energy: energy + (kinetic * potential)
      ]
      energy
    ] [
      cycles: collect [
        history: make hash! []
        repeat i 3 [
          init
          clear history
          count: 0
          forever [
            state: step/state i
            either find history state [
              keep to-decimal count
              break
            ] [
              append history state
              count: count + 1
            ]
          ]
        ]
      ]
      gcd: func [m n] [
        while [n > 0] [set [m n] reduce [n m // n]]
        m
      ]
      ; Returning Least Common Multiple of all 3 axis-independent cycles
      head clear find form cycles/1 / (gcd cycles/1 cycles/2) * cycles/2 / (gcd cycles/2 cycles/3) * cycles/3 {.0}
    ]
  ]
]

r1: n-body/compute/energy 1000
print [{Part 1:} r1]

; --- Part 2 ---
r2: n-body/compute
print [{Part 2:} r2]
