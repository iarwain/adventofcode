REBOL [
  Title: {Day 24}
  Date: 24-12-2019
]

data: read %data/24.txt

; --- Part 1 ---
eris: context [
  evolve: funct [/recursive steps] [
    empty: #"." bug: #"#"
    either recursive [
      bugs: collect [
        pos: 0x0
        parse data [
          some [
            some [
              [ bug (keep/only reduce [0 pos])
              | empty
              ] (pos/x: pos/x + 1)
            ] newline (pos: as-pair 0 pos/y + 1)
          ]
        ]
      ]
      neighbors?: funct [lvl pos] [
        result: 0
        foreach neighbor collect [
          foreach dir [-1x0 1x0 0x-1 0x1] [
            test: pos + dir
            case [
              test/x = -1 [
                keep/only reduce [lvl - 1 1x2]
              ]
              test/x = 5 [
                keep/only reduce [lvl - 1 3x2]
              ]
              test/y = -1 [
                keep/only reduce [lvl - 1 2x1]
              ]
              test/y = 5 [
                keep/only reduce [lvl - 1 2x3]
              ]
              test = 2x2 [
                switch pos [
                  2x1 [
                    for i 0 4 1 [
                      keep/only reduce [lvl + 1 as-pair i 0]
                    ]
                  ]
                  2x3 [
                    for i 0 4 1 [
                      keep/only reduce [lvl + 1 as-pair i 4]
                    ]
                  ]
                  1x2 [
                    for i 0 4 1 [
                      keep/only reduce [lvl + 1 as-pair 0 i ]
                    ]
                  ]
                  3x2 [
                    for i 0 4 1 [
                      keep/only reduce [lvl + 1 as-pair 4 i ]
                    ]
                  ]
                ]
              ]
              true [keep/only reduce [lvl test]]
            ]
          ]
        ] [
          if find/only bugs neighbor [result: result + 1]
        ]
        result
      ]
      loop steps [
        bugs: collect [
          for level bugs/1/1 - 1 (first last bugs) + 1 1 [
            for i 0 4 1 [
              for j 0 4 1 [
                if 2x2 != pos: as-pair j i [
                  neighbors: neighbors? level pos
                  if any [all [none? find/only bugs reduce [level pos] neighbors = 2] neighbors = 1] [
                    keep/only reduce [level pos]
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
      length? bugs
    ] [
      map: collect [
        pos: 0x0
        parse data [
          some [
            some [
              [ empty (keep reduce [pos empty])
              | bug (keep reduce [pos bug])
              ] (pos/x: pos/x + 1)
            ] newline (pos: as-pair 0 pos/y + 1)
          ]
        ]
      ]
      neighbors?: funct [pos] [
        result: 0
        foreach dir [1x0 -1x0 0x1 0x-1] [
          attempt [if map/(pos + dir) = bug [result: result + 1]]
        ]
        result
      ]
      history: make hash! []
      while [not find/only history map] [
        append/only history copy map
        map: collect [
          foreach [pos cell] map [
            neighbors: neighbors? pos
            keep reduce [pos either any [all [cell = empty neighbors = 2] neighbors = 1] [bug] [empty]]
          ]
        ]
      ]
      biodiversity: 0
      foreach [pos cell] map [
        if cell = bug [
          biodiversity: biodiversity + power 2 (pos/x + (5 * pos/y))
        ]
      ]
      head clear find form biodiversity ".0"
    ]
  ]
]

r1: eris/evolve
print [{Part 1:} r1]

; --- Part 2 ---

r2: eris/evolve/recursive 200
print [{Part 2:} r2]
