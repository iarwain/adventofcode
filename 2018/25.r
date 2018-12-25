REBOL [
  Title: {Day 25}
  Date: 25-12-2018
]

data: load replace/all read %data/25.txt {,} { }

; --- Part 1 ---
device: context [
  constellations: collect [foreach [x y z w] data [keep/only reduce [x y z w]]]
  use [connect] [
    connect: has [dist? connection dst src other] [
      dist?: funct [a b] [distance: 0 repeat c 4 [distance: distance + abs (a/:c - b/:c)]]
      connection: 0 forall constellations [
        dst: constellations/1 other: next constellations forall other [
          src: other/1 forskip dst 4 [
            forskip src 4 [
              all [
                3 >= dist? dst src
                (connection: connection + 1 dst: insert tail dst take/part head src tail src break)
              ]
            ]
          ]
        ]
      ]
      remove-each constellation constellations [empty? constellation]
      connection
    ]
    until [connect = 0]
  ]
]
r1: length? device/constellations
print [{Part 1:} r1]

; --- Part 2 ---
r2: {There's no part 2! :-)}
print [{Part 2:} r2]
