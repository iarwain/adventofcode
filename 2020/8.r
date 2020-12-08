REBOL [
  Title: {Day 8}
  Date: 08-12-2020
]

data: read/lines %data/8.txt

; --- Part 1 ---

handheld: context [
  run: fix: none
  use [ip acc program init] [
    ip: 1 acc: 0 program: copy init: data
    run: has [seen] [
      ip: 1 acc: 0 seen: copy []
      while [all [ip <= length? program not find seen ip]] [
        append seen ip
        parse program/:ip [
          [ {nop} to end
          | {acc} copy value to end (acc: acc + load value)
          ] (ip: ip + 1)
        | {jmp} copy value to end (ip: ip + load value)
        ]
      ]
      acc
    ]
    fix: has [offset] [
      offset: 0 until [
        offset: offset + 1 program: copy init
        if parse/all program/:offset [
          [{nop} (new: {jmp}) | {jmp} (new: {nop})]
          copy value to end (program/:offset: reform [new value])
        ] [
          run
        ]
        ip > length? program
      ]
      acc
    ]
  ]
]
r1: handheld/run
print [{Part 1:} r1]

; --- Part 2 ---
r2: handheld/fix
print [{Part 2:} r2]
