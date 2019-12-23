REBOL [
  Title: {Day 23}
  Date: 23-12-2019
]

; This one needs Rebol3 (Ren-C) in order to be able to do integer operations on 64 bits.
data: load replace/all read %data/23.txt {,} { }

; --- Part 1 ---
network: context [
  log: copy {} computers: _
  process: func [/first <local> log icc computer nat old-nat idle result message] [
    log: func [entry] [append network/log trim form reduce [reduce entry newline]]
    icc: [
      memory: ip: base: last: _
      compute: func [inputs /log <local> grow opcode ops op1 op2 op3 in-ops out-ops mode res] [
        if not block? inputs [inputs: to-block inputs]
        res: _
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
              if empty? inputs [if log [print ["BREAK!"]] return []]
              grow out-ops/1
              memory/(out-ops/1): take inputs
              if log [attempt [prin to-char memory/(out-ops/1)]]
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
    computers: collect [
      repeat i 50 [
        keep computer: reduce [context copy icc reduce [i - 1] copy []]
        computer/1/compute computer/2
      ]
    ]
    log ["*** START [" pick ["FIRST" "WAKE"] to-logic first "] ***"]
    nat: old-nat: []
    forever [
      idle: true
      for-each [computer input output] computers [
        ; Compute
        until [
          attempt [log ["RECV" (index? find computers computer) - 1 "X" input/1 "Y" input/2]]
          if empty? input [insert input -1]
          append output result: computer/compute input
          block? result
        ]
        ; Distribute
        while [3 <= length? output] [
          message: take/part output 3
          case [
            message/1 <= 50 [
              idle: false
              append computers/(message/1 * 3 + 2) next message
              log ["SEND" message/1 "X" message/2 "Y" message/3 "FROM" (index? find computers computer) - 1]
            ]
            message/1 = 255 [
              nat: copy next message
              if first [return nat]
            ]
          ]
        ]
      ]
      ; Wake?
      if idle [
        log ["WAKING" 0 "X" nat/1 "Y" nat/2]
        if old-nat = nat [
          return nat
        ]
        append computers/2 old-nat: nat
        nat: copy []
      ]
    ]
  ]
]

r1: second network/process/first
print [{Part 1:} r1]

; --- Part 2 ---
r2: second network/process
print [{Part 2:} r2]
