REBOL [
  Title: {Day 20}
  Date: 20-12-2017
]

data: read %data/20.txt

; --- Part 1 ---
vec: context [
  x: y: z: 0
  length?: does [(abs x) + (abs y) + (abs z)]
  add: func [o] [x: x + o/x y: y + o/y z: z + o/z]
  hash: does [checksum/method reform [x y z] 'sha1]
]
sort/compare particles: collect [
  index: 0
  data: load replace/all data charset [{=<,>}] { }
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

r1: particles/1/id
print [{Part 1:} r1]

; --- Part 2 ---
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

r2: length? particles
print [{Part 2:} r2]
