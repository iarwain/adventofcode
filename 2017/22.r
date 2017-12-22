REBOL [
  Title: {Day 22}
  Date: 22-12-2017
]

data: read/lines %data/22.txt

; --- Part 1 ---
sporifica-virus: make virus: context [
  states: [clean infected clean]
  actions: [
    clean     [dir: (mod dir length) + 1]
    infected  [dir: (mod dir - 2 length) + 1]
  ]
  length: length? dirs: [0x-1 -1x0 0x1 1x0] dir: 1
  grid: make hash! collect [
    forall data [
      line: data/1 forall line [
        keep reduce [as-pair index? line index? data pick [clean infected] line/1 = #"."]
      ]
    ]
  ]
  move: func [iterations [integer!] /local state? toggle pos count] [
    state?: does [any [select grid pos 'clean]]
    toggle: has [node state] [
      either none? node: find grid pos [
        append grid reduce [pos state: select states 'clean]
      ] [
        poke node 2 state: select states node/2
      ]
      state = 'infected
    ]
    pos: as-pair round 0.5 * length? data/1 round 0.5 * length? data
    count: 0 dir: 1 unless iterations [iterations: 1]
    loop iterations [
      switch state? actions
      if toggle [count: count + 1]
      pos: pos + dirs/:dir
    ]
    count
  ]
] []

r1: sporifica-virus/move 10000
print [{Part 1:} r1]

; --- Part 2 ---
evolved-virus: make virus [
  states: [clean weakened infected flagged clean]
  actions: [
    clean     [dir: (mod dir length) + 1]
    infected  [dir: (mod dir - 2 length) + 1]
    flagged   [dir: (mod dir + 1 length) + 1]
  ]
]

r2: evolved-virus/move 10000000
print [{Part 2:} r2]
