REBOL [
  Title: {Day 13}
  Date: 13-12-2021
]

data: read %data/13.txt

; --- Part 1 ---
paper: context [
  first-fold: code: none
  use [point instruction points fold x y axis value size] [
    point: [copy x integer! {,} copy y integer!]
    instruction: [{fold along} copy axis to {=} skip copy value integer!]
    fold: func [axis value] [
      points: unique map-each point points [
        all [point/:axis > value point/:axis: 2 * value - point/:axis] point
      ]
    ]
    parse data [
      (points: copy []) some
      [ point       (append points as-pair load x load y)
      | instruction (fold to-word trim axis load value first-fold: any [first-fold length? points])
      | skip
      ]
    ]
    size: 0x0 foreach point points [size: max size point]
    code: to-string collect [
      repeat y size/y + 1 [
        repeat x size/x + 1 [
          keep pick [{#} { }] found? find points as-pair x - 1 y - 1
        ]
        keep newline
      ]
    ]
  ]
]

r1: paper/first-fold
print [{Part 1:} r1]

; --- Part 2 ---
r2: paper/code
print [{Part 2:} newline r2]
