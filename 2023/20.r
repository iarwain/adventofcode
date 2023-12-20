REBOL [
  Title: {Day 20}
  Date: 20-12-2023
]

data: read/lines %data/20.txt

machine: context [
  propagate: use [wiring back-wiring] [
    back-wiring: map []
    wiring: map collect [
      foreach line data [
        parse line [copy sw to { } thru {> } copy values to end]
        switch/default first sw [
          #"%" [value: 0 first+ sw]
          #"&" [value: copy [] first+ sw]
        ] [value: none]
        keep sw: to-word sw
        keep/only reduce [value dests: load rejoin [{[} trim/with values {,} {]}]]
        foreach dest dests [try/with [append back-wiring/:dest sw] [back-wiring/:dest: reduce [sw]]]
      ]
    ]
    foreach [name sw] wiring [
      if block? sw/1 [foreach src back-wiring/:name [repend sw/1 [src 0]]]
    ]
    funct [/final] [
      lcm: funct [values] [
        gcd: funct [m n] [while [n > 0] [set [m n] reduce [n m // n]] m]
        res: first+ values
        forall values [
          res: res * values/1 / gcd res values/1
        ]
      ]
      flip: funct [/local name src pulse] [
        pulses: copy [broadcaster none 0]
        until [
          set [name src pulse] take/part pulses 3
          sw: state/:name
          ++ (pick [low high] pulse = 0)
          if pulse = 0 [
            if find watch-list name [
              either find history name [
                append cycles it - history/:name
                remove find watch-list name
              ] [
                history/:name: it
              ]
            ]
          ]
          try [
            send: true
            case [
              block? sw/1 [
                sw/1/:src: pulse pulse: 0 foreach [n p] sw/1 [if p = 0 [pulse: 1 break]]
              ]
              integer? sw/1 [
                either pulse = 0 [sw/1: pulse: 1 - sw/1] [send: false]
              ]
            ]
            all [send foreach dest sw/2 [repend pulses [dest name pulse]]]
          ]
          empty? pulses
        ]
      ]
      state: copy/deep wiring
      if final [
        targets: [rx]
        watch-list: remove-each target copy while [1 = length? targets] [targets: back-wiring/(targets/1)] [
          not block? wiring/:target/1
        ]
      ]
      low: high: it: 0 cycles: copy [] history: map []
      until [
        ++ it flip
        either final [empty? watch-list] [it = 1000]
      ]
      either final [lcm cycles] [low * high]
    ]
  ]
]

; --- Part 1 ---
r1: machine/propagate
print [{Part 1:} r1]

; --- Part 2 ---
r2: machine/propagate/final
print [{Part 2:} r2]
