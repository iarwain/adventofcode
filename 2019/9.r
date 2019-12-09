REBOL [
  Title: {Day 9}
  Date: 09-12-2019
]

; This one needs Rebol3 (Ren-C) in order to be able to do integer operations on 64 bits.
data: load replace/all read %data/9.txt {,} { }

; --- Part 1 ---
intcode-computer: context [
  memory: ip: base: last: _
  compute: func [inputs <local> opcode ops op1 op2 op3 in-ops out-ops mode res] [
    inputs: to-block inputs res: _
    grow: func [size <local> length] [
      all [size > length: length? memory insert/dup tail memory 0 size - length]
    ]
    while [memory/:ip != 99] [
      opcode: memory/:ip in-ops: copy/part set [op1 op2 op3] skip memory ip 3
      mode: to-integer (opcode / 100) opcode: (opcode mod 100)
      out-ops: collect [
        for-next in-op in-ops [
          attempt [
            in-op/1: switch to-integer (mode mod 10) [
              0 [keep (in-op/1 + 1) memory/(in-op/1 + 1)]
              1 [keep (in-op/1 + 1) in-op/1]
              2 [keep (in-op/1 + 1 + base) memory/(in-op/1 + base + 1)]
            ]
          ]
          mode: round mode / 10
        ]
      ]
      ip: switch opcode [
        1 2 [
          ops: [add multiply]
          grow out-ops/3
          memory/(out-ops/3): do reduce [ops/:opcode in-ops/1 in-ops/2]
          ip + 4
        ]
        3 [
          grow out-ops/1
          memory/(out-ops/1): first inputs
          inputs: next inputs
          ip + 2
        ]
        4 [
          res: in-ops/1
          ip + 2
        ]
        5 6 [
          ops: [not-equal? equal?]
          either do reduce [ops/(opcode - 4) in-ops/1 0] [
            in-ops/2 + 1
          ] [
            ip + 3
          ]
        ]
        7 8 [
          ops: [lesser? equal?]
          grow out-ops/3
          memory/(out-ops/3): pick [1 0] do reduce [ops/(opcode - 6) in-ops/1 in-ops/2]
          ip + 4
        ]
        9 [
          base: base + in-ops/1
          ip + 2
        ]
      ]
      all [res return last: res]
    ]
    return reduce [last]
  ]
  do reset: does [
    memory: copy data ip: 1 base: 0 last: _
  ]
]
r1: intcode-computer/compute 1
print [{Part 1:} r1]

; --- Part 2 ---
intcode-computer/reset
r2: intcode-computer/compute 2
print [{Part 2:} r2]
