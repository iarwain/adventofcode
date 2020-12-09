REBOL [
  Title: {Day 8}
  Date: 08-12-2020
]

data: read/lines %data/8.txt

; --- Part 1 ---
handheld: context [
  solve: fix: none
  use [accumulator ip acc jmp nop program init] [
    acc: func [value] [accumulator: accumulator + value]
    jmp: func [value] [ip: ip + value - 1]
    nop: func [value] []
    program: copy init: bind collect [
      foreach line data [keep/only load line]
    ] 'acc
    solve: has [seen] [
      accumulator: 0 ip: 1 seen: copy []
      while [all [ip <= length? program not find seen ip]] [
        append seen ip
        do program/:ip
        ip: ip + 1
      ]
      accumulator
    ]
    fix: has [mapping offset] [
      mapping: [jmp nop jmp] offset: 0
      until [
        offset: offset + 1 program: copy/deep init
        if find mapping program/:offset/1 [
          change program/:offset mapping/(program/:offset/1)
          solve
        ]
        ip > length? program
      ]
      accumulator
    ]
  ]
]
r1: handheld/solve
print [{Part 1:} r1]

; --- Part 2 ---
r2: handheld/fix
print [{Part 2:} r2]
