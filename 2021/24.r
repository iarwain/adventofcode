REBOL [
  Title: {Day 24}
  Date: 24-12-2021
]

; !! This one requires REBOL 3 due to the 32bit signed integer limitation of REBOL 2 and slower map! performance !!

; The original code was executing the instructions defined in the input, but it was slow.
; The instructions are now hand-compiled into a faster version, however the relevant parameters are still automatically extracted from the original input.

comment [
  data: map-each line read/lines %data/24.txt [load line]
  inp: func ['i1] [
    set i1 take in
  ]
  add: func ['i1 i2] [
    set i1 (get i1) + i2
  ]
  mul: func ['i1 i2] [
    set i1 (get i1) * i2
  ]
  div: func ['i1 i2] [
    set i1 to-integer (get i1) / i2
  ]
  mod: func ['i1 i2] [
    set i1 (get i1) // i2
  ]
  eql: func ['i1 i2] [
    set i1 pick [1 0] i2 == get i1
  ]
  x: y: z: w: 0 in: [9 9 9 9 9 9 9 9 9 9 9 9 9 9]
  foreach line data [
    if line/1 = 'inp [print [{x} x {y} y {z} z {w} w]]
    do line
  ]
]

monad: context [
  validate: none
  use [parameters value] [
    parameters: collect [
      parse read %data/24.txt [
        some [
          thru {div z} copy value to newline (keep load value)
          thru {add x} copy value to newline (keep load value)
          thru {add y w}
          thru {add y} copy value to newline (keep load value)
        ]
      ]
    ]
    validate: funct [/first] [
      run: funct [in z params start stop inc] [
        result: false
        if all [
          z < 10000000
          not select seen id: in + (10 * index? params) + (500 * z)
        ] [
          append seen reduce [id true]
          ; --- BEGIN: hand-compiled instructions ---
          mod: z // 26
          all [params/1 != 1 z: to-integer z / params/1]
          if in != (mod + params/2) [
            z: (z * 26) + params/3 + in
          ]
          ; --- END: hand-compiled instructions ---
          either empty? params: skip params 3 [
            all [z = 0 result: reduce [in]]
          ] [
            for i start stop inc [
              if result: run i z params start stop inc [insert result in break]
            ]
          ]
        ]
        result
      ]
      seen: make map! []
      either first [start: 1 stop: 9 inc: 1] [start: 9 stop: 1 inc: -1]
      for i start stop inc [if result: run i 0 parameters start stop inc [return rejoin head result]]
    ]
  ]
]

; --- Part 1 ---
r1: monad/validate
print [{Part 1:} r1]

; --- Part 2 ---
r2: monad/validate/first
print [{Part 2:} r2]
