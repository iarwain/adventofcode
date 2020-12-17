REBOL [
  Title: {Day 17}
  Date: 17-12-2020
]

data: read %data/17.txt

; --- Part 1 ---
pocket: context [
  process: funct [/hyper] [
    v-add: funct [c1 c2] [map-each c c1 [c + first+ c2]]
    size: pick [4 3] to-logic hyper
    cubes: collect [
      x: y: 0 parse data [
        some [
          [#"#" (keep/only head change array/initial size 0 reduce [x y]) | #"."] (x: x + 1)
        | newline (y: y + 1 x: 0)
        ]
      ]
    ]
    offsets: copy [[]] remove find/only loop size [
      offsets: collect [foreach offset offsets [foreach range [-1 0 1] [keep/only append copy offset range]]]
    ] array/initial size 0
    repeat i 6 [
      cubes: collect [
        neighbors: copy []
        foreach cube cubes [
          count: 0 foreach offset offsets [
            either find/only cubes new: v-add cube offset [
              count: count + 1
            ] [
              any [attempt [neighbors/:new: neighbors/:new + 1] append neighbors reduce [new 1]]
            ]
          ]
          if any [count = 2 count = 3] [keep/only cube]
        ]
        foreach [neighbor value] neighbors [all [value = 3 keep/only neighbor]]
      ]
    ]
    length? cubes
  ]
]
r1: pocket/process
print [{Part 1:} r1]

; --- Part 2 ---
; Part 2 is rather slow using a sparse block to track the active cubes, would it be faster using a flat memory model?
r2: pocket/process/hyper
print [{Part 1:} r2]
