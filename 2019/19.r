REBOL [
  Title: {Day 19}
  Date: 19-12-2019
]

; This one needs Rebol3 (Ren-C) in order to be able to do integer operations on 64 bits.
data: load replace/all read %data/19.txt {,} { }

; --- Part 1 ---
beam: context [
  icc: context [
    memory: ip: base: last: _
    compute: func [inputs /log <local> grow opcode ops op1 op2 op3 in-ops out-ops mode res] [
      if not block? inputs [inputs: to-block inputs] res: _
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
                0 [keep (in-op/1 + 1) grow in-op/1 + 1 memory/(in-op/1 + 1)]
                1 [keep (in-op/1 + 1) in-op/1]
                2 [keep (in-op/1 + 1 + base) grow in-op/1 + base + 1 memory/(in-op/1 + base + 1)]
              ]
            ]
            mode: to-integer mode / 10
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
            if empty? inputs [print "EMERGENCY STOP!" return []]
            grow out-ops/1
            memory/(out-ops/1): take inputs
            if log [prin to-char memory/(out-ops/1)]
            ip + 2
          ]
          4 [
            res: in-ops/1
            if log [attempt [prin to-char res]]
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
  field: func [width height <local> res] [
    res: 0
    repeat i width [
      repeat j height [
        icc/reset
        all [
          1 = icc/compute reduce [j - 1 i - 1]
          res: res + 1
        ]
      ]
    ]
    res
  ]
  fit: func [size <local> x y offset] [
    test: func [x y] [
      icc/reset
      icc/compute reduce [x y]
    ]
    ; Arbitrary start point to reduce the processing time with R3
    y: 1000 x: 0 offset: size - 1
    until [x: x + 1 1 = test x y]
    until [x: x + 1 0 = test x y]
    x: x - 1
    until [
      y: y + 1
      while [1 = test x y] [x: x + 1] x: x - 1
      1 = test x - offset y + offset
    ]
    10'000 * (x - offset) + y
  ]
]

r1: beam/field 50 50
print [{Part 1:} r1]

; --- Part 2 ---
r2: beam/fit 100
print [{Part 1:} r2]
