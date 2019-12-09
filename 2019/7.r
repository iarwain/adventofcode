REBOL [
  Title: {Day 7}
  Date: 07-12-2019
]

data: load replace/all read %data/7.txt {,} { }

; --- Part 1 ---
intcode-computer: context [
  memory: ip: last: none
  compute: func [inputs /local opcode op1 op2 op3 mem-ops mode res ops] [
    inputs: to-block inputs res: none
    while [memory/:ip != 99] [
      opcode: memory/:ip mem-ops: copy/part set [op1 op2 op3] skip memory ip 2
      mode: round opcode / 100 opcode: opcode // 100
      forall mem-ops [
        if 0 = (mode // 10) [
          mem-ops/1: memory/(mem-ops/1 + 1)
        ]
        mode: round mode / 10
      ]
      ip: switch opcode [
        1 2 [
          ops: [add multiply]
          memory/(op3 + 1): do reduce [ops/:opcode mem-ops/1 mem-ops/2]
          ip + 4
        ]
        3 [
          memory/(op1 + 1): first+ inputs
          ip + 2
        ]
        4 [
          res: mem-ops/1
          ip + 2
        ]
        5 6 [
          ops: [not-equal? equal?]
          either do reduce [ops/(opcode - 4) mem-ops/1 0] [
            mem-ops/2 + 1
          ] [
            ip + 3
          ]
        ]
        7 8 [
          ops: [lesser? equal?]
          memory/(op3 + 1): pick [1 0] do reduce [ops/(opcode - 6) mem-ops/1 mem-ops/2]
          ip + 4
        ]
      ]
      all [res return last: res]
    ]
    return reduce [last]
  ]
  do reset: does [
    memory: copy data ip: 1 last: none
  ]
]
get-permutations: funct [values] [
  collect [
    do gen: func [values length] [
      either length = 1 [
        keep/only copy values
      ] [
        repeat i length [
          gen values length - 1
          either 0 = (length and 1) [
            swap at values i at values length
          ] [
            swap values at values length
          ]
        ]
      ]
    ] copy values length? values
  ]
]

r1: first maximum-of collect [
  use [comp signal] [
    foreach settings get-permutations [0 1 2 3 4] [
      signal: 0
      foreach value settings [
        signal: intcode-computer/compute reduce [value signal]
        intcode-computer/reset
      ]
      keep signal
    ]
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: first maximum-of collect [
  computers: array/initial 5 does [make intcode-computer []]
  foreach settings get-permutations [5 6 7 8 9] [
    signal: 0
    forall computers [
      computers/1/reset
      signal: computers/1/compute reduce [first+ settings signal]
    ]
    until [
      forall computers [
        signal: computers/1/compute reduce [signal]
      ]
      block? signal
    ]
    keep signal/1
  ]
]
print [{Part 2:} r2]
