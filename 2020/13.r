REBOL [
  Title: {Day 13}
  Date: 13-12-2020
]

data: read/lines %data/13.txt

; --- Part 1 ---
early: load data/1
buses: sort/skip collect [
  foreach bus schedule: load replace/all data/2 {,} { } [
    all [number? bus keep reduce [(bus * round/ceiling early / bus) - early bus]]
  ]
] 2
r1: buses/1 * buses/2
print [{Part 1:} r1]

; --- Part 2 ---
gcd: func [m n] [while [n > 0] [set [m n] reduce [n m // n]] m]
r2: 0 lcm: to-decimal first+ schedule
forall schedule [
  if number? schedule/1 [
    check: mod negate (index? schedule) - 1 schedule/1
    while [(r2 // schedule/1) != check] [r2: r2 + lcm]
    lcm: lcm / (gcd lcm schedule/1) * schedule/1
  ]
]
print [{Part 2:} copy/part r2: form r2 find r2 {.}]
