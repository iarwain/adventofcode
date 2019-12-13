REBOL [
  Title: {Day 13}
  Date: 13-12-2019
]

; This one needs Rebol3 (Ren-C) in order to be able to do integer operations on 64 bits.
data: load replace/all read %data/13.txt {,} { }

; --- Part 1 ---
arcade: context [
  run: count: _
  use [tiles] [
    run: func [/count /play <local> icc input score x y type ball pad] [
      tiles: copy []
      icc: context [
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
      if play [
        icc/memory/1: 2
        ball: pad: _
      ]
      score: input: 0
      forever [
        x: icc/compute input
        y: icc/compute input
        type: icc/compute input
        if any [block? x block? y block? type] [break]
        either play [
          case [
            all [x = -1 y = 0]  [score: type]
            type = 3            [pad: as-pair x y]
            type = 4            [ball: as-pair x y]
          ]
          if all [pair? pad pair? ball] [
            input: case [
              ball/x < pad/x  [-1]
              ball/x > pad/x  [1]
              true            [0]
            ]
          ]
        ] [
          append tiles reduce [as-pair x y type]
        ]
      ]
      score
    ]
    count: func [type <local> res] [
      res: 0
      for-each tile tiles [
        if tile = type [res: res + 1]
      ]
      res
    ]
  ]
]

arcade/run
r1: arcade/count 2
print [{Part 1:} r1]

; --- Part 2 ---
r2: arcade/run/play
print [{Part 2:} r2]
