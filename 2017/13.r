REBOL [
  Title: {Day 13}
  Date: 13-12-2017
]

data: read %data/13.txt

; --- Part 1 ---
firewall: context [
  use [depth range] [
    data: collect [
      parse read %data/13.txt [
        some [copy depth integer! skip copy range integer! (keep load depth keep load range) skip]
      ]
    ]
  ]
  scanner: context [
    range: 0
    position: func [step [integer!]] [
      all [
        range > 0
        (length: range - 1) - (abs length - step + 1 // (2 * length)) + 1
      ]
    ]
  ]
  scanners: array (pick data (length? data) - 1) + 1
  foreach [d r] data [poke scanners (d + 1) make scanner [range: r]]
  collisions: has [depth] [
    collect [
      forall scanners [
        all [
          scanners/1
          1 == scanners/1/position (depth: index? scanners)
          keep depth
        ]
      ]
    ]
  ]
  cost: has [result] [
    result: 0
    foreach collision collisions [
      result: result + ((collision - 1) * get in pick firewall/scanners collision 'range)
    ]
  ]
]

r1: firewall/cost
print [{Part 1:} r1]

; --- Part 2 ---
delay-firewall: make firewall [
  delay?: has [delay collide] [
    delay: -1
    until [
      delay: delay + 1 collide: false scanners: head scanners
      forall scanners [
        all [
          scanners/1
          1 == scanners/1/position (index? scanners) + delay
          collide: true
          break
        ]
      ]
      not collide
    ]
    delay
  ]
]

r2: delay-firewall/delay?
print [{Part 2:} r2]
