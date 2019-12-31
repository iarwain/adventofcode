REBOL [
  Title: {Day 10}
  Date: 10-12-2019
]

data: read %data/10.txt

; --- Part 1 ---
belt: context [
  station: none map: collect [
    use [pos] [
      pos: 0x0
      parse/all data [
        some
        [ [#"#" (keep pos) | #"."] (pos: pos + 1x0)
        | newline (pos: as-pair 0 pos/y + 1)
        | skip
        ]
      ]
    ]
  ]
  do compute: funct [] [
    gcd: func [m n] [
      while [n > 0] [set [m n] reduce [n m // n]]
      m
    ]
    angle?: funct [pos] [
      dir: pos - station/pos
      ; (Pi/2 + ATan2 dir/x dir/y) % 2*Pi
      mod ((0.5 * pi) + either any [(dir/x > 0) (dir/y != 0)] [2 * arctangent/radians (dir/y / (dir/x + square-root ((dir/x * dir/x) + (dir/y * dir/y))))] [pi]) (2 * pi)
    ]
    best: sort/compare collect [
      foreach pos map [
        asteroids: copy []
        foreach asteroid map [
          if pos != asteroid [
            dir: asteroid - pos
            case [
              dir/x = 0 [dir/y: sign? dir/y]
              dir/y = 0 [dir/x: sign? dir/x]
              true      [dir: divide dir gcd abs dir/x abs dir/y]
            ]
            test: pos
            until [
              test: test + dir
              if test = asteroid [append asteroids asteroid]
              find map test
            ]
          ]
        ]
        keep/only reduce [pos asteroids]
      ]
    ] func [a b] [(length? a/2) > (length? b/2)]
    set 'station context [
      pos: best/1/1
      vis-set: best/1/2
    ]
    sort/compare station/vis-set func [a b] [(angle? a) < (angle? b)]
  ]
]

r1: length? belt/station/vis-set
print [{Part 1:} r1]

; --- Part 2 ---
r2: 100 * belt/station/vis-set/200/x + belt/station/vis-set/200/y
print [{Part 2:} r2]
