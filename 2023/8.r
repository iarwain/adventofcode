REBOL [
  Title: {Day 8}
  Date: 08-12-2023
]

data: read/lines %data/8.txt

maps: context [
  navigate:
  use [next-instruction? reset-instructions network start] [
    next-instruction?: does [
      all [tail? instructions instructions: head instructions]
      first+ instructions
    ]
    reset-instructions: does [instructions: head instructions]
    instructions: take data network: map []
    start: collect [
      foreach line next data [
        nodes: split line [3 4 3 2 3]
        all [#"A" = last nodes/1 keep nodes/1]
        network/(nodes/1): reduce [nodes/3 nodes/5]
      ]
    ]
    funct [/ghost] [
      either ghost [
        lcm: funct [values] [
          gcd: funct [m n] [while [n > 0] [set [m n] reduce [n m // n]] m]
          res: first+ values
          forall values [
            res: res * values/1 / gcd res values/1
          ]
        ]
        lcm collect [
          nodes: copy start
          until [
            current: first+ nodes count: 0 reset-instructions
            history: copy []
            until [
              ++ count
              current: pick network/:current #"L" = next-instruction?
              #"Z" = last current
            ]
            keep count
            empty? nodes
          ]
        ]
      ] [
        current: first sort copy start count: 0 reset-instructions
        until [
          ++ count
          current: pick network/:current #"L" = next-instruction?
          {ZZZ} = current
        ]
        count
      ]
    ]
  ]
]

; --- Part 1 ---
r1: maps/navigate
print [{Part 1:} r1]

; --- Part 2 ---
r2: maps/navigate/ghost
print [{Part 2:} r2]
