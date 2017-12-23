REBOL [
  Title: {Day 22}
  Date: 22-12-2017
]

data: read/lines %data/22.txt

; --- Part 1 ---
virus: context [
  actions: []
  length: length? dirs: [0x-1 -1x0 0x1 1x0]
  dir: 1 pos: as-pair round 0.5 * length? data/1 round 0.5 * length? data
  grid: make hash! collect [
    forall data [
      line: data/1 forall line [
        keep reduce [as-pair index? line index? data pick [clean infected] line/1 = #"."]
      ]
    ]
  ]
  state?: does [any [select grid pos 'clean]]
  move: func [iterations [integer!] /local states toggle count] [
    append states: collect [foreach [state action] actions [keep state]] states/1
    toggle: has [node state] [
      either none? node: find grid pos [
        append grid reduce [pos state: select states 'clean]
      ] [
        poke node 2 state: select states node/2
      ]
      state = 'infected
    ]
    count: 0
    loop iterations [
      switch state? actions
      if toggle [count: count + 1]
      pos: pos + dirs/:dir
    ]
    count
  ]
]
sporifica-virus: make virus [
  actions: [
    clean     [dir: (mod dir length) + 1]
    infected  [dir: (mod dir - 2 length) + 1]
  ]
]

r1: sporifica-virus/move 10'000
print [{Part 1:} r1]

; --- Part 2 ---
evolved-virus: make virus [
  actions: [
    clean     [dir: (mod dir length) + 1]
    weakened  []
    infected  [dir: (mod dir - 2 length) + 1]
    flagged   [dir: (mod dir + 1 length) + 1]
  ]
]

r2: evolved-virus/move 10'000'000
print [{Part 2:} r2]
