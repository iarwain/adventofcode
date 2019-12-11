REBOL [
  Title: {Day 11}
  Date: 11-12-2019
]

; This one needs Rebol3 (Ren-C) in order to be able to do integer operations on 64 bits.
data: load replace/all read %data/11.txt {,} { }

; --- Part 1 ---
paintbot: context [
  registration: panels: _
  paint: func [init /display <local> icc current color turn pos dir temp] [
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
    process-image: func [<local> tl br] [
      tl: 0x0 br: 0x0
      for-each [pos color] panels [
        tl: min tl pos
        br: max br pos
      ]
      registration: make image! reduce [br - tl + 1x1]
      for-each [pos color] panels [
        registration/(pos - tl + 1x1): either color = 0 [black] [white]
      ]
      registration
    ]
    panels: copy reduce [pos: 0x0 init] dir: copy 0x-1
    forever [
      current: any [select panels pos 0]
      color: icc/compute current turn: icc/compute current
      all [
        block? color
        block? turn
        break
      ]
      either find panels pos [
        panels/:pos: color
      ] [
        append panels reduce [pos color]
      ]
      temp: dir/x
      either turn = 0 [
        dir/x: 0 - dir/y dir/y: temp
      ] [
        dir/x: dir/y dir/y: 0 - temp
      ]
      pos: pos + dir
    ]
    either display [process-image] [(length? panels) / 2]
  ]
]

r1: paintbot/paint 0
print [{Part 1:} r1]

; --- Part 2 ---
save %registration.png paintbot/paint/display 1
show-program: {
  REBOL []
  registration: load %registration.png
  view layout [image (5 * registration/size) registration effect [flip 1x0 fit] [unview]]
  quit
}
print [{Part 2: Result displayed in image.}]
attempt [call form reduce [{r2-view -s --do "} show-program {"}]]
