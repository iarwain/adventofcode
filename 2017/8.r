REBOL [
  Title: {Day 8}
  Date: 08-12-2017
]

data: map-each line read/lines %data/8.txt [load line]

; --- Part 1 ---
cpu: context [
  op: reg: val: cond: peak: 0 ip: program: copy data
  regs: context insert [0] sort collect [
    foreach line program [keep to-set-word line/1]
  ]
  instruction: [
    set reg word!
    set op ['inc | 'dec] (op: switch op [inc ['add] dec ['subtract]])
    set val integer!
    copy cond ['if 2 word! integer!]
    (do bind repend/only cond [to-set-word reg op reg val to-set-word 'peak 'max reg 'peak] regs)
  ]
  run: does [
    peak: 0
    foreach line program [
      unless attempt [parse line instruction] [return rejoin [{Invalid instruction: [} ip: line {]}]]
    ]
    first maximum-of values-of regs
  ]
]
print [{Part 1:} r1: cpu/run]

; --- Part 2 ---
print [{Part 2:} r2: cpu/peak]
