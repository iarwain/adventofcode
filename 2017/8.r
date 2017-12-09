REBOL [
  Title: {Day 8}
  Date: 08-12-2017
]

data: load %data/8.txt

; --- Part 1 ---
cpu: context [
  peak: 0 i-size: 7 ip: program: copy data
  regs: context insert [0] sort collect [
    forskip program i-size [keep to-set-word program/1]
  ]
  rule: [
    ip:
    set reg word!
    set op ['inc | 'dec] (op: switch op [inc ['add] dec ['subtract]])
    set val integer!
    copy cond ['if 2 word! integer!]
    (do bind repend/only cond [to-set-word reg op reg val to-set-word 'peak 'max reg 'peak] regs)
  ]
  run: does [
    either attempt [parse program [any rule]] [
      first maximum-of values-of regs
    ] [
      reduce [{Invalid instruction:} copy/part ip i-size]
    ]
  ]
]
print [{Part 1:} r1: cpu/run]

; --- Part 2 ---
print [{Part 2:} r2: cpu/peak]
