REBOL [
  Title: {Day 20}
  Date: 20-12-2017
]

; Set analytical to true to use the analytical approach which is the definitive solution (it will find all the collisions, no matter how late they happen) but takes much longer to run with the given data.
analytical: false

data: read %data/20.txt

; --- Part 1 ---
use [vec] [
  sort/compare particles: collect [
    vec: context [
      x: y: z: 0
      length?: does [(abs x) + (abs y) + (abs z)]
      add: func [o] [x: x + o/x y: y + o/y z: z + o/z]
      hash: does [checksum/method reform [x y z] 'sha1]
    ]
    index: 0 data: load replace/all data charset [{=<,>}] { }
    parse data [
      some [
        'p copy pos [3 integer!] 'v copy vel [3 integer!] 'a copy acc [3 integer!]
        (keep context [id: ++ index p: make vec [x: pos/1 y: pos/2 z: pos/3] v: make vec [x: vel/1 y: vel/2 z: vel/3] a: make vec [x: acc/1 y: acc/2 z: acc/3]])
      ]
    ]
  ]
  func [a b] [
    to-logic any [
      a/a/length? < b/a/length?
      all [a/a/length? == b/a/length? a/v/length? < b/v/length?]
      all [a/a/length? == b/a/length? a/v/length? == b/v/length? a/p/length? < b/p/length?]
    ]
  ]
]

r1: particles/1/id
print [{Part 1:} r1]

; --- Part 2 ---
either analytical [
  simulate: funct [] [
    collide?: funct [p0 [object!] p1 [object!]] [
      axes: [x y z] roots: [x [] y [] z []]
      foreach axe axes [
        neg-b: negate b: p0/v/:axe + (0.5 * p0/a/:axe) - p1/v/:axe - (0.5 * p1/a/:axe)
        c: p0/p/:axe - p1/p/:axe
        either 0 != two-a: p0/a/:axe - p1/a/:axe [
          either 0 <= delta: (b ** 2) - (2 * two-a * c) [
            sqrt-delta: square-root delta coef: 1 / two-a
            roots/:axe: reduce [coef * (neg-b - sqrt-delta) coef * (neg-b + sqrt-delta)]
          ] [
          return false
          ]
        ] [
          either neg-b != 0 [roots/:axe: reduce [c / neg-b]] [return false]
        ]
      ]
      pick intersect intersect roots/x roots/y roots/z 1
    ]
    collisions: sort/skip collect [
      foreach p0 particles [
        foreach p1 particles [
          all [
            time: collide? p0 p1
            time = to-integer time
            keep time keep/only reduce [p0 p1]
          ]
        ]
      ]
    ] 2
    batch: copy [] last-time: 0
    foreach [time col] collisions [
      if last-time != time [
        last-time: time
        foreach particle unique batch [remove find particles particle]
        clear batch
      ]
      all [
        p1: find particles col/1
        p2: find particles col/2
        repend batch [p1/1 p2/1]
      ]
    ]
    foreach particle unique batch [remove find particles particle]
    length? particles
  ]
] [
  simulate: funct [] [
    loop-count: 0 max-gap: 10
    until [
      positions: make hash! []
      foreach particle particles [
        particle/v/add particle/a
        particle/p/add particle/v
        either colliders: select positions hash: particle/p/hash [
          append colliders particle/id
        ] [
          repend positions [hash reduce [particle/id]]
        ]
      ]
      old-length: length? particles
      foreach [hash colliders] positions [
        if 1 < length? colliders [
          remove-each particle particles [find colliders particle/id]
        ]
      ]
      if old-length != length? particles [loop-count: 0]
      max-gap == loop-count: loop-count + 1
    ]
    length? particles
  ]
]

r2: simulate
print [{Part 2:} r2]
