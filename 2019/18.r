REBOL [
  Title: {Day 18}
  Date: 18-12-2019
]

; This solution is far too slow in the case of data3 (though we get lucky after a few minutes) and the original data (player input), but works flawlessly for the other data sets.
; Needs to be ported back from the non-REBOL version that contains the following optimizations + clean-up:
; - use BFS instead of DFS
; - cache states while solving (pos/inventory) for early exits
; This will not happen tonight though...

data: read %data/18.txt

data1: {########################
#f.D.E.e.C.b.A.@.a.B.c.#
######################.#
#d.....................#
########################}

data2: {########################
#...............b.C.D.f#
#.######################
#.....@.a.B.c.d.A.e.F.g#
########################}

data3: {#################
#i.G..c...e..H.p#
########.########
#j.A..b...f..D.o#
########@########
#k.E..a...g..B.n#
########.########
#l.F..d...h..C.m#
#################}

data4: {########################
#@..............ac.GI.b#
###d#e#f################
###A#B#C################
###g#h#i################
########################}

; --- Part 1 ---
r1: 0

pos: 0x0
key: charset [#"a" - #"z"]
door: charset [#"A" - #"Z"]
wall: #"#"
empty: #"."
entrance: #"@"
doors: make hash! []
keys: make hash! []
map: make hash! collect [
  parse data [
    some [
      [ copy cell wall
      | copy cell empty
      | copy cell entrance (player: pos)
      | copy cell door (append doors reduce [pos to-char cell])
      | copy cell key (append keys reduce [pos to-char cell])
      ] (keep reduce [pos to-char cell] pos/x: pos/x + 1)
    | newline (pos: as-pair 0 pos/y + 1)
    ]
  ]
]

in-range: funct [pos inventory] [
  dirs: [0x-1 0x1 -1x0 1x0]
  visited: make hash! reduce [pos empty] trail: 0
  elements: collect [
    do roam: funct [] [
      foreach dir dirs [
        test-pos: pos + dir
        unless find visited test-pos [
          append visited test-pos
          test-cell: select map test-pos
          if any [
            test-cell = empty
            test-cell = entrance
            find key test-cell
            all [
              find door test-cell
              ;print ["TESTING DOOR" test-cell]
              find inventory lowercase test-cell
            ]
          ] [
            ;print ["MOVING TO" test-pos]
            ;append trail set 'pos test-pos
            set 'pos test-pos
            set 'trail trail + 1
            either all [
              find key test-cell
              not find inventory test-cell
            ] [
              keep reduce [pos test-cell trail]
            ] [
              roam
            ]
            set 'pos pos - dir
            set 'trail trail - 1
            ;clear back tail trail
          ]
        ]
      ]
    ]
  ]
]
path-to: funct [pos inventory target] [
  dirs: [0x-1 0x1 -1x0 1x0]
  visited: make hash! reduce [pos empty] trail: copy []
  do roam: funct [] [
    repeat dir 4 [
      test-pos: pos + dirs/:dir
      unless find visited test-pos [
        append visited test-pos
        test-cell: select map test-pos
        if any [
          test-cell = empty
          test-cell = entrance
          find key test-cell
          all [
            find door test-cell
            ;print ["TESTING DOOR" test-cell]
            find inventory lowercase test-cell
          ]
        ] [
          ;print ["MOVING TO" test-pos]
          append trail set 'pos test-pos
          either test-cell = target [
            return true
          ] [
            if roam [return true]
          ]
          set 'pos pos - dirs/:dir
          clear back tail trail
        ]
      ]
    ]
    false
  ]
  trail
]

; This will yield the correct result... eventually. It needs to be rewritten with optimizations cited at the top of the file to become viable.
solve: funct [] [
  best: 999'999
  navigate: funct [pos inventory distance] [
    ;print ["CHECKING" pos mold inventory distance]
    elements: in-range pos inventory
    ;print ["ELEMS" mold elements]
    if best < distance [return]
    either empty? elements [
      set 'best distance
      print ["DIST" distance "MIN" best "INV" rejoin inventory]
      ;print ["FOUND" distance]
    ] [
      sum: 0
      foreach [p k d] elements [sum: sum + d]
      if best < (distance + sum) [return]
      foreach [p k d] elements [
        ;print ["TAKING" k "at" p "dist+=" d]
        if best > (distance + d) [navigate p append copy inventory k distance + d]
      ]
    ]
  ]
  navigate player copy [] 0
  best
]

; Another aggressive optimization attempt that doesn't yield the correct result
;get-permutations: funct [values] [
;  collect [
;    do gen: func [values length] [
;      either length = 1 [
;        keep/only copy values
;      ] [
;        repeat i length [
;          gen values length - 1
;          either 0 = (length and 1) [
;            swap at values i at values length
;          ] [
;            swap values at values length
;          ]
;        ]
;      ]
;    ] copy values length? values
;  ]
;]
;
;solve: funct [] [
;  sum: 0
;  inventory: copy [] pos: player
;  while [not empty? probe elements: in-range pos inventory] [
;    perms: get-permutations extract next elements 3
;    b: 999'999
;    foreach perm perms [
;      test-pos: pos test-inventory: copy inventory
;      t: collect [
;        forall perm [
;          keep path-to test-pos test-inventory perm/1
;          test-pos: first back find elements perm/1
;          append test-inventory perm/1
;        ]
;      ]
;      if b > length? t [
;        b: length? t
;        last-pos: last t
;      ]
;    ]
;    sum: sum + b
;    append inventory extract next elements 3
;    pos: last-pos
;  ]
;  sum
;]

r1: solve
print [{Part 1:} r1]


; --- Part 2 ---
do transform: funct [] [
  pos: find data entrance
  width: index? find data newline
  pos/-1: pos/1: pos/2: pos/(0 - width): pos/(width + 1): wall
  pos/:width: pos/(width + 2): pos/(0 - width - 1): pos/(1 - width): entrance
]

; Same as part 1 but with 4 parallel searchers

r2: 0
print [{Part 2:} r2]
