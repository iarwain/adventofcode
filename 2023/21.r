REBOL [
  Title: {Day 21}
  Date: 21-12-2023
]

data: read/lines %data/21.txt
garden: context [
  steps?: funct [/long] [
    walk: funct [steps] [
      counts: copy [0 1] current: reduce [start] previous: copy []
      repeat it steps [
        current: unique collect [
          foreach location current [
            foreach dir [1x0 -1x0 0x1 0x-1] [
              pos: location + dir
              all [
                #"#" != data/(pos/y - 1 // size/y + 1)/(pos/x - 1 // size/x + 1)
                not find previous pos
                keep pos
              ]
            ]
          ]
          previous: current
        ]
        ; Optimization: when stepping, we go back to where we were 2 steps before + expansion
        append counts (pick tail counts -2) + length? current
      ]
      skip counts 2
    ]
    forall data [if found: find data/1 #"S" [start: as-pair index? found index? data]]
    size: as-pair length? data/1 length? data
    either long [
      divider: to-integer (steps: 26501365) / size/x
      remainder: steps // size/x
      steps: walk 2 * size/x + 1
      lin: steps/(remainder + size/x) - steps/(remainder)
      quad: (last steps) - (mid: steps/(size/x + 1)) - (mid - first steps)
      quad * divider * (divider - 1) / 2 + (lin * divider) + steps/:remainder
    ] [
      last walk 64
    ]
  ]
]

; --- Part 1 ---
r1: garden/steps?
print [{Part 1:} r1]

; --- Part 2 ---
r2: garden/steps?/long
print [{Part 2:} r2]
