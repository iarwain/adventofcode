REBOL [
  Title: {Day 17}
  Date: 17-12-2019
]

data: load replace/all read %data/17.txt {,} { }

; --- Part 1 ---
ascii: context [
  intersection?: clean: none
  use [icc map] [
    icc: context [
      memory: ip: base: last: none
      compute: func [inputs /log /local grow opcode ops op1 op2 op3 in-ops out-ops mode res] [
        unless block? inputs [inputs: to-block inputs] res: none
        grow: func [size /local length] [
          all [size > length: length? memory insert/dup tail memory 0 size - length]
        ]
        while [memory/:ip != 99] [
          opcode: memory/:ip in-ops: copy/part set [op1 op2 op3] skip memory ip 3
          mode: to-integer (opcode / 100) opcode: (opcode // 100)
          out-ops: collect [
            forall in-ops [
              in-ops/1: c: switch to-integer (mode // 10) [
                0 [keep (in-ops/1 + 1) grow in-ops/1 + 1 memory/(in-ops/1 + 1)]
                1 [keep (in-ops/1 + 1) in-ops/1]
                2 [keep (in-ops/1 + 1 + base) grow in-ops/1 + base + 1 memory/(in-ops/1 + base + 1)]
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
        memory: copy data ip: 1 base: 0 last: none
      ]
    ]
    intersection?: funct [] [
      icc/reset
      pos: 0x0
      set 'map make hash! collect [
        while [not block? res: icc/compute/log []] [
          either res = newline [
            pos: as-pair 0 pos/y + 1
          ] [
            keep reduce [pos to-char res]
            pos/x: pos/x + 1
          ]
        ]
      ]
      sum: 0 check: array/initial 5 #"#"
      foreach [pos cell] map [
        if check = map-each dir [0x0 -1x0 1x0 0x-1 0x1] [select map pos + dir][
          sum: pos/x * pos/y + sum
        ]
      ]
      sum
    ]
    clean: funct [] [
      to-ascii: func [value /local letter steps action] [
        letter: charset [#"A" - #"Z" #"a" - #"z"]
        head change back tail collect [
          parse value [
            some [
              [ copy action letter (keep to-integer to-char action)
              | copy steps integer! (forall steps [keep to-integer steps/1])
              ] (keep to-integer #",")
            ]
          ]
        ] to-integer #"^/"
      ]
      foreach [dir value] [-1x0 #"<" 1x0 #">" 0x-1 #"^^" 0x1 #"V"] [
        if last-pos: find map value [
          last-dir: dir last-pos: first back last-pos
          break
        ]
      ]
      path: rejoin collect [
        dirs: [-1x0 0x-1 1x0 0x1 -1x0]
        until [
          steps: 0
          foreach turn [#"L" #"R"] [
            dir: either turn = #"L" [
              first back find next dirs last-dir
            ] [
              select dirs last-dir
            ]
            pos: last-pos
            while [#"#" = select map pos: pos + dir] [steps: steps + 1]
            if steps != 0 [
              keep reduce [turn steps]
              last-dir: dir last-pos: pos - dir
              break
            ]
          ]
          steps = 0
        ]
      ]
      next-command?: funct [path] [digit: charset [#"0" - #"9"] parse path [copy result [[#"L" | #"R"] 1 2 digit]] result]
      count?: funct [path pattern] [result: 0 parse path [some [pattern (result: result + 1) | skip]] result]
      foreach [name program] programs: [A "" B "" C ""] [
        parse path [any [#"A" | #"B" | #"C"] start:]
        while [
          all [
            21 >= length? to-ascii pattern: ajoin [program command: next-command? start]
            1 < count? path pattern
          ]
        ] [
          append program command
          start: skip start length? command
        ]
        replace/all path program to-string name
      ]
      icc/reset
      icc/memory/1: 2
      inputs: collect [
        foreach input reduce [
          path
          programs/A
          programs/B
          programs/C
          "n"
        ] [
          keep to-ascii input
        ]
      ]
      until [
        res: icc/compute/log inputs
        block? res
      ]
      res/1
    ]
  ]
]

r1: ascii/intersection?
print [{Part 1:} r1]

; --- Part 2 ---
r2: ascii/clean
print [{Part 2:} r2]
