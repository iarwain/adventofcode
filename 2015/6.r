REBOL [
  Title: {Day 6}
  Date: 30-01-2018
]

; This one requires REBOL View, for image manipulation / colors

data: load replace/all read %data/6.txt {,} { }

; --- Part 1 ---
commands: collect [
  parse data [
    some [
      ['turn 'on (command: 'on) | 'turn 'off (command: 'off) | 'toggle (command: 'toggle)]
      set src-x integer! set src-y integer! 'through set dst-x integer! set dst-y integer!
      (keep reduce [command as-pair src-x src-y as-pair dst-x dst-y])
    ]
  ]
]
lights: make image! 1000x1000
foreach [command src dst] commands [
  delta: dst - src + 1
  switch command [
    on      [change/dup at lights src white delta]
    off     [change/dup at lights src black delta]
    toggle  [lights: to-image layout/tight [image lights at src image delta effect [merge invert]]]
  ]
]
r1: 0 lookup: lights
while [lookup: find/tail lookup white] [r1: r1 + 1]
print [{Part 1:} r1]

; --- Part 2 ---
lights2: array/initial 1000 * 1000 0
foreach [command src dst] commands [
  value: switch command [
    on      [1]
    off     [-1]
    toggle  [2]
  ]
  for i src/x dst/x 1 [
    for j src/y dst/y 1 [
      index: j * 1000 + i + 1
      lights2/:index: max 0 (lights2/:index + value)
    ]
  ]
]
r2: 0
foreach light lights2 [r2: r2 + light]
print [{Part 2:} r2]
