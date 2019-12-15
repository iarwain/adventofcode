REBOL [
  Title: {Day 15}
  Date: 15-12-2019
]

data: load replace/all read %data/15.txt {,} { }

; --- Part 1 ---
droid: context [
  trail: copy [] discover: fill: show: none
  use [map dirs fill-time? step reset-map] [
    map: make hash! []
    dirs: [0x-1 0x1 -1x0 1x0]
    fill-time?: does [
      (first maximum-of/skip next map 2) - 2
    ]
    step: funct [] [
      current: fill-time? + 2
      foreach [pos value] map [
        if value = current [
          foreach dir dirs [
            test-pos: pos + dir
            all [
              select map test-pos
              map/:test-pos = 1
              map/:test-pos: current + 1
            ]
          ]
        ]
      ]
    ]
    reset-map: does [
      foreach [pos value] map [
        if value > 2 [
          map/:pos: 1
        ]
      ]
    ]
    discover: funct [] [
      icc: context [
        memory: ip: base: last: none
        compute: func [inputs /local opcode ops op1 op2 op3 in-ops out-ops mode res] [
          inputs: to-block inputs res: none
          grow: func [size /local length] [
            all [size > length: length? memory insert/dup tail memory 0 size - length]
          ]
          while [memory/:ip != 99] [
            opcode: memory/:ip in-ops: copy/part set [op1 op2 op3] skip memory ip 3
            mode: to-integer (opcode / 100) opcode: (opcode // 100)
            out-ops: collect [
              forall in-ops [
                attempt [
                  in-ops/1: switch to-integer (mode // 10) [
                    0 [keep (in-ops/1 + 1) memory/(in-ops/1 + 1)]
                    1 [keep (in-ops/1 + 1) in-ops/1]
                    2 [keep (in-ops/1 + 1 + base) memory/(in-ops/1 + base + 1)]
                  ]
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
                grow out-ops/1
                memory/(out-ops/1): first inputs
                inputs: next inputs
                ip + 2
              ]
              4 [
                res: in-ops/1
                ip + 2
              ]
              5 6 [
                ops: [not-equal? equal?]
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
      use [pos] [
        pos: 0x0
        move: funct [dir] [
          test-pos: pos + dirs/:dir
          append map reduce [test-pos res: icc/compute dir]
          if res != 0 [set 'pos test-pos]
          res
        ]
        roam: funct [] [
          repeat dir 4 [
            unless find map (pos + dirs/:dir) [
              if 0 != res: move dir [
                append trail pos
                if any [2 = res 2 = res: roam] [break]
                clear back tail trail
                move switch dir [1 [2] 2 [1] 3 [4] 4 [3]]
              ]
            ]
          ]
          res
        ]
      ]
      clear map clear trail
      roam
      set 'map unique/skip map 2

      length? droid/trail
    ]
    fill: funct [] [
      reset-map
      until [
        step
        not find map 1
      ]
      fill-time?
    ]
    show: funct [/animate] [
      render: does [
        foreach [pos value] map [
          bitmap/(pos - tl): case [
            pos = 0x0       [red]
            value = 2       [blue]
            value >= 2      [cyan]
            find trail pos  [leaf]
            value = 1       [wheat]
            value = 0       [black]
          ]
        ]
      ]
      tl: br: 0x0
      foreach [pos color] map [
        tl: min tl pos
        br: max br pos
      ]
      bitmap: make image! reduce [size: br - tl + 1x1]
      reset-map
      render
      either animate [
        view layout [
          panel [
            across text bold brick "Time:" txt: text bold leaf "000"
          ]
          img: image (size * 8) bitmap key #"^(esc)" [unview]
          rate 60 feel [
            engage: func [face action event] [
              switch action [
                time [
                  unless find map 1 [reset-map]
                  step
                  render
                  set-face txt form fill-time?
                  set-face img bitmap
                ]
              ]
            ]
          ]
        ]
      ] [
        window: layout [image (size * 8) bitmap key #"^(esc)" [unview]]
        save/png %droid.png to-image window
        view window
      ]
    ]
  ]
]

r1: droid/discover
print [{Part 1:} r1]

; --- Part 2 ---
r2: droid/fill
print [{Part 2:} r2]
droid/show/animate
