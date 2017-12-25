REBOL [
  Title: {Day 25}
  Date: 25-12-2017
]

data: read %data/25.txt

; --- Part 1 ---
core: context [
  start: iterations: 0
  steps: collect [
    use [name state index value]
    [
      parse data [
        thru {begin in state} copy start to {.} (start: to-word trim start)
        thru {checksum after} copy iterations integer! (iterations: load iterations)
        some [
          thru {in state} copy name to {:} (keep name: to-word trim name keep/only state: array [2 3])
          2 [
            thru {value is} copy index integer! (index: 1 + load index)
            thru {the value} copy value integer! (state/:index/1: pick [unset set] {0} = trim value)
            thru {one slot to the} [{right} (state/:index/2: 'right) | {left} (state/:index/2: 'left)]
            thru {with state} copy name to {.} (state/:index/3: to-word trim name)
          ]
        ]
      ]
    ]
  ]
  diagnose: funct [] [
    memory: make bitset! size: ((2 * iterations + 1 + 8) and complement 7)
    state: start pos: iterations left: -1 right: 1
    is-set?: does [to-logic find memory pos]
    set: does [insert/part memory pos 1]
    unset: does [remove/part memory pos 1]
    bind steps 'memory
    loop iterations [
      action: either is-set? [steps/:state/2] [steps/:state/1]
      do action/1
      pos: pos + do action/2
      state: action/3
    ]
    count: either find memory 0 [1] [0]
    repeat i size - 1 [if find memory i [count: count + 1]]
    count
  ]
]

r1: core/diagnose
print [{Part 1:} r1]

; --- Part 2 ---
r2: {There's no part 2! :-)}
print [{Part 2:} r2]
