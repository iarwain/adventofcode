REBOL [
  Title: {Day 8}
  Date: 08-12-2017
]

data: map-each line read/lines %data/8.txt [load line]

; --- Part 1 ---
cpu: context [
  reg: op: val: cond: peak: 0 program: copy data
  regs: context insert [0] sort collect [
    foreach line program [keep to-set-word line/1]
  ]
  make-rule: func [list [block!]] [collect [foreach entry list [keep reduce [to-lit-word entry '|]]]]
  op-rule: make-rule [{>} {<} {>=} {<=} {==} {!=}]
  reg-rule: make-rule words-of regs
  instr-rule: [
    set reg reg-rule
    set op ['inc | 'dec] (op: switch op [inc ['add] dec ['subtract]])
    set val integer!
    copy cond ['if reg-rule op-rule integer!]
    (do bind repend/only cond [to-set-word reg op reg val to-set-word 'peak 'max reg 'peak] regs)
  ]
  run: does [
    peak: 0 foreach reg words-of regs [set reg 0]
    foreach line program [
      unless attempt [parse line instr-rule] [return rejoin [{Invalid instruction: [} line {]}]]
    ]
    first maximum-of values-of regs
  ]
]
print [{Part 1:} r1: cpu/run]

; --- Part 2 ---
print [{Part 2:} r2: cpu/peak]
