REBOL [
  Title: {Day 13}
  Date: 13-12-2023
]

data: read/string %data/13.txt

valley: context [
  summarize: use [mirrors] [
    mirrors: collect [foreach mirror split data [newline newline] [keep/only split mirror newline]]
    funct [/smudges] [
      rows: copy [] columns: copy []
      symmetry?: funct [mirror tolerance] [
        check: funct [/vertical] [
          distance?: funct [left right] [
            res: 0
            for i 1 length? left 1 [
              all [left/:i != right/:i ++ res]
            ]
            res
          ]
          for i 1.5 l: length? pick reduce [mirror mirror/1] to-logic vertical 1 [
            distance: 0
            for j 0.5 i 1 [
              either vertical [
                if any [none? left: mirror/(i - j) none? right: mirror/(i + j)] [break]
              ] [
                if any [i - j < 1 i + j > l] [break]
                left: copy [] right: copy []
                foreach line mirror [append left line/(i - j) append right line/(i + j)]
              ]
              distance: distance + distance? left right
            ]
            all [distance = tolerance append pick reduce [rows columns] to-logic vertical to-integer i break]
          ]
        ]
        check mirror
        check/vertical mirror
      ]
      foreach mirror mirrors [
        symmetry? mirror pick [1 0] to-logic smudges
      ]
      res: 0
      foreach row rows [res: res + (100 * row)]
      foreach column columns [res: res + column]
      res
    ]
  ]
]

; --- Part 1 ---
r1: valley/summarize
print [{Part 1:} r1]

; --- Part 2 ---
r2: valley/summarize/smudges
print [{Part 2:} r2]
