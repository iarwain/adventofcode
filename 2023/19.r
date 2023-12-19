REBOL [
  Title: {Day 19}
  Date: 19-12-2023
]

data: read/string %data/19.txt

avalanche: context [
  rating?: use [input flows] [
    input: split data [newline newline]
    flows: map collect [
      comp: charset {<>}
      foreach entry split first input newline [
        parse/case entry [
          copy flow to "{" skip (keep flow index: 1)
          some [
            copy var to comp copy op comp copy value to {:} skip copy label to {,} skip
            (sub: join flow ++ index keep/only reduce pick [[to-word var load value reduce [label sub]] [to-word var 1 + load value reduce [sub label]]] op = {<} keep sub)
          | copy label to "}" skip
            (keep label)
          ]
        ]
      ]
    ]
    funct [/total] [
      either total [
        count: funct [state parts] [
          switch/default state [
            {A} [res: 1 foreach [_ value] parts [res: res * (value/2 - value/1 + 1)]]
            {R} [res: 0]
          ] [
            state: flows/:state
            try/with [
              range: get in parts state/1
              case [
                state/2 > range/2   [res: count state/3/1 parts]
                state/2 <= range/1  [res: count state/3/2 parts]
                true                [
                  set in left: copy parts state/1 reduce [range/1 state/2 - 1]
                  set in right: copy parts state/1 reduce [state/2 range/2]
                  res: (count state/3/1 left) + (count state/3/2 right)
                ]
              ]
            ] [res: count state parts]
          ]
          res
        ]
        res: count {in} context [x: [1 4000] m: [1 4000] a: [1 4000] s: [1 4000]]
      ] [
        parts: map-each part split second input newline [
          foreach [src dst] ["{" {[} "}" {]} "=" {: } "," { }] [replace/all part src dst]
          context load part
        ]
        res: 0
        foreach part parts [
          state: {in} until [
            try [state: flows/:state state: pick state/3 state/2 > get in part state/1]
            find [{A} {R}] state
          ]
          all [state = {A} res: res + part/x + part/m + part/a + part/s]
        ]
      ]
      res
    ]
  ]
]

; --- Part 1 ---
r1: avalanche/rating?
print [{Part 1:} r1]

; --- Part 2 ---
r2: avalanche/rating?/total
print [{Part 2:} r2]
