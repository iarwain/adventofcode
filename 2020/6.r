REBOL [
  Title: {Day 6}
  Date: 06-12-2020
]

data: append read %data/6.txt {^/^/}

; --- Part 1 ---
groups: collect [
  parse data [
    some [
      copy group to {^/^/} some {^/}
      (keep/only parse group {^/})
    ]
  ]
]
r1: 0 foreach group groups [
  check: {}
  r1: r1 + length? foreach votes group [
    check: union check votes
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0 foreach group groups [
  check: {abcdefghijklmnopqrstuvwxyz}
  r2: r2 + length? foreach votes group [
    check: intersect check votes
  ]
]
print [{Part 2:} r2]
