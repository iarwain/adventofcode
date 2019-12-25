REBOL [
  Title: {Day 25}
  Date: 25-12-2019
]

; This one needs Rebol3 (Ren-C) in order to be able to do integer operations on 64 bits.
data: load replace/all read %data/25.txt {,} { }

; --- Part 1 ---
game: context [
  play: func [/solve /grue /greedy /escape /infinite /magnet /lava <local> icc to-ascii command solution] [
    icc: context [
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
              if empty? inputs [return []]
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
    to-ascii: func [commands] [
      collect [
        for-each command to-block commands [
          keep head append map-each letter command [to-integer letter] to-integer newline
        ]
      ]
    ]
    command: to-ascii case [
      solve     [["north" "north" "north" "take mutex" "south" "south" "east" "north" "take loom" "south" "west" "south" "west" "west" "take sand" "south" "east" "north" "take wreath" "south" "west" "north" "north" "east" "east"]]
      grue      [["east" "east" "north" "take photons"]]
      escape    [["north" "east" "take escape pod"]]
      infinite  [["east" "east" "north" "west" "take infinite loop"]]
      magnet    [["east" "east" "north" "west" "west" "take giant electromagnet"]]
      lava      [["west" "west" "south" "take molten lava"]]
      greedy    [["north" "north" "north" "take mutex" "south" "south" "east" "north" "take loom" "south" "west" "south" "east" "take semiconductor" "east" "take ornament" "west" "west" "west" "west" "take sand" "south" "east" "take asterisk" "north" "take wreath" "south" "west" "north" "north" "take dark matter" "east" "inv"]]
      true      [[]]
    ]
    forever [
      until [
        block? icc/compute/log command
      ]
      command: to-ascii input
    ]
  ]
]

r1: {Play the adventure game and find the solution!}
print [{Part 1:} r1]
game/play

; --- Part 2 ---
r2: {There's no part 2! :-)}
print [{Part 2:} r2]
