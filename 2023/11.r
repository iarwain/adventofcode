REBOL [
  Title: {Day 11}
  Date: 11-12-2023
]

data: read/lines %data/11.txt

universe: context [
  paths?: use [galaxies rows columns] [
    galaxies: copy []
    rows: collect [
      rows: 0
      forall data [
        keep rows: rows + pick [0 1] to-logic find data/1 #"#"
      ]
    ]
    columns: collect [
      columns: 0
      for x 1 length? data/1 1 [
        empty: true
        forall data [
          all [
            data/1/:x = #"#"
            append galaxies as-pair x index? data
            empty: false
          ]
        ]
        keep columns: columns + pick [1 0] empty
      ]
    ]
    funct [/older] [
      res: 0 expansion: pick [999999 1] to-logic older
      forall galaxies [
        foreach other next galaxies [
          begin: min galaxies/1 other end: max galaxies/1 other
          res: res + end/x - begin/x + end/y - begin/y + (expansion * (columns/(end/x) - columns/(begin/x) + rows/(end/y) - rows/(begin/y)))
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
