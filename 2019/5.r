REBOL [
  Title: {Day 5}
  Date: 05-12-2019
]

data: load replace/all read %data/5.txt {,} { }

; --- Part 1 ---
compute: func [input /local ip memory opcode op1 op2 op3 mem-ops mode instructions res] [
  ip: memory: copy data
  while [ip/1 != 99] [
    opcode: first+ ip set [op1 op2 op3] mem-ops: copy/part ip 3
    mode: round opcode / 100 opcode: opcode // 100
    forall mem-ops [
      if 0 = (mode // 10) [
        mem-ops/1: memory/(mem-ops/1 + 1)
      ]
      mode: round mode / 10
    ]
    ip: switch opcode [
      1 [
        memory/(op3 + 1): mem-ops/1 + mem-ops/2
        skip ip 3
      ]
      2 [
        memory/(op3 + 1): mem-ops/1 * mem-ops/2
        skip ip 3
      ]
      3 [
        memory/(op1 + 1): input
        skip ip 1
      ]
      4 [
        res: mem-ops/1
        skip ip 1
      ]
      5 [
        either mem-ops/1 != 0 [
          at memory (mem-ops/2 + 1)
        ] [
          skip ip 2
        ]
      ]
      6 [
        either mem-ops/1 = 0 [
          at memory (mem-ops/2 + 1)
        ] [
          skip ip 2
        ]
      ]
      7 [
        memory/(op3 + 1): pick [1 0] mem-ops/1 < mem-ops/2
          skip ip 3
      ]
      8 [
        memory/(op3 + 1): pick [1 0] mem-ops/1 = mem-ops/2
          skip ip 3
      ]
    ]
  ]
  res
]

r1: compute 1
print [{Part 1:} r1]

; --- Part 2 ---
r2: compute 5
print [{Part 2:} r2]
