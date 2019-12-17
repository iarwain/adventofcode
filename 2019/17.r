REBOL [
  Title: {Day 17}
  Date: 17-12-2019
]

; Part #2 needs to be solved programmatically, current solution uses hand-crafted path

data: load replace/all read %data/17.txt {,} { }

; --- Part 1 ---
ascii: context [
  intersection?: clean: none
  use [icc] [
    icc: context [
      memory: ip: base: last: none
      compute: func [inputs /local grow opcode ops op1 op2 op3 in-ops out-ops mode res] [
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
              ;prin to-char memory/(out-ops/1)
              ip + 2
            ]
            4 [
              res: in-ops/1
              ip + 2
            ]
            5 6 [
              ops: [not-equal? equal?]
              if none? in-ops/1 [halt]
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
      map: parse rejoin collect [
        while [not block? res: icc/compute []] [
          keep to-char res
        ]
      ] none
      sum: 0
      forall map [
        if all [not head? map not tail? next map] [
          line: map/1
          forall line [
            if all [
              line/1 = #"#"
              line/2 = #"#"
              line/-1 = #"#"
              map/-1/(index? line) = #"#"
              map/2/(index? line) = #"#"
            ] [
              sum: ((index? map) - 1) * ((index? line) - 1) + sum
            ]
          ]
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
      icc/reset
      icc/memory/1: 2
      inputs: collect [
        foreach block [
        "AABCBCBCBA"
        "R6L12R6"
        "L12R6L8L12"
        "R12L10L10"
        "n"
        ] [
          keep to-ascii block
        ]
      ]
      until [
        res: icc/compute inputs
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
