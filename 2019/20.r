REBOL [
  Title: {Day 20}
  Date: 20-12-2019
]

data: read %data/20.txt

; --- Part 1 ---
donut: context [
  roam: map: none
  use [empty tunnels outer] [
    use [pos gate wall gates cell pos1 gate1 pos2 gate2 dist tunnel tl br] [
      gate: charset [#"A" - #"Z"] wall: #"#" empty: #"."
      gates: make hash! [] tunnels: make hash! [] pos: 0x0
      map: make hash! collect [
        parse/all data [
          some [
            [ copy cell wall
            | copy cell empty
            | copy cell gate (append gates reduce [pos to-char cell])
            ] (keep reduce [pos to-char cell] pos/x: pos/x + 1)
          | newline (pos: as-pair 0 pos/y + 1)
          | skip (pos/x: pos/x + 1)
          ]
        ]
      ]
      until [
        pos1: take gates gate1: take gates
        foreach [pos2 gate2] gates [
          dist: abs pos1 - pos2
          if 1 = (dist/x + dist/y) [
            gate: rejoin [gate1 gate2]
            pos: either any [
              empty = select map pos1 - 1x0
              empty = select map pos1 - 0x1
            ] [pos1] [pos2]
            remove/part find map pos1 2
            remove/part find map pos2 2
            append map reduce [pos gate]
            either tunnel: find tunnels gate [
              insert next tunnel pos
            ] [
              append tunnels reduce [gate pos]
            ]
          ]
        ]
        empty? gates
      ]
      tl: 1000x1000 br: 0x0
      foreach [pos cell] map [
        tl: min tl pos
        br: max br pos
      ]
      outer: make hash! collect [
        foreach tunnel tunnels [
          if pair? tunnel [
            if any [
              tunnel/x = tl/x
              tunnel/y = tl/y
              tunnel/x = br/x
              tunnel/y = br/y
            ] [
              keep tunnel
            ]
          ]
        ]
      ]
    ]
    roam: funct [/recursive] [
      dirs: [1x0 0x1 -1x0 0x-1]
      pos: tunnels/("AA")
      foreach dir dirs [
        if empty = select map pos + dir [
          pos: pos + dir
          break
        ]
      ]
      level: 1 result: 1'000'000'000
      queue: copy reduce [to-tuple reduce [pos/x pos/y level]]
      visited: reduce [make hash! reduce [pos 0]]
      until [
        key: take queue
        pos: as-pair key/1 key/2 level: key/3
        dist: visited/:level/:pos
        if dist < result [
          foreach dir dirs [
            test-pos: pos + dir continue: false
            either old-dist: select visited/:level test-pos [
              if old-dist > (dist + 1) [
                visited/:level/:test-pos: dist + 1
                continue: true
              ]
            ] [
              append visited/:level reduce [test-pos dist + 1]
              continue: true
            ]
            if continue [
              test-cell: select map test-pos
              case [
                test-pos = tunnels/("AA")       []
                test-pos = tunnels/("ZZ")       [all [level = 1 dist < result result: dist]]
                empty = test-cell               [append queue to-tuple reduce [test-pos/x test-pos/y level]]
                tunnel: find tunnels test-cell  [
                  out: either test-pos = tunnel/2 [tunnel/3] [tunnel/2]
                  new-level: case [
                    not recursive       [1]
                    find outer test-pos [level - 1]
                    true                [level + 1]
                  ]
                  if new-level >= 1 [
                    all [recursive new-level > length? visited append/only visited make hash! []]
                    either old-dist: select visited/:new-level out [
                      all [old-dist > dist visited/:new-level/:out: dist]
                    ] [
                      append visited/:new-level reduce [out dist]
                      append queue to-tuple reduce [out/x out/y new-level]
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]
        empty? queue
      ]
      result
    ]
  ]
]

r1: donut/roam
print [{Part 1:} r1]

; --- Part 2 ---
r2: donut/roam/recursive
print [{Part 1:} r2]
