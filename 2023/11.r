REBOL [
  Title: {Day 11}
  Date: 11-12-2023
]

data: read/lines %data/11.txt

universe: context [
  paths?: use [galaxies expansion] [
    galaxies: copy []
    expansion: context [
      count: use [rows columns] [
        rows: sort collect [
          forall data [
            any [find data/1 #"#" keep index? data]
          ]
        ]
        columns: sort collect [
          for x 1 length? data/1 1 [
            empty: true
            forall data [
              all [
                data/1/:x = #"#"
                append galaxies as-pair x index? data
                empty: false
              ]
            ]
            all [empty keep x]
          ]
        ]
        funct [src dst] [
          begin: min src dst end: max src dst count: 0
          foreach column columns [all [column >= begin/x any [column <= end/x break] ++ count]]
          foreach row rows [all [row >= begin/y any [row <= end/y break] ++ count]]
          count
        ]
      ]
    ]
    funct [/older] [
      res: 0 size: pick [999999 1] to-logic older
      forall galaxies [
        foreach target next galaxies [
          dist: abs (target - galaxies/1)
          res: res + dist/x + dist/y + (size * expansion/count galaxies/1 target)
        ]
      ]
      to-integer res
    ]
  ]
]

; --- Part 1 ---
r1: universe/paths?
print [{Part 1:} r1]

; --- Part 2 ---
r2: universe/paths?/older
print [{Part 2:} r2]
